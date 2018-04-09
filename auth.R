library(streamR)
library(ROAuth)
consumerKey <- YOUR CONSUMER KEY
consumerSecret <- YOUR CONSUMER SECRET KEY
requestURL <- 'https://api.twitter.com/oauth/request_token'
accessURL <- 'https://api.twitter.com/oauth/access_token'
authURL <- 'https://api.twitter.com/oauth/authorize'
cred <- OAuthFactory$new(consumerKey = consumerKey,
                             consumerSecret = consumerSecret,
                             requestURL = requestURL,
                             accessURL = accessURL,
                             authURL = authURL)
cred$handshake()

#Save the credentials in the application folder for the oauth parameter in the filterstream function
save(cred, file="credentials.RData")
readRDS('.httr-oauth')



