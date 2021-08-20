library(shinydashboard)
#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {

  library(ggplot2)

  dashboardPage(skin = "yellow",
  dashboardHeader(title = "Tópicos"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Shiny - Base Diamonds", tabName = "shinydiamonds")

    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
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
    '))),
    tabItems(
      tabItem(
        tabName = "shinydiamonds",
        h1("Estudo da base Diamonds com Shiny"),
        tagList(
          # Leave this function for adding external resources
          golem_add_external_resources(),
          # Your application UI logic

          fluidPage(
            "Histogramas diamonds",
            selectInput(
              inputId = "variavel",
              label = "Selecione a variável",
              choices = names(diamonds)
            ),
            plotOutput(outputId = "hist")
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

