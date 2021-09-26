#Reading Train & Test Tables
X_train<-read.table("~/My R Work/R Studio Default/data/UCI HAR Dataset/train/X_train.txt")
X_test<-read.table("~/My R Work/R Studio Default/data/UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("~/My R Work/R Studio Default/data/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("~/My R Work/R Studio Default/data/UCI HAR Dataset/test/y_test.txt")

#Creating a Complete DataSet
my_data<-rbind(X_train, X_test)


#Reading features data table and assigning column names to X-table
features <- read.table("~/My R Work/R Studio Default/data/UCI HAR Dataset/features.txt")

colnames(my_data) = features$V2
rm(features)

#Using dplyr on the data set
my_data<-tbl_df(my_data, silent = TRUE)
library(dplyr)

#Extracting Columns with Mean and Standard Deviation Only
HAR_dataset<-select(my_data, contains(c("mean()" , "std()")))
rm(my_data)

#Adding Descriptive Activity Names
activity_labels <- read.table("~/My R Work/R Studio Default/data/UCI HAR Dataset/activity_labels.txt")
#Creating a list of Activities for Train Datas
train_activity<- y_train %>%
  mutate(V1 = replace(V1,V1==1,activity_labels$V2[1]))  %>%
  mutate(V1 = replace(V1,V1==2,activity_labels$V2[2])) %>%
  mutate(V1 = replace(V1,V1==3,activity_labels$V2[3])) %>%
  mutate(V1 = replace(V1,V1==4,activity_labels$V2[4])) %>%
  mutate(V1 = replace(V1,V1==5,activity_labels$V2[5])) %>%
  mutate(V1 = replace(V1,V1==6,activity_labels$V2[6]))

#Creating a list of Activities for Test Datas
test_activity<- y_test %>%
  mutate(V1 = replace(V1,V1==1,activity_labels$V2[1]))  %>%
  mutate(V1 = replace(V1,V1==2,activity_labels$V2[2])) %>%
  mutate(V1 = replace(V1,V1==3,activity_labels$V2[3])) %>%
  mutate(V1 = replace(V1,V1==4,activity_labels$V2[4])) %>%
  mutate(V1 = replace(V1,V1==5,activity_labels$V2[5])) %>%
  mutate(V1 = replace(V1,V1==6,activity_labels$V2[6]))

#Creating a list of Activities for Entire data and adding to Data Frame
activity_list<-rbind(train_activity,test_activity)
activity_list<-rename(activity_list,"Activity"="V1")

# #Cleaning Column names for HAR_dataset
colnames(HAR_dataset)<-gsub("tBody", "TimeBody_",colnames(HAR_dataset))
colnames(HAR_dataset)<-gsub("Acc-", "Acceleration_",colnames(HAR_dataset))
colnames(HAR_dataset)<-gsub("Acc", "Acceleration_",colnames(HAR_dataset))
colnames(HAR_dataset)<-gsub("mean()", "Mean",colnames(HAR_dataset))
colnames(HAR_dataset)<-gsub("tGravity", "TimeGravity_",colnames(HAR_dataset))
colnames(HAR_dataset)<-gsub("Jerk-", "Jerk_",colnames(HAR_dataset))
colnames(HAR_dataset)<-gsub("Mag-", "Magnitude_",colnames(HAR_dataset))
colnames(HAR_dataset)<-gsub("Gyro-", "Gyroscope",colnames(HAR_dataset))



HAR_dataset<- cbind(activity_list,HAR_dataset)


# #Creating a Separate Dataset for with the average of each variable for each
# activity and each subject.
subject_train <- read.table("~/My R Work/R Studio Default/data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("~/My R Work/R Studio Default/data/UCI HAR Dataset/test/subject_test.txt")

subject_list<-rbind(subject_train,subject_test)
subject_list<-subject_list %>% rename(Subject = V1)

tempset<- cbind(subject_list,HAR_dataset)

HAR_perSubject<- tempset %>% group_by(Subject,Activity) %>%
  summarise(across(everything(),mean))
rm(tempset)

#Removes Unused variables
rm(y_train,y_test,train_activity,test_activity,activity_list,activity_labels)
rm("X_train","X_test")
rm(subject_list,subject_test,subject_train)

#Outputs two data Set namely:
#HAR_dataset which has all experiment values for each Activity
#HAR_perSubject shows mean of each experiment value for subjects per Activity
