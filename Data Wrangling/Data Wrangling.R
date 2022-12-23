library(tidyverse)
library(styler)
library(stringr)

# setwd("C:/Users/Griffin Ong/Documents/GitHub/Code-Samples/Data Wrangling")

total_emp <- read_csv("SAEMP25N_total.csv", skip = 4)

total_emp <- filter(total_emp, GeoName != " ")

total_emp_pivot <- pivot_longer(total_emp,
  cols = `2000`:`2017`,
  names_to = "Year",
  values_to = "Total Employment"
)

##############################

industry_emp <- read_csv("SAEMP25N_by_industry.csv",
  skip = 4,
  na = c("(D)", "(T)")
)

industry_emp <- filter(industry_emp, LineCode != " ")

industry_emp <- select(
  industry_emp, "GeoFips", "GeoName", "Description",
  `2000`, `2017`
)

industry_emp_pivot <- pivot_longer(industry_emp,
  cols = `2000`:`2017`,
  names_to = "Year",
  values_to = "Employment"
)

industry_emp_wide <- pivot_wider(industry_emp_pivot,
  names_from = "Description",
  values_from = "Employment"
)

#####################

merged <- merge(industry_emp_wide, total_emp_pivot)

merged <- merged %>%
  rename("State" = GeoName) %>%
  select(-GeoFips)
