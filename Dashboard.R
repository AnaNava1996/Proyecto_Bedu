## app.R ##

## Dash board para el data set 'mtcars'

if (!require("shiny")) install.packages("shiny")
if (!require("shinydashboard")) install.packages("shinydashboard")
if (!require("shinythemes")) install.packages("shinythemes")

library(shiny)
library(shinydashboard)
library(shinythemes)

incendios<-read.csv("./Data_Sets/incendios_en_regiones.csv")



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
                    menuItem("Histograma", tabName = "Dashboard", icon = icon("dashboard")),
                    menuItem("Dispersión", tabName = "graph", icon = icon("area-chart")),
                    menuItem("Data Table", tabName = "data_table", icon = icon("table")),
                    menuItem("Mapas", tabName = "img", icon = icon("map")),
                    menuItem("Mapa de Calor", tabName = "map", icon = icon("map-marker"))
                )
                
            ),
            
            dashboardBody(
                
                tabItems(
                    
                    # Histograma
                    tabItem(tabName = "Dashboard",
                            fluidRow(
                                titlePanel("Histograma de las variables del data set mtcars"), 
                                selectInput("x", "Seleccione el valor de X",
                                            choices = names(mtcars)),
                                
                                #selectInput("zz", "Selecciona la variable del grid", 
                                            
                                #            choices = c("cyl", "vs", "gear", "carb")),
                                #box(plotOutput("plot1", height = 250)),
                                
                                box(
                                    title = "Controls",
                                    sliderInput("bins", "Number of observations:", 1, 30, 15)
                                )
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
                              dateRangeInput("dates", label = h3("Incendios por rango de fechas")),
                              
                              hr(),
                              fluidRow(column(4, verbatimTextOutput("value")))
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
        
        x <- mtcars[,input$x]
        bin <- seq(min(x), max(x), length.out = input$bins + 1)
        
        ggplot(mtcars, aes(x, fill = mtcars[,input$zz])) + 
            geom_histogram( breaks = bin) +
            labs( xlim = c(0, max(x))) + 
            theme_light() + 
            xlab(input$x) + ylab("Frecuencia") + 
            facet_grid(input$zz)
        
        
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
    
  
    
}


shinyApp(ui, server)