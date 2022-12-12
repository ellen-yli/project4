# project4

## Brief description

This app is to predict the propability that whether a patient has diabetes based on eight diagnostic measurements. 
The app includes data introduction, data exploration, model fitting and prediction. It provides a comparison among three different models. You can also make a prediction with customized dataset by using one of the models. 

## Here are the list of packages needed for the app:

* shiny
* shinydashboard
* tidyverse
* caret
* rsample
* rpart
* rpart.plot
* randomForest

## Code for install all the packages:

```
library(shiny)
library(shinydashboard)
library(tidyverse)
library(caret)
library(rsample)
library(rpart)
library(rpart.plot)
library(randomForest)
```
## Link for running the app:

```
shiny::runGitHub(repo = "project4", username = "ellen-yli", ref = "main")
```
