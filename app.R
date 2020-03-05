library(shiny)
library(dplyr)
library(sqldf)
library(datasets)
library(shinythemes)
#Lee archivos excel
library(readxl)
#install.packages ('rsconnect')
library(rsconnect)
#Librearias a utilizar
library(tseries)
#install.packages("forecast")
library(forecast)
library(datasets)
library(shinythemes)
#Lee archivos excel
library(readxl)
library(RMySQL)
library(DBI)
library(readr)
library(purrr)
library(dygraphs)
library(data.table)
library(moments)
library(stats)
library(plumber)

rsconnect :: setAccountInfo (name = 'alexander12',
                             token = '35926456CB9D83F4234F0F1AF2EAF6ED',
                             secret ='2wkwSnbdIhtWH1QWO/c8x5GTcaX/MyGWTVAsjpMh')

#getwd()
#setwd('C:/Users/Cielo/Documents/Shinny/EjemploProyecto')



#########################################################
#Variables globales
archivo <- NULL
lista1<-list()
datosex<-NULL
plot<-NULL
arimadtf<-NULL


#########################################################



source("www/Recoleccion.R")
source("www/Preprocesamiento.R")
source("www/Exploracion.R")
source("www/Otros.R")
source("www/Exportacion.R")
source("www/ModeloSeries.R")


#########################################################
# Define UI for application that draws a histogram
ui <- fluidPage(
      titlePanel("Plataforma datascience"),
      tabsetPanel(
        tabPanel("Descripcion",
                 flowLayout(
                  h2("Prediccion de seguros Rimac para el 2018"),
                  p("En el presente proyecto se realizara una prediccion de series de tiempo con el modelo ARIMA")
        
                 ) 
                 ),
        tabPanel("Recoleccion",recoleccion),
        tabPanel("Preprocesamiento",preprocesamiento),
        #tabPanel("Modelo",modelo),
        tabPanel("Exploracion",exploracion),
        tabPanel("Series",series),
        tabPanel("Exportar",exportar),
        tabPanel("Funcionalidades adicionales",otros)
        #tabPanel("Acerca de...",acerca)
        )
      )

# Define server logic required to draw a histogram
server <- function(input, output) {
  

  output$archivoLectura<-renderTable(
    
    {archivo <- input$Archivo1
    if (is.null(archivo)) 
      return(NULL)
    
    # for(i in 1:14)
    #{
    #lista[[i]]<<- read_excel(ruta<-archivo$datapath,sheet=i)
    #}
    lista1[[as.numeric(input$txtHoja)]]<<-read_excel(archivo$datapath,sheet=as.numeric(input$txtHoja))
    
     
    }
    )
  
  observeEvent(input$btnMuestreo,{
    
    h1<-lista1[[1]][1:5,c(1,6)]
    h2<-lista1[[2]][2:13,c("MESES","RIMAC")]
    h3<-lista1[[3]][2:13,c("MESES","RIMAC")]
    h4<-lista1[[4]][2:12,c("MESES","RIMAC")]
    h5<-lista1[[5]][2:13,c("MESES","RIMAC")]
    h6<-lista1[[6]][2:13,c("MESES","RIMAC")]
    h7<-lista1[[7]][2:13,c("MESES","RIMAC")]
    h8<-lista1[[8]][2:13,c("MESES","RIMAC")]
    h9<-lista1[[9]][2:13,c("MESES","RIMAC")]
    h10<-lista1[[10]][2:13,c("MESES","RIMAC")]
    h11<-lista1[[11]][2:13,c("MESES","RIMAC")]
    h12<-lista1[[12]][2:13,c("MESES","RIMAC")]
    h13<-lista1[[13]][2:13,c("MESES","RIMAC")]
    h14<-lista1[[14]][2:13,c("MESES","RIMAC")]
    
    datosex<<-rbind(h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14)
  
    datosex$MESES<-as.Date.character(datosex$MESES,'%y/%m/%d')
    datosex$RIMAC<-as.numeric(datosex$RIMAC)
    
  }
  )
  observeEvent(input$btnImputacion,{
    
    
    imputando_cero<-function(df,pro)
    {
      for(i in 1:dim(df)[1])
      {
        if(as.numeric(df[i,2])==0)
        {
          df[i,2]<-pro
        }
        
      }
      return(df)
    }
    datosex<<-imputando_cero(datosex,mean(datosex$RIMAC))
    
    
  })
  output$tblPreprocesar<-renderTable(
    
    {
      
    print( datosex)
      
    }
  )
  output$tblImputacion<-renderTable(
    
    
    {
      print(datosex)
    }
    
  )
  output$exploracion<-renderPlot(
    {
      plot(datosex$RIMAC,type = "l",xlab = "Fecha",ylab = "RIMAC")
    }
  )
  output$plotserie<-renderPlot(
    
    { dRIMAC<-diff(datosex$RIMAC)
      
      auto.arima(datosex$RIMAC)
      
      arimadtf<<-arima(datosex$RIMAC,order=c(5,0,3))
      
     plot<<-plot(forecast(arimadtf,30,level = 95),type = "l",main = "Pronostico con auto-arima")
      
      
    }
    
  )
  observeEvent(input$btnExportar,{
    
    pdf(file=input$txtRuta)
    plot(forecast(arimadtf,30,level = 95),type = "l",main = "Pronostico con auto-arima")
    dev.off()
    
    } 
  )
 observeEvent(input$btnPlumber,{
   
       r <- plumb(file = "www/Recoleccion.R") 
        r$run(port=8000)
    
} 
)
 # output$dygrpah<-renderDygraph(
    #{ 
      
   
      
      # dygraph(data.table(datosex),xlab="Fechas de cierre de mes",ylab = "Monto de seguros RIMAC",
       # main = "Cantidad de pagos realizados a la aseguradora RIMAC")%>%dyOptions(colors = "blue")%>%dygraphs::dyRangeSelector()
    
   # }
  #)
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
