function(request){
    
  page_navbar(theme = 
                bs_theme(
                  bootswatch = "lux", version = 5,
                  primary = "#0ae",
                  secondary = "#e28a1b",
                  "navbar-bg" = "#eb0",
                  "navbar-text" = "#320"
                ),
  title = "Windmill Algorithm vs Real Data",
              sidebar=sidebar(
                selectInput(inputId = "division", "Division:",
                            choices = c("Mixed", "Open", "Women"), selected = "Mixed"),
                sliderInput(inputId = "round", "Round:",
                            min = 1, max = 8, value = 8, step = 1),
              ),
              nav_panel(
                title="Team",
                uiOutput("team_select"),
                layout_columns(widths = 1/3,
                               value_box(title="Rank", showcase=bs_icon("reception-4"), value=textOutput("team_rank"), theme="primary"),
                               value_box(title="Strength",showcase=bs_icon("heart-half"),value=textOutput("team_strength"), theme="primary"),
                               value_box(title="Total Algorithm Error", showcase=bs_icon("lightning-fill"), value=textOutput("team_algo_error"), theme="primary")
                               ),
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
                card(tags$style('#team_games_table td {padding: 5px}'),
                  dataTableOutput("team_games_table")
                )
              ),
              nav_panel(
                title="Tournament",
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
                  
                  navset_card_tab(title = "Ranking",
                    nav_panel(
                      "Table",
                      tags$style('#ranking_table td {padding: 5px}'),
                      dataTableOutput("ranking_table")
                    ),
                    nav_panel(
                      "Plot",
                      plotlyOutput("plot_ranking_overview"))
                )
              ))
  )
}