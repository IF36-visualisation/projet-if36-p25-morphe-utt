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


