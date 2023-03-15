library(tidyverse)
library(tree)
library(rpart)
library(rpart.plot)
library(dbarts)
library(xgboost)
library(ranger)
library(caret)
library(glmnet)
library(SparseM)
library(randomForest)
library(glmnet)
library(ROCR)
library(bestglm)
library(modelsummary)
library(h2o)
options(scipen = 999)

#####

# setwd("C:/Users/Griffin Ong/Documents/GitHub/Code-Samples/Machine Learning/")

load("HumanActivityRecognition.Rdata")

train_df <- inner_join(Xtrain, Ytrain, by = "X")
test_df <- inner_join(Xtest, Ytest, by = "X")

# rename outcome variable 
train_df <- train_df %>% 
  rename(output = "data.y_train")

test_df <- test_df %>% 
  rename(output = "data.y_test")

train_df <- mutate_if(train_df, is.character, as.factor)
test_df <- mutate_if(test_df, is.character, as.factor)

##### Random Forest #####
phat_list <- list()

train_df <- mutate_if(train_df, is.character, as.factor)
test_df <- mutate_if(test_df, is.character, as.factor)

hyper_grid <- expand.grid(
  mtry       = 50,
  node_size  = c(25, 50, 100, 150, 200),
  OOB_RMSE   = 0
)

for(i in 1:nrow(hyper_grid)) {
  
  # train model
  model <- ranger(
    formula         = output ~ ., 
    data            = train_df, 
    num.trees       = 200,
    mtry            = hyper_grid$mtry[i],
    min.node.size   = hyper_grid$node_size[i],
    seed            = 345
  )
  
  # add OOB error to grid
  hyper_grid$OOB_RMSE[i] <- sqrt(model$prediction.error)
}

(oo = hyper_grid %>% 
    dplyr::arrange(OOB_RMSE) %>%
    head(10))

rf.fit.final <- ranger(
  formula         = output ~ ., 
  data            = train_df, 
  num.trees       = 200,
  mtry            = oo[1,]$mtry,
  min.node.size   = oo[1,]$node_size
)

yhat.rf = predict(rf.fit.final, data = test_df)$predictions

phat_list$rf <- matrix(yhat.rf)

# confusion matrix 
cm <- confusionMatrix(as.factor(test_df$output), as.factor(phat_list$rf[,1]))
print(cm)
