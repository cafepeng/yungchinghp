rm(list=ls(all=TRUE))
# install.packages("jiebaR")
# install.packages("tm")
# install.packages("slam")
# install.packages("RColorBrewer")
# install.packages("wordcloud")
# install.packages("topicmodels")
# install.packages("igraph")
# install.packages("xml2")

library(jiebaRD)
library(jiebaR)       # 斷辭利器
library(NLP)
library(tm)           # 文字詞彙矩陣運算
library(slam)         # 稀疏矩陣運算
library(RColorBrewer)
library(wordcloud)    # 文字雲
library(topicmodels)  # 主題模型
library(plyr)

#source('chosePage.R')

#Sys.setlocale("LC_ALL", "cht")

#result = chosePage(1,2)

#ORIGIN: orgPath = "./temp" -->Pecu used the website of finance rather than PTT
# Here: use PTT's allText folder I created


##ORIGIN  orgPath = "./allText"
##ADD the following because of reading a txt file only
setwd('D:/Desktop/R-project/yungching house')
orgPath=readLines('allhouse01.txt')

##ORIGIN text = Corpus(DirSource(orgPath), list(language = NA))
##replace with the following because of reading a file instead
text = Corpus(VectorSource(orgPath), list(language = NA))
text <- tm_map(text, removePunctuation)
text <- tm_map(text, removeNumbers)
text <- tm_map(text, function(word)
{ gsub("[A-Za-z0-9]", "", word) })
##ADD -->remove those meaningless words  but unsuccessful
#text<-tm_map(text,removeWords,c("只是","其實","一定","只有","因為"))

# 進行中文斷辭
mixseg = worker()
mat <- matrix( unlist(text) )
totalSegment = data.frame()
for( j in 1:length(mat) )
{
  for( i in 1:length(mat[j,]) )
  {
    result = segment(as.character(mat[j,i]), jiebar=mixseg)
  }
  totalSegment = rbind(totalSegment, data.frame(result))
}

# define text array that you want
# delete text length < 2
delidx = which( nchar(as.vector(totalSegment[,1])) < 2 )
countText = totalSegment[-delidx,]
countResult = count(countText)[,1]
countFreq = count(countText)[,2] / sum(count(countText)[,2])

#Try to sort text by frequency but failed
#x <- sort(count(countText),decreasing=T)


#wordcloud(countResult, countFreq, min.freq = 1, random.order = F, ordered.colors = T, 
#          colors = rainbow(length(countResult)))
wordcloud(countResult, countFreq, min.freq = 100, random.order = F, ordered.colors = T, 
          colors = rainbow(length(countResult)))

####try to find the words with high frequency#####
x1<-c(count(countText))
head(x1)
x2<-data.frame(x1)
x3<-x2[x2$freq<220,1]