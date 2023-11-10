team_str_to_link <- function(team_string, input) {
  paste0("<a href=/?_inputs_",
         "&division=\"", input$division, "\"",
         "&round=\"", input$round, "\"",
         "&team=\"", team_string %>% 
           str_replace_all(" ", "%20") %>% 
           str_replace_all("&", "%26"), "\"",
         ">",team_string,"</a>")
}
