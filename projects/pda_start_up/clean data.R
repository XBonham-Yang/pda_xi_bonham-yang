library(tidyr)
library(tidyverse)
library(janitor)
library(assertr)
#3.1 Writing function/program to process data from an external file 
meteorite <- read_csv("data/meteorite_landings.csv")

#The data has the variable names we expect (“id”, “name”, “mass (g)”, “fall”, “year”, “GeoLocation”).
verify(meteorite, (names(meteorite) %in% c("id","name", "mass (g)", "fall", "year", "GeoLocation")))
#I checked names here to make sure it's the correct data 
#I didn't check the other two var as they will be seperated out later 
#It will be easiler to check them then. 



#3.3 Writing function/program to clean data
#3.4 Writing function/program to wrangle data
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
  clean_names() %>% 
  filter(mass_g >= 1000) %>% 
  arrange(year)
#I did clean name here as the code doesn't like mass(g) or `mass(g)`
#I don't know what else I can try... 


#Check Latitude and longitude are valid values. (Latitude between -90 and 90, longitude between -180 and 180).
verify(meteorite, meteorite$latitude >= -90 & meteorite$latitude <= 90)
verify(meteorite, meteorite$longitude >= -180 & meteorite$longitude <= 180)

#one thing doesn't meet the requirement..

meteorite <- meteorite %>% 
  filter(latitude >= -90 & latitude<= 90) %>% 
  filter(longitude>= -180 & longitude <= 180)

verify(meteorite, meteorite$latitude >= -90 & meteorite$latitude <= 90)
verify(meteorite, meteorite$longitude >= -180 & meteorite$longitude <= 180)
#Now all good 

meteorite_cleaned <- write_csv(meteorite,'meteorite_cleaned.csv')
