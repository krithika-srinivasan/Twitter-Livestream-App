# Twitter-Livestream-App
This is an R Shiny application that streams tweets in real time and then generates interactive analytics from the collected Tweets.
You can find it at this address: https://moopyminesbleetr.shinyapps.io/appv2/ (THE APP ISN'T WORKING RIGHT NOW. I'M CURRENTLY IN THE PROCESS OF UPDATING THE CODE TO REFLECT CHANGES IN R PACKAGES IN THE LAST FEW YEARS. THE CODE IN THIS REPO WILL WORK PROPERLY, BUT CURRENTLY IS NOT VALIDATED) To run this code, you will need R Studio and the following libraries installed:
textstem

rtweet

tm

textdata

tidyverse

tidytext

stringr

igraph

ggraph

qdap

shiny

What's new --> Switched from streamR to rtweet. Advantages of rtweet are that there's no need to worry about authentication, and it's easier to consider multiple inputs. It also shows tweets in its entirety without truncation.

# TO DO:
  1. Add tab for topic modelling (Mostly BTM for short text modelling)
  2. Add tab for time series for the term
  3. Correlated word search
  4. Proper validation and error handling
  4. Smaller stuff:
  
      4.1. Make the plots bigger
      
      4.2. Make a real progress bar for tweet collection
      
      4.3. Python script for lemmatization (?)

# Future exploration
   1. Narrative extraction --> what stories surround this topic? (Possibly the most-retweeted tweets?)
   2. More sophisticated sentiment analysis, i.e. move away from the lexicon-based approaches   
