rm(list=ls())

# create data dirs if no exists
if (!file.exists("./data")) {
     dir.create("./data")
}

if (!file.exists("./data/raw")) {
     dir.create("./data/raw")
}

if (!file.exists("./data/tidy")) {
     dir.create("./data/tidy")
}

# download zip file
fileZIP <- file.path("./data/raw", "UCI_HAR.zip")
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, fileZIP)

# unzip dataset
unzip(fileZIP, exdir = "./data/raw")
list.files(
     "./data/raw",
     all.files = TRUE,
     recursive = TRUE,
     include.dirs = TRUE
)

library(dplyr)

#1 Merges the training and the test sets to create one data set.
t_X_test <- as.tbl(read.table("./data/raw/UCI HAR Dataset/test/X_test.txt"))
t_y_test <- as.tbl(read.table("./data/raw/UCI HAR Dataset/test/y_test.txt"))
t_subject_test <- as.tbl(read.table("./data/raw/UCI HAR Dataset/test/subject_test.txt"))

t_X_train <- as.tbl(read.table("./data/raw/UCI HAR Dataset/train/X_train.txt"))
t_y_train <- as.tbl(read.table("./data/raw/UCI HAR Dataset/train/y_train.txt"))
t_subject_train <- as.tbl(read.table("./data/raw/UCI HAR Dataset/train/subject_train.txt"))

# create one dataset for training and test sets
tbl_X <- union_all(t_X_test,t_X_train)
tbl_Y <- union_all(t_y_test, t_y_train)
tbl_subject <- union_all(t_subject_test, t_subject_train)

print(object.size(tbl_X), units = "Kb")
tbl_X

print(object.size(tbl_Y), units = "Kb")
tbl_Y

print(object.size(tbl_subject), units = "Kb")
tbl_subject

# remove primary objects
rm(list = grep("t.+(test|train)", ls(), value = TRUE))

# read variables names
varNames <- read.table("./data/raw/UCI HAR Dataset/features.txt")
varNames <- as.character(varNames[,2])

# read activity names
activityNames <- read.table("./data/raw/UCI HAR Dataset/activity_labels.txt")
activityNames[,2] <- tolower(gsub("_","",activityNames[,2]))
names(activityNames) <- c("id","activity")

# set names
names(tbl_Y) <- "activityid"
names(tbl_subject) <- "subject"

# choose only mean|std variable indexes
cols <- grep("(-mean\\(\\)|-std\\(\\))", varNames)

# use activity label instead of id
tbl_Y <- tbl_Y %>% mutate(activity = activityNames[activityid,2]) %>% select(activity)

# rename variables, set descriptive names
tbl_X <- tbl_X %>% select(cols) %>% 
           setNames(tolower(gsub("\\W", "", varNames[cols])))

# create result dataset            
result <- bind_cols(tbl_subject, tbl_Y, tbl_X)

# remove objects
rm(list = grep("^tbl",ls(),value = TRUE))

# save tidy data to file
write.table(result, "./data/tidy/UCI_HAR_Cleaned.txt", row.names = FALSE)

# save averaged data
result <- result %>% group_by(subject, activity) %>% summarise_all(.funs = mean)
write.table(result, "./data/tidy/UCI_HAR_Average_Cleaned.txt", row.names = FALSE)

rm(result)