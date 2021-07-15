#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic
  output$hist <- renderPlot({
    amostra <- rnorm(input$num)
    hist(amostra)
  })
}
