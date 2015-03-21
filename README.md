run_analysis.R

run_analysis.R is the code for the Project for the Coursera course Getting and Cleaning Data.

The purpose of run_analysis.R is to:

Create one R script called run_analysis.R that does the following:

Merges the training and the test sets to create one data set. Extracts only the measurements on the mean and standard deviation for each measurement. Uses descriptive activity names to name the activities in the data set Appropriately labels the data set with descriptive variable names. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The code is organized as follows:

1) loading needed libraries (data.table and dplyr)

2) read meta data (features.txt and activity_labels.txt)

3) read training data set (subject_train.txt [subjectTrain], y_train.txt [activityTrain] and X_train.txt [featuresTrain])

4) read test data set (subject_test.txt [subjectTest], y_test.txt [activityTest] and X_test.txt [featuresTest])

5) merge data

5.1) subject, activity and features can be merged for both data sets

5.2) load column names (features.txt)

5.3) create complete data set (completeData)

6) extract the measurements on mean and standard deviation for each measurement

6.1) column indices that have either mean or standard deviation (extract these indices)

6.2) add activity and subject columns to the list

6.3) create extractedData with selected columns in requiredColumn and change activity type from numeric to character

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

9) create a second, independent tidy data set with the average of each variable for each activity and each subject

9.1) update extracteData table

9.2) create tidy data set as tidyData (aggregate and order by Subject and Activity and remove NAs)

9.3) write tidy data as new "tidyData.txt" file
