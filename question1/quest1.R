library("ggplot2")
library("dplyr")
library("tidyr")

getwd()

redwine <- read.csv("~/projet-if36-p25-morphe-utt/data/red_wine.csv", header = TRUE, sep = ';')
whitewine <- read.csv("~/projet-if36-p25-morphe-utt/data/white_wine.csv", header = TRUE, sep = ';')

redwine2 <- redwine %>%
  mutate(quality_cat = case_when(
    quality <= 4              ~ "mauvais",
    quality %in% 5:6          ~ "moyen",
    quality >= 7              ~ "bon"
  )) %>%
  mutate(quality_cat = factor(quality_cat, levels = c("mauvais","moyen","bon")))

vars_sel <- c("fixed_acidity", "volatile_acidity", "citric_acid",
              "residual_sugar", "chlorides", "free_sulfur_dioxide",
              "total_sulfur_dioxide", "density", "pH", "sulphates", "alcohol")

df_long <- redwine2 %>%
  select(quality_cat, all_of(vars_sel)) %>%
  pivot_longer(
    cols = all_of(vars_sel),
    names_to  = "variable",
    values_to = "valeur"
  )

ggplot(df_long, aes(x = quality_cat, y = valeur, fill = quality_cat)) +
  geom_boxplot(outlier.size = 0.5, alpha = 0.7) +
  facet_wrap(~ variable, scales = "free_y", ncol = 3) +
  scale_fill_brewer(palette = "Set2", name = "Qualité") +
  theme_minimal(base_size = 12) +
  theme(
    legend.position   = "bottom",
    axis.text.x       = element_text(angle = 45, hjust = 1),
    strip.text        = element_text(face = "bold")
  ) +
  labs(
    title = "Distribution des propriétés chimiques selon la catégorie de qualité",
    x     = "Catégorie de qualité",
    y     = "Valeur de la variable"
  )
