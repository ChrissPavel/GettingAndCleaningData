# By: Christian Llano

#setwd("~/UCI HAR Dataset") # Setting workspace directory to folder UCI HAr Dataset 

library("plyr", lib.loc="C:/Program Files/R/R-3.1.2/library")
feats<-read.table("features.txt") #read features.txt
actvty<-read.table("activity_labels.txt") #reading activity_labels.txt

#Reading files from train folder

X_subTr<-read.table("./train/subject_train.txt",col.names=c("Subject"))
X_Tr<-read.table("./train/X_train.txt")
y_Tr<-read.table("./train/y_train.txt",col.names=c("Activity"))


#Reading files from test folder

X_subTst<-read.table("./test/subject_test.txt",col.names=c("Subject"))
X_Tst<-read.table("./test/X_test.txt")
y_Tst<-read.table("./test/y_test.txt",col.names=c("Activity"))

#Changing the feature names from second column of feats
#these are going to be our column names for the required data frame.
#For this reason i'm going to replace minus and comma by underscore, and remove parenthesis, so names
#of columns were readable.(point 4.)

feats[,2]<-gsub("-|\\,","_",feats[,2]) #changing minus or comma by underscore
feats[,2]<-gsub("\\(|\\)","",feats[,2]) #removing parenthesis,here \\ in quotes of first argumet of gsub,for specific strings


#Now, binding by rows "features" and X files of train an test 

data<-rbind(unlist(feats[,2]),X_Tr,X_Tst) 

#Next, rename header with first row of "data", where are placed the column names
colnames(data)<-data[1,] 
data<-data[-1,] #removing first row of names, we need it no more

#Adding Subject and Activity, ulinst() onlny for converting rbind data.frame to vector
data$Subject<-unlist(rbind(X_subTr,X_subTst)) #adding Subject column as a new variable 
data$Activity<-unlist(rbind(y_Tr,y_Tst)) #adding Activity column as a new variable

#Renaming Subject and Activity to its corresponing names(performing point 3.)
#using mapvalues() from "plyr" package

data$Activity <- mapvalues(data$Activity, from = 1:6, 
                           to = c("WALKING", "WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                                  "SITTING","STANDING","LAYING"))
#
#dim(data)
#[1] 10299   563
#We have 10299 rows and 563 columns

#Finally, choose the indexes of columns which has mean or standard deviation 
#Additional Im taking the subject (index 562) and activity (index 563) column
#(point 2.)


ind<-grep("Mean|mean|std",feats[,2])
data_Result<-data[,c(ind,562,563)]

#Converting character columns to numeric columns
data_Result[,1:86]<-sapply(data_Result[,1:86],as.numeric)

#Using aggregate to find mean of each column variable from point 2 by Subject and Activity 
tidy_Data<-aggregate(data_Result[,1:86],list(Activity=data_Result$Activity,
                                             Subject=data_Result$Subject),mean)

#My tidy data consist on 180 registers with 88 columns
#dim(tidy_Data)
#[1] 180  88

#Saving tidy_Data to a txt file "tidy_Data.txt"
write.table(tidy_Data,"tidy_Data.txt",row.name=FALSE)

