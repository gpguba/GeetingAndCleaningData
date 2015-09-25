# Getting and Cleaning Data Project

Instructions for the project
--------------------------

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

> Here are the data for the project: 

> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

>  You should create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

> Good luck!

This document contains the same codes as the `run_analysis.R`.

Initialize parameters and load packages
--------------------------------------------


```r
path <- getwd()
require(data.table, quietly = TRUE)
require(tidyr, quietly = TRUE)
```

Download and unzip the file.
----------------------------


```r
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip")
unzip("Dataset.zip")
```

The files are extraced in the `UCI HAR Dataset` folder. Set this as the data path and list the files.


```r
dataPath <- "./UCI HAR Dataset"
list.files(dataPath, recursive = TRUE)
```

```
##  [1] "activity_labels.txt"                         
##  [2] "features.txt"                                
##  [3] "features_info.txt"                           
##  [4] "README.txt"                                  
##  [5] "test/Inertial Signals/body_acc_x_test.txt"   
##  [6] "test/Inertial Signals/body_acc_y_test.txt"   
##  [7] "test/Inertial Signals/body_acc_z_test.txt"   
##  [8] "test/Inertial Signals/body_gyro_x_test.txt"  
##  [9] "test/Inertial Signals/body_gyro_y_test.txt"  
## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"  
## [12] "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"  
## [14] "test/subject_test.txt"                       
## [15] "test/X_test.txt"                             
## [16] "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt" 
## [18] "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt" 
## [20] "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt"
## [22] "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt"
## [24] "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt"
## [26] "train/subject_train.txt"                     
## [27] "train/X_train.txt"                           
## [28] "train/y_train.txt"
```

The`README.txt` file contains detailed information about this data set.  
For the purpose of this project, the files in the `Inertial Signals` folder are not used.


Read the files
--------------

Read files inside `train` and `test` folders.


```r
dtSubjectTrain <- fread(file.path(dataPath,"train", "subject_train.txt"))
dtTrain <- fread(file.path(dataPath,"train","x_train.txt"))
dtTrainLabel <-fread(file.path(dataPath,"train","y_train.txt"))

dtSubjectTest <- fread(file.path(dataPath,"test","subject_test.txt"))
dtTestLabel <-  fread(file.path(dataPath,"test","y_test.txt"))
dtTest <- fread(file.path(dataPath,"test","x_test.txt"))
```

Merge the training and the test data sets
-----------------------------------------

Combine the test and training label(activity) data set.


```r
dtLabel <- rbind(dtTestLabel,dtTrainLabel)
setnames(dtLabel,"V1", "Label")
```

Combine the test and training subject data set.


```r
dtSubject <- rbind(dtSubjectTest,dtSubjectTrain)
setnames(dtSubject,"V1", "Subject")
```

concatenate the test and training  data set.


```r
dt <- rbind(dtTest,dtTrain)
```

Combine the data sets on columns


```r
dtSubjectLabel <- cbind(dtSubject,dtLabel)
dt <- cbind(dtSubjectLabel,dt)
```


Extract only the mean and standard deviation
--------------------------------------------

Read the `features.txt` file to determine which variable in `dt` are the mean and standard deviation measurements.


```r
dtFeatures <- fread(file.path(dataPath, "features.txt"))
setnames(dtFeatures,names(dtFeatures), c("featureNum","feature"))
```

Determine the the variable names with `mean()` and `std()` on it and use this to get its subset. 


```r
dtFeatures <-dtFeatures[grep("mean\\(\\)|std\\(\\)",dtFeatures$feature),]
```

Show variable name pattern in `dt`


```r
head(names(dt))
```

```
## [1] "Subject" "Label"   "V1"      "V2"      "V3"      "V4"
```

Create a new column with vector of variables to match the variable names in `dt` based on `featureNum'


```r
dtFeatures$code <- paste0("V",dtFeatures$featureNum)
head(dtFeatures)
```

```
##    featureNum           feature code
## 1:          1 tBodyAcc-mean()-X   V1
## 2:          2 tBodyAcc-mean()-Y   V2
## 3:          3 tBodyAcc-mean()-Z   V3
## 4:          4  tBodyAcc-std()-X   V4
## 5:          5  tBodyAcc-std()-Y   V5
## 6:          6  tBodyAcc-std()-Z   V6
```

Use the `code` vectors to subset the variables names in`dt`


```r
dt <- dt[,c("Subject", "Label", dtFeatures$code), with=FALSE]
```


Use descriptive activity names
------------------------------

Read `activity_labels.txt` file to get the descriptive names of the activities.


```r
dtActivity <- fread(file.path(dataPath,"activity_labels.txt"))
setnames(dtActivity,names(dtActivity),c("ActivityNum", "ActivityName"))
dtActivity
```

```
##    ActivityNum       ActivityName
## 1:           1            WALKING
## 2:           2   WALKING_UPSTAIRS
## 3:           3 WALKING_DOWNSTAIRS
## 4:           4            SITTING
## 5:           5           STANDING
## 6:           6             LAYING
```

Merge the activity names with `dt` and set the key.


```r
dt <- merge(dt,dtActivity,by.x="Label",by.y = "ActivityNum",all = TRUE)
setkey(dt, Subject, Label, ActivityName)
```

Label the data set with descriptive variable names
--------------------------------------------------

Reshape the `dt` to put all activity variables in 1 column.


```r
dt <- data.table(melt(dt, key(dt), variable.name = "code"))
```

Merge feature names with `dt` 


```r
dt<-merge(dt, dtFeatures, by = "code", all.x = TRUE)
#setkey(dt, Subject,ActivityName,feature)
```


Show `dt` to verify


```r
dt
```

```
##         code Subject Label ActivityName      value featureNum
##      1:   V1       1     1      WALKING  0.2820216          1
##      2:   V1       1     1      WALKING  0.2558408          1
##      3:   V1       1     1      WALKING  0.2548672          1
##      4:   V1       1     1      WALKING  0.3433705          1
##      5:   V1       1     1      WALKING  0.2762397          1
##     ---                                                      
## 679730:  V86      30     6       LAYING -0.9883015         86
## 679731:  V86      30     6       LAYING -0.9946520         86
## 679732:  V86      30     6       LAYING -0.9958571         86
## 679733:  V86      30     6       LAYING -0.9917411         86
## 679734:  V86      30     6       LAYING -0.9902446         86
##                      feature
##      1:    tBodyAcc-mean()-X
##      2:    tBodyAcc-mean()-X
##      3:    tBodyAcc-mean()-X
##      4:    tBodyAcc-mean()-X
##      5:    tBodyAcc-mean()-X
##     ---                     
## 679730: tBodyAccJerk-std()-Z
## 679731: tBodyAccJerk-std()-Z
## 679732: tBodyAccJerk-std()-Z
## 679733: tBodyAccJerk-std()-Z
## 679734: tBodyAccJerk-std()-Z
```

Split `feature` into different variables and rename  to be more descriptive.

```r
dt$feature <- gsub("mean","Mean", dt$feature)
dt$feature <- gsub("std","StandardDeviation", dt$feature)
dt$feature <- gsub("BodyBody","Body", dt$feature)
dt <- separate(dt,feature, c("var","EstimatedVariable","Axis"))
dt <- separate(dt,var, c("Domain","var"), sep=1)
dt$Domain <- gsub("^t", "Time", dt$Domain)
dt$Domain <- gsub("^f", "Frequency", dt$Domain)
dt$var <- gsub("Body","Body_", dt$var)
dt$var <- gsub("Gravity","Gravity_", dt$var)
dt <- separate(dt,var,c("Component", "var"))
dt$var<- gsub("Acc","Accelerometer_", dt$var)
dt$var<- gsub("Gyro","Gyroscope_", dt$var)
dt<- separate(dt,var,c("Instrument", "FeatureVariable"))
```

Fill empty variable cells with NA


```r
dt$FeatureVariable <- ifelse(dt$FeatureVariable=="",NA,dt$FeatureVariable)
dt$Axis <- ifelse(dt$Axis=="",NA,dt$Axis)
```

Show `dt`


```r
dt
```

```
##         code Subject Label ActivityName      value featureNum Domain
##      1:   V1       1     1      WALKING  0.2820216          1   Time
##      2:   V1       1     1      WALKING  0.2558408          1   Time
##      3:   V1       1     1      WALKING  0.2548672          1   Time
##      4:   V1       1     1      WALKING  0.3433705          1   Time
##      5:   V1       1     1      WALKING  0.2762397          1   Time
##     ---                                                             
## 679730:  V86      30     6       LAYING -0.9883015         86   Time
## 679731:  V86      30     6       LAYING -0.9946520         86   Time
## 679732:  V86      30     6       LAYING -0.9958571         86   Time
## 679733:  V86      30     6       LAYING -0.9917411         86   Time
## 679734:  V86      30     6       LAYING -0.9902446         86   Time
##         Component    Instrument FeatureVariable EstimatedVariable Axis
##      1:      Body Accelerometer              NA              Mean    X
##      2:      Body Accelerometer              NA              Mean    X
##      3:      Body Accelerometer              NA              Mean    X
##      4:      Body Accelerometer              NA              Mean    X
##      5:      Body Accelerometer              NA              Mean    X
##     ---                                                               
## 679730:      Body Accelerometer            Jerk StandardDeviation    Z
## 679731:      Body Accelerometer            Jerk StandardDeviation    Z
## 679732:      Body Accelerometer            Jerk StandardDeviation    Z
## 679733:      Body Accelerometer            Jerk StandardDeviation    Z
## 679734:      Body Accelerometer            Jerk StandardDeviation    Z
```

Create tidy data set
--------------------
Set the keys  and get the average of each variable for each activity and each subject


```r
setkey(dt, Subject,ActivityName,Domain, Component, Instrument, FeatureVariable, EstimatedVariable,Axis)
dtTidy <- dt[,list(Average = mean(value)), by=key(dt)]
dtTidy
```

```
##        Subject     ActivityName    Domain Component    Instrument
##     1:       1           LAYING Frequency      Body Accelerometer
##     2:       1           LAYING Frequency      Body Accelerometer
##     3:       1           LAYING Frequency      Body Accelerometer
##     4:       1           LAYING Frequency      Body Accelerometer
##     5:       1           LAYING Frequency      Body Accelerometer
##    ---                                                           
## 11876:      30 WALKING_UPSTAIRS      Time   Gravity Accelerometer
## 11877:      30 WALKING_UPSTAIRS      Time   Gravity Accelerometer
## 11878:      30 WALKING_UPSTAIRS      Time   Gravity Accelerometer
## 11879:      30 WALKING_UPSTAIRS      Time   Gravity Accelerometer
## 11880:      30 WALKING_UPSTAIRS      Time   Gravity Accelerometer
##        FeatureVariable EstimatedVariable Axis    Average
##     1:              NA              Mean    X -0.9390991
##     2:              NA              Mean    Y -0.8670652
##     3:              NA              Mean    Z -0.8826669
##     4:              NA StandardDeviation    X -0.9244374
##     5:              NA StandardDeviation    Y -0.8336256
##    ---                                                  
## 11876:              NA StandardDeviation    X -0.9540336
## 11877:              NA StandardDeviation    Y -0.9149339
## 11878:              NA StandardDeviation    Z -0.8624028
## 11879:             Mag              Mean   NA -0.1376279
## 11880:             Mag StandardDeviation   NA -0.3274108
```

Separate the `Mean` and `StandardDeviation` into two variables to show data clearer. 


```r
dtTidy<- spread(dtTidy,EstimatedVariable,Average)
dtTidy
```

```
##       Subject     ActivityName    Domain Component    Instrument
##    1:       1           LAYING Frequency      Body Accelerometer
##    2:       1           LAYING Frequency      Body Accelerometer
##    3:       1           LAYING Frequency      Body Accelerometer
##    4:       1           LAYING Frequency      Body Accelerometer
##    5:       1           LAYING Frequency      Body Accelerometer
##   ---                                                           
## 5936:      30 WALKING_UPSTAIRS      Time      Body     Gyroscope
## 5937:      30 WALKING_UPSTAIRS      Time   Gravity Accelerometer
## 5938:      30 WALKING_UPSTAIRS      Time   Gravity Accelerometer
## 5939:      30 WALKING_UPSTAIRS      Time   Gravity Accelerometer
## 5940:      30 WALKING_UPSTAIRS      Time   Gravity Accelerometer
##       FeatureVariable Axis        Mean StandardDeviation
##    1:            Jerk    X -0.95707388        -0.9641607
##    2:            Jerk    Y -0.92246261        -0.9322179
##    3:            Jerk    Z -0.94806090        -0.9605870
##    4:         JerkMag   NA -0.93330036        -0.9218040
##    5:             Mag   NA -0.86176765        -0.7983009
##   ---                                                   
## 5936:              NA    Z  0.08146993        -0.2115736
## 5937:             Mag   NA -0.13762786        -0.3274108
## 5938:              NA    X  0.93182983        -0.9540336
## 5939:              NA    Y -0.22664729        -0.9149339
## 5940:              NA    Z -0.02214011        -0.8624028
```

Save tidy data set to a tab-delimited text file calles `TidyDataSet.txt`.


```r
f <- file.path(path, "TidyDataSet.txt")
write.table(dtTidy, f, quote=FALSE, sep="\t", row.names=FALSE)
```
