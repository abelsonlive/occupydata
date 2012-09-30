Sys.setenv(NOAWT=TRUE)
require("tm")
require("stringr")
require("topicmodels")
require("plyr")
require("RWeka")
require("Snowball")
setwd()
data = read.csv("data/TumblrClean.csv", stringsAsFactors=F)

# remove empties
data = data[which(data$body!=""),]
text = str_trim(tolower(data$body)))

# convert to corpus
text = Corpus(VectorSource(text))


# HERES WHAT I ADDED _ BA #
#_________________________#
stopwords <- c(stopwords('SMART'),
				"occupywallst.org", 
				"http://",
				"99", "000", "wall",
				"k", "don", "occupy", "street",
				"week", "year", "years")

text <- tm_map(text, removeWords, stopwords)
#_________________________#

# Quotations in the following comments are excerpts from "topicmodels: An R
# Package for Fitting Topic Models" (Grün & Hornik, 2010):
# 	http://cran.r-project.org/web/packages/topicmodels/vignettes/topicmodels.pdf
# (§4. Illustrative Example).

# "The corpus is exported to a document-term matrix using function
# DocumentTermMatrix() from package tm. The terms are stemmed and the stop
# words, punctuation, numbers and terms of length less than 3 are removed using
# the control argument."
dtm <- DocumentTermMatrix(text,
				control = list(stemming = TRUE, stopwords = TRUE, minWordLength = 3,
				removeNumbers = TRUE, removePunctuation = TRUE))

# "The mean term frequency-inverse document frequency (tf-idf) over documents
# containing this term is used to select the vocabulary. This measure allows to
# omit terms which have low frequency as well as those occurring in many
# documents. We only include terms which have a tf-idf value of at least 0.1
# which is a bit less than the median and ensures that the very frequent terms
# are omitted."
term_tfidf <- tapply(dtm$v/row_sums(dtm)[dtm$i], dtm$j, mean) * 
				log2(nDocs(dtm) / col_sums(dtm > 0))
dtm <- dtm[,term_tfidf >= 0.1]
dtm <- dtm[row_sums(dtm) > 0,]

# "In the following we fit an LDA model with [3] topics using ... Gibbs sampling
# with a burn-in of 1000 iterations and recording every 100th iterations for
# 1000 iterations. The initial α is set to the default value..." 
k <- 5
lda <- LDA(dtm, k = k, method = "Gibbs", control = list(seed = 1000, burnin = 1000, 
				thin = 100, iter = 1000))
nrow(lda)
Terms <- terms(lda, 10)

Terms