library(shiny)
library(shinydashboard)



server <- function(input, output, session){
  
  diabetes<- read.csv("diabetes.csv")
  
  output$plot1<- renderPlot({
    hist<-hist(diabetes$Glucose)
  })
}

