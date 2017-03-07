setwd('yourpath/train.json')
library(jsonlite)
library(data.table)
library(kknn) #Load the weighted knn library.)
library(class)
library(dplyr)
library(tidyr)


f=read_json('train.json')

q=read_json('test.json')

p=as.data.frame(t(do.call(rbind, lapply(lapply(f, unlist), "[",
                                        unique(unlist(c(sapply(f,names))))))))

q=as.data.frame(t(do.call(rbind, lapply(lapply(q, unlist), "[",
                                        unique(unlist(c(sapply(q,names))))))))


rm(f)

p[,1]=as.numeric(as.character(p[,1]))
p[,2]=as.numeric(as.character(p[,2]))
p$description = trimws(p$description)
p[,4] = trimws(p[,4])
p[,6]=as.character(p[,6])
p[,7]=as.character(p[,7])
p[,8]=as.numeric(as.character(p[,8]))
p[,9]=as.character(p[,9])
p[,10]=as.numeric(as.character(p[,10]))
p[,12]=as.character(p[,12])
p[,13]=as.numeric(as.character(p[,13]))
p[,14]=as.character(p[,14])
p[,15]=as.character(p[,15])
sapply(p, class)
p['bedbathratio'] = p$bedrooms / p$bathrooms

mp = p[p$price > 400 & p$price < 25000,]


q[,1]=as.numeric(as.character(q[,1]))
q[,2]=as.numeric(as.character(q[,2]))
q$description = trimws(p$description)
q[,4] = trimws(q[,4])
q[,6]=as.character(q[,6])
q[,7]=as.character(q[,7])
q[,8]=as.numeric(as.character(q[,8]))
q[,9]=as.character(q[,9])
q[,10]=as.numeric(as.character(q[,10]))
q[,12]=as.character(p[,12])
q[,13]=as.numeric(as.character(q[,13]))
q[,14]=as.character(q[,14])


mq= q[q$price > 400 & q$price < 25000,]


tot=3839+34284+11229
pcthi = 3839/tot
pctmed = 11229/tot
pctlow=34284 / tot

kdat=mp[, c(1,2,3,8,9,10,11,13)]    
kdat$manager_id = as.integer(as.factor(kdat$manager_id)) 
kdat$building_id = as.integer(as.factor(kdat$building_id))
kdat$price = log(kdat$price)

ktst=mq[, c(1,2,3,8,9,10,11,13)]   
ktst$manager_id = as.integer(as.factor(ktst$manager_id)) 
ktst$building_id = as.integer(as.factor(ktst$building_id))
ktst$price = log(ktst$price)


mytrain = subset(kdat[, -c(4, 5, 6)])
mytest = subset(ktst[, -c(4, 5, 6)])

y = mp$interest_level


fit <- knn(train = mytrain, test = mytest, cl = y, k = 221, prob = TRUE)

knnres =(data.frame(mq$listing_id, pred = fit, prob = attr(fit, "prob")))


colnames(knnres)[3] = 'low'
knnres$med = (1 - knnres$low) * pctmed / (pctmed + pcthi)
knnres$hi = (1 - knnres$low - knnres$med)

knnres = knnres[,3:5]

# write output #####
testPreds <- data.table(knnres$mq.listing_id, knnres$hi, knnres$med,
                        knnres$low)
fwrite(testPreds, "knn test.csv")