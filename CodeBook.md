CodeBook for Course Project
---------------------------

The dataset used in the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Input files folder:

     ./data/raw/

Output files folder:

     ./data/tidy/

Output files names:

- UCI_HAR_Average_Cleaned.txt
- UCI_HAR_Cleaned.txt

Steps to clean a source dataset:

- extracts only the measurements on the mean and standard deviation for each measurement
- use lower case for column/variable names
- replace non word (like space, underscore etc) symbols in column names
- merge train and test datasets
- use activity label instead of id
