# One of the most exciting areas in all of data science right now is 
# wearable computing - see for example  this article . Companies like Fitbit,
# Nike, and Jawbone Up are racing to develop the most advanced algorithms 
# to attract new users. The data linked to from the course website represent 
# data collected from the accelerometers from the Samsung Galaxy S smartphone. 
# A full description is available at the site where the data was obtained: 
#         
#         http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# 

##  Load needed packages
##  plyr used for mapvalues() function
##  dplyr used for Selecting colums easily
library(plyr)
library(dplyr)
library(reshape2)  ## reshape2 used for the melt commands
##
## Set working Directory to the directory where the run_analysis.R file resides
## The script will make sure the ./data directory exists and
## download the zip file containing the data and save to the ./data directory
## be sure to use mode = "wb" to treat as a binary file on Windows
## then unzip the file


if(!file.exists("./data")) {dir.create("./data")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/UCI HAR Dataset.zip", mode = "wb") 

setwd("./data")
unzip("./UCI HAR Dataset.zip")

setwd("./UCI HAR Dataset")

## Get the names for the Features vectors
features_names <- read.csv("./features.txt", header = FALSE, sep = " ")

## get the Activity Labels
activity_labels <- read.csv("./activity_labels.txt", header = FALSE, sep = " ")

## Get names vector for the test and train Subjects
test_subject_names <- read.csv("./test/subject_test.txt", col.names = c("Subject"), header = FALSE)
train_subject_names <- read.csv("./train/subject_train.txt", col.names = c("Subject"), header = FALSE)

## Get the Activity Vector to tie activity codes to data vectors
test_activity_vector <- read.csv("./test/y_test.txt", header = FALSE, col.names = c("Activity"))
train_activity_vector <- read.csv("./train/y_train.txt", header = FALSE, col.names = c("Activity"))

## Finally, read in the actual data vectors for the Train and Test datasets
## Use the data from the features.txt file as the column headers (read above into the 'features_names' dataframe
X_train <- read.csv("./train/X_train.txt", header = FALSE, sep = "", col.names = features_names[ ,2])
X_test <- read.csv("./test/X_test.txt", header = FALSE, sep = "", col.names = features_names[ ,2])

## add  the subject #'s to the two datasets
X_train <- cbind(train_subject_names, X_train)
X_test <- cbind(test_subject_names, X_test)

## add the activity #'s to the two datasets
X_train <- cbind(train_activity_vector, X_train)
X_test <- cbind(test_activity_vector, X_test)

## NOW COMBINE THE TEST AND TRAIN DATA INTO A SINGLE DATA FRAME

X_data <- rbind(X_train, X_test)

## Select only the columns that contain "mean" or "std" and that don't start with an "f" (we do not need the Fast Fourrier Transforms)
X_data_final <- cbind(select(X_data, contains("Subject"), contains("Activity"), contains("mean"), contains("std"), -starts_with("f")))

## Replace the Activity numeric values with the descriptive values from the activity_labels.txt file
X_data_final$Activity <- mapvalues(as.numeric(X_data_final$Activity), activity_labels[, 1], as.character(activity_labels[,2]))

## here are some ways we can test this data set
#
#  This command will give a count of observations for each Subject and Activity 
#
#       tail(X_data_final %>% mutate(count =1) %>% group_by(Subject, Activity) %>% summarize(sum(count)))

## These two commands will verify that we have all 30 Subjects,
## and all 6 Activities for each subject
#
#       by_Subject <- group_by(X_data_final, Subject)
#       summarize(by_Subject, unique = n_distinct(Activity))


## NOW CREATE A TIDY DATA SET containing the Average of each variable per Step 5 of the instructions
## 
## create a vector of column names that indicate the Key columns
id.vars <- c("Subject", "Activity")

## MELT the data to just key values and each variable on a separate row
myMelt <- melt(X_data_final, id.vars = id.vars)

## Now, we will summarize the melted data by calculating the mean of each variable, grouped by Subject, Activity, and variable
id.vars2 <- c("Subject", "Activity", "variable")
mySummary <- ddply(myMelt, id.vars2, summarise, mean = mean(value))

##return a tidy data set by dcast'ing the melted data so the each variable is its own column
tidyData <- dcast(mySummary, Subject + Activity ~ variable, mean)

## Order the data by Subject and Activity
tidyData <- arrange(tidyData, Subject, Activity)

##now we must clean up the variable names
vNames <- names(tidyData)

        #1.  Make Lower Case
        #vNames <- tolower(vNames)
        #2.  Change abbreviation "t" to "timeseries"
        vNames <- sub("^t", "TimeSeries", vNames)
        #3.  Change abbreviation ".std" to "standarddeviation"
        vNames <- sub(".std", "StandardDeviation", vNames)
        #4.  Change abbreviation "acc" to "acceleration"
        vNames <- (sub("Acc", "Acceleration", vNames))
        #5.  Change .mean to mean
        vNames <- (sub(".mean", "Mean", vNames))
        #6.   Change ...x to xaxis, similarly for y and z axis
        vNames <- sub("\\.\\.\\.X$", "Xaxis", vNames)
        vNames <- sub("\\.\\.\\.Y$", "Yaxis", vNames)
        vNames <- sub("\\.\\.\\.Z$", "Zaxis", vNames)
        #7.  Remove any trailing periods
        vNames <- sub("\\.\\.$", "", vNames)
        #8.  Remove any remaining periods
        vNames <- gsub("\\.", "", vNames)

        names(tidyData) <- vNames

## write the file iin the ./data directory
setwd("../")
write.table(tidyData, file = "tidyData.txt", sep = " ", row.names = FALSE)

#reset to original working directory
setwd("..")
