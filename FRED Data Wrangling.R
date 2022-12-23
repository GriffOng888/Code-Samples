library(tidyverse)
library(fredr)
library(stringr)
options(scipen = 999)

fredr_set_key("cf83c745940a2b4622a6510d91372ab8")

start <- as.Date("2020-01-01")
end <- as.Date("2021-01-01")

states_data = list()
for (st in state.abb) {
  series_name <- paste0(st, "NGSP")
  states_data[[st]] <- fredr(series_id = series_name,
                             observation_start = start,
                             observation_end   = end)
}

gdp_df <- bind_rows(states_data) 
gdp_df <- gdp_df %>% 
  select(-realtime_start, -realtime_end) %>% 
  rename(state = series_id, 
         GDP = value, 
         year = date) 

gdp_df$state <- substr(gdp_df$state, 1, 2)
gdp_df$year <- as.numeric(substr(gdp_df$year, 1, 4))
