#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
url <- "https://github.com/milikest/map-of-the-food-production/raw/main/FAOSTAT_data_7-8-2022-All_Countries.zip"
download.file(url, destfile = "./data.zip")
unzip("./data.zip")

data <- read.csv("FAOSTAT_data_7-8-2022-All_Countries.csv")

select_items <- unique(data$Item)
select_years <- unique(data$Year)

# Define UI for application that creates a world map
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Food Production Analysis"),
  
  # Sidebar with food and year input
  sidebarLayout(
    sidebarPanel(
      selectInput("food_var",
                  label = "Select a Food",
                  choices = select_items),
      selectInput("year_var",
                  label = "Select a Year",
                  choices = select_years)
    ),
    
    # Show a plot of the world map
    mainPanel(
      htmlOutput("distPlot")
    )
  )
))
