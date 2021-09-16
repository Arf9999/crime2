library(tidyverse)
library(tsibble)
library(hms)
library(lubridate)

#function to create character vector of dates within a period.
itemizeDates <- function(startDate, endDate, 
                         format="%y-%m-%d") {
  out <- seq(as.Date(startDate, format=format), 
             as.Date(endDate, format=format), by="days")  
  format(out, format)
}

restrictions_2020 <- tibble::tribble(
                             ~start,         ~end, ~Level, ~Curfew.hours, ~`Alcohol.off-premise`, ~off_premise_days, ~off_premise_hours.allowed,   ~`Alcohol.on-premise`, ~on_premise_days, ~on_premise_hours, ~Cigarette.ban.index,
                       "2020-01-01", "2020-01-31",     0L,            0L,         "unrestricted",                6L,                        10L,          "unrestricted",               7L,               12L,                   0L,
                       "2020-02-01", "2020-02-29",     0L,            0L,         "unrestricted",                6L,                        10L,          "unrestricted",               7L,              12L,                   0L,
                       "2020-03-01", "2020-03-25",     0L,            0L,         "unrestricted",                6L,                        10L,          "unrestricted",               7L,               12L,                   0L,
                       "2020-03-26", "2020-03-31",     5L,           24L,               "banned",                0L,                         0L,                "banned",               0L,                0L,                   1L,
                       "2020-04-01", "2020-04-30",     5L,           24L,               "banned",                0L,                         0L,                "banned",               0L,                0L,                   1L,
                       "2020-05-01", "2020-05-31",     4L,            9L,               "banned",                0L,                         0L,                "banned",               0L,                0L,                   1L,
                       "2020-06-01", "2020-06-30",     3L,            0L,        "mon-thurs 9-5",                4L,                         8L,                "banned",               0L,                0L,                   1L,
                       "2020-07-01", "2020-07-11",     3L,            0L,        "mon-thurs 9-5",                4L,                         8L,                "banned",               0L,                0L,                   1L,
                       "2020-07-12", "2020-07-31",     3L,            6L,               "banned",                0L,                         0L,                "banned",               0L,                0L,                   1L,
                       "2020-08-01", "2020-08-17",     3L,            6L,               "banned",                0L,                         0L,                "banned",               0L,                0L,                   1L,
                       "2020-08-18", "2020-08-31",     2L,            6L,  "mon-thu 09h00-17h00",                4L,                         8L, "allowed 09h00 - 21h00",               7L,               9L,                   0L,
                       "2020-09-01", "2020-09-19",     2L,            6L,  "mon-thu 09h00-17h00",                4L,                         8L, "allowed 09h00 - 21h00",               7L,               9L,                   0L,
                       "2020-09-20", "2020-09-30",     1L,            4L,  "mon-fri 09h00-17h00",                5L,                         8L, "allowed 09h00 - 23h00",               7L,               10L,                   0L,
                       "2020-10-01", "2020-10-31",     1L,            4L,  "mon-fri 09h00-17h00",                5L,                         8L, "allowed 09h00 - 23h00",               7L,               10L,                   0L,
                       "2020-11-01", "2020-11-30",     1L,            4L,  "mon-fri 09h00-17h00",                5L,                         8L, "allowed 09h00 - 23h00",               7L,               10L,                   0L,
                       "2020-12-01", "2020-12-29",     1L,            4L,  "mon-fri 09h00-17h00",                5L,                         8L, "allowed 09h00 - 23h00",               7L,               10L,                   0L,
                       "2020-12-29", "2020-12-31",     3L,            5L,               "banned",                0L,                         0L,                "banned",               0L,                0L,                   0L,
                       "2021-01-01", "2021-01-31",     3L,            5L,               "banned",                0L,                         0L,                "banned",               0L,                0L,                   0L,
                       "2021-02-01", "2021-02-28",     1L,            4L,  "mon-fri 10h00-18h00",                5L,                         8L, "allowed 10h00 - 22h00",               7L,               9L,                   0L,
                       "2021-03-01", "2021-03-31",     1L,            4L,  "mon-sat 10h00-18h00",                6L,                         8L, "allowed 10h00 - 23h00",               7L,               10L,                   0L,
                       "2021-04-01", "2021-04-30",     1L,            4L,  "mon-sat 10h00-18h00",                6L,                         8L, "allowed 10h00 - 23h00",               7L,                10L,                   0L,
                       "2021-05-01", "2021-05-31",     1L,            4L,  "mon-sat 10h00-18h00",                6L,                         8L, "allowed 10h00 - 23h00",               7L,                10L,                   0L,
                       "2021-06-01", "2021-06-14",     1L,            4L,  "mon-sat 10h00-18h00",                6L,                         8L, "allowed 10h00 - 23h00",               7L,               10L,                   0L,
                       "2021-06-15", "2021-06-27",     3L,            6L,  "mon-thu 10h00-18h00",                4L,                         8L, "allowed 10h00 - 21h00",               7L,               8L,                   0L,
                       "2021-06-28", "2021-06-30",     4L,            7L,               "banned",                0L,                         0L,                "banned",               0L,                0L,                   0L
                       ) %>% 
  janitor::clean_names("snake") %>% 
  mutate(start_ = lubridate::ymd(start),
         end_ = lubridate::ymd(end)
         ) %>% 
  rowwise() %>% 
  mutate(start_end = (list(wday(itemizeDates(startDate = start_, endDate = end_)))),
         off_premise_permitted_index = 
           (length(which(start_end <= off_premise_days))*off_premise_hours_allowed) / (length(which(start_end <= 6))*10),
         on_premise_permitted_index = 
           (length(which(start_end <= on_premise_days))*on_premise_hours)/ (length(start_end)*12),
         alcohol_restriction_index = (1-(off_premise_permitted_index*0.499) - (on_premise_permitted_index *0.501))) %>% 
  rowwise() %>% 
  mutate(month_year = yearmonth(start),
         period = length(start_end), 
         proportion_of_month = period/as.numeric(days_in_month(start)),
         alco_index_proportion = alcohol_restriction_index * proportion_of_month,
         alco_off_sale_index = (1- off_premise_permitted_index) * proportion_of_month,
         alco_on_premise_index = (1- on_premise_permitted_index) * proportion_of_month,
         restriction_level = level*proportion_of_month) %>%
  mutate(curfew_severity = proportion_of_month * curfew_hours/24 ) %>% 
  group_by(month_year) %>%
  arrange(month_year) %>% 
  summarise(alco_index = sum(alco_index_proportion),
            alco_on_premise_index = sum(alco_on_premise_index),
            alco_off_sale_index = sum(alco_off_sale_index),
            curfew_index = sum(curfew_severity),
            mean_restriction_level = sum(restriction_level)) %>%
  ungroup() %>% 
  arrange(month_year) %>% 
  mutate( delta_alco = alco_index - dplyr::lag(alco_index,1)) %>%
  as_tsibble()

restrictions2019 <- read_csv("~/restrictions2019.csv")%>%
  mutate(month_year = yearmonth(month_year)) %>% 
  as_tsibble()
  
  
         
  
  
            
            
         

                      
  


         
