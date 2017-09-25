setwd("C:/Users/olive/Documents/R/UCI HAR Dataset")
# Read training tables:

x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

# Read testing tables:
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

# Read feature vector:
features <- read.table("features.txt")

# Read activity labels:
activity_labels = read.table("activity_labels.txt")

# Set column names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activity_id"
colnames(subject_train) <- "subject_id"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity_id"
colnames(subject_test) <- "subject_id"

colnames(activity_labels) <- c('activity_id','activity_type')

# Merge

merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
compilation <- rbind(merge_train, merge_test)

# Extract mean and std
colNames <- colnames(compilation)

mean_std <- (grepl("activity_id" , colNames) | 
                   grepl("subject_id" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

set_mean_std <- compilation[ , mean_std == TRUE]

# Name activity

set_activity_name <- merge(set_mean_std, activity_labels,
                              by='activity_id',
                              all.x=TRUE)

# Create TidySet
TidySet <- aggregate(. ~subject_id + activity_id, set_activity_name, mean)
TidySet <- secTidySet[order(secTidySet$subject_id, secTidySet$activity_id),]

write.table(secTidySet, "TidySet.txt", row.name=FALSE)
