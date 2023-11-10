function(input, output, session) {
    
    ranking_round <- reactive({
        ranking_data %>% filter(Round == input$round,
                                Division == input$division) %>%
            select(-Round, -Division)
    })
    
    ranking_round <- reactive({
        ranking_data %>% filter(Round == input$round,
                                Division == input$division) %>%
            select(-Round, -Division)
    })
    
    game_ranking_combined <- reactive({
        game_data %>%
            filter(Division == input$division,
                   Round <= input$round) %>%
            filter(Team_1 %in% input$teams_overview | Team_2 %in% input$teams_overview) %>%
            left_join(ranking_round(),
                      by = c("Team_Winner"="Team")) %>%
            left_join(ranking_round(),
                      by = c("Team_Loser"="Team"),
                      suffix = c("_Winner", "_Loser")) %>%
            mutate(Score_Difference_Expected = 
                       round(Strength_Winner - Strength_Loser, digits = 2)) %>%
            mutate(Algorithm_Error =
                       Score_Difference_Expected - Score_Difference_Real) %>%
            mutate(Game = paste0(Team_Winner, ": ", Score_Winner,
                                 " - ",
                                 Team_Loser, ": ", Score_Loser)) %>%
            mutate(Game_Expected = paste0(Team_Winner, ": ",
                                          round(Strength_Winner, digits = 2),
                                          " - ",
                                          Team_Loser, ": ",
                                          round(Strength_Loser, digits=2)))
    })
    
    game_ranking_one_team <- reactive({
        game_data %>%
            filter(Division == input$division,
                   Round <= input$round) %>%
            filter(Team_1 == input$team | Team_2 == input$team) %>%
            mutate(Team              = input$team,
                   Score             = if_else(Team_1 == input$team, Score_1, Score_2),
                   Opponent          = if_else(Team_1 == input$team, Team_2, Team_1),
                   Score_Opponent    = if_else(Team_1 == input$team, Score_2, Score_1)) %>%
            left_join(ranking_round(),
                      by = c("Team"="Team")) %>%
            left_join(ranking_round(),
                      by = c("Opponent"="Team"),
                      suffix = c("", "_Opponent")) %>%
            mutate(Score_Difference_Expected = round(Strength - Strength_Opponent, digits = 2)) %>%
            mutate(Score_Difference_Real = Score - Score_Opponent) %>%
            mutate(Algorithm_Error =
                       Score_Difference_Expected - Score_Difference_Real) %>%
            mutate(Game = paste0(Team, ": ", Score,
                                 " - ",
                                 Opponent, ": ", Score_Opponent)) %>%
            mutate(Game_Expected = paste0(Team, ": ",
                                          round(Strength, digits = 2),
                                          " - ",
                                          Opponent, ": ",
                                          round(Strength_Opponent, digits=2)))
    }
    )
    
    #Overview elements
   output$teams_picker <- renderUI({
        pickerInput(inputId = "teams_overview", "Teams:", 
                    choices = ranking_data %>% 
                        filter(Division == input$division) %>% 
                        pull(Team) %>% unique() %>% 
                        sort(),
                    selected = ranking_data %>% 
                        filter(Division == input$division) %>% 
                        pull(Team) %>% unique(),
                    multiple = TRUE,
                    options = list(`actions-box` = TRUE))
    })
    
    output$plot_real_vs_expected_overview <- renderPlotly({
        req(input$teams_overview)
        
        game_ranking_combined() %>%
            plot_real_vs_expected()
    })
    
    output$plot_ranking_overview <- renderPlotly({
        req(input$teams_overview)
        
        ranking_data %>% 
            filter(Division == input$division,
                   Round <= input$round) %>%
            filter(Team %in% input$teams_overview) %>%
            ggplot(aes(x=Round, y=Rank, color=str_wrap(Team, 10),
                       label=Strength)) + 
            geom_point() + 
            geom_line() +
            scale_y_reverse(limits = c(NA,1)) +
            labs(color = "Team")
    })
    
    
    #Team Explorer elements
    output$team_select <- renderUI({
        selectInput(inputId = "team", "Team:", 
                    choices = ranking_data %>% 
                        filter(Division == input$division) %>% 
                        pull(Team) %>% unique() %>% 
                        sort(),
                    selected = ranking_data %>% 
                        filter(Division == input$division) %>% 
                        pull(Team) %>% unique(),
                    multiple = FALSE)
    })
    
    output$team_text <- renderText({
        req(input$team)
        current_ranking <- ranking_data %>% filter(Team == input$team, Round == input$round)
        strength <- current_ranking %>% pull(Strength) %>% round(digits = 2)
        rank <- current_ranking %>% pull(Rank)
        algorithmic_error <- game_ranking_one_team() %>% pull(Algorithm_Error) %>% sum() %>% round(digits = 4)
        
        paste0("After Round ", input$round, ", ", input$team, " has strength of ", strength, 
               ", which ranks them ", rank,
               ". The total algorithmic error (over 0 means the algorithm is overestimating the team and less than 0 means the algorithm is underestimating the team) for the team is ", algorithmic_error, ".")
        
    })
    
    output$plot_real_vs_expected_team <- renderPlotly({
        req(input$team)
        
        game_ranking_one_team() %>%
            plot_real_vs_expected(x_lim = c(-15, 15), y_lim = c(-20, 20))
    })
    
    output$plot_ranking_team <- renderPlotly({
        req(input$team)
        
        number_teams <- ranking_data %>% filter(Division == input$division) %>%
            pull(Rank) %>% max()
        
        ranking_data %>%
            filter(Team == input$team,
                   Round <= input$round) %>%
            left_join(game_ranking_one_team() %>% select(Team, Opponent, Round), by=c("Team", "Round")) %>%
            ggplot(aes(x = Round, y=Rank, label=Strength)) +
            geom_line() +
            geom_point(aes(color=str_wrap(Opponent, 10))) +
            scale_y_reverse(limits = c(number_teams, 1)) +
            labs(color="Opponent")
    })
    
    output$team_games_table <- renderDataTable({
        req(input$team)
        game_ranking_one_team() %>%
            select(-Strength, -Rank) %>%
            left_join(ranking_data, by=c("Team", "Round")) %>%
            mutate(Score = paste0(Score, " - ", Score_Opponent)) %>%
            select(Round, Team, Opponent, Score, Rank, Strength, Rank_Opponent, Strength_Opponent) %>%
            mutate(Opponent = paste0("<a href=/?_inputs_",
                                     "&division=\"", input$division, "\"",
                                     "&round=\"", input$round, "\"",
                                     "&team=\"", Opponent %>% 
                                         str_replace_all(" ", "%20") %>% 
                                         str_replace_all("&", "%26"), "\"",
                                     
                                     ">",Opponent,"</a>")) %>% 
            DT::datatable(options = list(lengthChange = FALSE, searching = FALSE, paging = FALSE, info = FALSE),
                          rownames= FALSE, escape = FALSE)
    })
}
