## Load files and stuff
library(jsonlite)
library(dplyr)
library(VIM)
library(data.table)
library(ggplot2)
library(tree)
setwd("~/DataScience/Projects/MachineLearning")

#train.data <- read.csv("train_data.csv")
train.data <- readRDS("train_data.rds")

################################

## keep these counts in mind
interest.level.counts <- as.data.frame(train.data %>% group_by(interest_level) %>% summarise(count = n()))
interest.level.counts <- data.frame(interest.level.counts %>% filter(interest_level=="high") %>% select(count), 
                                    interest.level.counts %>% filter(interest_level=="medium") %>% select(count),
                                    interest.level.counts %>% filter(interest_level=="low") %>% select(count)
)
names(interest.level.counts) <- c("high", "medium", "low")

################################

features <- read.csv("~/DataScience/Projects/MachineLearning/data/features_2.csv",
                     quote="", row.names=NULL, stringsAsFactors=FALSE)

names(features) <- c("fid", "f.text", "frequency")

listing.features <- read.csv("~/DataScience/Projects/MachineLearning/data/listing_features.csv",
                             quote="", row.names=NULL, stringsAsFactors=FALSE)

names(listing.features) <- c("listing_id", "fid")

features$common <- ifelse(features$frequency > 3, "Common", "Uncommon")

listing.features2 <- inner_join(listing.features, features, by="fid")

listing.features.commoncounts <- listing.features2 %>% group_by(listing_id) %>% 
  summarise(Common = sum(common=="Common"), Uncommon = sum(common=="Uncommon")) %>%
  mutate(ratio = Common / (Common + Uncommon)) %>% mutate(Total = Common+Uncommon)

listing.features.commoncounts <- inner_join(listing.features.commoncounts, 
                                            train.data, 
                                            by="listing_id")

listing.features.commoncounts <- listing.features.commoncounts %>% filter(price < 3000)

## Does number of common features help?

plot.data <- listing.features.commoncounts
ggplot() + geom_freqpoly(aes(plot.data$Common, ..density..,
                             color=plot.data$interest_level), bins = max(plot.data$Common))

## What about strictly common?

plot.data <- listing.features.commoncounts %>% filter(Uncommon==0)

ggplot() + geom_freqpoly(aes(plot.data$Common, ..density..,
                             color=plot.data$interest_level), bins = max(plot.data$Common))

## What about uncommon?, but only where uncommon>0

plot.data <- listing.features.commoncounts %>% filter(Uncommon>0)

ggplot() + geom_freqpoly(aes(plot.data$Uncommon, ..density..,
                             color=plot.data$interest_level), bins = max(plot.data$Uncommon))

## What about uncommon where uncommon>0 and common==0?

plot.data <- listing.features.commoncounts %>% filter(Uncommon>0, Common==0)

ggplot() + geom_freqpoly(aes(plot.data$Uncommon, ..density..,
                             color=plot.data$interest_level), bins = max(plot.data$Uncommon))

## What about totals
plot.data <- listing.features.commoncounts
ggplot() + geom_freqpoly(aes(plot.data$Total, ..density..,
                             color=plot.data$interest_level), bins = max(plot.data$Total))


### NOTES SO FAR!!
# Very few where we have only uncommmon features
# For strictly common, it's basically 50-50 for high and low
# Same for stricttly uncommon
# And for any common, it's also 50-50
# So common features mean nothing!

### Are there any features that mean something?

listing.features.commoncounts2 <- 
  inner_join(listing.features2, listing.features.commoncounts) %>%
  group_by(f.text) %>% 
  summarise(High = sum(interest_level=="high") / interest.level.counts$high, 
            Medium = sum(interest_level=="medium") / interest.level.counts$medium,
            Low = sum(interest_level=="low") / interest.level.counts$low) %>%
  mutate(dHL = High-Low)

listing.features.commoncounts2 <- inner_join(select(features, f.text, frequency), listing.features.commoncounts2, by="f.text")


## Looking at how frequency of occurences for features changes occurances in each class

listing.features.commoncounts2 <- listing.features.commoncounts2 %>% arrange(frequency)

plot(x=listing.features.commoncounts2$frequency, y=listing.features.commoncounts2$High,type="l", col="red", ylab="% Occurances in class", xlab="Frequency")
lines(x=listing.features.commoncounts2$frequency, y=listing.features.commoncounts2$Medium, col="blue")
lines(x=listing.features.commoncounts2$frequency, y=listing.features.commoncounts2$Low, col="green")

# Well, great, how frequent a word is has no bearing on it's occurances in different classes

### Trying to look at class and frequency of features in a different way

listing.features.totalcounts <- inner_join(select(train.data, listing_id, interest_level), listing.features, by="listing_id")
listing.features.totalcounts <- inner_join(listing.features.totalcounts, select(features, fid, frequency), by="fid")

ggplot(listing.features.totalcounts) + geom_freqpoly(aes(frequency, ..density..,
                                                         color=interest_level))

## Stats for mean and stdev of frequencies for features for different interest levels

listing.features.totalcounts %>% group_by(interest_level) %>% summarise(mean(frequency), sd(frequency))


## Lets look at prices and features

listing.features.price <- inner_join(select(train.data, listing_id, interest_level, price), listing.features, by="listing_id")
listing.features.price <- inner_join(listing.features.price, select(features, fid, f.text, frequency), by="fid")

features.by.price <- listing.features.price %>% group_by(fid) %>% summarise(Max.Price = max(price), 
                                                                            Mean.Price = mean(price),
                                                                            Median.Price = median(price),
                                                                            Sd.Price = sd(price),
                                                                            count = n())

features.by.price <- inner_join(features.by.price, select(features, fid, f.text, frequency), b="fid")

errors <- features.by.price[features.by.price$count!=features.by.price$frequency, ]

