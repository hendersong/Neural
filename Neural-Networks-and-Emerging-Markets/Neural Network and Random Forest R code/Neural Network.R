
#conect to databases
library(RODBC)
library(zoo)
library(caret)
library(nnet)
library(randomForest)
library(e1071)
library(doParallel)
library(pROC)
library(quantmod)
#import the function from Github
library(devtools)
source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')



con <- odbcConnect("BachEssay")

#data before 2007, use as training set
data07 <- sqlQuery(con, "select num2.*, us.one_mo, us.three_mo, us.six_mo, us.one_yr, us.two_yr, us.three_yr, us.five_yr, us.seven_yr, us.ten_yr, us.twenty_yr, us.thirty_yr
from
                   (SELECT num.*, india.GDP
                   from
                   (select rsi_macd.*, price.Open_Price, price.Close_Price, price.percent_change, price.Volume
                   from
                   (SELECT r.date_t,r.ticker, r.RSI,m.MACD, m.signal
                   FROM [Bachlor Essay].[dbo].[RSI] as r
                   inner join [Bachlor Essay].dbo.MACD as m
                   on m.Date_of_Price=r.date_t and m.Ticker=r.ticker) as rsi_macd
                   inner join [Bachlor Essay].dbo.Historic_NSE_Date as price
                   on price.Date_of_Price = rsi_macd.date_t and rsi_macd.Ticker= price.Ticker) as num
                   left join [Bachlor Essay].dbo.India_GDP as india
                   on india.Date_of_GDP=num.date_t) as num2
                   left join [Bachlor Essay].dbo.US_Yield as us
                   on us.Date_of_Bond= num2.date_t
                   
                   where year(num2.date_t) < 2007")

#2007-2013, use as validation set
data13 <- sqlQuery(con, "select num2.*, us.one_mo, us.three_mo, us.six_mo, us.one_yr, us.two_yr, us.three_yr, us.five_yr, us.seven_yr, us.ten_yr, us.twenty_yr, us.thirty_yr
from
                   (SELECT num.*, india.GDP
                   from
                   (select rsi_macd.*, price.Open_Price, price.Close_Price, price.percent_change, price.Volume
                   from
                   (SELECT r.date_t,r.ticker, r.RSI,m.MACD, m.signal
                   FROM [Bachlor Essay].[dbo].[RSI] as r
                   inner join [Bachlor Essay].dbo.MACD as m
                   on m.Date_of_Price=r.date_t and m.Ticker=r.ticker) as rsi_macd
                   inner join [Bachlor Essay].dbo.Historic_NSE_Date as price
                   on price.Date_of_Price = rsi_macd.date_t and rsi_macd.Ticker= price.Ticker) as num
                   left join [Bachlor Essay].dbo.India_GDP as india
                   on india.Date_of_GDP=num.date_t) as num2
                   left join [Bachlor Essay].dbo.US_Yield as us
                   on us.Date_of_Bond= num2.date_t
                   
                   where year(num2.date_t) >= 2007 and year(num2.date_t) < 2013 ")

#close down the connection to sql for performance
odbcClose(con)

#get the next days percent change value and order by ticker, then date
data13<- data13[order(data13[,2], data13[,1]), ]
data13$next_percent_changer <- c(data13$percent_change[-1], NA)

data07<- data07[order(data07[,2], data07[,1]), ]
data07$next_percent_changer <- c(data07$percent_change[-1], NA)

#fill na values with value before it. Otherwise, fill 0
data07 <- na.locf(data07)
data07[is.na(data07)] <- 0

data13 <- na.locf(data13)
data13[is.na(data13)] <- 0

cols=c(3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22)
data07[,cols] = apply(data07[,cols], 2, function(x) as.numeric(x));

cols=c(3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22)
data13[,cols] = apply(data13[,cols], 2, function(x) as.numeric(x));

## for time series, create lag columns for each variable
data07$rsiLag1 <-Lag(data07[,3])
data07$macdLag1 <-Lag(data07[,4])
data07$signalLag1 <-Lag(data07[,5])
data07$openLag1 <-Lag(data07[,6])
data07$closeLag1 <-Lag(data07[,7])
data07$percent_changeLag1 <-Lag(data07[,8])
data07$volumeLag1 <-Lag(data07[,9])

#lag two days
data07$rsiLag2 <-Lag(data07[,3],2)
data07$macdLag2 <-Lag(data07[,4],2)
data07$signalLag2 <-Lag(data07[,5],2)
data07$openLag2 <-Lag(data07[,6],2)
data07$closeLag2 <-Lag(data07[,7],2)
data07$percent_changeLag2 <-Lag(data07[,8],2)
data07$volumeLag2 <-Lag(data07[,9],2)

#lag three days
data07$rsiLag3 <-Lag(data07[,3],3)
data07$macdLag3 <-Lag(data07[,4],3)
data07$signalLag3 <-Lag(data07[,5],3)
data07$openLag3 <-Lag(data07[,6],3)
data07$closeLag3 <-Lag(data07[,7],3)
data07$percent_changeLag3 <-Lag(data07[,8],3)
data07$volumeLag3 <-Lag(data07[,9],3)

## for 2013

data13$rsiLag1 <-Lag(data13[,3])
data13$macdLag1 <-Lag(data13[,4])
data13$signalLag1 <-Lag(data13[,5])
data13$openLag1 <-Lag(data13[,6])
data13$closeLag1 <-Lag(data13[,7])
data13$percent_changeLag1 <-Lag(data13[,8])
data13$volumeLag1 <-Lag(data13[,9])

#lag two days
data13$rsiLag2 <-Lag(data13[,3],2)
data13$macdLag2 <-Lag(data13[,4],2)
data13$signalLag2 <-Lag(data13[,5],2)
data13$openLag2 <-Lag(data13[,6],2)
data13$closeLag2 <-Lag(data13[,7],2)
data13$percent_changeLag2 <-Lag(data13[,8],2)
data13$volumeLag2 <-Lag(data13[,9],2)

#lag three days
data13$rsiLag3 <-Lag(data13[,3],3)
data13$macdLag3 <-Lag(data13[,4],3)
data13$signalLag3 <-Lag(data13[,5],3)
data13$openLag3 <-Lag(data13[,6],3)
data13$closeLag3 <-Lag(data13[,7],3)
data13$percent_changeLag3 <-Lag(data13[,8],3)
data13$volumeLag3 <-Lag(data13[,9],3)

# code percent change, above 0 is one, zero and below is zero

data07= within(data07, {predict=ifelse(next_percent_changer > 0, "Up", "Down")})
data13= within(data13, {predict=ifelse(next_percent_changer > 0, "Up", "Down")})

#factorize next day up or down using for classification
data07[, 44 ] <- as.factor(data07[, 44])
data13[, 44 ] <- as.factor(data13[, 44])

#remove all NA's left
data13[is.na(data13)] <- 0
data07[is.na(data07)] <- 0

data07[,22]<- NULL
data13[,22]<- NULL

##
##
##
## Neural Network and Random Forest
####


#create training data and validation data to test on

#randomize order, so you dont just get the same dates all the time
data07<- data07[sample( nrow(data07), nrow(data07)),]
data13<- data13[sample( nrow(data13), nrow(data13)),]

x_train <-data07[1:25550, 3:42]
y_train <-data07[1:25550, 43]

x_valid <-data13[25556:60000,3:42]
y_valid <-data13[25556:60000,43]

## randomforest
rf <- randomForest(x=x_train,y=y_train,importance=TRUE,ntree=127,proximity=F)
#predict using randomForest
rf_predict <- predict(rf,x_valid)

#accuracy measurements
confusion_rf=confusionMatrix(rf_predict,y_valid)
confusion_data<-confusion_rf$overall
save(rf, file="RF.rda")

#Find the most important variables
rf_importance=importance(rf,scale=FALSE)
a=rf_importance[order(-rf_importance[,3]),]

## run multicore for faster performance
cl <- makeCluster(detectCores())
registerDoParallel(cl)

#neural network, using nnet and caret
model_nn <- train(x_train, y_train, method='nnet', linout=FALSE,MaxNWts=10000,maxit=100, trace = FALSE,metric="ROC",
                  #Grid of tuning parameters to try:
                  tuneGrid=expand.grid(.size=c(1,5,10),.decay=c(.001,.01,.1,1)), trControl=trainControl(allowParallel=TRUE, savePredictions = T, classProbs = TRUE, summaryFunction = twoClassSummary))
save(model_nn, file="neural_net_full_data.rda")

#predict validation set with neural net
ps_nn <- predict(model_nn, x_valid)
stopCluster(cl)

#if this doesn't work, it's because model isn't predicting one variable at all
table_nn_rf=table(ps_nn, y_valid)
confusion_nn=confusionMatrix(ps_nn, y_valid)

#print out of each method, this is all visualization
#
#
#



#random Forest
confusion_rf$table
#only for postive class
confusion_rf$byClass
confusion_rf$overall

#neural net
confusion_nn$table
#only for postive class
confusion_nn$byClass
confusion_nn$overall

#visualize random forest
varImpPlot(rf)

#plot neural network
plot.nnet(model_nn)
