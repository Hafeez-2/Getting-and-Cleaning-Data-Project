# Getting and Cleaning Data Course Project

features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

colnames(x_data) <- features[,2]

mean_std <- grep("mean\\(\\)|std\\(\\)", features[,2])
x_data <- x_data[, mean_std]

colnames(y_data) <- "activityId"
y_data <- merge(y_data, activity_labels, by.x="activityId", by.y="V1")
colnames(y_data)[2] <- "activity"

names(x_data) <- gsub("^t", "Time", names(x_data))
names(x_data) <- gsub("^f", "Frequency", names(x_data))
names(x_data) <- gsub("Acc", "Accelerometer", names(x_data))
names(x_data) <- gsub("Gyro", "Gyroscope", names(x_data))
names(x_data) <- gsub("Mag", "Magnitude", names(x_data))
names(x_data) <- gsub("BodyBody", "Body", names(x_data))

clean_data <- cbind(subject_data, y_data["activity"], x_data)

library(dplyr)
tidy_data <- clean_data %>%
  group_by(subject_data, activity) %>%
  summarise_all(mean)

write.table(tidy_data, "tidy_data.txt", row.name = FALSE)
