#' @export

noapp = function(filepath = 'example_data/example.xlsx'){
#Install required packages if not already installed 
packages <- c("ggplot2", "dplyr", "stats", "ggplot2", "box", "openxlsx", "plotly")
box::use(utils = utils)
need_installation = setdiff(packages, rownames(utils$installed.packages()))
if(length(need_installation) > 0){
  utils$install.packages(need_installation)
}

box::use(openxlsx = openxlsx,
         plotly = plotly)
data = openxlsx$read.xlsx(xlsxFile = filepath)
setwd('.') #Change to folder where this file is
box::use(./lj_plot)
plot = lj_plot$lj_plot(data)
interactive_plot = plotly$ggplotly(plot)
interactive_plot
}

