function(request){
    
  page_navbar(theme = bs_theme(version=5,
                               bg="#f9f8f5",
                               fg="#000",
                               primary="#0ad",
                               "navbar-bg" = "#eb4",
                               "navbar-text" = "#FFF"),
              title = "Windmill Algorithm vs Real Data",
              sidebar=sidebar(
                selectInput(inputId = "division", "Division:",
                            choices = c("Mixed", "Open", "Women"), selected = "Mixed"),
                sliderInput(inputId = "round", "Round:",
                            min = 1, max = 8, value = 8, step = 1),
                #uiOutput("team_select"),
                #uiOutput("teams_picker"),
              ),
              nav_panel(
                title="Team Explorer",
                uiOutput("team_select"),
                layout_columns(widths = 1/3,
                               value_box(title="Rank", showcase=bs_icon("reception-4"), value=textOutput("team_rank")),
                               value_box(title="Strength",showcase=bs_icon("heart-half"),value=textOutput("team_strength")),
                               value_box(title="Algorithm Error", showcase=bs_icon("lightning-fill"), value=textOutput("team_algo_error"))
                               ),
                #textOutput("team_text"),
                layout_columns(widths = 1/3,
                               card(
                                 
                                 full_screen = T, 
                                 card_header(
                                   tooltip(
                                     span("Real vs Expected", bsicons::bs_icon("question-circle-fill")),
                                     textOutput("team_graph_explainer"),
                                     placement = "right"
                                   )
                                 ),
                                 plotlyOutput("plot_real_vs_expected_team")
                                 ),
                               card(full_screen = T, plotlyOutput("plot_ranking_team"))
                       ),
                # fluidRow(
                #   column(12, textOutput("team_graph_explainer"), style="padding:25px;")
                # ),
                card(
                  dataTableOutput("team_games_table")
                )
              ),
              nav_panel(
                title="Tournament Overview",
                uiOutput("teams_picker"),
                layout_columns(
                  card(
                    full_screen = T,
                    card_header(
                      tooltip(
                        span("Real vs Expected", bsicons::bs_icon("question-circle-fill")),
                        "The winning team outperformed the algorithm in blue games and underperformed the algorithm in red games",
                        placement = "right"
                      )),
                    plotlyOutput("plot_real_vs_expected_overview")),
                  card(plotlyOutput("plot_ranking_overview"))
                ),
                # fluidRow(
                #   column(12, div("The winning team outperformed the algorithm in blue games and underperformed the algorithm in red games", style="padding:25px;"))
                # )
                
              )
  )
}