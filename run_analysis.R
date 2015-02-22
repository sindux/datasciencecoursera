# clean workspace
rm(list=ls())

# 0. download and unzip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="dataset.zip")
unzip("dataset.zip")

# 1. Merges the training and the test sets to create one data set.
# load features and activity master data
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("act_id", "activity"))

# load test & train measurement data
test<-read.table("UCI HAR Dataset/test/X_test.txt")
train<-read.table("UCI HAR Dataset/train/X_train.txt")

# load test & train activity
test_activity<-read.table("UCI HAR Dataset/test/Y_test.txt", col.names=c("act_id"))
train_activity<-read.table("UCI HAR Dataset/train/Y_train.txt", col.names=c("act_id"))

# load test & train subject
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"))

# bind activity & subject as last columns
train_with_act <- cbind(train,train_activity,train_subject)
test_with_act <- cbind(test,test_activity,test_subject)

# merge train and test dataset
dataset<-rbind(train_with_act,test_with_act)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
meanstdcols <- features[grepl("-(mean|std)\\(\\)", features$V2),]  ## get -mean() or -std() cols from features
meanstddataset <- dataset[,meanstdcols$V1]   ## pick mean-std cols only from dataset
meanstddataset$act_id <- dataset$act_id   ## add back act_id
meanstddataset$subject <- dataset$subject   ## add back subject

# 3. Uses descriptive activity names to name the activities in the data set
dataset_with_act <- merge(meanstddataset, activity) # join with act_id column to get activity column
dataset_with_act$act_id <- NULL # drop act_id

# 4. Appropriately labels the data set with descriptive variable names. 
cols <- sub("^V", "", names(dataset_with_act))   # strip V prefix
colnames <- sapply(cols, function(x) {f<-features[x,2]; if (is.na(f)) x else as.character(f)}) # get colname from feature
names(dataset_with_act) <- colnames  # replace column names

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
dataset_avg <- dataset_with_act %>% group_by(activity,subject) %>% summarise_each(funs(mean))

write.table(dataset_avg,file = "step5.txt",row.name=FALSE)