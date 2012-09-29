require("tm")
require("stringr")
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
topics<-rep(0,2522)
for(j in 1:2522) {
 	topics[j]<-which.max(result$document_sums[ ,j])
 	ifelse(max(result$document_sums[,j])==0, topics[j]<-0, topics[j])
}
data$topic = topics

# assign semantic labels
data$topic[data$topic==0] = NA
data$topic[data$topic==1] = "Students"
data$topic[data$topic==2] = "Ideals"
data$topic[data$topic==3] = "Health Care"
data$topic[data$topic==4] = "Jobs/Economy"

# write to file
write.csv(data, "data/tumblrTopics.csv", row.names=F)
