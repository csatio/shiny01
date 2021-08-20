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


  v <- reactiveValues()

  observeEvent(input$executar,{
    carat <- input$carat
    cut <- input$cut
    color <- input$color
    clarity <- input$clarity
    depth <- input$depth
    table <- input$table
    x <- input$x
    y <- input$y
    z <- input$z

    v$preco <- diamondprice(as.double(carat),cut,color,clarity,as.double(depth),
                            as.double(table),as.double(x),as.double(y),as.double(z))
  })


  output$preco <- renderText( v$preco)
}


diamondprice <- function(carat,cut,color,clarity,depth,table,x,y,z){
  library(tidyverse)
  library(tidymodels)
  diamonds2 <- mutate(diamonds,price_log=log(price))
  diamonds2 <- add_row(diamonds2,"carat" = as.double(carat),
                       "cut" = cut,
                       "color" = color,
                       "clarity" =clarity,
                       "depth" = as.double(depth),
                       "table" = as.double(table),
                       "x" = as.double(x),
                       "y" = as.double(y),
                       "z" = as.double(z),
                       "price" = integer(1),
                       "price_log" = 0.0)
  diamonds_final_model<-readRDS('diamonds_final_model.rds')
  diamonds_com_previsao <- mutate(diamonds2,price_pred = exp(predict(diamonds_final_model, new_data = diamonds2)$.pred))       #### exp para reverter o log
  return(tail(diamonds_com_previsao,n=1)$price_pred)
}
