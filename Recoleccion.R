# plumber.R


#* Recoleccion de datos
#* @excel
#* @get /read_excel1




recoleccion<-sidebarLayout(
  sidebarPanel(
    textInput(inputId = "txtHoja",label ="Numero de hoja a leer",value = 1),
    fileInput(inputId = "Archivo1", 
              label = "Obtener Archivo ", 
              accept = c(".tsv",".data",".csv","xls","xlsx")),
    hr(),
    checkboxInput(inputId = "cabecera",label = "¿Tiene cabecera?",value=FALSE)),
    
    mainPanel(
    tableOutput(outputId = "archivoLectura")
  # tableOutput(outputId = "archivoLectura2")
  )
  
  
)


