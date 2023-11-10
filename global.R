library(tidyverse)
library(plotly)
library(jsonlite)
library(shiny)
library(shinyWidgets)
library(DT)
theme_set(theme_minimal())

game_data <- read_csv("data/game_data_2023.csv")
ranking_data <- read_csv("data/ranking_data_2023.csv")


# game_data <- get_all_windmill_data(FUN=read_windmill_game_data)
# ranking_data <- get_all_windmill_data(FUN=read_windmill_ranking_data, rounds=seq(1,8))

enableBookmarking("url")