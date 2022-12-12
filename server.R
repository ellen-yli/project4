library(shiny)
library(shinydashboard)
library(tidyverse)
library(caret)
library(rsample)
library(rpart)
library(rpart.plot)
library(randomForest)

diabetes<- read.csv("diabetes.csv")
diabetes$Outcome <- as.factor(diabetes$Outcome)

server <- function(input, output, session){
  
  #Create reactive dataframe
  diabetes_new <- reactive({
    diabetes[input$rows[1]:input$rows[2],input$variable]
  })
  ## 
  output$plot1<- renderPlot({

    hist(diabetes_new(),xlab = input$variable)

  })
  output$plot2<- renderPlot({
    d<- density(diabetes_new())
    plot(d, main = "Kernel Density", xlab = input$variable)
  })
  output$summary<- renderPrint({
    summary(diabetes_new())
  }) 
  output$ex1<- renderUI({
    withMathJax(helpText('The general equation is $$\\log(P/1-P) = \\beta_{null} + \\beta_1X_1 + ... + \\beta_nX_n$$'))
  })
  
  # split data to train and test set and reactive the data set
  
  diabetes$id<- c(1:nrow(diabetes))
  train_set <- reactive({
    index<- initial_split(diabetes, prop = input$train)
    training(index)
  }) 
  
  test_set<- reactive({
    diabetes %>% anti_join(train_set(), by=c("id"))
  })
  
  ## Logistic regression model
  mod1<- reactive({
    train_control<- trainControl(method = "cv", number =10)
    logit<- train(Outcome ~., 
                  data=train_set()[,-10],
                  trControl = train_control,
                  method = "glm",
                  family = binomial())
  })
    output$logit_sum<- renderPrint({
      print(summary(mod1()))
      })
    
    ## Accuracy on training data
    output$logit_train_pro<- renderPrint({
      pred_train<- predict(mod1(), newdata=train_set()[,-10], type = "prob")
      pred_train$var<- as.numeric(pred_train[,1]<pred_train[,2])
      pred_train$var<- as.factor(pred_train$var)
      cm<- confusionMatrix(data=pred_train$var, reference = train_set()$Outcome)
      print(cm)
    })
    
    ## Accuracy on testing data
    output$logit_test_pro<- renderPrint({
      pred_test<- predict(mod1(), newdata=test_set()[,-10], type = "prob")
      pred_test$var<- as.numeric(pred_test[,1]<pred_test[,2])
      pred_test$var<- as.factor(pred_test$var)
      cm_t<- confusionMatrix(data=pred_test$var, reference = test_set()$Outcome)
      print(cm_t)
    })
  
    ## Classification tree model
    mod2<- reactive({
      class_tree<- rpart(Outcome ~., data= train_set()[,-10], method = 'class')
    })
    output$class_plot<- renderPlot({
      rpart.plot(mod2(), extra = 106)
    })
    output$pred_train <- renderPrint({
      pred_train<- predict(mod2(), train_set()[,-10], type = "class")
      table(train_set()$Outcome, pred_train)
    })
    output$pred_test <- renderPrint({
      pred_test<- predict(mod2(), test_set()[,-10], type = "class")
      table(test_set()$Outcome, pred_test)
    })

    ## Random forest model
    mod3<- reactive({
      ran_forest<- randomForest(Outcome ~., data=train_set()[,-10], 
                                mtry = ncol(train_set()[,-10])/3,
                                ntree = 100, importance = TRUE)
    })
    output$rf_sum <- renderPrint({
      print(mod3())
    })
    output$rf_test<- renderPrint({
      pred_test<- predict(mod3(), test_set())
      confusionMatrix(pred_test,test_set()$Outcome)
    })
    new_data<- reactive({
      data.frame(Pregnancies=input$Preg, Glucose=input$Glu, BloodPressure=input$BP, SkinThickness=input$ST, Insulin=input$Ins, BMI=input$BMI, DiabetesPedigreeFunction=input$DPF, Age=input$Age)
    })
    output$new_pred<- renderPrint({
      pred<- predict(mod1(), newdata=new_data(), type = "prob")
      print(pred)
    })
    
    diabetes_re<- reactive({diabetes[,-10]})
    
}


