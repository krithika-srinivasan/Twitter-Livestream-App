library(textstem)
library(rtweet)
library(tm)
library(textdata)
library(tidyverse)
library(tidytext)
library(stringr)
library(igraph)
library(ggraph)
# library(qdap) --> can't use it here, but needed later
library(shiny)

runOnline = T

function(input, output) {

  getTweetData <- eventReactive( input$search, {
    isolate({
      withProgress(message = 'Collecting tweets', {
        req(input$searchstr)
        input$search
        stream_tweets(q = input$searchstr, timeout = input$time, file_name = "file1.json", language = 'en', retweets = FALSE)
        setProgress(input$time)
        df <- parse_stream('file1.json')
        df <- df$text
        df <- unique(df)
      })
    })
   
  })
  
  #Raw tweet display
  output$contents <- renderTable({
    fn <- "file1.json"
    if (file.exists(fn)) file.remove(fn)
    tweets <- getTweetData()
    
  })
  
  #Preprocessing
  
  
  tidytweets <- reactive({
    tweets <- getTweetData()
    tweetcorpus <- Corpus(VectorSource(tweets))
    tweetcorpus <- tm_map(tweetcorpus, function(x) iconv(enc2utf8(x), sub = "byte"))
    tweetcorpus <- tm_map(tweetcorpus, stripWhitespace)
    tweetcorpus <- tm_map(tweetcorpus, removePunctuation)
    tweetcorpus <- tm_map(tweetcorpus, removeNumbers)
    tweetcorpus <- tm_map(tweetcorpus, tolower)
    
    tweetdtm <- DocumentTermMatrix(tweetcorpus)
    
    tidytweet <- tidy(tweetdtm)
    
    tidytweet <- tidytweet %>%
      unnest_tokens(word,term)
    
    replace_reg <- "https://tco/[A-Za-z\\d]+|http://[A-Za-z\\d]+|tco[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https"
    unnest_reg <- "([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"
    tidytweet <- tidytweet %>% 
      filter(!str_detect(word, "^RT")) %>%
      mutate(word = str_replace_all(word, replace_reg, "")) %>%
      unnest_tokens(word, word, token = "regex", pattern = unnest_reg) %>%
      filter(!word %in% stop_words$word, str_detect(word, "[a-z]"))
    
    badwords <- c(input$searchstr)
    badwords <- tidy(badwords) %>%
      unnest_tokens(word,x)
    tidytweet <- tidytweet %>%
      anti_join(badwords)
    
    tidytweet <- tidytweet%>%
      anti_join(stop_words)
    
    tidytweet$word <- tibble(lemmatize_words(tidytweet$word))
    tidytweet$word <- tidytweet$word$`lemmatize_words(tidytweet$word)`
    
    badwords <- c(input$searchstr)
    badwords <- tidy(badwords) %>%
      unnest_tokens(word,x)
    tidytweet <- tidytweet %>%
      anti_join(badwords)
    
    tidytweet <- tidytweet %>%
      anti_join(stop_words)
    
    tidytweet
  })
  
  output$wordfreq <- renderPlot({
    tidytweet <- tidytweets()
    tidytweet %>%
      count(word, sort = TRUE) %>%
      top_n(input$n) %>%
      mutate(word = reorder(word, n)) %>%
      ggplot(aes(word, n)) +
      geom_col() +
      xlab(NULL) +
      theme_set(theme_gray(base_size = 20)) +
      coord_flip()
  })
  
  output$senti1 <- renderPlot({
    tidytweet <- tidytweets()
    tidytweet %>%
      inner_join(get_sentiments("bing")) %>%
      count(word, sentiment, sort = TRUE) %>%
      group_by(sentiment) %>%
      top_n(input$n1) %>%
      ungroup() %>%
      mutate(word = reorder(word, n)) %>%
      ggplot(aes(word, n, fill = sentiment)) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~sentiment, scales = "free_y") +
      labs(y = "Contribution to sentiment",
           x = NULL) +
      coord_flip()
  })
  
  output$senti2 <- renderPlot({
    tidytweet <- tidytweets()
    tidytweet %>%
      inner_join(get_sentiments("nrc")) %>%
      count(word, sentiment, sort = TRUE) %>%
      group_by(sentiment) %>%
      top_n(input$n2) %>%
      ungroup() %>%
      mutate(word = reorder(word, n)) %>%
      ggplot(aes(word, n, fill = sentiment)) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~sentiment, scales = "free_y") +
      labs(y = "Contribution to sentiment",
           x = NULL) +
      coord_flip()
  })
  
  output$sentiscore <- renderPlot({
    tidytweet <-tidytweets()
    tweetsent <- tidytweet %>%
      inner_join(get_sentiments("afinn")) %>%
      count(word, value, sort = TRUE) %>%
      group_by(value) %>%
      top_n(input$n3) %>%
      ungroup() %>%
      mutate(word = reorder(word, n))
    ggplot(tweetsent,aes(word, n, fill = value)) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~value, scales = "free_y") +
      labs(y = paste0("Average sentiment: ", mean(tweetsent$value)),
           x = NULL) +
      coord_flip()
  })
  
  output$bigram <- renderPlot({
    tidytweet <-tidytweets()
    tweetbi <- tidytweet %>%
      unnest_tokens(bigram, word, token = "ngrams", n = 2)
    tweetbi <- tweetbi%>%
      filter(!is.na(bigram))
    tweetbi %>%
      count(bigram, sort = TRUE) %>%
      top_n(input$n4) %>%
      mutate(bigram = reorder(bigram, n)) %>%
      ggplot(aes(bigram, n)) +
      geom_col() +
      xlab(NULL) +
      coord_flip()
  })
  output$bigramnw <- renderPlot({
    tidytweet <-tidytweets()
    tweetbi <- tidytweet %>%
      unnest_tokens(bigram, word, token = "ngrams", n = 2)
    tweetbisep <- tweetbi %>%
      separate(bigram, c("word1", "word2"), sep = " ")
    
    tweetgraph <- tweetbisep %>%
      count(word1,word2, sort = TRUE) %>%
      filter(n > input$n5)%>%
      filter(!is.na(word1))
    shiny::validate(
      need(nrow(tweetgraph) > 0, "Try a lower frequency")
    )
    tweetgraph <- tweetgraph %>%
      graph_from_data_frame()
    set.seed(2016)
    ggraph(tweetgraph, layout = "fr") +
      geom_edge_link() +
      geom_node_point() +
      geom_node_text(aes(label = name), vjust = 1, hjust = 1)
  })
  
 #word Search
  output$tweetsrch <- renderTable({
    req(input$tweetsrch)
    input$searchstr
    tweets <- getTweetData()
    library(qdap)
    
    dat <- data.frame(text=tweets, stringsAsFactors = FALSE)
    dat <- unique(dat)
    
    twtsearch <- Search(dat, input$tweetsrch)
    twtsearch <- tidy(twtsearch)
    rename(twtsearch, Tweets = x)
      
  })
  

}
