library(randomForest)
library(dplyr)
library(reshape2)
library(stats)
library(e1071)
library(h2o)
library(jsonlite)

multiloss <- function(p, actual){
  p <- pmin(pmax(p, 1e-15), 1 - 1e-15)
  sum(sapply(unique(actual),function(item){sum(-log(p[actual==item,item]))})
  )/nrow(p)
}

accuracy <- function(p, actual){
  p <- pmin(pmax(rf.response, 1e-15), 1 - 1e-15)
  p <- sapply(max.col(p), function (x) {colnames(p)[x]})
  mean(p==actual)
}

setwd("~/DataScience/Projects/MachineLearning/Code and Stuff/MachineLearning/MachineLearning")
train.data <- readRDS("train_data2.rds")
test.data <- readRDS("test_data.rds")

###
# This will simply build the training set
###

training <- train.data

training <- training %>% 
  select(listing_id, price, Photo_Counts, latitude, longitude, bedrooms, 
         fee, pets, pre_war, interest_level) %>%
  mutate(bedrooms = (bedrooms * 10) ** 0.5 * 10) %>%
  mutate(num.photos = (Photo_Counts * 10) ** 0.5 * 10) %>%
  mutate(price = log(price))

###
# This is for testing/training on the training set
###

smp_size <- floor(0.3 * nrow(training))
traindex <- sample(seq_len(nrow(training)), size = smp_size)

training <- training[traindex,]
testing<- training[-traindex,]

predictors <- testing %>% select(-interest_level, -listing_id)
truth <- as.character(testing$interest_level)

###
# This is the test data from Kaggle
##

testing <- test.data

testing <- testing %>% 
  select(listing_id, price, Photo_Counts, latitude, longitude, bedrooms, 
         fee, pets, pre_war) %>%
  mutate(bedrooms = (bedrooms * 10) ** 0.5 * 10) %>%
  mutate(num.photos = (Photo_Counts * 10) ** 0.5 * 10) %>%
  mutate(price = log(price))

predictors <- testing %>% select(-listing_id)

###

training.no.lid <- training %>% select(-listing_id)

r.Forest <- randomForest(interest_level ~ ., training.no.lid, ntree=500, nodesize = 50)

rf.response <- predict(r.Forest, predictors, type='prob')

rf.response <- cbind(testing$listing_id, rf.response)

write.csv(rf.response, "tree_output_1000_512.csv", row.names = FALSE, quote = FALSE)

###

multiloss(rf.response, truth)
accuracy(rf.response, truth)
