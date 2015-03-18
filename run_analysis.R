# This is rather an amateur attempt

# Make sure you are inside the data directory. You should be able to see the
# A. The folders - test & train in your CWD
# B. The file - "features.txt" in the CWD.

#Following the list of steps

# 1.First I am reading the two sets of data located under the sub-directories
#   test & train
#   I have used LaF and ffbase libraries to make the reading faster
#   Once I have the two data sets as two dataframes (test_data, train_data)

# 2. I do an rbind to merge the two datasets (total_data)
#   The data frame 'total_data has 10299 rows and 561 columns

# 3. Then I read the 'features.txt' file for subsetting the columns corresponding to
#   Mean and STD of measurements: the values are read into the DF 'reqcol'

# 4. I use the first column in the 'reqcol' to subset total_data, I name those columns
#  from the second column in 'reqcol'

# 5. ss (selected subset) is the data frame that has 10299 rows and 86 columns, each column
#   corresponding to some mean/std in the total data set.

# 6. Next I read the y_test/train.txt files to get the activity code, merge them into
# a single file - cbind to ss, to get ss2

# 7. Repeat the same for the subject_test/train to get ss3.
#using plenty of rm commands to clear up space. 

# 8. Now I use the "dplyr" package to group the data by "Subject" & "ActivityCode"
#    and get the means for each columns. I write the output as a dataframe 'ft'

# 9. Rename Activity Code values with descriptional data in the dataframe 'ft'

# 10. Use write.table with row.name = FALSE, for the final table. BINGO

library("LaF")  #Step 1
library("ffbase") #1
library("plyr")
library("dplyr")
d1 <- laf_open_fwf("test/X_test.txt", column_widths= c(rep(16, 561)), column_types = rep("double", 561))
d2 <- laf_open_fwf("train/X_train.txt", column_widths= c(rep(16, 561)), column_types = rep("double", 561))
pr_d1 <- laf_to_ffdf(d1)
pr_d2 <- laf_to_ffdf(d2)
test_data <- as.data.frame(pr_d1)
train_data <- as.data.frame(pr_d2)
total_data <- rbind(train_data, test_data) #Step 2
    rm(test_data) #clear memory
    rm(train_data)
    rm(d1)
    rm(d2)
    rm(pr_d1)
    rm(pr_d2)
strings <- "mean|Mean|std"  # I want to subset those columns that have the name mean/std
f1 <- read.csv("features.txt", sep=" ", header=FALSE) #Step 3
reqcol <- f1[grepl(strings,as.character(f1[[2]])),]
ss <- total_data[, reqcol[[1]]] # subset of total data as per column numbers from above
colnames(ss) <- c(as.character(reqcol[[2]])) #assign column names to the subset.
  # The block below reads y_test/train and does an r-bind
  d1 <- laf_open_fwf("test/y_test.txt", column_widths= 1, column_types = "integer") 
  pr_d1 <- laf_to_ffdf(d1)
  testy <- as.data.frame(pr_d1) # this did not work as intended hence repeating below
  testy <- data.frame("ActivityCode" = testy)
  d2 <- laf_open_fwf("train/y_train.txt", column_widths= 1, column_types = "integer")
  pr_d2 <- laf_to_ffdf(d2)
  trainy <- as.data.frame(pr_d2) # this did not work as intended hence repeating below
  trainy <- data.frame("ActivityCode" = trainy)
  totaly <- rbind(trainy,testy)  # Here we get the merged test/train Activity code list

# Step 6 completed below. New data frame has selected subset plus the activity code
ss2 <- cbind(totaly, ss) # Step 6 c-bind "activity code" to culled subset

#Clear Space again
    rm(d1)
    rm(d2)
    rm(pr_d1)
    rm(pr_d2)
# Step 7: repeat step 5,6 to read subjects in test/training sets.
d1 <- read.csv("test/subject_test.txt", header = FALSE)
tests <- data.frame("Subject" = as.numeric(as.character(d1[[1]])))
d2 <- read.csv("train/subject_train.txt", header = FALSE)
trains <- data.frame("Subject" = as.numeric(as.character(d2[[1]])))
totals <- rbind(trains,tests)  # Here we get the merged test/train Activity code list

#cbind subject list to the subset of data
ss3 <- cbind(totals,ss2) #This data frame has 88 columns, 86 MEAN/STD columns
                          # and 2 columns "Subject" & "Activity Code"

#clear space
    rm(d1)
    rm(d2)
    rm(pr_d1)
    rm(pr_d2)
    rm(total_data)
    rm(reqcol)
    rm(ss)
    rm(ss2)
    rm(totaly)
    rm(totals)
    rm(tests)
    rm(testy)
    rm(trains)
    rm(trainy)
    rm(f1)
    gc(reset = TRUE)

#Step 8:
#Following three lines nails the job. Using dplyr functions to summarise each
#column of the subset grouped by Subject and then ActivityCode
fd <- tbl_df(ss3)
rm(ss3)
ft <- as.data.frame(fd %>% arrange(Subject, ActivityCode) %>% group_by(Subject, ActivityCode) %>% summarise_each(funs(mean)))

#Step 9
#Replace ActivityCode by descriptional data
ft$ActivityCode[ft$ActivityCode == 1] <- "WALKING"
ft$ActivityCode[ft$ActivityCode == 2] <- "WALKING_UPSTAIRS"
ft$ActivityCode[ft$ActivityCode == 3] <- "WALKING_DOWNSTAIRS"
ft$ActivityCode[ft$ActivityCode == 4] <- "SITTING"
ft$ActivityCode[ft$ActivityCode == 5] <- "STANDING"
ft$ActivityCode[ft$ActivityCode == 6] <- "LAYING"

#Step 10: use write.table function to write the desired output & yes, BINGO.
write.table(ft, file = "finaltable.txt",row.names = FALSE)

## Make sure you are in the proper working directory. I have not added any 
# file checks.
# you should have the folders test & train in your working directory
# you should have the file "features.txt" in your working directory