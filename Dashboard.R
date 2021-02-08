library(shiny)
library(shinydashboard)
library(shinythemes)
library(googleway)
library(ggplot2)
library(dplyr)
library(lubridate)
library(stringr)

incendios <- 
  read.csv("./Data_Sets/incendios_con_ecoregiones_y_tiposdesuelo.csv") %>%
  filter(DESECON1!="",GRUPO_FINA!="") %>% 
  mutate(
    date_acq = ymd(acq_date),
    time_acq = hm(acq_time),
    year = year(date_acq),
    moy = month(date_acq)
  )

by_ecoregion <- 
  incendios %>% 
  group_by(date_acq, DESECON1) %>% 
  summarise(count = n()) %>% 
  mutate(doy = yday(date_acq))

by_tiposuelo <- 
  incendios %>% 
  group_by(date_acq, GRUPO_FINA) %>% 
  summarise(count = n()) %>% 
  mutate(doy = yday(date_acq))

dashboard <- 
  tabItem(
    tabName = "Dashboard",
    fluidRow(
      titlePanel("Histograma incendios por ecorregión y tipo de suelo"),
      selectInput("x", "Seleccione el valor de X", choices = names(incendios)),
      box(plotOutput("plot1", width = 750)),
    ),
    box(
      title = "Controls",
      sliderInput("bins", "Número de observaciones:", 1, 30, 15)
    )
  )

graph <- 
  tabItem(
    tabName = "graph",
    fluidRow(
      titlePanel(h3("Gráficos de dispersión")),
      selectInput("a", "Selecciona el valor de x", choices = names(mtcars)),
      selectInput("y", "Seleccione el valor de y", choices = names(mtcars)),
      selectInput("z", "Selecciona la variable del grid", choices = c("cyl", "vs", "gear", "carb")),
      box(plotOutput("output_plot", height = 300, width = 460))
    )
  )

data.table <- 
  tabItem(
    tabName = "data_table",
    fluidRow(titlePanel(h3("Data Table")),
    dataTableOutput ("data_table"))
  )

img <- 
  tabItem(
    tabName = "img",
    fluidRow(
      titlePanel(h3("Imágen de calor para la correlación de las variables")),
      img(src = "ecorregiones.png", align = "center", width = 750),
      img(src = "conabio_vegetacion.png", align = "center", width = 750)
    )
  )

map <- 
  tabItem(
    tabName = "map",
    fluidRow(
      dateRangeInput(
        "dates",
        label = h3("Incendios por rango de fechas"),
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
  )

map2 <- 
  tabItem(
    tabName = "map2",
    fluidRow(
      dateInput(
        inputId = "fecha",
        label = h3("Incendios por rango de fechas"),
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
      fluidRow(box(width = 6,google_mapOutput(outputId = "map")))
    )
  )

ecoregion <- 
  tabItem(
    tabName = "ecoregion",
    fluidRow(
      selectInput('rowName1', 'Seleccione eco-región:', distinct_at(incendios, vars(DESECON1))),
      plotOutput("interannual_ecoreg_plot"),
      plotOutput("intrannual_ecoreg_plot")
    )
  )

tipodesuelo <- 
  tabItem(
    tabName = "tipodesuelo",
    fluidRow(
      selectInput('rowName2', 'Seleccione tipo/uso de suelo:', distinct_at(incendios, vars(GRUPO_FINA))),
      plotOutput("interannual_tiposuelo_plot"),
      plotOutput("intrannual_tiposuelo_plot")
    )
  )

ui <-
  fluidPage(
    dashboardPage(
      skin = "purple",
      dashboardHeader(title = "Proyecto, análisis de incendios en México", titleWidth = 450),
      dashboardSidebar(
        width = 350,
        sidebarMenu(
          menuItem("Mapa de incendios", tabName = "map2", icon = icon("map-marker")),
          menuItem("Ecorregiones y uso de suelo", tabName = "img", icon = icon("map")),
          menuItem("Data Table", tabName = "data_table", icon = icon("table")),
          menuItem("Histogramas", tabName = "Dashboard", icon = icon("dashboard")),
          menuItem("Diagramas de dispersión", tabName = "graph", icon = icon("area-chart")),
          menuItem("Incendios por año", tabName = "tiempo", icon = icon("line-chart")),
          menuItem("Incendios por eco-región", tabName = "ecoregion", icon = icon("line-chart")), 
          menuItem("Incendios por tipo/uso de suelo", tabName = "tipodesuelo", icon = icon("line-chart")) 
        )
      ),
      dashboardBody(
        tabItems(
          dashboard,
          graph,
          data.table,
          img,
          map,
          map2,
          ecoregion,
          tipodesuelo
        )
      )
    )
  )

server <- function(input, output) {
  library(ggplot2)
  
  #Gráfico de Histograma
  output$plot1 <- renderPlot({
    x <- incendios[, input$x]
    bin <- seq(min(x), max(x), length.out = input$bins + 1)
    
    ggplot(incendios, aes(x)) +
      geom_histogram(breaks = bin) +
      labs(xlim = c(0, max(x))) +
      theme_light() +
      xlab(input$x) + ylab("Frecuencia")
  })
  
  output$interannual_ecoreg_plot <- renderPlot({ 
    by_ecoregion %>% 
    filter(DESECON1 == input$rowName1) %>%
    ggplot() +
      aes(x = "date_acq", y = "count") +
      geom_smooth() +
      # scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
      coord_cartesian(ylim = c(0, 30)) +
      labs(
        title = str_c("Incendios por eco-región en México 2000-2019"),
        subtitle = input$rowName1,
        x = "año",
        y = "número de incendios"
      )
  })

  output$intrannual_ecoreg_plot <- renderPlot({ 
    by_ecoregion %>%
    filter(DESECON1 == input$rowName1) %>%
    ggplot() +
      aes(x = "doy", y = "count") +
      geom_smooth() +
      coord_cartesian(ylim=c(0, 45)) +
      labs(
        title = str_c("Incendios por eco-región en México acumulados por día del año"),
        subtitle = input$rowName1,
        x = "día del año",
        y = "número de incendios"
      )
  })

  output$interannual_tiposuelo_plot <- renderPlot({ 
    by_tiposuelo %>%
    filter(GRUPO_FINA == input$rowName2) %>%
    ggplot() +
      aes(x = "date_acq", y = "count") +
      geom_smooth() +
      # scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
      coord_cartesian(ylim=c(0, 30)) +
      labs(
        title = str_c("Incendios por tipo/uso de suelo en México 2000-2019"),
        subtitle = input$rowName2,
        x = "año",
        y = "número de incendios"
      )
    
  })

  output$intrannual_tiposuelo_plot <- renderPlot({ 
    by_tiposuelo %>%
    filter(GRUPO_FINA == input$rowName2) %>%
    ggplot() +
      aes(x = "doy", y = "count") +
      geom_smooth() +
      labs(
        title = str_c("Incendios por tipo/uso de suelo en México acumulados por día del año"),
        subtitle = input$rowName2,
        x = "día del año",
        y = "número de incendios"
      )
  })

  # Gráficas de dispersión
  output$output_plot <- renderPlot({
    ggplot(mtcars, aes(
      x =  mtcars[, input$a],
      y = mtcars[, input$y],
      colour = mtcars[, input$z]
    )) +
      geom_point() +
      ylab(input$y) +
      xlab(input$a) +
      theme_linedraw() +
      facet_grid(input$z)
  })
  
  #Data Table
  output$data_table <- renderDataTable({
    incendios
  },
  options = list(
    aLengthMenu = c(5, 25, 50),
    iDisplayLength = 5
  ))
  
  # Mapa de puntos de calor... en rangos de fechas
  output$value <- renderPrint({
    input$dates
  })
  
  map_key <- set_key("AIzaSyDVWX-3h0oB3u8vsTWeWI9bvjVzmi2DZ1A")
  output$map <- renderGoogle_map({
    entre_fechas <- incendios[incendios$acq_date == input$fecha, ]
    latitudes <- entre_fechas$latitude
    longitudes <- entre_fechas$longitudes
    
    google_map(
      key = map_key,
      location = c(23.6345, -102.5528),
      data = entre_fechas,
      update_map_view = TRUE,
      zoom = 5
    ) %>% add_markers(lat = latitudes, lon = longitudes)
  })
  
}

shinyApp(ui, server)