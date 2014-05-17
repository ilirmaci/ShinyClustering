ShinyClustering
===============

Small Shiny app to illustrate clustering (*K-means* and *hierarchical*).

The app uses random generated data (90 point, the same each time). 
Cluster colors are from `RColorBrewer`, `"Paired"` palette.

To run you will need to have both files in the same folder and run:
    
    library(shiny)
    runApp("<folder>/")
    
where `<folder>` is the location where you stored the script files (w/o "<>").
