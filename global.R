library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(broom)

whr <- read.csv("whr-2023.csv")

variables <- c(
  "Life.Ladder",
  "Log.GDP.per.capita",
  "Social.support",
  "Healthy.life.expectancy.at.birth",
  "Freedom.to.make.life.choices",
  "Generosity",
  "Perceptions.of.corruption"
)

# 3. data clean
model_data <- whr %>%
  filter(year >= 2008, year <= 2022) %>%
  select(Country.name, year, all_of(variables)) %>%
  drop_na()

# 4. PCA 
pca_data <- model_data %>% select(all_of(variables[-1]))
pca_result <- prcomp(pca_data, scale. = TRUE)

pca_scores <- as.data.frame(pca_result$x)
pca_scores$Country <- model_data$Country.name
pca_scores$Year <- model_data$year

variance <- tibble(
  PC = paste0("PC", 1:length(pca_result$sdev)),
  Variance = pca_result$sdev^2 / sum(pca_result$sdev^2)
)

loadings <- as.data.frame(pca_result$rotation)
loadings$Variable <- rownames(loadings)

var_labels <- c(
  "Log GDP per capita" = "Log.GDP.per.capita",
  "Social support" = "Social.support",
  "Healthy life expectancy" = "Healthy.life.expectancy.at.birth",
  "Freedom to make life choices" = "Freedom.to.make.life.choices",
  "Generosity" = "Generosity",
  "Perceptions of corruption" = "Perceptions.of.corruption"
)