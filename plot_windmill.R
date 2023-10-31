plot_real_vs_expected <- function(game_ranking_data, x_lim = c(0,15), y_lim = c(-10,20))
{
  breaks <- c(-15, -1, 1, 15)
  
  
  game_ranking_data %>%                 
    ggplot(aes(label = Round,
               label1 = Game,
               label2 = Game_Expected,
               x=Score_Difference_Real, y=Score_Difference_Expected,
               color = Algorithm_Error,
    )) +
    geom_jitter() +
    #scale_color_gradient2(low = "blue", mid="black", high="red") +
    scale_color_gradientn(colors = c("blue", "black", "red"),
                          values = scales::rescale(breaks),
                          limits = range(breaks),
                          breaks = c(-15, 0, 15)) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    xlim(x_lim) +
    ylim(y_lim)
}