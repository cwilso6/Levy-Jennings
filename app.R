#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#Install required packages if not already installed 
packages <- c("ggplot2", "dplyr", "stats", "ggplot2", "box", "openxlsx", 
              "plotly", "shiny")
box::use(utils = utils, 
         openxlsx = openxlsx,
         plotly = plotly)
need_installation = setdiff(packages, rownames(utils$installed.packages()))
if(length(need_installation) > 0){
  utils$install.packages(need_installation)
}
box::use(./R/lj_plot)

library(shiny)
# Define UI for application that draws a histogram
ui <- fluidPage(
  # Application title
  titlePanel("Levy-Jennings Plot"),
  sidebarLayout(
    sidebarPanel(
  fileInput("upload", NULL, buttonLabel = "Upload...", multiple = FALSE),
  textInput(inputId = 'Start', label = 'Start', value = "", width = NULL, placeholder = 'MM/DD/YYYY (Not Required)'),
  textInput(inputId = 'End', label = 'End', value = "", width = NULL, placeholder = 'MM/DD/YYYY (Not Required)'),
  actionButton(inputId = "button", "Generate Plots"),
  tableOutput("files")),
  # Show a plot of the generated distribution
  mainPanel(
    plotly$plotlyOutput("ljPlot")
  )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  dates_set = eventReactive(input$button,{
      data <- openxlsx$read.xlsx(xlsxFile = input$upload$datapath)
      }
  )
  
output$ljPlot <- plotly$renderPlotly({
    data = dates_set()
    plotly$ggplotly(lj_plot(data, start = input$Start, end = input$End))
  }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)
