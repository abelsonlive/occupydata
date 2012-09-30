setwd("~/Dropbox/GitRepository/occupydata/")
library("RColorBrewer")
library("plyr")
library("reshape2")
library("lubridate")
library("stringr")
d = read.csv("data/tumblrTopics.csv", stringsAsFactors=F)

# clean up dates
d$date = as.Date(d$date)

# order by date
d = d[order(d$date),]
d$month = month(d$date)
d$year = year(d$date)
head(d$month)
d$mthyr = paste(d$month, d$year, sep="-")

# pie chart of topics
counts = ddply(d, .(topic), nrow)
counts = counts
cols = brewer.pal(5, "RdYlBu")
cols = cols[-3]

pdf(height=4, width=4, file="viz/piechart.pdf")
pie(counts$V1, labels = counts$topic, main="Pie Chart of Topics", col=cols)
dev.off()

#line chart of 
daycounts = ddply(d, .(date), nrow)
par(mai=c(0.9, 0.9, 0.5, 0.5), family="OpenSans")

plot(daycounts, 
	type="h", 
	lwd=5, 
	col=cols[4], 
	xlab="Time", 
	ylab="date",
	xaxt="n", 
	main="Posts on wearethe99percent.tumblr.com over time")
axis.Date(1, unique(d$date), labels = TRUE)

