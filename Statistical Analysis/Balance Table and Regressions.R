library(tidyverse)
library(kableExtra)
library(stargazer) 
options(scipen = 999)

# setwd("C:/Users/Griffin Ong/Documents/GitHub/Code-Samples/Statistical Analysis")

df <- read.csv("sample_data.csv")

# balance table 
balance <- df %>% 
  select("baseline_payments", 
         "baseline_elec_use", 
         "baseline_hhsize", 
         "baseline_hh_head_age"
  ) %>% 
  lapply(function(x) lm(x ~ keller_trt, data = df))

balance_table <- balance %>%
  sapply(function(x) coef(summary(x))[c(2,8)]) %>%
  t()

balance_table %>%
  kable(col.names = c("Differences in means", "p-value")) %>%
  kable_styling(position = "center", font_size = 8.5, latex_options = "hold_position")

# regression 
base_rg <- lm(endline_payments ~ keller_trt, data = df)

summary(base_rg)

stargazer(base_rg,
          type = "text",
          header = FALSE,
          title = "Treatment Impact Regression",
          column.labels = c("$Base Reg.$"),
          colnames = FALSE,
          model.numbers = FALSE,
          df = FALSE)