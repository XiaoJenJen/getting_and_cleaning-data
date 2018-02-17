library(reshape2)

filename<-"getdata_dataset.zip"

# Download and unzip dataset:
if(!file.exists(filename)){
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method = "curl")
}
if(!file.exists("UCI HAR Dataset")){
        unzip(filename)
} 

# Read activity_labels and feature file
activityLabels<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")

# Read test file
x_test<-read.table("/Users/YafeiXu/GoogleCloud/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("/Users/YafeiXu/GoogleCloud/UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("/Users/YafeiXu/GoogleCloud/UCI HAR Dataset/test/subject_test.txt")

# Read train file
x_train<-read.table("/Users/YafeiXu/GoogleCloud/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("/Users/YafeiXu/GoogleCloud/UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("/Users/YafeiXu/GoogleCloud/UCI HAR Dataset/train/subject_train.txt")

# Assign column names
colnames(x_test)<-features[,2]
colnames(y_test)<-"activityType"
colnames(subject_test)<-"subjectType"

colnames(x_train)<-features[,2]
colnames(y_train)<-"activityType"
colnames(subject_train)<-"subjectType"

colnames(activityLabels)<-c("activityType","activityname")

# Merge the training and the test sets to create one data set
merge_test<-cbind(x_test,y_test,subject_test)
merge_train<-cbind(x_train,y_train,subject_train)
dataset<-rbind(merge_test,merge_train)

# Extract only the measurements on the mean and standard deviation for each measurement
colNames<-colnames(dataset)
meanNstd<-(grepl("mean",colNames)|grepl("std",colNames)|
                   grepl("activityType",colNames)|
                   grepl("subjectType",colNames))
datasetExtracted<-dataset[,meanNstd==TRUE]

# Use descriptive activity names to name the activities in the data set
extractedDatasetWithNames<-merge(datasetExtracted,activityLabels,by="activityType",all.x = TRUE)

# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

TidyDataset <- aggregate(. ~subjectType + activityType, datasetExtracted, mean)
TidyDataset<-merge(TidyDataset,activityLabels,by="activityType",all.x = TRUE)

# Write this tidy dataset in txt file
write.table(TidyDataset,"TidyDataset.txt",row.names = FALSE)
