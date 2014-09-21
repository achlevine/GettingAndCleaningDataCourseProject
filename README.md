GettingAndCleaningDataCourseProject
===================================

This repository contains the files for the Course Project for the Getting and Cleaning Data Coursera course

1.      README.md:  contains an overview, the study description and list of related documents
2.      run_analysis.R: master script that takes the downloaded data and creates a tidy data file with a row for each observation by Subject and Activity.  The observations are the mean of the mean and standard deviation values from the original dataset, for each Subject and Activity.
3.      tidyData.txt:  the data file produced by the run_analysis.R script

STARTING CONDITIONS:
        1.  Set your working directory to the directory you will run the run_analysis.R file from. Place the run_analysis.R script in this directory. The run_analysis script will create a ./data subdirectory under the working directory it is run in, and will download the original zip file containing the datasets and related files from the SAMSUNG study to that subdirectory.   It will then extract the zip files into a subdirectory titled "UCI HAR Dataset".    The output of the script will be a text file in the ./data directory named tidyData.txt
        
        
Script tasks:

The run_analysis.R script accomplishes the following tasks:

 1.Merges the training and the test sets to create one data set.
 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
 3.Uses descriptive activity names to name the activities in the data set
 4.Appropriately labels the data set with descriptive variable names. 
 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

BACKGROUND and SOURCE DATA:

One of the most exciting areas in all of data science right now is 
 wearable computing - see for example  this article . Companies like Fitbit,
 Nike, and Jawbone Up are racing to develop the most advanced algorithms 
 to attract new users. The data linked to from the course website represent 
 data collected from the accelerometers from the Samsung Galaxy S smartphone. 
 A full description is available at the site where the data was obtained: 
         
         http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
 
 Here are the data for the project: 
         
         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
 
 
