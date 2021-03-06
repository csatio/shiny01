library(shinydashboard)
library(ggplot2)
library(rlang)
library(tidyverse)
library(tidymodels)

app_ui <- dashboardPage(skin = "yellow",title = "Claudio Satio - ASN.ROCKS",
                dashboardHeader(title = "Tópicos"),
                dashboardSidebar(
                  sidebarMenu(
                    menuItem("Introdução", tabName = "introhtml"),

                    menuItem("Shiny - Base Diamonds", tabName = "shinydiamonds"),

                    menuItem("RMarkdown - DC x Marvel", tabName = "dcmarvelhtml"),

                    menuItem("Análise Cluster", tabName = "clusterhtml"),

                    menuItem("Séries Temporais", tabName = "serieshtml"),

                    menuItem("Text Mining", tabName = "textmininghtml"),

                    menuItem("Geoestatística", tabName = "geohtml")
                  )
                ),
                dashboardBody(
                  tags$head(tags$style(HTML("
    @import url('https://fonts.googleapis.com/css?family=Open+Sans');
      .content-wrapper {
        background-color: #fff;
      }
      .skin-yellow .main-sidebar {
                              background-color: #fff;
                              color: #000000;
      }
      .skin-yellow .main-sidebar .sidebar .sidebar-menu .active a{
                              background-color: #fff;
                              color: #000000;
                              }
    "))),
                  tabItems(
                    tabItem(tabName = "introhtml",
                            fluidPage(
                              htmltools::tags$iframe(src = "intro.html", width = '100%',  height = 1000,  style = "border:none;"))
                    ),
                    tabItem(
                      tabName = "shinydiamonds",
                      h1("Estudo da base Diamonds com Shiny"),
                      tagList(
                        # Your application UI logic
                        fluidRow(
                          column(7,
                                 fluidPage(
                                   "Histogramas diamonds",
                                   selectInput(
                                     inputId = "variavel",
                                     label = "Selecione a variável",
                                     choices = names(diamonds)
                                   ),
                                   plotOutput(outputId = "hist")
                                 )
                          ),
                          column(5,
                                 fluidPage(
                                   "Executar o modelo",
                                   numericInput("carat", "carat:", 0.3, min = 0.001, max = 5),
                                   selectInput(
                                     inputId = "cut",
                                     label = "cut",
                                     choices = unique(diamonds$cut)
                                   ),
                                   selectInput(
                                     inputId = "color",
                                     label = "color",
                                     choices = unique(diamonds$color)
                                   )
                                   ,
                                   selectInput(
                                     inputId = "clarity",
                                     label = "clarity",
                                     choices = unique(diamonds$clarity)
                                   ),
                                   numericInput("depth", "depth:", 62, min = 40, max = 80),
                                   numericInput("table", "table:", 56, min = 40, max = 80),
                                   numericInput("x", "x:", 5, min = 0, max = 10),
                                   numericInput("y", "y:", 5, min = 0, max = 10),
                                   numericInput("z", "z:", 5, min = 0, max = 10),
                                   actionButton(inputId = "executar", label = "Executar"),
                                   fluidRow(p("")),
                                   "Preço estimado:",
                                   textOutput("preco")
                                 )
                          )
                        )
                      )
                    ),
                    tabItem(tabName = "dcmarvelhtml",
                               fluidPage(
                                 htmltools::tags$iframe(src = "dc_marvel.html", width = '100%',  height = 1000,  style = "border:none;"))
                     ),
                    tabItem(tabName = "clusterhtml",
                            fluidPage(
                              htmltools::tags$iframe(src = "cluster.html", width = '100%',  height = 1000,  style = "border:none;"))
                    ),
                    tabItem(tabName = "serieshtml",
                            fluidPage(
                              htmltools::tags$iframe(src = "series.html", width = '100%',  height = 1000,  style = "border:none;"))
                    ),
                    tabItem(tabName = "textmininghtml",
                            fluidPage(
                              htmltools::tags$iframe(src = "textmining.html", width = '100%',  height = 1000,  style = "border:none;"))
                    ),
                    tabItem(tabName = "geohtml",
                            fluidPage(
                              htmltools::tags$iframe(src = "geo.html", width = '100%',  height = 1000,  style = "border:none;"))
                    )
                  )
                )

)



app_server <- function( input, output, session ) {
  # Your application server logic


  #output$hist <- renderPlot({
  #  hist(diamonds[,input$variavel])

  output$hist <- renderPlot({

    if (class(unlist(diamonds[,input$variavel]))=="numeric"){
      hist(as.numeric(unlist(diamonds[,input$variavel])),col="#0073C2FF",main=input$variavel,xlab=input$variavel)
    } else {
      x = parse_quo(input$variavel, env = caller_env())
      ggplot(diamonds, aes(!!x))+ geom_bar(fill = "#0073C2FF")
    }

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

    tryCatch({

      diamonds_final_model<-readRDS('www/diamonds_final_model.rds')
      diamonds_com_previsao <- mutate(diamonds2,price_pred = exp(predict(diamonds_final_model, new_data = diamonds2)$.pred))       #### exp para reverter o log

      v$preco <- tail(diamonds_com_previsao,n=1)$price_pred
    }, error=function(e) {

      v$preco <- e$message
    }, warning=function(w) {
      #browser()
      v$preco <- w$message
    })

  })


  output$preco <- renderText( v$preco)
  #output$preco <- renderText("Em manutenção.")
}

shiny::shinyApp(app_ui, app_server)

