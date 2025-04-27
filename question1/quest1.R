library("ggplot2")
library("dplyr")
library("tidyr")

getwd()

redwine <- read.csv("~/projet-if36-p25-morphe-utt/data/red_wine.csv", header = TRUE, sep = ';')
whitewine <- read.csv("~/projet-if36-p25-morphe-utt/data/white_wine.csv", header = TRUE, sep = ';')


# 1. On ne garde que les variables qui sont reliées à de la chimie
variables_chimiques <- c("fixed_acidity", "volatile_acidity", "citric_acid",
              "residual_sugar", "chlorides", "free_sulfur_dioxide",
              "total_sulfur_dioxide", "density", "pH", "sulphates", "alcohol")


# 2. On factorise nos différentes variables et leurs valeurs dans un tableau à 2 dimensions.
# ça va permettre de générer pleins de graphiques en une seule fois plutot que d'en générer plusieurs à la main
redwine2 <- redwine %>%
  select(quality, all_of(variables_chimiques)) %>%
  pivot_longer(
    cols = all_of(variables_chimiques),
    names_to  = "variable",
    values_to = "valeur"
  )

# 3. Génération des scatters plots avec le tableau factorisé B)
ggplot(redwine2, aes(x = valeur, y = quality)) +
  # Génération des points
  geom_point(alpha = 0.3, shape = 1) +
  # Génération de la droite de regression avec son intervalle de confiance
  geom_smooth(method = "lm", se = TRUE, color = "darkred") +
  # Sert pour la création de nos graphiques, c'est ce qui permet la répartion sur 3 colonnes 
  # mais aussi le fait que les abcisses soient libre 
  facet_wrap(~ variable, scales = "free_x", ncol = 3) +
  # Utilise un thème épuré, pour faire ressortir la droite de regression je trouve ça cool
  theme_minimal(base_size = 12) +
  # Gestion des labels
  labs(
    title = "Relations entre une variable chimique d'un vin et sa note de qualité",
    x     = "Valeur de la variable chimique",
    y     = "Qualité (note sur 10 attribuée par un ou des expert(s))"
  )

# La droite de regression est stable quasiment de partout, on peut donc en conclure qu'il n'y a pas de lien fort
# entre les éléments chimiques et la note du vin. Une des hypothèses qu'on pourrait tirer serait que la note 
# pourrait être attribuée en fonction du ressentit des experts, donc par le gout, l'odeur, l'apparence etc...
