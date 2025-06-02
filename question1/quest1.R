library("ggplot2")
library("dplyr")
library("tidyr")

# ================= LA QUESTION DONNEE ================= 

# Existe-t-il une corrélation forte entre certaines propriétés chimiques et la qualité du vin ?

# ================= GENERATION DE GRAPHIQUES POUR REPONDRE A LA QUESTION (vin rouge) ================= 
# Choix d'un scatter plot pour montrer une corrélation entre un élément chimique et la note d'un vin

getwd()

redwine <- read.csv("~/projet-if36-p25-morphe-utt/data/red_wine.csv", header = TRUE, sep = ';')
whitewine <- read.csv("~/projet-if36-p25-morphe-utt/data/white_wine.csv", header = TRUE, sep = ';')


# Etape 1 : On ne garde que les variables qui sont reliées à de la chimie
variables_chimiques <- c("fixed_acidity", "volatile_acidity", "citric_acid",
              "residual_sugar", "chlorides", "free_sulfur_dioxide",
              "total_sulfur_dioxide", "density", "pH", "sulphates", "alcohol")

# Etape 1.5 : Ajout des unités aux catégories gardées
unit_labels <- c(
  "fixed_acidity"         = "Acidité fixe (g/dm³)",
  "volatile_acidity"      = "Acidité volatile (g/dm³)",
  "citric_acid"           = "Acide citrique (g/dm³)",
  "residual_sugar"        = "Sucre résiduel (g/dm³)",
  "chlorides"             = "Chlorures (g/dm³)",
  "free_sulfur_dioxide"   = "SO2 libre (mg/dm³)",
  "total_sulfur_dioxide"  = "SO2 total (mg/dm³)",
  "density"               = "Densité (g/cm³)",
  "pH"                    = "pH",
  "sulphates"             = "Sulfates (g/dm³)",
  "alcohol"               = "Alcool (% vol.)"
)

# Etape 2 : On factorise nos différentes variables et leurs valeurs dans un tableau à 2 dimensions.
# ça va permettre de générer pleins de graphiques en une seule fois plutot que d'en générer plusieurs à la main
redwine2 <- redwine %>%
  select(quality, all_of(variables_chimiques)) %>%
  pivot_longer(
    cols = all_of(variables_chimiques),
    names_to  = "variable",
    values_to = "valeur"
  )

# Etape 3 : Génération des scatters plots avec le tableau factorisé B)
ggplot(redwine2, aes(x = as.factor(quality), y = valeur)) +
  geom_boxplot(outlier.alpha = 0.2, fill = "lightpink", color = "darkred") +
  facet_wrap(~ variable, scales = "free_y", ncol = 3, labeller = labeller(variable = unit_labels)) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Distribution des variables chimiques en fonction de la note de qualité (vin rouge)",
    x     = "Qualité (note sur 10)",
    y     = "Valeur de la variable chimique"
  )

# ================= GENERATION DE GRAPHIQUES POUR REPONDRE A LA QUESTION (vin blanc) ================= 

# Etape 2 
whitewine2 <- whitewine %>%
  select(quality, all_of(variables_chimiques)) %>%
  pivot_longer(
    cols = all_of(variables_chimiques),
    names_to  = "variable",
    values_to = "valeur"
  )

# Etape 3 :
ggplot(whitewine2, aes(x = as.factor(quality), y = valeur)) +
  geom_boxplot(outlier.alpha = 0.2, fill = "lightblue", color = "darkblue") +
  facet_wrap(~ variable, scales = "free_y", ncol = 3, labeller = labeller(variable = unit_labels)) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Distribution des variables chimiques en fonction de la note de qualité (vin blanc)",
    x     = "Qualité (note sur 10)",
    y     = "Valeur de la variable chimique"
  )

# ================= ANALYSE ET REPONSE A LA QUESTION DONNEE ================= 

# VIN ROUGE :
# La droite de regression est stable quasiment de partout, on peut donc en conclure qu'il n'y a pas de lien fort
# entre les éléments chimiques et la note du vin. Une des hypothèses qu'on pourrait tirer serait que la note 
# pourrait être attribuée en fonction du ressentit des experts, donc par le gout, l'odeur, l'apparence etc...

# VIN BLANC :
# La même conclusion peut-être apportée. Cependant on voit un lien + fort lorsqu'il s'agit du pH et des sulphates.
# Plus le pH est haut et plus la note diminue, et c'est exactement pareil pour les sulphates.
