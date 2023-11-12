function(request){

fluidPage(theme = shinytheme("darkly"),
# 
#     # Application title
#     titlePanel("Windmill Algorithm vs Real Data"),
    
    sidebarPanel(
        selectInput(inputId = "division", "Division:",
                    choices = c("Mixed", "Open", "Women"), selected = "Mixed"),
        sliderInput(inputId = "round", "Round:",
                    min = 1, max = 8, value = 8, step = 1)),
    
     mainPanel(
         tabsetPanel(
             
             tabPanel("Team Explorer",
                      #inputPanel(
                          uiOutput("team_select"),
                      #),
                      textOutput("team_text"),
                      fluidRow(
                          column(6,plotlyOutput("plot_real_vs_expected_team")),
                          column(6,plotlyOutput("plot_ranking_team"))
                      ),
                      fluidRow(
                          column(12, textOutput("team_graph_explainer"), style="padding:25px;")
                      ),
                      fluidRow(
                          column(12,dataTableOutput("team_games_table"))
                      )
                      
                      
             ),
             tabPanel("Overview",
                      #inputPanel(
                          uiOutput("teams_picker"),
                      #),
                      fluidRow(
                          column(6,plotlyOutput("plot_real_vs_expected_overview")),
                          column(6,plotlyOutput("plot_ranking_overview"))
                      ),
                      fluidRow(
                          column(12, div("The winning team outperformed the algorithm in blue games and underperformed the algorithm in red games", style="padding:25px;"))
                      )
             )
         )
     ))
}