library(tidyverse)
library(plotly)
library(jsonlite)
library(shiny)
library(shinyWidgets)
library(thematic)
library(DT)
library(bslib)
library(bsicons)
theme_set(theme_minimal())
source("read_windmill.R")
source("plot_windmill.R")
source("string_functions.R")


thematic_shiny(font = "auto")

# game_data <- read_csv("data/game_data_2023.csv") %>% mutate(Round = Round %>% case_match(9~8, .default = Round))
# ranking_data <- read_csv("data/ranking_data_2023.csv")


game_data <- get_all_windmill_game_data()
ranking_data <- get_all_windmill_ranking_data()

enableBookmarking("url")
