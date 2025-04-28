---
  title: "Rapport sur la corrélation potentielle entre certaines propriétés chimiques et la qualité du vin"
author: "MONTERIN Maxime"
output: pdf_document
---
  
```{r include=FALSE}
library(ggplot2)
library(dplyr)
library(tidyr)
```

# Nous cherchons ici à répondre à la question: 
# Y a-t-il une différence significative entre les vins rouges et les vins blancs en termes de caractéristiques et de qualité ?

### Chargement des données
```{r}
red_wine <- read.csv("~/projet-if36-p25-morphe-utt/data/red_wine.csv", header = TRUE, sep = ';')
white_wine <- read.csv("~/projet-if36-p25-morphe-utt/data/white_wine.csv", header = TRUE, sep = ';')
```
# Harmoniser les noms de colonnes
names(red_wine) <- tolower(names(red_wine))
names(white_wine) <- tolower(names(white_wine))

# Vérification
setdiff(names(red_wine), names(white_wine))
setdiff(names(white_wine), names(red_wine))

# Ajouter une colonne type_vin pour identifier
red_wine$type_vin <- "rouge"
white_wine$type_vin <- "blanc"


# Ajouter les colonnes manquantes
red_wine$mineralite <- NA
white_wine$tannins <- NA

# Réordonner
red_wine <- red_wine[, names(white_wine)]

# Fusionner
vin_total <- rbind(red_wine, white_wine)

# -------- Ton plot initial --------

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
# -------- NOUVEAU : Facet Wrap --------
library(tidyr)

vin_long <- vin_total %>%
  pivot_longer(cols = c(fixed.acidity, volatile.acidity, citric.acid,
                        residual.sugar, chlorides, free.sulfur.dioxide,
                        total.sulfur.dioxide, density, sulphates,
                        alcohol, temperature_service, mineralite),
               names_to = "variable",
               values_to = "valeur")  # Ajout de la parenthèse fermante

ggplot(vin_long, aes(x = as.factor(quality), y = valeur, color = type_vin)) +
  geom_smooth(method = "lm", se = TRUE, linetype = "solid", size = 3, aes(group = type_vin, color = type_vin, fill = type_vin)) +  # Courbes de régression seules
  facet_wrap(~ variable, scales = "free_y") +
  labs(
    title = "Comparaison des caractéristiques selon la qualité du vin",
    subtitle = "Analyse de la qualité du vin blanc et rouge",
    x = "Qualité du vin (0-10)",
    y = "Valeur mesurée",
    color = "Type de vin"
  ) +
  scale_color_manual(values = c("rouge" = "#D32F2F", "blanc" = "#388E3C")) +  # Couleurs plus distinctes
  scale_fill_manual(values = c("rouge" = "#D32F2F", "blanc" = "#388E3C")) +  # Remplissage en couleur plus doux
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12),  # Texte des axes plus lisible
    axis.text.y = element_text(size = 12),
    axis.title = element_text(size = 14),
    strip.text = element_text(size = 14),  # Titres des facettes plus gros
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),  # Titre principal plus gros et centré
    plot.subtitle = element_text(size = 14, hjust = 0.5)  # Sous-titre centré
  )
#

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


