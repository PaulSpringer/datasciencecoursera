##---------------------Required Libraries---------------------------------------

library(dplyr)
library(tidyr)

## -------------------- 0) Loadign Data-----------------------------------------

## The following funtion loads the data. It uses two arguments:
## 1. data_path: path to the table with data
## 2. columns_path: path to the table with names of columns

data <- function(data_path, columns_path){
        
        # Reading raw data
        raw_data <- read.table(data_path)
        
        # Reading column names vector
        column_names <- read.table(columns_path, stringsAsFactors = FALSE,
                                   colClasses = c("NULL", NA))
        
        # Setting column names to data
        names(raw_data) <- t(column_names)
        
        # Output data
        raw_data
}

##---------------------1) Merging Data------------------------------------------

## This function loads training and test data sets using function "data" and
## merges them together. Training data is listed in the begining of the merged
## data set. Here is assumed that the source directory "UCI HAR Dataset" - which
## includes the training and test data sets - is located in working directory.

merge_data <- function(){
        
        # Pathes to data
        train_path <- "UCI HAR Dataset/train/X_train.txt"
        test_path <- "UCI HAR Dataset/test/X_test.txt"
        columns_path <- "UCI HAR Dataset/features.txt"
        
        # Loading training and test data
        train_data <- data(train_path, columns_path)
        test_data <- data(test_path, columns_path)
        
        # merging data
        merged_data <- rbind(train_data, test_data) 
        
        # Output
        merged_data
        
}

##---------------------2) Extractig---------------------------------------------

## This function extracts only the measurements on the mean and standard
## deviation for each measurement

extract_data <- function(){
        
        # Loading merged data
        merged_data <- merge_data()
        
        # Extracting mean only the measurements on the mean and standard
        # deviation for each measurement
        extracted_data <- tbl_df(merged_data[, grepl("mean\\(\\)|std\\(\\)",
                                              names(merged_data))])
        
        # Output
        extracted_data
}

##---------------------3) Descriptive activity names----------------------------

## This function takes activity labels from "y_train.txt" and "y_test.txt"
## (possible values 1 - 6) and translates these labels into human-readable form
## using following rules:
## 1 - WALKING
## 2 - WALKING_UPSTAIRS
## 3 - WALKING_DOWNSTAIRS
## 4 - SITTING
## 5 - STANDING
## 6 - LAYING
## These rules are taken from table "activity_labels.txt"
## Note: Theis function also already merges the activity label data for
## training and test data sets

translate_labels <- function(){

        # Loading labels for data set
        labels_train_path <- "UCI HAR Dataset/train/y_train.txt"
        labels_test_path <- "UCI HAR Dataset/test/y_test.txt"
        lables_train <- read.table(labels_train_path)
        lables_test <- read.table(labels_test_path)
        
        # Loading translation table
        translation_path <- "UCI HAR Dataset/activity_labels.txt"
        translation_table <- read.table(translation_path)
        
        # Merging labels into one table
        labels_for_data_set <- rbind(lables_train, lables_test)
        
        # Translating labels into human-readable form
        labels_readable<- tbl_df(merge(labels_for_data_set,translation_table,
                                       by.x = "V1", by.y = "V1", sort = FALSE))
        
        # Output
        labels_readable
}

##---------------------4) Labeling data set-------------------------------------

## This function labels data set by activity labels taken from 3)

label_data<- function(){
        
        # Getting extracted data from 2)
        data_set <- extract_data()
        
        # Getting human-readable labels
        labels_readable <- translate_labels()
        
        # Labeling data set
        labeled_data_set <- tbl_df(cbind(labels_readable[,2], data_set))
        
        # Setting proper name for activity label column
        names(labeled_data_set)[1] <- "activity"
        
        # Output
        labeled_data_set
}

##----------------5) Averages for each variable & tidy formating----------------

## This final function calculates the average of each variable for each activity
## and each subject for data set from 4). In addition it brings the result into
## a tidy format.

final_tidy_data_frame <- function(){
        
        # Loading data set from step 4)
        labeled_data_set <- label_data()
        
        # Loading subject data
        subject_train_path <- "UCI HAR Dataset/train/subject_train.txt"
        subject_test_path <- "UCI HAR Dataset/test/subject_test.txt"
        subject_train_table <- read.table(subject_train_path)
        subject_test_table <- read.table(subject_test_path)
        
        # Merging subject data
        subject_data <- rbind(subject_train_table, subject_test_table)
        
        # Enhancing data set from 4) by subject
        labeled_data_set_with_subject <- tbl_df(cbind(subject_data[,1],
                                                      labeled_data_set))
        
        # Setting proper name for subject column
        names(labeled_data_set_with_subject)[1] <- "subject"
        
        # Calculate average of each variable for each activity and each subject
        avg_table_not_tidy <- labeled_data_set_with_subject %>% 
                group_by(subject, activity) %>% summarise_all(funs(mean))
        
        # Make "avg_table_not_tidy" to a tidy table and arrange the result by
        # subject and activity
        final_table <- avg_table_not_tidy %>%  gather(variable, meanofvariable,
                                                      -c(subject, activity))%>%
                arrange(subject, activity)
        
        # Outputs
        final_table
        
}