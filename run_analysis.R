library(plyr)

# Step 1
# Merge the training and test sets to create one data set
###############################################################################

xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# create 'x' data set
xdata <- rbind(xtrain, xtest)

# create 'y' data set
ydata <- rbind(ytrain, ytest)

# create 'subject' data set
subjectdata <- rbind(subjecttrain, subjecttest)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table("./data/UCI HAR Dataset/features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
xdata <- xdata[, mean_and_std_features]

# correct the column names
names(xdata) <- features[mean_and_std_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
ydata[, 1] <- activities[ydata[, 1], 2]

# correct column name
names(ydata) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subjectdata) <- "subject"

# bind all the data in a single data set
alldata <- cbind(xdata, ydata, subjectdata)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averagesdata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averagesdata, "averagesdata.txt", row.name=FALSE)
