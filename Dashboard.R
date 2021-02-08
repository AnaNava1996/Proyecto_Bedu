## app.R ##

#install.packages("leaflet")
#install.packages("units", dependencies = TRUE)

#if (!require("shiny")) install.packages("shiny")
#if (!require("shinydashboard")) install.packages("shinydashboard")
#if (!require("shinythemes")) install.packages("shinythemes")
#if (!require("tmap"))
#install.packages("tmap",dependencies=TRUE)
#library(tmap)


library(shiny)
library(shinydashboard)
library(shinythemes)
library(googleway)
library(ggplot2)
library(dplyr)


incendios<-na.omit(read.csv("./Data_Sets/incendios_con_ecoregiones_y_tiposdesuelo.csv"))



ui <- 
    
    fluidPage(
        
        dashboardPage(
            
            skin = "purple",
            
            dashboardHeader(
                title = "Proyecto, análisis de incendios en México",
                titleWidth = 450),
            
            dashboardSidebar(
                width = 350,
                sidebarMenu(
                    menuItem("Mapa de incendios", tabName = "map2", icon = icon("map-marker")),
                    menuItem("Ecorregiones y uso de suelo", tabName = "img", icon = icon("map")),
                    menuItem("Data Table", tabName = "data_table", icon = icon("table")),
                    menuItem("Histogramas", tabName = "Dashboard", icon = icon("dashboard")),
                    menuItem("Diagramas de dispersión", tabName = "graph", icon = icon("area-chart")),
                    menuItem("Incendios por año", tabName = "tiempo", icon = icon("line-chart")) #este va a ser para las series de tiempo

                    
                )
                
            ),
            
            dashboardBody(
                
                tabItems(
                    
                    # Histograma
                    tabItem(tabName = "Dashboard",
                            fluidRow(
                                titlePanel("Histograma incendios por ecorregión y tipo de suelo"), 
                                selectInput("x", "Seleccione el valor de X",
                                            choices = names(incendios)),
                                
                                box(plotOutput("plot1", width = 750)),
                            ),
                            box(
                              title = "Controls",
                              sliderInput("bins", "Number of observations:", 1, 30, 15)
                            )
                    ),
                    
                    # Dispersión
                    tabItem(tabName = "graph", 
                            fluidRow(
                                titlePanel(h3("Gráficos de dispersión")),
                                selectInput("a", "Selecciona el valor de x",
                                            choices = names(mtcars)),
                                selectInput("y", "Seleccione el valor de y",
                                            choices = names(mtcars)),
                                selectInput("z", "Selecciona la variable del grid", 
                                            choices = c("cyl", "vs", "gear", "carb")),
                                box(plotOutput("output_plot", height = 300, width = 460) )
                                
                            )
                    ),
                    
                    
                    
                    tabItem(tabName = "data_table",
                            fluidRow(        
                                titlePanel(h3("Data Table")),
                                dataTableOutput ("data_table")
                            )
                    ), 
                    
                    tabItem(tabName = "img",
                            fluidRow(
                                titlePanel(h3("Imágen de calor para la correlación de las variables")),
                                img( src = "ecorregiones.png", align = "center",
                                     width = 750),
                                img( src = "conabio_vegetacion.png", align = "center",
                                     width = 750)
                            )
                    ),
                    
                    
                    tabItem(tabName= "map",
                            fluidRow(
                              dateRangeInput("dates", label = h3("Incendios por rango de fechas"),
                                             start = "2000-11-01",
                                             end = "2019-12-31",
                                             min = NULL,
                                             max = NULL,
                                             format = "yyyy-mm-dd",
                                             startview = "month",
                                             weekstart = 0,
                                             language = "es",
                                             separator = " a "
                                             
                                             ),
                              
                              hr(),
                              fluidRow(column(4, verbatimTextOutput("value")))
                            )
                    ),
                    tabItem(tabName= "map2",
                            fluidRow(
                                
                                dateInput(
                                  inputId="fecha",
                                  label= h3("Incendios por rango de fechas"),
                                  value = "2019-06-12",
                                  min = "2000-11-01",
                                  max = "2019-12-31",
                                  format = "yyyy-mm-dd",
                                  startview = "month",
                                  weekstart = 0,
                                  language = "es",
                                  width = NULL,
                                  datesdisabled = NULL,
                                  daysofweekdisabled = NULL
                                ),
                                
                                
                              fluidRow(
                                box(width = 6,
                                    google_mapOutput(outputId = "map")
                                )
                              )
                    )
                    
                    
                )
            )
        )
    )
    )    

#De aquí en adelante es la parte que corresponde al server

server <- function(input, output) {
    library(ggplot2)
    
    #Gráfico de Histograma
    output$plot1 <- renderPlot({
        
        x <- incendios[,input$x]
        bin <- seq(min(x), max(x), length.out = input$bins + 1)
        
        ggplot(incendios, aes(x)) + 
            geom_histogram( breaks = bin) +
            labs( xlim = c(0, max(x))) + 
            theme_light() + 
            xlab(input$x) + ylab("Frecuencia")
        
        
    })
    
    # Gráficas de dispersión
    output$output_plot <- renderPlot({ 
        
        ggplot(mtcars, aes(x =  mtcars[,input$a] , y = mtcars[,input$y], 
                           colour = mtcars[,input$z] )) + 
            geom_point() +
            ylab(input$y) +
            xlab(input$a) + 
            theme_linedraw() + 
            facet_grid(input$z)  #selección del grid
        
    })   

        
    #Data Table
    output$data_table <- renderDataTable( {incendios}, 
                                          options = list(aLengthMenu = c(5,25,50),
                                                         iDisplayLength = 5)
    )

    
    # Mapa de puntos de calor... en rangos de fechas
    output$value <- renderPrint({ input$dates })    
    
    map_key <- set_key("AIzaSyDVWX-3h0oB3u8vsTWeWI9bvjVzmi2DZ1A")
    
    output$map <- renderGoogle_map({
        entrada <- input$fecha
        print(entrada)
        
        entre_fechas <- function(fecha){incendios[incendios$acq_date == fecha,]}
        entre_fechas <- entre_fechas(entrada)
        
        latitudes <- entre_fechas$latitude
        longitudes <- entre_fechas$longitudes
        
        gmap <- google_map(key = map_key,
                   location = c(23.6345,-102.5528),
                   data=entre_fechas,
                   update_map_view = TRUE,
                   zoom = 5) #%>%
            
        add_markers(gmap,lat = latitudes, lon = longitudes)
    })    
  
}


shinyApp(ui, server)