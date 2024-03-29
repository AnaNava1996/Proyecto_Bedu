library(shiny)
library(shinydashboard)
library(shinythemes)
library(googleway)
library(ggplot2)
library(dplyr)
library(lubridate)
library(stringr)

incendios <- 
  read.csv("./Data_Sets/incendios_con_ecoregiones_y_tiposdesuelo.csv", row.names = NULL) %>%
  filter(DESECON1 != "", GRUPO_FINA != "") %>% 
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
      titlePanel("Cantidad de Incendios por Ecorregión y Tipo de Suelo"),
      mainPanel(plotOutput("plot1"))
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
      titlePanel(h3("Localizacion de eco-regiones y tipos de suelo")),
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
          menuItem("Incendios por Regiones", tabName = "Dashboard", icon = icon("dashboard")),
          menuItem("Incendios por eco-región", tabName = "ecoregion", icon = icon("line-chart")), 
          menuItem("Incendios por tipo/uso de suelo", tabName = "tipodesuelo", icon = icon("line-chart")) 
        )
      ),
      dashboardBody(
        tabItems(
          dashboard,
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
    mapping <- list(
      "Regiones" = "GRUPO_FINA",
      "Tipo de suelo" = "DESECON1"
    )
    
    incendios %>%
      ggplot() +
      aes(x = GRUPO_FINA, fill = DESECON1) +
      geom_bar() +
      theme_light() +
      xlab("Regiones") +
      ylab("Frecuencia") +
      labs(fill = "Ecorregiones") +
      theme(axis.text.x = element_text(angle = 90))
  })
  
  output$interannual_ecoreg_plot <- renderPlot({ 
    #by_ecoregion %>% 
    #filter(DESECON1 == input$rowName1) %>%
    ggplot(filter(by_ecoregion,DESECON1 == input$rowName1)) +
      aes(x = date_acq, y = count) +
      geom_smooth() +
      # scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
      #coord_cartesian(ylim = c(0, 30)) +
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
      aes(x = doy, y = count) +
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
      aes(x = date_acq, y = count) +
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
      aes(x = doy, y = count) +
      geom_smooth() +
      labs(
        title = str_c("Incendios por tipo/uso de suelo en México acumulados por día del año"),
        subtitle = input$rowName2,
        x = "día del año",
        y = "número de incendios"
      )
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