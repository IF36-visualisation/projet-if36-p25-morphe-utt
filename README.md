MorpheUTT fait référence à Morpheus de Matrix, film faisant également référence aux vecteurs et surtout matrices que l'on manipulera pendant le projet. La terminaison UTT est pour l'école !

# Proposition

## Introduction

### Données

Dans le cadre de ce projet, nous avons choisi d'utiliser deux jeux de données portant sur la **qualité des vins** : l'un sur le **vin rouge** (`red_wine.csv`), l'autre sur le **vin blanc** (`white_wine.csv`).  
Ces données sont issues d’une étude menée par l'Université de Minho (Portugal) et sont accessibles publiquement sur plusieurs plateformes de data science. Elles ont été collectées afin de prédire la qualité des vins à partir de leurs propriétés physico-chimiques.

Les deux fichiers contiennent les observations suivantes :

- **Vin rouge** :
    - Nombre d'observations : **1 599**
    - Nombre de variables : **12** (11 variables explicatives + 1 variable cible)

- **Vin blanc** :
    - Nombre d'observations : **4 898**
    - Nombre de variables : **12** (11 variables explicatives + 1 variable cible)

#### Type des variables

Les variables explicatives sont de type **quantitatif continu**

#### Description des variables

| Variable                 | Description                                                         | Type                |
|--------------------------|---------------------------------------------------------------------|---------------------|
| `nom_du_vin`             | Nom commercial du vin.                                              | Catégorique         |
| `region`                 | Région viticole d'origine (ex : Toscane, Bordeaux, Napa Valley).    | Catégorique         |
| `cepage`                 | Type de raisin utilisé (ex : Cabernet Sauvignon, Malbec).           | Catégorique         |
| `annee`                  | Année de production du vin (millésime).                             | Numérique (discret) |
| `prix_eur`               | Prix du vin en euros (€).                                           | Numérique (continu) |
| `type_vin`               | Type de vin (rouge, blanc, etc.).                                   | Catégorique         |
| `fixed acidity`          | Quantité d'acide fixe présent dans le vin (g/dm³).                  | Numérique (continu) |
| `volatile acidity`       | Quantité d'acide volatil, influence l'arôme (g/dm³).                | Numérique (continu) |
| `citric acid`            | Quantité d'acide citrique, donne de la fraîcheur (g/dm³).           | Numérique (continu) |
| `residual sugar`         | Teneur en sucre résiduel après fermentation (g/dm³).                | Numérique (continu) |
| `chlorides`              | Teneur en chlorure (sel) du vin (g/dm³).                            | Numérique (continu) |
| `free sulfur dioxide`    | Dioxyde de soufre libre, protège contre la dégradation (mg/dm³).    | Numérique (continu) |
| `total sulfur dioxide`   | Quantité totale de dioxyde de soufre (mg/dm³).                      | Numérique (continu) |
| `density`                | Densité du vin (g/cm³), liée à l'alcool et au sucre.                | Numérique (continu) |
| `pH`                     | Mesure de l'acidité du vin (sans unité, entre 0 et 14).             | Numérique (continu) |
| `sulphates`              | Teneur en sulfates, contribue à la conservation et au goût (g/dm³). | Numérique (continu) |
| `alcohol`                | Teneur en alcool (% vol.).                                          | Numérique (continu) |
| `quality`                | Note de qualité du vin (entre 0 et 10), attribuée par des experts.  | Numérique (discret) |
| `temperature_service`    | Température idéale de dégustation (°C).                             | Numérique (continu) |
| `tannins`                | Indice de teneur en tannins (impacte l'astringence du vin).         | Numérique (continu) |
| `vieillissement_optimal` | Durée recommandée de vieillissement avant consommation (années).    | Numérique (discret) |
| `quality`                | note de qualité du vin attribuée par des dégustateurs, de 0 à 10.   | Numérique (discret) |


---

### 🧐 Plan d’analyse

L'objectif de notre analyse est d'explorer les relations entre les propriétés physico-chimiques des vins et leur **qualité**. Nous souhaitons répondre aux questions suivantes :

#### Questions principales

- Existe-t-il une corrélation forte entre certaines propriétés chimiques et la qualité du vin ?
- Y a-t-il des différences significatives entre les vins rouges et les vins blancs en termes de caractéristiques et de qualité ?
- Peut-on identifier les variables qui influencent le plus la qualité du vin ?
- Les vins ayant une teneur élevée en alcool obtiennent-ils une meilleure note ?
- Y a-t-il des anomalies, des valeurs extrêmes ou des déséquilibres dans la distribution des notes de qualité ?

#### Méthodologie envisagée

- **Analyse descriptive** : statistiques de base (moyenne, médiane, variance) pour chaque variable.
- **Visualisation des données** : histogrammes, boxplots, matrices de corrélation.
- **Comparaison inter-groupes** : analyse comparative entre vin rouge et vin blanc.
- **Analyse des corrélations** : calcul du coefficient de corrélation pour identifier les relations les plus significatives.
- **Recherche d'outliers** : détection des valeurs extrêmes susceptibles d’impacter l’analyse.
- **Analyse multivariée** : étude de la combinaison de plusieurs variables pour comprendre leur impact global sur la qualité.

Nous resterons attentifs aux éventuels biais ou déséquilibres présents dans les données, notamment une répartition inégale des notes de qualité.

---

📂 Les jeux de données utilisés sont disponibles dans le dossier `/data`.
