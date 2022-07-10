# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Data has been gathered from https://www.fao.org/faostat/en/#data/QCL
# From the source  All Countries, Production Quantity, Crops Primary>(List) and Crops Processed>List, All years are selected. 
library(shiny)
library(dplyr)
library(tibble)
library(googleVis)
library(plotly)
library(DT)

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


# Server function
shinyServer(function(input, output) {
  output$distPlot <- renderGvis({
    gvisGeoChart(filter(data, Year == input$year_var, Item == input$food_var), locationvar = 'Country', colorvar = 'Tonnes',
                 options = list(projection ="kavrayskiy-vii",width=900,height=1000))
  })
  output$toptable <- renderDataTable({
    filter(data, Year == input$year_var, Item == input$food_var)[,c(4,12)][order(filter(data, Year == input$year_var, Item == input$food_var)$Tonnes, decreasing = T),][1:10,]
  })
  
  output$p <- renderPlotly({
    plot_ly(x = filter(data, Country==input$country_var, Year==input$year_var2)[c(8,12)][order(filter(data, Country==input$country_var, Year==input$year_var2)[,c(12)], decreasing = T),]$Item[1:10],
            y = filter(data, Country==input$country_var, Year==input$year_var2)[c(8,12)][order(filter(data, Country==input$country_var, Year==input$year_var2)[,c(12)], decreasing = T),][,c(2)][1:10],
            color = ~filter(data, Country==input$country_var, Year==input$year_var2)[c(8,12)][order(filter(data, Country==input$country_var, Year==input$year_var2)[,c(12)], decreasing = T),]$Item[1:10],
            colors="BrBG",
            type = "bar") %>% hide_legend()
  })
  
  df_creater <- reactive({
  foods <- unique(data$Item)
  food <- array()
  rank <- array()
  for(i in 1:length(foods)){
    fo_co <- filter(data, Item==foods[i], Year == input$year_var2)[,c(4,12)][order(filter(data,  Item == foods[i], Year == input$year_var2)$Tonnes, decreasing = T),] 
    if(input$country_var %in% fo_co$Country){
      rank <- append(rank, which(fo_co$Country == input$country_var))  
      food <- append(food, foods[i])
    }
  }
  df <- data.frame(food, rank)
  return(df[order(df$rank,df$food),][1:10,])
  })
  
  output$toprank <-renderDataTable({
    df_creater()
  })
  
})
