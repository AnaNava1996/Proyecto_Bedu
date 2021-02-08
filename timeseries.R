library(dbplyr)

fires <-
  read.csv('./Data_Sets/incendios_con_ecoregiones_y_tiposdesuelo.csv') %>%
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

plot(fires.ts)
