## run_analysis.R does the following: 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

setwd("C:/Users/Lynne/Desktop/Coursera/GettingCleaningData/project/data/Dataset")

## Load libraries
if (!require("data.table")) {
  install.packages("data.table")
}
require("data.table")

if (!require("reshape2")) {
  install.packages("reshape2")
}
require("reshape2")

## Load the activity labels, column names and determine which columns will be included
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
columnNames <- read.table("./UCI HAR Dataset/features.txt")[,2]
columnsInclude <- grepl("mean\\(\\)|std\\(\\)", columnNames) 

## 1. Merges the training and the test sets to create one data set.

## Load test set parts (X,y,subject) and merge
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
## 3. Uses descriptive activity names to name the activities in the data set
y_test[,2] = activityLabels[y_test[,1]]
testData <- cbind(as.data.frame(subject_test), y_test, X_test)

## Load train set parts (X,y,subject) and merge
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
## 3. Uses descriptive activity names to name the activities in the data set
y_train[,2] = activityLabels[y_train[,1]]
trainData <- cbind(as.data.frame(subject_train), y_train, X_train)

mergedData <- rbind(testData, trainData)

## 4. Appropriately labels the data set with descriptive variable names. 
headColumns <- c("Subject","ActivityID", "Activity")
allColumns <- c(headColumns, as.character(columnNames))
setnames(mergedData,allColumns)

includeColumns = c(c(TRUE,TRUE,TRUE),columnsInclude)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
data = mergedData[,includeColumns]

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
dataColumns = setdiff(colnames(data), headColumns)
meltData = melt(data, id = headColumns, measure.vars = dataColumns)
meltData$var <- meltData$variable

## Recodes the data hidden in the column headers

## First character t or f = Domain
rc <- grepl("^t", meltData$var)
rc[rc==TRUE] <- "TIME"
rc[rc==FALSE] <- "FREQUENCY"
meltData$Domain <- as.factor(rc)

## Body or Gravity = Acceleration type
rc <- grepl("[a-z]Body", meltData$var)
rc[rc==TRUE] <- "BODY"
rc[rc==FALSE] <- "GRAVITY"
meltData$Acceleration <- as.factor(rc)

## Acc or Gyro = Instrument type
rc <- grepl("Acc", meltData$var)
rc[rc==TRUE] <- "ACCELEROMETER"
rc[rc==FALSE] <- "GYROSCOPE"
meltData$Instrument <- as.factor(rc)

## Is Jerk involved
rc <- grepl("Jerk", meltData$var)
rc[rc==TRUE] <- "YES"
rc[rc==FALSE] <- "NO"
meltData$Jerk <- as.factor(rc)

## Is Magnitude involved
rc <- grepl("Mag", meltData$var)
rc[rc==TRUE] <- "YES"
rc[rc==FALSE] <- "NO"
meltData$Magnitude <- as.factor(rc)

## X, Y or Z Axis
rcX <- grepl("-X", meltData$var)
rcY <- grepl("-Y", meltData$var)
rcZ <- grepl("-Z", meltData$var)
tAxis <- rcX
tAxis[rcX==TRUE] <- "X"
tAxis[rcY==TRUE] <- "Y"
tAxis[rcZ==TRUE] <- "Z"
tAxis[tAxis==FALSE] <- "NA"
meltData$Axis <- as.factor(tAxis)

## Mean or StDev
rc <- grepl("mean",meltData$var)
rc[rc==TRUE] <- "MEAN"
rc[rc==FALSE] <- "STD"
meltData$Variable <- as.factor(rc)

## Create a new data table cleaning out unused columns
ds <- as.data.table(meltData[,c("Subject","Activity","Domain","Acceleration","Instrument","Jerk","Magnitude","Axis","Variable","value")])

## Set key and then calculate frequency and mean of mean or std
setkey(ds, Subject, Activity, Domain, Acceleration, Instrument, Jerk, Magnitude, Axis, Variable)
tidyData <- ds[, list(Count = .N, Avg = mean(value)), by=key(ds)]

write.table(tidyData, file = "./tidydata.txt")
