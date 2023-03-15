library(tidyverse)
library(sf)
library(rnaturalearth)
library(spData)
library(scales)

# setwd("C:/Users/Griffin Ong/Documents/GitHub/Code-Samples/Plotting")

df_clean <- read.csv("df_clean.csv")

# zip codes shapefile
zip_shape <- st_read("ZIP_CODE_040114.shp")
zip_shape <- st_transform(zip_shape, 4326)

# match data types to join clean data with shapefile
df_clean$zip_code <- as.character(df_clean$zip_code)
df_clean_merged <- inner_join(zip_shape, df_clean,
  by = c("ZIPCODE" = "zip_code")
)

# filter to Black population only - this was part of our original research 
# question to determine whether predominantly Black neighborhoods had less home 
# broadband adoption
df_clean_merged <- df_clean_merged %>%
  filter(Demographic == "black_non_hispanic")

# chloropleth of no home broadband adoption
ggplot() +
  geom_sf(data = zip_shape) +
  geom_sf(data = df_clean_merged, aes(fill = no_home_broadband_adoption)) +
  labs(
    title = "Proportion of Homes without Broadband Access by ZIP Code",
    caption = "Source: NYC Open Data",
    fill = "Proportion of Homes without Broadband"
  ) +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_gradient(low = "darkolivegreen1", high = "darkgreen") +
  theme_void()
