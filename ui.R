library(shiny)

shinyUI(
  navbarPage('Twitter Streamer',
             tabPanel('Get Tweets',
                      fluidPage(
                        
                        # Sidebar layout with input and output definitions ----
                        sidebarLayout(
                          
                          # Sidebar panel for inputs ----
                          sidebarPanel(
                            
                            # Input: Select a file ----
                            textInput("searchstr", "Search for a topic" ),
                            
                            numericInput("time", "For how many seconds?", 100, min = 1, max = 10800),
                            
                            actionButton('search', "Search")
                            
                            ),
                          
                          
                          # Main panel for displaying outputs ----
                          mainPanel(
                            
                            # Output: Data file ----
                            tableOutput("contents")
                            
                          )
                          
                        )
                      )
                      
                      
                      ),
             
             tabPanel("Word Frequency",
                      fluidPage(
                        sidebarPanel(
                          sliderInput("n", "Top Words",min = 5, max = 100, value = 10)
                        ),
                        mainPanel(plotOutput("wordfreq"), height = '800px')
                        
                      )),
             
             tabPanel("Sentiments 1",
                      fluidPage(
                        sidebarPanel(
                          sliderInput("n1", "Top Words",min = 1, max = 100, value = 10)
                        ),
                        mainPanel(plotOutput("senti1"), height = '800px')
                      )),
             
             tabPanel("Sentiments 2",
                      fluidPage(
                        sidebarPanel(
                          sliderInput("n2", "Top Words",min = 1, max = 100, value = 5)
                        ),
                        mainPanel(plotOutput("senti2"), height = '800px')
                      )),
             
             tabPanel("Sentiment Scores",
                      fluidPage(
                        sidebarPanel(
                          sliderInput("n3", "Top Words",min = 1, max = 100, value = 5)
                        ),
                        mainPanel(plotOutput("sentiscore"), height = '800px')
                      )),
             
             tabPanel("Bigrams",
                      fluidPage(
                        sidebarPanel(
                          sliderInput("n4", "Top Words",min = 1, max = 100, value = 10)
                        ),
                        mainPanel(plotOutput("bigram"), height = '800px')
                      )),
             
             tabPanel("Bigram Network",
                      fluidPage(
                        sidebarPanel(
                          sliderInput("n5", "Top Words",min = 1, max = 100, value = 5)
                        ),
                        mainPanel(plotOutput("bigramnw"), height = '800px')
                      )),
             
             tabPanel("Tweet Search",
                      fluidPage(
                        sidebarPanel(
                          textInput('tweetsrch', 'Word or Phrase')
                          # actionButton('srch', 'Search')
                        ),
                        mainPanel(tableOutput('tweetsrch'))
                      ))
             #Other tab panels
    
  )
  
)
