# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tibble)
library(googleVis)

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

# Server function
shinyServer(function(input, output) {
  output$distPlot <- renderGvis({
    gvisGeoChart(filter(data, Year == input$year_var, Item == input$food_var), locationvar = 'Area', colorvar = 'Value',
                 options = list(projection ="kavrayskiy-vii",width=900,height=1000))
  })
  
})
