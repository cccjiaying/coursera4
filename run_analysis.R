# loading relevant packages and data files
library(data.table)
library(plyr)
subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)
subjectTest = read.table('./test/subject_test.txt',header=FALSE)
xTest = read.table('./test/x_test.txt',header=FALSE)
yTest = read.table('./test/y_test.txt',header=FALSE)
#1. Combining train and test data sets
xDataSet <- rbind(xTrain, xTest)
yDataSet <- rbind(yTrain, yTest)
Data1 <- rbind(subjectTrain, subjectTest)
#2 Keeping Mean/Std columns
xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xDataSet_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
View(xDataSet_mean_std)
dim(xDataSet_mean_std)
#3 Name activities in Y
yDataSet[, 1] <- read.table("activity_labels.txt")[yDataSet[, 1], 2]
names(yDataSet) <- "Activity"
View(yDataSet)
#4 Label variable names in x,y and mean/std files
names(Data1) <- "Subject"
summary(Data1)
Data1 <- cbind(xDataSet_mean_std, yDataSet, Data1)
names(Data1) <- make.names(names(Data1))
names(Data1) <- gsub('Acc',"Acceleration",names(Data1))
names(Data1) <- gsub('GyroJerk',"AngularAcceleration",names(Data1))
names(Data1) <- gsub('Gyro',"AngularSpeed",names(Data1))
names(Data1) <- gsub('Mag',"Magnitude",names(Data1))
names(Data1) <- gsub('^t',"TimeDomain.",names(Data1))
names(Data1) <- gsub('^f',"FrequencyDomain.",names(Data1))
names(Data1) <- gsub('\\.mean',".Mean",names(Data1))
names(Data1) <- gsub('\\.std',".StandardDeviation",names(Data1))
names(Data1) <- gsub('Freq\\.',"Frequency.",names(Data1))
names(Data1) <- gsub('Freq$',"Frequency",names(Data1))
#5 average of each actvity and subject
names(Data1)
Data2 <-aggregate(. ~Subject + Activity, Data1, mean)
Data2 <-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)