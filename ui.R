#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Windmill Algorithm vs Real Data"),
    
    inputPanel(
        selectInput(inputId = "division", "Division:",
                    choices = c("Mixed", "Open", "Women"), selected = "Mixed"),
        sliderInput(inputId = "round", "Round:",
                    min = 1, max = 8, value = 1, step = 1)),
    
     tabsetPanel(
        tabPanel("Overview",
                 inputPanel(
                     uiOutput("teams_picker")
                 ),
                 fluidRow(
                     column(6,plotlyOutput("plot_real_vs_expected_overview")),
                     column(6,plotlyOutput("plot_ranking_overview"))
                 )
        ),
        tabPanel("Team Explorer",
                 inputPanel(
                     uiOutput("team_select")
                 ),
                 textOutput("team_text"),
                 fluidRow(
                     column(6,plotlyOutput("plot_real_vs_expected_team")),
                     column(6,plotlyOutput("plot_ranking_team"))
                     ),
                 dataTableOutput("teams_games_table")
        )
    )
)
