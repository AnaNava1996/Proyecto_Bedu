library(tidyverse)
annos <- as.character((2000:2019))
#ann0 <- 2000

sub1 <- "https://firms.modaps.eosdis.nasa.gov/data/country/modis/"
sub2 <- "/modis_"
sub3 <- "_Mexico.csv"


#mmm <- lapply(annos, function(x) {str_c(filename1,x,filename2,x,filename3)})
ggg <- lapply(annos, function(x) {read.table(file = str_c(sub1,x,sub2,x,sub3), header = T, sep =",")})
combined_df <- do.call("rbind", lapply(ggg, as.data.frame)) 
fileConn<-file(str_c("afgadfgadg.csv"))
write_lines(combined_df,fileConn)
rm(list=ls())

