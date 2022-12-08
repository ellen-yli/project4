library(shiny)
library(shinydashboard)

ui<- dashboardPage(
  dashboarHeader(),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output){}

shinyApp(ui,server)