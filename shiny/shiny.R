# ────────────────────
#  Librairies
# ────────────────────
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(stringr)

# ────────────────────
#  Chargement & fusion
# ────────────────────
redwine <- read.csv("/Users/lucarafe/Desktop/UTT-1er/projet-if36-p25-morphe-utt/data/red_wine.csv", sep = ";") %>%
  mutate(type = "Vin rouge")

whitewine <- read.csv("/Users/lucarafe/Desktop/UTT-1er/projet-if36-p25-morphe-utt/data/white_wine.csv", sep = ";") %>%
  mutate(type = "Vin blanc")

wine_all <- bind_rows(redwine, whitewine) %>%
  mutate(
    vieillissement_clean = case_when(
      str_detect(vieillissement_optimal, "-") ~ {
        nums <- str_extract_all(vieillissement_optimal, "\\d+")
        sapply(nums, function(x) mean(as.numeric(x)))
      },
      str_detect(vieillissement_optimal, "\\d+") ~ as.numeric(str_extract(vieillissement_optimal, "\\d+")),
      TRUE ~ NA_real_
    ),
    vieillissement_clean = round(vieillissement_clean, 1),
    type = factor(type)
  )

wine_model <- wine_all %>%
  filter(!is.na(alcohol), !is.na(tannins), !is.na(vieillissement_clean))

# ────────────────────
#  Modèle de régression
# ────────────────────
modele <- lm(vieillissement_clean ~ alcohol + tannins, data = wine_model)

# ────────────────────
#  UI
# ────────────────────
ui <- dashboardPage(
  dashboardHeader(title = "Analyse du vieillissement"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Estimation",  tabName = "estimation",  icon = icon("hourglass-half")),
      menuItem("Exploration", tabName = "exploration", icon = icon("flask"))
    )
  ),
  dashboardBody(
    tabItems(
      # Estimation
      tabItem(tabName = "estimation",
              fluidRow(
                box(title = "Paramètres du vin", width = 4, solidHeader = TRUE, status = "info",
                    sliderInput("alcool",  "Teneur en alcool (% vol.)", min = 8,  max = 15, value = 12, step = 0.1),
                    sliderInput("tannins", "Teneur en tannins",        min = 0,  max = 1.5, value = 0.5, step = 0.01)
                ),
                valueBoxOutput("prediction_box")
              ),
              fluidRow(
                box(title = "Position du vin dans l’espace chimique",
                    width = 12, status = "primary", solidHeader = TRUE,
                    plotOutput("scatterPlot", height = "450px", click = "plot_click")
                )
              )
      ),

      # Exploration
      tabItem(tabName = "exploration",
              fluidRow(
                box(title = "Exploration des propriétés chimiques", width = 4, solidHeader = TRUE, status = "warning",
                    selectInput("variable", "Choisir une variable :",
                                choices = c("alcohol", "pH", "citric.acid", "residual.sugar",
                                            "chlorides", "sulphates", "density", "volatile.acidity"),
                                selected = "alcohol"),
                    radioButtons("type_vin", "Type de vin :", choices = c("Tous", "Vin rouge", "Vin blanc"), selected = "Tous")
                ),
                box(title = "Distribution de la variable sélectionnée", width = 8,
                    plotOutput("chemPlot", height = "400px"))
              )
      )
    )
  )
)

# ────────────────────
#  Server
# ────────────────────
server <- function(input, output, session) {

  observeEvent(input$plot_click, {
    click <- input$plot_click
    updateSliderInput(session, "alcool",  value = round(click$x, 1))
    updateSliderInput(session, "tannins", value = round(click$y, 2))
  })

  prediction <- reactive({
    predict(modele, newdata = data.frame(
      alcohol = input$alcool,
      tannins = input$tannins
    ))
  })

  output$prediction_box <- renderValueBox({
    valueBox(
      paste0(round(prediction(), 1), " ans"),
      subtitle = "Vieillissement estimé",
      icon  = icon("wine-bottle"),
      color = "olive"
    )
  })

  output$scatterPlot <- renderPlot({
    ggplot(wine_model, aes(x = alcohol, y = tannins, color = vieillissement_clean)) +
      geom_point(alpha = 0.5, size = 2) +
      geom_point(aes(x = input$alcool, y = input$tannins), color = "red", size = 4, shape = 17) +
      scale_color_viridis_c(name = "Vieillissement (ans)") +
      labs(
        title    = "Carte chimique des vins",
        subtitle = "Couleur = durée de vieillissement ; Point rouge = votre sélection",
        x = "Alcool (% vol.)",
        y = "Tannins"
      ) +
      theme_minimal(base_size = 14)
  })

  output$chemPlot <- renderPlot({
    var <- input$variable

    data <- wine_all %>%
      filter(!is.na(.data[[var]])) %>%
    { if (input$type_vin != "Tous") filter(., type == input$type_vin) else . } %>%
      droplevels()

    moyenne <- round(mean(data[[var]], na.rm = TRUE), 2)
    mediane <- round(median(data[[var]], na.rm = TRUE), 2)

    titre       <- paste("Distribution de", var, "par type de vin")
    sous_titre  <- paste0("Moyenne = ", moyenne, " | Médiane = ", mediane)

    p <- ggplot(data, aes(x = .data[[var]]))

    if (input$type_vin == "Tous") {
      p <- p + geom_histogram(aes(fill = type), position = "identity", alpha = 0.6, bins = 30) +
        scale_fill_manual(values = c("Vin rouge" = "#C0392B", "Vin blanc" = "#2980B9"))
    } else {
      color <- if (unique(data$type) == "Vin rouge") "#C0392B" else "#2980B9"
      p <- p + geom_histogram(fill = color, alpha = 0.7, bins = 30)
    }

    p +
      geom_vline(xintercept = moyenne, color = "red", linetype = "dashed", linewidth = 1) +
      labs(title = titre,
           subtitle = paste0(sous_titre, " (trait rouge = moyenne)"),
           x = var, y = "Nombre de vins") +
      theme_minimal(base_size = 13) +
      theme(legend.position = "top")
  })
}

# ────────────────────
#  Lancement de l’app
# ────────────────────
shinyApp(ui, server)