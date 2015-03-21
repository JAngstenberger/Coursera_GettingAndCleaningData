The run_analysis.R script has the following structure and variables:

1) load needed libraries
library(data.table)
library(dplyr)

2) read meta data
In the variable featuresNames the features.txt file is stored containing the features names
In the variable activityLabels the activity_labels.txt is stored containing the activity labels

3) read training data set
In the variable subjectTrain the subject_train.txt file is stored containing the subjects 
In the variable activityTrain the y_train.txt file is stored containing the activities 
In the varialbe featuresTrain the X_train.txt file is stored containing the features

4) read test data set
In the variable subjectTest the subject_test.txt file is stored containing the subjects 
In the variable activityTest the y_test.txt file is stored containing the activities 
In the varialbe featuresTest the X_test.txt file is stored containing the features

5) merge data
5.1) subject, activity and features are merged for training and test data set
subject <- rbind(subjectTrain, subjectTest)
In the varialbe subjects both data sets for subjects are merged (test and training data sets)
activity <- rbind(activityTrain, activityTest)
In the varialbe activity both data sets for activities are merged (test and training data sets)
features <- rbind(featuresTrain, featuresTest)
In the varialbe features both data sets for features are merged (test and training data sets)

5.2) features columnn names are stored in meta data file "features.txt" and in data table "featuresNames"
colnames(features) <- t(featuresNames[2])

5.3) complete data set is stored in completeData
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)
In the variable completeData the complete data set of features, activity and subjects is combined

6) extract the measurements on mean and standard deviation for each measurement

6.1) column indices that have either mean or standard deviation are stored in the varialb ecolumnsWithMeanStd
columnsWithMeanStd <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

6.2) add activity and subject columns to the list
requiredColumns <- c(columnsWithMeanStd, 562, 563)
In the variable requiredColumns the Mean and Standard deviation columns are added

6.3) creates extractedData with selected columns in requiredColumn and changes activity type from numeric to character
extractedData <- completeData[,requiredColumns]
In the varialbe extractedData the requiredColumns from the completeData are stored to change the type.
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}

7) descriptive activity names to name the activities in the data set and factorize activity
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

8) appropriately labels the data set with descriptive variable names and factorize subject
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

10) creates a second, independent tidy data set with the average of each variable for each activity and each subject

10.1) updates extractedData
extractedData <- data.table(extractedData)

10.2) create tidy data set as tidyData
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean, na.rm=TRUE)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
In the variable tidyData the newly created data set is stored

10.3) write it in a new text file
write.table(tidyData, file = "TidyData.txt", row.names = FALSE)

The final TidyData.txt has the following structure:

Data Structure

tidyData is a data.frame consisting of 180 rows and 67 variables. The first variable, Activity, refers to the possible observed activity - Walking, Walking Up Stairs, Walking Down Stairs, Laying, Sitting and Standing. The second variable, Subject, identifies the observed subject. The remaining values represent the mean of the observations for each measure of the indiviual for each activity. 

Feature Selection

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ tGravityAcc-XYZ tBodyAccJerk-XYZ tBodyGyro-XYZ tBodyGyroJerk-XYZ tBodyAccMag tGravityAccMag tBodyAccJerkMag tBodyGyroMag tBodyGyroJerkMag fBodyAcc-XYZ fBodyAccJerk-XYZ fBodyGyro-XYZ fBodyAccMag fBodyAccJerkMag fBodyGyroMag fBodyGyroJerkMag
