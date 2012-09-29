rm(list=ls())
Sys.setenv(NOAWT=TRUE)
require("tm")
require("stringr")
require("Snowball")
require("lda")
require("plyr")
setwd("~/Dropbox/GitRepository/occupydata/")

data = read.csv("data/tumblrClean.csv", stringsAsFactors=F)

# remove empties
data = data[which(data$body!=""),]

# convert date
data$date = as.Date(data$datetime)

counts = ddply(data, .(date), nrow)
plot(counts, type="h")
text = str_trim(
			 tolower(
			 gsub("[[:punct:]]", " ", data$body)))
text = stemDocument(text)

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
text <- tm_map(text, stripWhitespace)
text <- tm_map(text, removeNumbers)
text = gsub("  ", " ", text)
# change document lines into the format for LDA
doclines<-as.character(text)
corpus<-lexicalize(doclines, sep=" ", count=1)

# Only keep words that appear at least twice, and you might change the number from 1 to 2, 3, 4 or others:
# N is the the least number of appearance of words that can be considered
N<-2
keep <- corpus$vocab[word.counts(corpus$documents, corpus$vocab) >= N]

# Re-lexicalize, using this subsetted vocabulary
documents <- lexicalize(doclines, lower=TRUE, vocab=keep)

# Gibbs Sampling
# K is the number of topics
K<-4
result <- lda.collapsed.gibbs.sampler(documents,K, keep, 1000, 0.1, 0.1)
top.topic.words(result$topics, num.words = 20, by.score = FALSE)
 topic.films<-rep(0,2522)
 for(j in 1:2522) {
 	topic.films[j]<-which.max(result$document_sums[ ,j])
 	ifelse(max(result$document_sums[,j])==0, topic.films[j]<-0, topic.films[j]<-topic.films[j])
}
data$topic = topic.films

# assign semantic labels
data$topic[data$topic=1] = 
data$topic[data$topic=2] = 
data$topic[data$topic=3] = 
data$topic[data$topic=4] = 
# top words in each topic


# top documents in each topic
top.topic.documents(result$document_sums, num.documents = 20, alpha = 0.1)