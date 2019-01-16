library(shiny)
library(rsconnect)

token <- read.csv("~/shinyApps/token_info",header=F)
secret <- read.csv("~/shinyApps/secret_info",header=F)

token <- as.character(token$V1)
secret <- as.character(secret$V1)

rsconnect::setAccountInfo(name='sidmontu', token=token, secret=secret)
deployApp()
