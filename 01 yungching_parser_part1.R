rm(list=ls(all=TRUE))
library(XML)
library(bitops)
library(RCurl)
library(httr)

orgURL1 = 'https://buy.yungching.com.tw/region/%E5%8F%B0%E5%8C%97%E5%B8%82-_c/pricereduction_filter/?pg='


startPage = 1
endPage = 20
alldata = data.frame()
for( i in startPage:endPage)
{
  pttURL <- paste(orgURL1, sep='')
  urlExists = url.exists(pttURL)
  
  if(urlExists)
  {
    html = getURL(pttURL, ssl.verifypeer = FALSE)
    xml = htmlParse(html, encoding ='utf-8')
    
    write(html, "test.html")
    
    housename = xpathSApply(xml, "//a/h3", xmlValue)
    #detail = xpathSApply(xml, "//div[@class=\"item-description\"]", xmlValue)
    
    type= xpathSApply(xml, "//ul[@class=\"item-info-detail\"]/li[1]",xmlValue)
    year=xpathSApply(xml, "//ul[@class=\"item-info-detail\"]/li[2]",xmlValue)
    year=gsub("\r\n","",year)
    #delete space
    year=gsub(" ","",year)
    #delete chinese character
    year=gsub("年","",year)
    bed =xpathSApply(xml, "//ul[@class=\"item-info-detail\"]/li[7]", xmlValue)
    bed=gsub("\r\n","",bed)
    #delete space
    bed=gsub(" ","",bed)
    price= xpathSApply(xml,"//div[@class=\"price\"]",xmlValue)
    price=gsub(",","",price)
    price=gsub(" 萬","",price)
    urltemp= xpathSApply(xml,"//ul[@class=\"l-item-list\"]//div/a",xmlGetAttr,'href')
    #there were two spaces in between, so 4th-1st=3
    urlid=seq(1,length(urltemp),by=3)
    url=urltemp[urlid]
    tempdata = data.frame(housename, price, type, year,bed,url)
  }
  alldata = rbind(alldata, tempdata)
}

write.csv(alldata,"yungching01.csv")