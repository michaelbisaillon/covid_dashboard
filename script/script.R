library(COVID19)
library(tidyverse)
library(leaflet)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(gganimate)
library(ggmap)
library(lubridate)
library(gifski)
library(skimr)
library(DataExplorer)
library(janitor)





#database
x <- covid19(level = 2)
head(x)

base <- x %>% 
  filter(administrative_area_level_1 == "Canada") 



#EDA 
str(base, 10)

summary(base)

skim(base)

#create_report(base)

base_2 <- base %>% remove_empty(c("cols", "rows"))

names(base)

#manque la correlation et le pca car insufficient incomplete rows
base_2 <- base %>%
  remove_empty(c("cols", "rows")) %>% 
  filter(!date > "2021-10-01")
  select(administrative_area_level_2, date, confirmed, deaths, tests, population, government_response_index, elderly_people_protection)

create_report(base_2)

write_rds(base_2, "data/canada_covid19.RDS")



