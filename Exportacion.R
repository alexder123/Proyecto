exportar<-sidebarLayout(
  sidebarPanel(
    
    actionButton(inputId="btnExportar",label = "Exportar"),
    textInput(inputId="txtRuta", label="Ruta para exportar",value = "C:/Users/Cielo/Documents/Shinny/EjemploProyecto/grafico1.pdf")
    
  ),mainPanel(
    
    
  )
  
)
