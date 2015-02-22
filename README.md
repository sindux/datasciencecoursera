<pre>
Coursera's DataScience - "Getting and Cleaning Data" course project.

## Getting started
Place the script in a new folder and load it into R.
Make sure the current working directory is set to where the script is located.

## Script walkthrough

### Step 0 - Download and unzip
0.1. The script will download the dataset ZIP file from the internet.
0.2. It then unzips the file under current working directory.
A folder "UCI HAR Dataset" should contain the extracted dataset.

### Step 1 - Merges the training and the test sets to create one data set.
1.1. The script will first load the masters data (features.txt and activity_labels.txt).
1.2. It then loads the training and test measurement datasets (X_(test|train).txt)
1.3. It loads activity (Y_(test|train).txt) and subject (subject_(test|train).txt).
     Both of these columns are appended at the end of each datasets.
1.4. Finally the test and train datasets are combined into a single data set.

### Step 2 - Extracts only the measurements on the mean and standard deviation
    for each measurement. 
2.1. The script searches the features master table and get all columns
     which have "-mean()" or "-std()".
2.2. The script picks columns of the dataset which match the result from step (2.1).
2.3. It then appends back activity and subject columns which gets dropped by step (2.2).

### Step 3 - Uses descriptive activity names to name the activities in the data set
3.1. The script merges the dataset output from step 2 above with activity master table
     loaded in step 1.1. Both table are joined using act_id column.
3.2. As we now have the activity column from the activity master table, we can now drop
     unused act_id column from the dataset.

### Step 4 - Appropriately labels the data set with descriptive variable names. 
4.1. The script strips the V prefix that was given by R when the datasets was loaded
     in step 1.2 above.
4.2. For each column, the script will then lookup in features table loaded in step 1.1.
     If a match is not found, the current column name is reused,
	 otherwise the column name from the feature table is used.
4.3. The column names of the dataset are then substituted.

### Step 5 - From the data set in step 4, creates a second, independent tidy data set
    with the average of each variable for each activity and each subject.
5.1. The script uses dplyr package to group the dataset by activity and subject
     and summarize all the remaining columns using mean function to get the average.
5.2. Finally the script writes the output to step5.txt file
</pre>