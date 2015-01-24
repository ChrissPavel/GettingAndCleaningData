# GettingAndCleaningData
Getting and Cleaning Data
First of all, My run_analysis.R code reads all txt files: features, 
activity_labels, and files,  subject_ X_ and y_ for train and test

I take the second column of features.txt, which are going to be the labels 
of my merged data. I change minus and comma to underscope and remove parenthesis. 
With this I´m getting label column names, and making them readable also there aren't no allowed symbols for column names of my merged data

Next, I create an object called "data" which is the result of row binding: column names described above,
X_Tr(from file X_train) and X_test (from file X_test)

With "data" I use first row to rename columns (before, they had names V1 V2 ...),
doing that I proceed to remove first row. 

After that, I'm adding new columns to "data": Subject and Activity, which are the corresponding imported objects
from files subject_train,subject test (X_subTr,X_subTst) and activity_labels 
(y_Tr,y_Tst).

Next, I recode using mapvalues from "plyr" package each number to corresponding activities

I compute "ind" which identifies the indexes of column names which
have strings "Mean" "mean" or "std".I filter "data" according to "ind", and also using Subject and Activit column.The data frame obtained I call "data_Result". 

I convert the first 86 columns of data_Result to numeric type
(they were character columns before), the last two are Subject and Activity (no need type change). 

Finally using aggregate I find the mean of each column with measures grouping
by Activity and Subject and save it as "tidy_Data". Using write.table I save it as a txt file.









