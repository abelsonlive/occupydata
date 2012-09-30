
rm(list=ls())
# change to the directory you download to
setwd("~/Dropbox/GitRepository/occupydata/")
d = read.csv("data/tumblrTopics.csv", stringsAsFactors=F)
text = d$body
out <- classify_polarity(text,algorithm="bayes",pstrong=0.5,pweak=1.0,
prior=1.0,verbose=TRUE)
d[,c("pos", "neg", "pnratio", "fit")] = out
names(d)
write.csv(d, "data/tumblrFinal.csv", row.names=F)