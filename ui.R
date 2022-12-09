library(shinydashboard)
library(shiny)

ui<- dashboardPage(
  dashboardHeader(title = "Diabetes Prediction"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "About"),
      menuItem("Exploration", tabName = "Exploration"),
      menuItem("Model", tabName = "Model"),
      menuItem("Data", tabName = "Data")
    )
  ),
  
  dashboardBody(
    
    tabItems(
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
    tabItem(tabName = "Exploration",
            fluidRow(
              box(plotOutput ("plot1", height = 200)),
              
              box(
                selectInput( "plotType", "Plot Type",
                            c(Histogram = "hist"))
              )
            )),
    
    # Third tab content
    tabItem(tabName = "Model"),
    
    #Fourth tab content
    tabItem("Data")
  )
)
)