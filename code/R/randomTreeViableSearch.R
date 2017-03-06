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

find.best.tree <- function(train.data) {

  min.ll <- 1000
  min.nt <- 0
  min.ns <- 0
  
  training.base <- train.data %>% 
    select(listing_id, price, Photo_Counts, latitude, longitude, bedrooms, 
           fee, pets, pre_war, interest_level) %>%
    mutate(bedrooms = (bedrooms * 10) ** 0.5 * 10) %>%
    mutate(num.photos = (Photo_Counts * 10) ** 0.5 * 10) %>%
    mutate(price = log(price))
  
  forest.sizes.to.test <- seq(from=500, to=2000, by=250)
  node.sizes.to.test <- c(50, 100, 250, 500, 1000)
  
  total.tests <- length(forest.sizes.to.test) * length(node.sizes.to.test)
  
  i <- 0
  
  for (nt in forest.sizes.to.test) {
  
    for (ns in node.sizes.to.test) {
    
      i <- i + 1
      
      print(paste0(i / total.tests * 100, '%'))
      
      print('Building training and testing sets')
      
      training <- training.base
      
      smp_size <- floor(0.6 * nrow(training))
      traindex <- sample(seq_len(nrow(training)), size = smp_size)
      
      testing <- training[-traindex,]
      training <- training[traindex,]
      
      predictors <- testing %>% select(-interest_level, -listing_id)
      truth <- as.character(testing$interest_level)
      
      training.no.lid <- training %>% select(-listing_id)
      
      print(paste('Building forest', ', # Trees:', nt, ', Node Size:', ns))
      
      r.Forest <- randomForest(interest_level ~ ., training.no.lid, ntree=nt, nodesize=ns)
      
      print('Predicting')
      
      rf.response <- predict(r.Forest, predictors, type='prob')
    
      print('Checking results')
      
      ll <- multiloss(rf.response, truth)
      
      if (ll < min.ll) {
        min.nt <- nt
        min.ns <- ns
        min.ll <- ll
        print(c(nt,ns,ll))
      }
    }
  }
  print(paste("# Trees:", min.nt, ", Node Size:", min.ns, " Min LogLoss:", min.ll))
  paste("# Trees:", min.nt, ", Node Size:", min.ns, " Min LogLoss:", min.ll)
}

setwd("~/DataScience/Projects/MachineLearning/Code and Stuff/MachineLearning/MachineLearning")
train.data <- readRDS("train_data2.rds")
#test.data <- readRDS("test_data.rds")

find.best.tree(train.data)
