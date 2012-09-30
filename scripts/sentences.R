setwd("~/Dropbox/GitRepository/occupydata/")
library("plyr")
library("stringr")

# extract i wants
iWants = function(body){
	sentences = unlist(str_extract_all(body, "(want|wanted)[^\\.]*."))
	return(as.character(sentences))
}

wants = unlist(llply(d$body, iWants))
wants = gsub("(want|wanted)", "", wants)
wants  = str_trim(gsub("OWS", "", wants))
write(ams, "data/wants.txt")

iAms = function(body){
	sentences = unlist(str_extract_all(body, "I am [^\\.]*."))
	return(as.character(sentences))

}

# extract i ams
ams = unlist(llply(d$body, iAms))
ams = gsub("I am", "", ams)
ams = gsub("99%", "", ams)
ams = gsub("99 percent", "", ams)
ams = str_trim(gsub("OWS", "", ams))
write(ams, "data/ams.txt")
