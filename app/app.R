library(shinydashboard)
ui <- dashboardPage(
  dashboardHeader(title='Hello world'),
  dashboardSidebar(),
  dashboardBody()
)
server <- function(input, output) { }
shinyApp(ui, server)

