setwd("~/Dropbox/GitRepository/occupydata/")
library("plyr")
library("stringr")

# extract i wants
iWants = function(body){
	sentences = unlist(str_extract_all(body, "I (want|wanted)[^\\.]*."))
	return(as.character(sentences))
}

wants = unlist(llply(d$body, iWants))
write(wants, "data/wants.txt")

iAms = function(body){
	sentences = unlist(str_extract_all(body, "I am [^\\.]*."))
	return(as.character(sentences))

}

# extract i ams
ams = unlist(llply(d$body, iAms))
write(ams, "data/ams.txt")
