rm(list=ls(all=TRUE))
library(XML)
library(bitops)
library(RCurl)
library(NLP)
library(httr)

#set the folder from which R derives the data
setwd('D:/Desktop/R-project/yungching house')
alldata=read.csv('./yungching01.csv')
orgUrl='https://buy.yungching.com.tw'
#ORIGIN: for(i in 1:length(alldata$X))

#check the number of observation
length(alldata$X)

#the length is 400, then go through different ranges separately

#need to create a folder name'alltext'prior the following command
##how to add the function to read the web every,say, 1 minutes?

for(i in 397:400)
{ #original: hurl=paste(orgUrl,alldata$url,sep='')-->not working
  hurl<-paste(orgUrl,alldata$url[i],sep='')
  urlExists=url.exists(hurl)
  
  if(urlExists)
  {
    html = getURL(hurl, ssl.verifypeer = FALSE, encoding='UTF-8')
    xml = htmlParse(html, encoding='UTF-8')
    text=xpathSApply(xml,"//dir[@class=\"m-house-description\"]",xmlValue)
    name<-paste('./alltext/c',i,'.txt',sep="")
    write(text,name)
  }
  
}  
######################################################   
##when running the if loop, from time to time the following error message 
## would pop up
##"Error in function (type, msg, asError = TRUE) :
##SSL read: error:00000000:lib(0):func(0):reason(0), errno 10054"
##SOLUTION: run the if loop for several times by changing the range (i.e. 1:100, then 101:200)

### preparation for the 3rd step#####################
## by using the cmd in windows, I combined all the text files into one txt file
## Steps:
# 1. in Windows, key in "cmd"
# 2. in CMD, key in "d:" to set the directory to D
# 3. further key in "cd(space)Desktop\R-project\yungching house\alltext"
# 4. further key in "copy(space)*txt(space)allhouse.txt" (i.e. name this file 'allhouse.txt')