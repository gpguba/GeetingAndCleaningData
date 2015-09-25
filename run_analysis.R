##Getting and cleaning Data Project


##Initialize parameters and load packages. Be sure to change the working directory first before running this code
setwd("./data science/getting and cleaning data/project")
path <- getwd()
require(data.table, quietly = TRUE)
require(tidyr, quietly = TRUE)
#require(dplyr, quietly = TRUE)



##download and  unzip the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip")
unzip("Dataset.zip")

##check files
dataPath <- "./UCI HAR Dataset"
list.files(dataPath, recursive = TRUE)

#read files
dtSubjectTrain <- fread(file.path(dataPath,"train", "subject_train.txt"))
dtTrain <- fread(file.path(dataPath,"train","x_train.txt"))
dtTrainLabel <-fread(file.path(dataPath,"train","y_train.txt"))

dtSubjectTest <- fread(file.path(dataPath,"test","subject_test.txt"))
dtTestLabel <-  fread(file.path(dataPath,"test","y_test.txt"))
dtTest <- fread(file.path(dataPath,"test","x_test.txt"))

##merge data sets ---
dtLabel <- rbind(dtTestLabel,dtTrainLabel)
setnames(dtLabel,"V1", "Label")
dtSubject <- rbind(dtSubjectTest,dtSubjectTrain)
setnames(dtSubject,"V1", "Subject")
dt <- rbind(dtTest,dtTrain)

#combine all data
#combine data
dtSubjectLabel <- cbind(dtSubject,dtLabel)
dt <- cbind(dtSubjectLabel,dt)


#read feature files
dtFeatures <- fread(file.path(dataPath, "features.txt"))
setnames(dtFeatures,names(dtFeatures), c("featureNum","feature"))

#extract mean and std only
dtFeatures <-dtFeatures[grep("mean\\(\\)|std\\(\\)",dtFeatures$feature),]
dtFeatures$code <- paste0("V",dtFeatures$featureNum)
##filter <- c(key(dt),dtFeatures$featureNum)

dt <- dt[,c("Subject", "Label", dtFeatures$code), with=FALSE]


#use activity names
dtActivity <- fread(file.path(dataPath,"activity_labels.txt"))
setnames(dtActivity,names(dtActivity),c("ActivityNum", "ActivityName"))
dt <- merge(dt,dtActivity,by.x="Label",by.y = "ActivityNum",all = TRUE)
setkey(dt, Subject, Label, ActivityName)

#use descritive activity names in data set
dt <- data.table(melt(dt, key(dt), variable.name = "code"))
dt<-merge(dt, dtFeatures, by = "code", all.x = TRUE)


#setkey(dt, Subject,ActivityName,feature)
#dt <- dt[,list(average = mean(value)), by=key(dt)] 


###
dt$feature<- gsub("mean","Mean", dt$feature)
dt$feature<- gsub("std","StandardDeviation", dt$feature)
dt$feature<- gsub("BodyBody","Body", dt$feature)
dt<- separate(dt,feature, c("var","EstimatedVariable","Axis"))
dt<- separate(dt,var, c("Domain","var"), sep=1)
dt$Domain <- gsub("^t", "Time", dt$Domain)
dt$Domain <- gsub("^f", "Frequency", dt$Domain)
dt$var<- gsub("Body","Body_", dt$var)
dt$var<- gsub("Gravity","Gravity_", dt$var)
dt<- separate(dt,var,c("Component", "var"))
dt$var<- gsub("Acc","Accelerometer_", dt$var)
dt$var<- gsub("Gyro","Gyroscope_", dt$var)
dt<- separate(dt,var,c("Instrument", "FeatureVariable"))

#fill empty cells with NA
dt$FeatureVariable <- ifelse(dt$FeatureVariable=="",NA,dt$FeatureVariable)
dt$Axis <- ifelse(dt$Axis=="",NA,dt$Axis)

#Create tidy data set
setkey(dt, Subject,ActivityName,Domain, Component, Instrument, FeatureVariable, EstimatedVariable,Axis)
dtTidy <- dt[,list(Average = mean(value)), by=key(dt)] 

dtTidy<- spread(dtTidy,EstimatedVariable,Average)

#save to text file
f <- file.path(path, "TidyDataSet.txt")
write.table(dtTidy, f, quote=FALSE, sep="\t", row.names=FALSE)


