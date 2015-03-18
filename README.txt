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

