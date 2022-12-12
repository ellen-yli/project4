library(shinydashboard)
library(shiny)
library(ggplot2)
library(tidyverse)
library(caret)
library(rsample)
library(rpart)
library(rpart.plot)

ui<- dashboardPage(
  dashboardHeader(title = "Diabetes Prediction"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "About"),
      menuItem("Exploration", tabName = "Exploration"),
      menuItem("Modeling", tabName = "Modeling",
               startExpended = TRUE,
               menuSubItem("Modeling Info", tabName = "MInfo"),
               menuSubItem("Model Fitting", tabName = "MFitting"),
               menuSubItem("Prediction", tabName = "Prediction")),
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
            
              selectInput("summary", "Summary Type", c("Histogram plot", "Density plot", "Numeric summary")),
              selectInput("variable", "Select Variable", choices=colnames(diabetes[,-9])),
              sliderInput("rows", "Number of Rows", min = 1, max = 768, step = 50, value = c(1,768)
            ),
            fluidRow(
             conditionalPanel(
               condition = "input.summary == 'Histogram plot'",
                box(title = "Histogram plot", plotOutput ("plot1",                                            height = 350))),
             conditionalPanel(
               condition = "input.summary == 'Density plot'",
               box(tittle = "Density plot", plotOutput ("plot2"), height = 350)
            ),
            conditionalPanel(
              condition = "input.summary == 'Numeric summary'",
              box(title = "Numeric summary", verbatimTextOutput("summary"))
            )
            )),
    
    # Third tab content
            tabItem(tabName = "MInfo",
                    fluidRow(
                      column(12,
                             span(h4("1. Generalized linear regression allow us to build a linear relationship between the response and predictors when their relationship is not linear. In this case, the response variable is categorical. However, this model is not for data which are correlated with each other."))),
              uiOutput("ex1"),
              column(12,
                     span(h4("2. Classification tree is to analyze and predict the class via tree-building algorithms. Some of the advantages are easy to interpret and visualize, less effort for pre-processing of data and no need to make assumptions about classifier structure. However, overftting can be one of problems. A small change in the data trends might cause a big difference in the tree structure."))),
              column(12,
                     span(h4("3. Random forest is a supervised machine learning algorith that is used widely in classification. Random Forests uses the same idea as bagging but only use a random subset of predictors for each booststrap. It will then average the results of the multiple trees created. Some of the advantages are no need to scale or transform the variables, handling well for both linear and non-linear reatltionships and balance the bias-variance trade-off. However, random forests are not easy to interpret and might be computationally intensive for large data sets.")))
                    )),
           tabItem(tabName = "MFitting",
                   sliderInput("train", "Select proportion for training data set:", min = 0.1, max = 0.9, step = 0.1, value = 0.1),
                   selectInput("model", "Select the model:", c("Logistic regression", "Classification tree", "Random forest")),
                   actionButton("button", "Click to fit the model"),
              conditionalPanel(condition = "input.model == 'Logistic regression'",     
                   box(title = "Model summaries", verbatimTextOutput("logit_sum")),
                   box(title = "Train data prediction", verbatimTextOutput(("logit_train_pro"))),
                   box(title = "Test data prediction", verbatimTextOutput("logit_test_pro"))),
              conditionalPanel(condition = "input.model == 'Classification tree'",
                               box(title = "Classification tree fit model", plotOutput("class_plot")),
                               box(title = "Prediction on training data", verbatimTextOutput("pred_train")),
                               box(title = "Prediction on testing data", verbatimTextOutput("pred_test"))),
              conditionalPanel(condition = "input.model == 'Random forest'",
                              box(title = "Model summaries", verbatimTextOutput("rf_sum")),
                              box(title = "Prediction accuracy on testing data", verbatimTextOutput(("rf_test"))))
                   ),
           
    tabItem(tabName = "Prediction",
            sliderInput("Preg", "Pregnancies", min= 0, max = 10, step = 1, value = 1),
            sliderInput("Glu", "Glucose", min=50, max = 200, step = 10, value = 90),
            sliderInput("BP", "BloodPressure", min=30, max=120, step =10, value = 80),
            sliderInput("ST","SkinThickness", min=0, max=100, step = 10, value = 20),
            sliderInput("Ins","Insulin", min=0, max=200, step=10, value=50),
            sliderInput("BMI","BMI", min=15, max =50, step=5, value=30),
            sliderInput("DPF","DiabetesPedigreeFunction", min=0, max=5, step=0.5, value=1),
            sliderInput("Age","Age",min=0, max=100, step=5, value=20),
            box(title ="Predction of probability of having diabetes", verbatimTextOutput("new_pred"))),
            
    
    #Fourth tab content
    tabItem(tabName = "Data",
         
              
            )
  
)))


