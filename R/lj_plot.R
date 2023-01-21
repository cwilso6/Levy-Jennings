#' @export
lj_plot = function(data, start = "", end = ""){
  box::use(gg = ggplot2, 
           dplyr= dplyr,
           stats = stats)
  #data = dplyr$filter(.data = data, dplyr$between(Day, left = as.numeric(start), right = as.numeric(end)))
  data$Day = format(as.Date(x = data$Day, origin = "12/30/1899", format = "%m/%d/%Y"),"%m/%d/%Y") 
  if(start == ""){
    start = data$Day[1]
  }
  if(end == ""){
    end = data$Day[nrow(data)]
  }
  data$In_range = (data$Day >= format(as.Date(start, format = "%m/%d/%Y"), "%m/%d/%Y")&
    data$Day <= format(as.Date(end, format = "%m/%d/%Y"),"%m/%d/%Y")) + 0
  sum_stats = dplyr$summarize(.data = data, mean = mean(Value), sd = stats$sd(Value)) 
  data = dplyr$mutate(.data = data, z_score = (Value - mean(Value)) / stats$sd(Value))
  data = dplyr$mutate(.data = data, 
                      Value = round(Value,3),
                      z_score = round(z_score,3))
  plot = gg$ggplot(data = dplyr$filter(.data = data, In_range == 1), 
                   gg$aes(x = Day, y = Value, label = z_score)) + 
    gg$geom_point() + 
    gg$geom_line() + 
    gg$geom_hline(yintercept = c(sum_stats$mean + -3*sum_stats$sd,sum_stats$mean + 3*sum_stats$sd), 
                  color = 'red', linetype = 'solid') +
    gg$geom_hline(yintercept = c(sum_stats$mean + -2*sum_stats$sd,sum_stats$mean + 2*sum_stats$sd), 
                  color = 'yellow', linetype
                  = '
                twodash') +
    gg$geom_hline(yintercept = c(sum_stats$mean + -1*sum_stats$sd,sum_stats$mean + 1*sum_stats$sd), 
                  color = 'green', linetype = 'dashed') +
    gg$geom_hline(yintercept = sum_stats$mean , 
                  color = 'blue', linetype = 'solid') + 
    gg$ggtitle(paste('Levy-Jennings Plot for', colnames(data)[2], '\n(mean =', round(sum_stats$mean,2), ', and sd = ', 
                     round(sum_stats$sd,2), ')')) + 
    gg$theme_bw() + 
    gg$theme(panel.grid = gg$element_blank(),
             axis.text.x = gg$element_text(angle = 45, vjust = 0.5, hjust=1)) + 
    gg$xlab('Day')
  
  plot
}





