rm(list=ls())
# change to the directory you download to
setwd("~/Dropbox/GitRepository/occupydata/")

#libraries
require("tm")
require("stringr")
require("lda")
require("plyr")
require("sentiment")
# read in data
data = read.csv("data/tumblrClean.csv", stringsAsFactors=F)

# remove empty posts
data = data[which(data$body!=""),]

# convert date
data$date = as.Date(data$datetime)

# clean up text
text = str_trim(
			 tolower(
			 gsub("[[:punct:]]", " ", data$body)))

# convert to corpus
text = Corpus(VectorSource(text))

#remove stopwords
stopwords <- c(stopwords('SMART'),
				"occupywallst.org", 
				"http://",
				"99", "000", "wall",
				"k", "don", "occupy", "street",
				"week", "year", "years")

text <- tm_map(text, removeWords, stopwords)

# run 
text <- tm_map(text, stripWhitespace)
text <- tm_map(text, removeNumbers)
text = gsub("  ", " ", text)

# lexicalize text
corpus<-lexicalize(text, sep=" ", count=1)

# Only keep words that appear at least twice, 
# and you might change the number from 1 to 2, 3, 4 or others:
N<-2
keep <- corpus$vocab[word.counts(corpus$documents, corpus$vocab) >= N]

# Re-lexicalize, using this subsetted vocabulary
documents <- lexicalize(text, lower=TRUE, vocab=keep)

# Gibbs Sampling
# K is the number of topics
K<-4
result <- lda.collapsed.gibbs.sampler(documents,K, keep, 1000, 0.1, 0.1)
top.topic.words(result$topics, num.words = 20, by.score = FALSE)

# assign topic to document
data$topic = ""
d = result$document_sums
row.names(d) = c("Students", "Ideals", "Health Care", "Jobs/Economy")
n  = ncol(d)
v<-rep(0,n)
topics = data.frame( p1=v , p2=v , p3=v , p4=v )
for(j in 1:n) {
 	data$topic[j] = which.max(d[,j])
 	topics[j,] <- d[,j]/sum(d[,j])
}
data[,row.names(d)] = topics
head(data)
# write to file
write.csv(data, "data/tumblrTopics.csv", row.names=F)
