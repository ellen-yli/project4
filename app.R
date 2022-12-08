library(shiny)
library(shinydashboard)

ui<- dashboardPage(
  dashboardHeader(title = "Diabetes Prediction"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "About", icon = icon("About")),
      menuItem("Exploration", tabName = "Data Exploration", icon = icon ("DE")),
      menuItem("Model", tabName = "Modeling", icon = icon("Mod")),
      menuItem("Data", tabName = "Data", icon = icon("Data"))
    )
  ),
  
  dashboardBody(
    
    # First tab content
    tabItem(tabName = "About",
    fluidRow(
      column(12,
      span(h3("This app is to display risk factors of Diabetes and how accurate the predictions are based on those factors.")),
      span(h3("Briefly discuss the data and its source.")),
      span(h3("Purpose of each tab"))
         )
      )
    ),
      
      # Second tab content
      tabItem(tabName = "Data Exploration"),
      
      # Third tab content
      tabItem(tabName = "Modeling Page"),
      
      #Fourth tab content
      tabItem("Data")
    )
  )

server <- function(input, output){}

shinyApp(ui,server)