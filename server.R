require(shiny)
options(shiny.usecairo=FALSE)


# generate data
set.seed(1235)
x1 <- rep(c(1, 2, 4), c(30, 25, 35))
x2 <- rep(c(1, 5, 2, 5, 3), c(10, 12, 28, 15, 25))

x1 <- x1 + 0.5*rnorm(x1)
x2 <- x2 + 2 + 0.4*rnorm(x2)

data <- data.frame(x1, x2)

# colors from RColorBrewer, palette "Paired"
cc <- c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99",
        "#E31A1C", "#FDBF6F", "#FF7F00")


# define server logic
shinyServer(function(input, output){
  
  # compute kmeans clusters reactively  
  km <- reactive({
    set.seed(input$kmseed)
    kmeans(data, centers=input$centroids, nstart=input$iterations)
  })
  
  # run hierarchical clustering analysis
  # could place inside renderPlot but may be better to run just once
  hc <- hclust(dist(data))
  
  
  # scatterplot with all data points
  output$clusterPlot <- renderPlot({
    
    # if no choice has been made plot unmarked data
    if (input$model == "none"){
      plot(data, pch=19, col="gray50",
           main="Clustering on two features (n=90)")
    }
    
    else if (input$model == "kmeans"){
      plot(data, pch=19, col=cc[km()$cluster],
           main="Clustering on two features (n=90)")
      points(km()$centers, col=cc[1:input$centroids], pch=3, cex=1.5)
    }
    
    # hierarchical clustering
    else if (input$model == "hier"){
      # if user opts for number of clusters
      if (input$hcswitch=="k"){
        plot(data, pch=19, col=cc[cutree(hc, k=input$hck)],
             main="Clustering on two features (n=90)")
      }
      
      # if user opts for tree height
      else if (input$hcswitch=="h"){
        plot(data, pch=19, col=cc[cutree(hc, h=input$hch)],
             main="Clustering on two features (n=90)")
      } 
    } 
  }, width=480)
  
  
  output$dendrogram <- renderPlot({
    
    # skip plot if not in hierarchical clustering
    if (input$model != "hier") return(NULL)
    
    # reduce lower margin and save old settings as op
    op <- par(mar=c(1, 4, 4, 2) + 0.1)
    plot(hc, xlab="", sub="", labels=FALSE)
    
    # if user opts for tree height show cutoff level
    if (input$hcswitch=="h"){
      abline(h=input$hch, col="orange")
    }
    
    # restore graphics options 
    par(op)
    
  }, width=480)
  
    output$sideText <- renderText({
      
      # help text if no model has been chosen
      if (input$model == "none"){
        HTML("There are two main methods to cluster your data: K-means clustering and 
        hierarchical clustering.<br/><br/>
        K-means clustering uses a greedy algorithm whose results depend on
        the initial choice of centroids.<br/><br/>
        Hierarchical clustering is deterministic and can allows a detailed
        choice of the number of clusters after the analysis has been run.")
      } 
      
      # help text if K-means clustering been chosen
      else if (input$model == "kmeans"){
          HTML('K-means clustering requires that you specify the desired number of 
          clusters beforehand. The cluster centroids are shown on the plot.<br/><br/>
          It then uses a greedy algorithm that depends on
          a random variable. You can change the seed value to see alternative
          results with a different starting point. Setting a higher number of 
          iterations should mitigate for this variability, because only the
          best result is returned.')
        }
      
      # help text if hierarchical clustering been chosen
      else if (input$model == "hier"){
        HTML("Hierarchical clustering does not rely on a random starting point or
        a specific number of clusters. It computes all possible pairings
        through an exhaustive, deterministic algorithm.<br/><br/>
        You can specify the desired number of clusters afterwards based
        on the dendrogram it returns. This is done either by specifying a
        desired number of clusters, or by setting a height threshold (a 
        cutoff on the distance between two points.)<br/><br/>
        A higher distance implies a broader definition of which points
        can be grouped together, and therefore a smaller number of clusters.")
      }
    })
    
    
})




