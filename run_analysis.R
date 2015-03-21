# load needed libraries
library(data.table)
library(dplyr)

# read meta data
featuresNames <- read.table("UCI HAR Dataset\\features.txt")
activityLabels <- read.table("UCI HAR Dataset\\activity_labels.txt", header = FALSE)

# read training data set
# y refers to activity
# x refers to features
subjectTrain <- read.table("UCI HAR Dataset\\train\\subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset\\train\\y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset\\train\\X_train.txt", header = FALSE)

# read test data set
# y refers to activity
# x refers to features
subjectTest <- read.table("UCI HAR Dataset\\test\\subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset\\test\\y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset\\test\\X_test.txt", header = FALSE)

# merge data
# 1) subject, activity and features can be merged for training and test data set
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

# 2) features columnn names are stored in meta data file "features.txt" and
# in data table "featuresNames"
colnames(features) <- t(featuresNames[2])

# 3) complete data set is stored in completeData
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

# extract the measurements on mean and standard deviation for each measurement
# 1) column indices that have either mean or standard deviation
columnsWithMeanStd <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

# 2) add activity and subject columns to the list
requiredColumns <- c(columnsWithMeanStd, 562, 563)

# 3) create extractedData with selected columns in requiredColumn and change
# activity type from numeric to character
extractedData <- completeData[,requiredColumns]
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}

# descriptive activity names to name the activities in the data set and factorize activity
names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))
extractedData$Activity <- as.factor(extractedData$Activity)

# appropriately labels the data set with descriptive variable names and factorize subject
names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))
extractedData$Subject <- as.factor(extractedData$Subject)

# create a second, independent tidy data set with the average of each 
# variable for each activity and each subject.
# 1) update extractedData
extractedData <- data.table(extractedData)
# 2) create tidy data set as tidyData
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean, na.rm=TRUE)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
# 3) write it in a new text file
write.table(tidyData, file = "TidyData.txt", row.names = FALSE)
