require(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Clustering by example"),
  
  # Sidebar with a slider input for bins
  sidebarLayout(
    sidebarPanel(
      
      # type of clustering algorithm, K-means vs. hierarchical
      selectInput("model", label = h4("Clustering algorithm"), 
                  choices = list("Choose one" = "none",
                                 "K-means" = "kmeans", 
                                 "Hierarchical" = "hier"), 
                  selected = "none"),
      
      # in case K-means clustering is chosen
      conditionalPanel('input.model == "kmeans"', 
                       
                       # show help text
                       helpText("For K-means clustering you need to pick the
                                number of clusters. Change the", strong("seed"),
                                "to run the algorithm with 
                                a different starting set of random centroids.
                                Increase the number of", strong("iterations"), 
                                "for more robust results."),
                       
                       # number of clusters desired (2-8)
                       sliderInput("centroids", label=h4("Number of clusters (K)"),
                                   min=2, max=8, value=3, step=1, ticks=TRUE),
                       
                       numericInput("kmseed", label=h4("Set seed for replicability"), 
                                    value=1234, min=1, max=9999999),
                       
                       sliderInput("iterations", label=h4("Number of iterations to try"),
                                   min=1, max=10, value=1, step=1, ticks=TRUE)
      ),
      
      
      # in case hierarchical clustering is chosen
      conditionalPanel('input.model == "hier"', 
                       
                       helpText("Hierarchical clustering you choose how the
                                resulting dendrogram should be cut. Opting 
                                for", strong("number of clusters"), "lets 
                                you set this directly. Choosing", 
                                strong("height"), "lets you determine a cutoff
                                distance beyond which points are considered 
                                to be in separate clusters."),
                       
                       # kind tree cutoff, by number of clusters vs by tree height
                       radioButtons("hcswitch", label=h4("Cluster selection"),
                                    choices = list("Number of clusters" = "k",
                                                   "Height of tree (distance)" = "h"),
                                    selected = "k"),
                       
                       # number of clusters desired (2-8)
                       sliderInput("hck", label=h4("Number of clusters"),
                                   min=2, max=8, value=3, step=1, ticks=TRUE),
                       
                       # height of tree to cut off
                       sliderInput("hch", label=h4("Height of tree"),
                                   min=2.1, max=6, value=4, step=0.1, ticks=FALSE)
      )  
    ),
    
    # show the plot
    mainPanel(
      
      # main scatterplot
      div(plotOutput("clusterPlot"), class = "span6"),

      # dendrogram in case of hierarchical clustering
      div(plotOutput("dendrogram"), class = "span6"),
      
      # show explanations dynamically
      div(htmlOutput('sideText'), class = "span6"),
      
      # mainPanel width (out of 12 total)
      width=8
    )
  )
))

