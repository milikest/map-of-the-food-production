# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(DT)

url <- "https://github.com/milikest/map-of-the-food-production/raw/main/FAOSTAT_data_7-8-2022-All_Countries.zip"
download.file(url, destfile = "./data.zip")
unzip("./data.zip")

data <- read.csv("FAOSTAT_data_7-8-2022-All_Countries.csv")
data$Area[data$Area=="TÃ¼rkiye" | data$Area=="Türkiye"] <- "Turkey"
data$Area[data$Area=="Bahamas"] <- "The Bahamas"
data$Area[data$Area=="Bolivia (Plurinational State of)"] <- "Bolivia"
data$Area[data$Area=="Brunei Darussalam"] <- "Brunei"
data$Area[data$Area=="Cabo Verde"] <- "Cape Verde"
data$Area[data$Area=="Congo"] <- "Republic of the Congo"
data$Area[data$Area=="CÃ´te d'Ivoire"] <- "Cote d'Ivoire"
data$Area[data$Area=="Democratic People's Republic of Korea"] <- "North Korea"
data$Area[data$Area=="Republic of Korea"] <- "South Korea"
data$Area[data$Area=="Gambia"] <- "The Gambia"
data$Area[data$Area=="Lao People's Democratic Republic"] <- "Laos"
data$Area[data$Area=="Micronesia (Federated States of)"] <- "Federated States of Micronesia"  
data$Area[data$Area=="Myanmar"] <- "Myanmar (Burma)"
data$Area[data$Area=="Republic of Moldova"] <- "Moldova"
data$Area[data$Area=="Russian Federation"] <- "Russia"
data$Area[data$Area=="United Kingdom of Great Britain and Northern Ireland"] <- "United Kingdom" 
data$Area[data$Area=="United Republic of Tanzania"] <- "Tanzania"
data$Area[data$Area=="United States of America"] <- "United States"
data$Area[data$Area=="Venezuela (Bolivarian Republic of)"] <- "Venezuela"
data$Area[data$Area=="Viet nam"] <- "Vietnam"
data[is.na(data)] = 0
colnames(data)[4] <- "Country"
colnames(data)[12] <- "Tonnes"

# First Panel Variables
select_items <- unique(data$Item)[order(unique(data$Item))]
select_years <- unique(data$Year)

#Second Panel Variables
select_countries <- unique(data$Country)[order(unique(data$Country))]

# Define UI for application that creates a world map
shinyUI(fluidPage(
  tabsetPanel(
    tabPanel("Map Of Production",
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
                             choices = select_years),
                 h3("Top Producer Countries:"),
                 dataTableOutput("toptable")
               ),
               
               # Show a plot of the world map
               mainPanel(
                 htmlOutput("distPlot")
               )
             )
    ),
    tabPanel("Country Lookup",
             titlePanel("Food Production By Countries"),
             sidebarLayout(
               sidebarPanel(
                 selectInput("country_var",
                             label = "Select a Country",
                             choices = select_countries),
                 selectInput("year_var2",
                             label = "Select a Year",
                             choices = select_years)
                 
               ),
               mainPanel(
                 h3("Top 10 Food Production"),
                 plotlyOutput(outputId = "p"),
                 h3("Top 10 Ranks of Food Production"),
                 dataTableOutput("toprank")
                 
               )
             )
    )
  )
))
