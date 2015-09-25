CodeBook
========
This codebook was generated on 2015-09-26 02:14:55

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

Sample Data
-----------


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
