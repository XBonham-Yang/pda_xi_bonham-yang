library(tidyr)
library(tidyverse)
library(janitor)
#3.1 Writing function/program to process data from an external file 
meteorite <- read_csv("data/meteorite_landings.csv")



#3.3 Writing function/program to clean data
meteorite <- meteorite %>% 
  separate(GeoLocation, c("latitude","longitude"), sep = ",") %>% 
  mutate(latitude = str_sub(latitude,2,)) %>% 
  mutate(longitude = str_sub(longitude,1, nchar(longitude)-1)) %>% 
  mutate(latitude = as.numeric(latitude),
         longitude = as.numeric(longitude))

summary(meteorite)
#3.4 Writing function/program to wrangle data
meteorite <-meteorite %>% 
  mutate(latitude = coalesce(latitude, 0)) %>% 
  mutate(longitude=coalesce(longitude,0))

summary(meteorite)

meteorite <- meteorite %>% 
  filter(mass_g >= 1000) %>% 
  arrange(year)

