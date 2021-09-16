library(tidyverse)
library(tsibble)
library(fable)
library(feasts)
library(patchwork)


##prepare crime data
crime_quarterly_consolidated <- readRDS("crime_stats_2020_1Q_4Q_2021_1Q.rds") %>% 
  distinct(month_year, station, crime_category, .keep_all = TRUE)

## remove data from prior to 2016.
crime_2016_2021 <- filter(crime_quarterly_consolidated,
                          as.Date(yearmonth(month_year))> "2015-12-31" ) %>% 
  mutate(month_year = yearmonth(month_year))

### overall crime za totals by base category
crime_2016_2021_summary_za <- filter(crime_2016_2021, include_in_totals == TRUE) %>% 
  group_by(month_year, contact_crime ) %>% 
  summarise(crimes_reported = sum(count_crimes_reported)) %>% 
  mutate(`Crime type` =case_when( !(contact_crime) ~ "Non-contact",
                                  TRUE ~ "Contact"))
## filter to contact crime only
contact_crime_2016_2021_summary_za  <- filter(crime_2016_2021, include_in_totals == TRUE & contact_crime == TRUE) %>% 
  group_by(month_year, crime_category ) %>% 
  summarise(crimes_reported = sum(count_crimes_reported), contact_crime) %>% 
  mutate(`Crime category` = crime_category) %>% 
  distinct()

##create time series
contact_crimes_tsibble_za <- contact_crime_2016_2021_summary_za %>% 
  group_by(month_year) %>% 
  summarise(contact_crimes_reported = sum(crimes_reported)) %>%
  as_tsibble()


### fit model ro 2016-2019 data
contact_crimes_za_fitted <- filter(contact_crimes_tsibble_za, as.Date(month_year) < "2020-01-01") %>% 
  model(auto_ets = ETS(contact_crimes_reported))

##forecast for 2020-21
forecast_contact_crimes_za <- contact_crimes_za_fitted%>% 
  forecast(h = "18 months") 

#create tsibble
forecast_contact <- forecast_contact_crimes_za[,c("month_year", ".mean")] %>% 
  rename(prediction = `.mean`) %>% 
  mutate(prediction = as.integer(prediction))

##join with restrictions
source("restrictions_2.R")
contact_crimes_excess <- left_join(
  filter(contact_crimes_tsibble_za, as.Date(month_year) > "2019-12-31"),
  forecast_contact, by = "month_year") %>% 
  mutate(excess = contact_crimes_reported - prediction) %>% 
  left_join(restrictions_2020, by = "month_year")

## Add upper/lower bounds
for (x in 1:18){
  contact_crimes_excess[x,"sigma"] <- forecast_contact_crimes_za[[3]][[x]][["sigma"]]
}
contact_crimes_excess <- contact_crimes_excess %>% 
  mutate(upper = as.integer(prediction - sigma),
         lower = as.integer(prediction + sigma),
         excess_upper_bound = contact_crimes_reported - upper,
         excess_lower_bound = contact_crimes_reported - lower)

#avoid scientific notation
options(scipen = 9)  
