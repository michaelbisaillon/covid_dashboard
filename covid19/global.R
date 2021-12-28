library(shiny)
library(tidyverse)
library(sf)
library(ggplot2)
library(lubridate)
library(COVID19)
library(janitor)
library(DT)
library(sf)
library(leaflet)
library(bslib)
library(scales)

options(scipen = "999")

base_1 <- covid19(level = 2)

base <- base_1 %>% 
  select(-id, -vent, -iso_alpha_3, -iso_alpha_2, -iso_numeric, -iso_currency, -key_local, -key_google_mobility, 
         -key_apple_mobility, -key_jhu_csse, -key_nuts, -key_gadm) %>% 
  group_by(administrative_area_level_2) %>% 
  mutate(confirmed_last = lag(confirmed)) %>% 
  ungroup() %>% 
  mutate(cases = confirmed - confirmed_last) %>% 
  st_as_sf(coords = c(lng = "longitude", lat = "latitude"), crs = "4326")



names(base)


#summary_data <- data.frame(Mesure = unclass(summary(base)), check.names = FALSE, stringsAsFactors = FALSE) %>% select(1) %>% 
 # remove_rownames()




