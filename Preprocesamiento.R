preprocesamiento<-sidebarLayout(
  sidebarPanel(
    
    actionButton(inputId="btnMuestreo",label = "Muestreo"),
      
    actionButton(inputId = "btnImputacion",label="Imputacion de los valores de cero")
    
    
  ),mainPanel(
    tableOutput(outputId = "tblPreprocesar"),
    tableOutput(outputId = "tblImputacion")
  ))
