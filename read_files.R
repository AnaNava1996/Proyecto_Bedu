library(dplyr)
library(stringr)

fetch.stats <- function(url) {
  print(url)
  read.csv(url, header = TRUE)
}

base.url <-
  "https://firms.modaps.eosdis.nasa.gov/data/country/modis/${year}/modis_${year}_Mexico.csv"

fire.00.19 <- as.character(2000:2019) %>%
  lapply(function(year) {
    str_interp(base.url, list(year = year))
  }) %>%
  lapply(fetch.stats)  %>%
  do.call("rbind", .) %>%
  filter(confidence >= 90)


write.csv(fire.00.19, "./Data_Sets/incendios_00_19.csv")
