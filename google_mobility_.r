library(readr)
library(tidyverse)
library(tsibble)

X2020_ZA_Region_Mobility_Report <- read_csv("2020_ZA_Region_Mobility_Report.csv", 
                                            col_types = cols(sub_region_1 = col_character(), 
                                                             sub_region_2 = col_character(), metro_area = col_character(), 
                                                             iso_3166_2_code = col_character(), 
                                                             census_fips_code = col_character()))

X2021_ZA_Region_Mobility_Report <- read_csv("2021_ZA_Region_Mobility_Report.csv", 
                                            col_types = cols(sub_region_1 = col_character(), 
                                                             sub_region_2 = col_character(), metro_area = col_character(), 
                                                             iso_3166_2_code = col_character(), 
                                                             census_fips_code = col_character()))

google_mobility <- bind_rows(X2020_ZA_Region_Mobility_Report, X2021_ZA_Region_Mobility_Report) %>% 
  mutate(iso_3166_2_code = case_when(is.na(iso_3166_2_code)~ "ZA-Nat",
                                     TRUE ~ iso_3166_2_code)) %>% 
  mutate(month_year = yearmonth(date)) %>%
  group_by(iso_3166_2_code, month_year) %>% 
  summarise(google_retail_and_recreation = mean(retail_and_recreation_percent_change_from_baseline)/100,
            google_grocery_and_pharmacy = mean(grocery_and_pharmacy_percent_change_from_baseline)/100,
            google_parks = mean(parks_percent_change_from_baseline)/100,
            google_transit_and_stations = mean (transit_stations_percent_change_from_baseline)/100,
            google_workplace = mean(workplaces_percent_change_from_baseline)/100,
            google_residential = mean(residential_percent_change_from_baseline)/100) %>% 
  ungroup()