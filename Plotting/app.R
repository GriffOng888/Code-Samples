library(shiny)
library(tidyverse)
library(sf)
library(rnaturalearth)
library(spData)
library(scales)
library(rsconnect)
library(plotly)

# setwd("C:/Users/Griffin Ong/Documents/GitHub/Code-Samples/Plotting")

ui <- fluidPage(
  fluidRow(column(width = 12,
                  tags$h2("NYC Broadband by ZIP Code",
                          align = "center"),
                  tags$hr())),
 
  fluidRow(column(width = 8,
                  offset = 2,
                  align = "center",
  sliderInput(inputId = "number", 
              label = "Filter ZIP Codes with > n% No Home Broadband Access",
              value = 25, min = 0, max = 50),
  plotlyOutput("plot"))
  )
)

server <- function(input, output){
  # import and transform shape files
  zip_shape <- st_read("ZIP_CODE_040114.shp")
  zip_shape <- st_transform(zip_shape, 4326)
  
  # join shapefile back to cleaned data
  df_clean <- read.csv("df_clean.csv")
  df_clean$zip_code <- as.character(df_clean$zip_code)
  
  df_clean_merged <- inner_join(zip_shape, df_clean,
                                by = c("ZIPCODE" = "zip_code"),
                                multiple = "all")
  
  df_clean_merged <- df_clean_merged %>%
    filter(Demographic == "black_non_hispanic")
  
  # create data reactive functions for filtering in final app 
  broadband_data <- reactive({
    df_clean_merged %>% filter(no_home_broadband_adoption * 100 >= input$number)
  })
  
  # Output layers on major streets shapefile if needed   
  output$plot <- renderPlotly({
    plt <- ggplot() + geom_sf(data = zip_shape) +
      geom_sf(data = broadband_data(), aes(fill = no_home_broadband_adoption * 100)) +
      labs(title = "No Home Broadband Access by NYC ZIP Codes",
           caption = "Source: NYC Open Data",
           fill = 'Total Percent (%)') + 
      theme(plot.title = element_text(hjust = 0.5)) + 
      scale_fill_gradient(low = "light blue", high = "blue")
    ggplotly(plt)
  })
}

shinyApp(ui = ui, server = server)
