rm(list=ls())
setwd("~/Dropbox/GitRepository/occupydata/")
library("lubridate")
library("sqldf")
library("plyr")
source("scripts/areagraph.R")

# read in, order, and format data
data = read.csv("data/tumblrFinal.csv", stringsAsFactors=F)
names(data) = tolower(gsub("\\.","",names(data)))
data$date = as.Date(data$datetime)
data = data[order(data$date, decreasing=F),]
<<<<<<< HEAD

# gen vars
=======
>>>>>>> 9c6fadd9e9e3f064529b6ed62fd23439c17f3114
data$p1 = ifelse(data$topic==1,1,0)
data$p2 = ifelse(data$topic==2,1,0)
data$p3 = ifelse(data$topic==3,1,0)
data$p4 = ifelse(data$topic==4,1,0)
data$p_pos= ifelse(data$fit=="positive",1,0)
data$p_neg= ifelse(data$fit=="negative",1,0)
data$p_neu= ifelse(data$fit=="neutral",1,0)

<<<<<<< HEAD
=======
plot(ddply(data, .(date), nrow), type="l")
>>>>>>> 9c6fadd9e9e3f064529b6ed62fd23439c17f3114
# normalize variables
normalize = function(x){
	x = sqrt(x/max(x))
	return(x)
}
data[,10:13] = t(apply(data[,10:13], 1, normalize))
data[,14:15] = t(apply(data[,14:15], 1, normalize))

viz_data = sqldf("select date, 
						 sum(students) as students,
						 sum(jobseconomy) as jobseconomy,
						 sum(healthcare) as healthcare,
						 sum(ideals) as ideals,
						 sum(p1) as p_students,
						 sum(p2) as p_jobseconomy,
						 sum(p3) as p_healthcare,
						 sum(p4) as p_ideals,
						 sum(p_pos) as p_pos,
						 sum(p_neu) as p_neu,
						 sum(p_neg) as p_neg
						 from data
						 group by date")
head(viz_data)
<<<<<<< HEAD
viz_data_1 = t(viz_data[,c(2:5)])
=======
viz_data_1 = t(viz_data[,6:12])
>>>>>>> 9c6fadd9e9e3f064529b6ed62fd23439c17f3114
# smooth over time
smoother = function(y){
	 y = lowess(y~1:length(y), f=0.09)$y
	 return(y)
}
viz_data_1 = t(apply(viz_data_1, 1, smoother))
names(viz_data_1) = as.Date(viz_data$date)
<<<<<<< HEAD
areaGraph(viz_data_1, type=2)
=======
areaGraph(viz_data_1)
>>>>>>> 9c6fadd9e9e3f064529b6ed62fd23439c17f3114
