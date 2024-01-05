# function that gets all windmill data
get_all_windmill_data <- function(divisions = c("mixed", "open", "women"),
                                  rounds = seq(1,9), FUN)
{
  all_rounds <- expand.grid(divisions,rounds)
  
  all_games <- mapply(FUN, 
                      division = all_rounds$Var1,
                      round = all_rounds$Var2, 
                      SIMPLIFY = F) %>% 
    bind_rows
}

# functions to get the game data
get_all_windmill_game_data <- function(divisions = c("mixed", "open", "women"),
                                       rounds = seq(1,9))
{
  get_all_windmill_data(FUN=read_windmill_game_data, divisions = divisions, rounds = rounds) %>% 
    clean_windmill_game_data
}

read_windmill_game_data <- function(division, round, 
                                    base_url = "https://windmill-api-production.herokuapp.com/api/v1/games/")
{
  full_url <- paste0(base_url, division, "/", round)
  get_data <- req_perform(request(full_url))
  
  
  jsonlite::fromJSON(rawToChar(get_data$body))
}

clean_windmill_game_data <- function(df)
{
  df %>% 
    transmute(Tournament = "Windmill",
              Date = ymd_hms(round$start_time) %>% 
                as.Date(),
              Team_1 = team_registration_1$team$name,
              Team_2 = team_registration_2$team$name,
              Score_1 = score_1,
              Score_2 = score_2,
              Division = str_to_title(round$division),
              Round = round$round %>% case_match(9 ~ 8, .default = round$round),
              Team_Winner = ifelse(Score_1 >= Score_2, Team_1, Team_2),
              Score_Winner = ifelse(Score_1 >= Score_2, Score_1, Score_2),
              Team_Loser = ifelse(Score_1 < Score_2, Team_1, Team_2),
              Score_Loser = ifelse(Score_1 < Score_2, Score_1, Score_2),
              Score_Difference_Real = Score_Winner - Score_Loser)
}


# functions to get the ranking data
get_all_windmill_ranking_data <- function(divisions = c("mixed", "open", "women"),
rounds = seq(1,8))
{
  get_all_windmill_data(FUN=read_windmill_ranking_data, divisions = divisions, rounds = rounds)
}

read_windmill_ranking_data <- function(division, round, 
                                       base_url = "https://windmill-api-production.herokuapp.com/api/v1/ranking/")
{
  full_url <- paste0(base_url, division, "/", round)
  get_data <- req_perform(request(full_url))
  
  jsonlite::fromJSON(rawToChar(get_data$body)) %>%
    transmute(Team = team_registration$team$name,
              Strength = strength,
              Rank = rank,
              Division = str_to_title(division),
              Round = round)
}
