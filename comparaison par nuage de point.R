# Objectif :
# Nous cherchons ici à répondre à la question : 
# Y a-t-il une différence significative entre les vins rouges et les vins blancs 
# en termes de caractéristiques chimiques et de qualité ?

# Chargement des données
red_wine <- read.csv('C:/Users/natha/OneDrive/Bureau/red_wine.csv', sep=";")
white_wine <- read.csv('C:/Users/natha/OneDrive/Bureau/white_wine.csv', sep=";")

# Harmoniser les noms de colonnes pour éviter les problèmes de casse
names(red_wine) <- tolower(names(red_wine))
names(white_wine) <- tolower(names(white_wine))

# Vérification de l'uniformité des colonnes
setdiff(names(red_wine), names(white_wine))
setdiff(names(white_wine), names(red_wine))

# Ajouter une colonne pour identifier le type de vin
red_wine$type_vin <- "rouge"
white_wine$type_vin <- "blanc"

# Ajouter les colonnes manquantes pour harmoniser les jeux de données
red_wine$mineralite <- NA
white_wine$tannins <- NA

# Réordonner les colonnes du vin rouge pour correspondre à celles du vin blanc
red_wine <- red_wine[, names(white_wine)]

# Fusionner les deux datasets en un seul
vin_total <- rbind(red_wine, white_wine)

# ---------------------------------------------
# Visualisation 1 : Relation alcool - qualité
# ---------------------------------------------

library(ggplot2)

ggplot(vin_total, aes(x = alcohol, y = quality, color = type_vin)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  labs(title = "Relation entre l'alcool et la qualité du vin selon le type",
       x = "Alcool (%)",
       y = "Qualité du vin",
       color = "Type de vin") +
  theme_minimal() +
  scale_color_manual(values = c("rouge" = "red", "blanc" = "green"))

# ---------------------------------------------
# Visualisation 2 : Comparaison multi-caractéristiques (Facet Wrap)
# ---------------------------------------------

library(tidyr)

# Restructuration des données : passage en format long
vin_long <- vin_total %>%
  pivot_longer(
    cols = c(fixed.acidity, volatile.acidity, citric.acid,
             residual.sugar, chlorides, free.sulfur.dioxide,
             total.sulfur.dioxide, density, sulphates,
             alcohol, temperature_service, mineralite),
    names_to = "variable",
    values_to = "valeur"
  )

# Visualisation par caractéristiques
ggplot(vin_long, aes(x = as.factor(quality), y = valeur, color = type_vin)) +
  geom_point(size = 1, alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed", size =2) +
  facet_wrap(~ variable, scales = "free_y") +
  labs(title = "Comparaison des caractéristiques selon la qualité du vin",
       x = "Qualité du vin (0-10)",
       y = "Valeur mesurée",
       color = "Type de vin") +
  scale_color_manual(values = c("rouge" = "red", "blanc" = "green")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ---------------------------------------------
# Conclusion de l'analyse
# ---------------------------------------------

# Pour ce qui est du vin rouge :
# - Les vins rouges présentent généralement des niveaux plus élevés 
#   d'acidité fixe, de chlorures, de densité, et de sulphates.
# - Les vins blancs affichent des teneurs plus élevées en sucre résiduel, 
#   en dioxyde de soufre libre et total, ainsi qu'en alcool.
# - Concernant la qualité (mesurée sur une échelle de 0 à 10), 
#   les deux types de vin montrent des variations similaires : 
#   il n'y a pas de différence très marquée en termes de note moyenne.
# - Cela suggère que même si les profils chimiques des vins rouges 
#   et blancs sont différents, ils peuvent mener à une qualité 
#   perçue similaire par les dégustateurs.
