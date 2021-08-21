#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {

  library(ggplot2)
  library(shinydashboard)

  dashboardPage(skin = "yellow",
  dashboardHeader(title = "Tópicos"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Shiny - Base Diamonds", tabName = "shinydiamonds")

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
      tabItem(
        tabName = "shinydiamonds",
        h1("Estudo da base Diamonds com Shiny"),
        tagList(
          # Leave this function for adding external resources
          golem_add_external_resources(),
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
      )
    )
  )
  )


}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'Claudio Satio - Analytics'
    )


    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

