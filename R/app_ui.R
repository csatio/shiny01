#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {

  library(ggplot2)

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    dashboardHeader(title = "IMDB"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Informações gerais", tabName = "info"),
        menuItem("Orçamentos", tabName = "orcamentos"),
        menuItem("Receitas", tabName = "receitas")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "info",
          h1("Informações gerais dos filmes"),
          fluidPage(
            "Histograma diamonds",
            selectInput(
              inputId = "variavel",
              label = "Selecione a variável",
              choices = names(diamonds)
            ),
            plotOutput(outputId = "hist")
          )
        ),
        tabItem(
          tabName = "orcamentos",
          h1("Analisando os orçamentos")
        ),
        tabItem(
          tabName = "receitas",
          h1("Analisando as receitas")
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
      app_title = 'Claudio Satio Amadatsu'
    )


    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

