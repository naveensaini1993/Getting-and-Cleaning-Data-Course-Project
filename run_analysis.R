# files are downloaded and unziped before execution of this code in the follwoing directory:
# "D:/Coursera/Data Science R/3. Getting & Cleaning data/final assignment"  this is set as working directory as well

library(dplyr)    # loading required library

# step 1: reading all data into r environment

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
s_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_train <-read.table("UCI HAR Dataset/train/X_train.txt")
y_train <-read.table("UCI HAR Dataset/train/y_train.txt")
s_train <-read.table("UCI HAR Dataset/train/subject_train.txt")

activity_labels <-read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# step 2: merge data

x_data <- rbind(x_train,x_test)
y_data <- rbind(y_train,y_test)
s_data <- rbind(s_train,s_test)

names(x_data) <- features[,2]
names(y_data) <- "Activity"
names(s_data) <- "Subject"

merged_data <- cbind(x_data,y_data,s_data)

# step 3: Extracts only the measurements on the mean and standard deviation for each measurement.
required_data <- select(merged_data,"Activity","Subject",contains("mean"),contains("std"))

# step 4: Uses descriptive activity names to name the activities in the data set
required_data$Activity <- activity_labels[required_data$Activity,2]

# step 5: Appropriately labels the data set with descriptive variable names.
names(required_data)<-gsub("Acc", "Accelerometer", names(required_data))
names(required_data)<-gsub("Gyro", "Gyroscope", names(required_data))
names(required_data)<-gsub("BodyBody", "Body", names(required_data))
names(required_data)<-gsub("Mag", "Magnitude", names(required_data))
names(required_data)<-gsub("^t", "Time", names(required_data))
names(required_data)<-gsub("^f", "Frequency", names(required_data))
names(required_data)<-gsub("tBody", "TimeBody", names(required_data))
names(required_data)<-gsub("-mean()", "Mean", names(required_data), ignore.case = TRUE)
names(required_data)<-gsub("-std()", "STD", names(required_data), ignore.case = TRUE)
names(required_data)<-gsub("-freq()", "Frequency", names(required_data), ignore.case = TRUE)
names(required_data)<-gsub("angle", "Angle", names(required_data))
names(required_data)<-gsub("gravity", "Gravity", names(required_data))

# step 6: tidy dataset with the average of each variable for each activity and each subject.
tidydata <- required_data %>% group_by(Activity,Subject) %>% summarise_all(list(mean))

write.table(tidydata, "FinalData.txt", row.name=FALSE)
