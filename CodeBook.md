---
title: "CodeBook"
output: 
  html_document:
    keep_md: true
---
This codebook was generated on 2015-09-26 02:02:13

Variable list and descriptions
------------------------------

Variable name        | Description
---------------------|------------
Subject              | ID of the subject who performed the activity (1 to 30). 
ActivityName         | Activity name
Domain               | Time or frequency domain signal (Time or Frequency)
Component            | Body or gravity component of signal (Body or Gravity)
Instrument           | Measuring instrument used (Accelerometer or Gyroscope)
FeatureVariable      | Feature variable signals (Jerk, Mag, JerkMag)
Axis                 | Direction of signal (X,Y, or Z)
Mean                 | Average mean of each variable for each activity and each subject
StandardDeviation    | Average standard deviation of each variable for each activity and each subject

Summary of Variables
--------------------


```
##     Subject                 ActivityName       Domain       Component   
##  1      : 198   LAYING            :990   Frequency:2340   Body   :5220  
##  2      : 198   SITTING           :990   Time     :3600   Gravity: 720  
##  3      : 198   STANDING          :990                                  
##  4      : 198   WALKING           :990                                  
##  5      : 198   WALKING_DOWNSTAIRS:990                                  
##  6      : 198   WALKING_UPSTAIRS  :990                                  
##  (Other):4752                                                           
##          Instrument   FeatureVariable   Axis           Mean         
##  Accelerometer:3600   Jerk   :1620    X   :1440   Min.   :-0.99762  
##  Gyroscope    :2340   JerkMag: 720    Y   :1440   1st Qu.:-0.93140  
##                       Mag    : 900    Z   :1440   Median :-0.12974  
##                       NA's   :2700    NA's:1620   Mean   :-0.30898  
##                                                   3rd Qu.:-0.01192  
##                                                   Max.   : 0.97451  
##                                                                     
##  StandardDeviation
##  Min.   :-0.9977  
##  1st Qu.:-0.9714  
##  Median :-0.9194  
##  Mean   :-0.6597  
##  3rd Qu.:-0.3638  
##  Max.   : 0.6871  
## 
```
