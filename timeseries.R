library(dbplyr)

fires.data <-
  read.csv('./Data_Sets/incendios_con_ecoregiones_y_tiposdesuelo.csv')

fires <-
  fires.data %>%
  select(acq_date) %>%
  group_by(acq_date) %>%
  summarize(count = n())

fires.ts <-
  ts(
    fires$count,
    start = c(2000, 11),
    end = c(2019, 12),
    frequency = 365
  )

days <-
  seq(as.Date("2000/11/1"), as.Date("2019/12/31"), "day") %>%
  data.frame(acq_date = .)

get.names <- function(df) {
  return(first(df$DESECON1))
}

to.time.serie <- function(df) {
  data <-
    df %>% full_join(days, by = "acq_date") %>% arrange(acq_date)
  data$count[is.na(data$count)] <- 0
  data$DESECON1[is.na(data$DESECON1)] <- first(data$DESECON1)
  
  return(ts(
    data$count,
    start = c(2000, 11),
    end = c(2019, 12),
    frequency = 365
  ))
}

environments <-
  fires.data %>%
  filter(DESECON1 != "") %>%
  mutate(acq_date = as.Date(acq_date)) %>%
  group_by(DESECON1, acq_date) %>%
  summarize(count = n()) %>%
  group_split(DESECON1)

environments.names <- lapply(environments, get.names)
names(environments) <- environments.names

environments.ts <- environments %>% lapply(to.time.serie)


