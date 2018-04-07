library(streamR)
library(ROAuth)
consumerKey <- 'EeXD2KLpYsQLZ8dxAotiHmwxG'
consumerSecret <- 'X3QfIGjztfM2SNYLYftrLn5sEMYy5V01PxmrL79NI5CN8L0Tn2'
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



