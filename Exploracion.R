exploracion<-  sidebarLayout(
  sidebarPanel(),
  mainPanel(
    tags$h1("SERIE DE TIEMPO"),
    
  
  #  dygraphOutput("dygraph"),
    plotOutput(outputId="exploracion") 
  )
)
 