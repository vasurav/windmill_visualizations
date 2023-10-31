read_windmill_game_data <- function(division, round, 
                                    base_url = "https://windmill-api-production.herokuapp.com/api/v1/games/")
{
  full_url <- paste0(base_url, division, "/", round)
  
  jsonlite::fromJSON(full_url) %>% 
    transmute(Tournament = "Windmill",
              Date = ymd_hms(round$start_time) %>% 
                as.Date(),
              Team_1 = team_registration_1$team$name,
              Team_2 = team_registration_2$team$name,
              Score_1 = score_1,
              Score_2 = score_2,
              Division = str_to_title(division),
              Round = round$round,
              Team_Winner = ifelse(Score_1 >= Score_2, Team_1, Team_2),
              Score_Winner = ifelse(Score_1 >= Score_2, Score_1, Score_2),
              Team_Loser = ifelse(Score_1 < Score_2, Team_1, Team_2),
              Score_Loser = ifelse(Score_1 < Score_2, Score_1, Score_2),
              Score_Difference_Real = Score_Winner - Score_Loser)
}

get_all_windmill_data <- function(divisions = c("mixed", "open", "women"),
                                  rounds = seq(1,9), FUN)
{
  all_rounds <- expand.grid(divisions,rounds)
  
  all_games <- mapply(FUN, 
                      division = all_rounds$Var1,
                      round = all_rounds$Var2, 
                      SIMPLIFY = F) %>% 
    bind_rows()
}


read_windmill_ranking_data <- function(division, round, 
                                       base_url = "https://windmill-api-production.herokuapp.com/api/v1/ranking/")
{
  full_url <- paste0(base_url, division, "/", round)
  jsonlite::fromJSON(full_url) %>% 
    transmute(Team = team_registration$team$name,
              Strength = strength,
              Rank = rank,
              Division = str_to_title(division),
              Round = round)
}
