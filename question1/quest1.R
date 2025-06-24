library("ggplot2")
library("dplyr")

# ================= LA QUESTION DONNEE ================= 

# Quelle est la distribution générale des températures de service dans le dataset ?

# ================= IMPORT DES DONNÉES ================= 

redwine <- read.csv("~/projet-if36-p25-morphe-utt/data/red_wine.csv", header = TRUE, sep = ';')
whitewine <- read.csv("~/projet-if36-p25-morphe-utt/data/white_wine.csv", header = TRUE, sep = ';')

# Ajout d'une colonne type_vin pour identifier les deux jeux de données
redwine$type_vin <- "Rouge"
whitewine$type_vin <- "Blanc"

# Fusion des deux datasets
wine <- bind_rows(redwine, whitewine)

# ================= VISUALISATION ================= 

# Les boites à moustache
ggplot(wine, aes(x = reorder(region, temperature_service, FUN = median), y = temperature_service, fill = type_vin)) +
  geom_boxplot(outlier.alpha = 0.3) +
  coord_flip() +
  scale_y_continuous(breaks = seq(5, 20, by = 1)) +  # axe Y = température plus détaillé
  theme_minimal(base_size = 12) +
  scale_fill_manual(values = c("Rouge" = "firebrick", "Blanc" = "steelblue")) +
  labs(
    title = "Température idéale de dégustation par région et type de vin",
    x     = "Région viticole",
    y     = "Température idéale de service (°C)",
    fill  = "Type de vin"
  )



