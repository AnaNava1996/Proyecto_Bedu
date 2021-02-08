#librerias necesarias
if (!require("tidyverse"))
  install.packages("tidyverse")

if (!require("lubridate"))
  install.packages("lubridate")

library(tidyverse)
library(lubridate)

# cargamos datos
# aqui utilice el CSV 'chico' pq sufre mi compu jejej
df <- read.csv("incendios_en_regiones.csv", header = TRUE) %>%
  # hasta aqui, acq_date y acq_time son char,hay q volverlos date y time
  mutate(date_acq = ymd(acq_date), time_acq = hm(str_c(
    str_sub(acq_time, 1,-3), ":", str_sub(acq_time,-2,-1)
  ))) %>%
  #quitamos puntos que no cayeron en ninguna ecorregion
  # (son poquitos como 150) :
  filter(DESECON1 != "") %>%
  select(date_acq, time_acq, confidence, daynight, DESECON1)

# checamos tipo de dato de columnas
str(df)

#agrupamos por ecorregion y fecha
red_time <- df %>% group_by(date_acq, DESECON1) %>%
  # contamos los puntos q ocurrieron en misma fecha misma ecorregion
  summarise(c0unt = n()) %>%
  # agregamos columnas d anno, mes y dia del anno p analisis intra-anual
  mutate(
    year = year(date_acq),
    moy = month(date_acq),
    doy = yday(date_acq)
  )

# visualizacion inter-anual
ggplot(red_time, aes(x = `date_acq`, y = `c0unt`, color = `DESECON1`)) +
  geom_smooth() +
  # le quite la simbologia pq se comprimia mucho la grafica
  # debe haber alguna forma de ajustar mejor eso sin quitarla
  theme(legend.position = "none")

#visualizacion intra-anual
ggplot(red_time, aes(x = `doy`, y = `c0unt`, color = `DESECON1`)) +
  geom_smooth() +
  theme(legend.position = "none")

# intento d graficar tipo serie de tiempo para 1 ecorregion
# no me sale :S
t3mp <- red_time %>%
  filter(DESECON1 == "Grandes Planicies")
lines(t3mp$date_acq, t3mp$c0unt)
plot(t3mp$date_acq, t3mp$c0unt)