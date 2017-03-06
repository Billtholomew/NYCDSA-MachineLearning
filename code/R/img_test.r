library(randomForest)
library(dplyr)
library(reshape2)
library(stats)
library(e1071)
library(h2o)
library(jsonlite)
library(ggplot2)

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

setwd("~/MachineLearning/MachineLearning")
train.data <- readRDS("train_data2.rds")
test.data <- readRDS("test_data.rds")
images.data <- read.csv("img_data2.csv")
images.data <- images.data %>% mutate(listing_id = listing) %>% select(-listing)

images.data[is.na(images.data)] <- 0

train.images <- inner_join(images.data, select(train.data, Photo_Counts, price, listing_id, interest_level))
test.images <- inner_join(images.data, select(test.data, Photo_Counts, price, listing_id))

traindex <- sample(1:nrow(train.images), 0.8 * nrow(train.images), replace=FALSE)

training <- train.images[traindex, ]
testing <- train.images[-traindex, ]

r.Forest <- randomForest(interest_level ~ . -listing_id, training, ntree=1000)

predictors <- testing %>% select(-interest_level)
truth <- as.character(testing$interest_level)

rf.response <- predict(r.Forest, predictors, type='prob')

multiloss(rf.response, truth)
accuracy(rf.response, truth)


#########################################

plot.data <- train.images %>% filter(Photo_Counts > 0)

#plot.data <- plot.data %>% mutate(mu_l = exp(mu_l / 256))

ggplot() + geom_freqpoly(aes(plot.data$mu_s, ..density..,
                             color=plot.data$interest_level), bins = 100) + 
  xlab("Mean Saturation") + ylab("Density") + 
  scale_color_discrete(name="Interest\nLevel",
                      breaks=c("high", "medium", "low"),
                      labels=c("High", "Medium", "Low"))

ggplot(plot.data, aes(x=mode_h * mu_s, y=mu_l, color=interest_level)) + geom_point() + geom_jitter()
