#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic

  library(ggplot2)
  library(rlang)

  #output$hist <- renderPlot({
  #  hist(diamonds[,input$variavel])

  output$hist <- renderPlot({
    x = parse_quo(input$variavel, env = caller_env())
    ggplot(diamonds, aes(!!x))+ geom_bar(fill = "#0073C2FF")


  })
}
