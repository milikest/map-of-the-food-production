
# Data has been gathered from https://www.fao.org/faostat/en/#data/QCL
# From the source  All Countries, Production Quantity, Crops Primary>(List) and Crops Processed>List, 2000-2020 years are selected. 
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
            colors="BrBG", type = "bar") %>% hide_legend()
  })
  regression <- reactive({
    newdf <- data.frame(2000:2020,matrix(sapply(2000:2020,function(i){filter(data, Year==i, Country==input$country_var) %>% summarise(sum(Tonnes))})))
    colnames(newdf) <- c("index","tonnes")
    newdf$tonnes <- as.numeric(newdf$tonnes)
    model <- lm(tonnes~index,newdf)
    preds <- predict(model)
    return(preds)
  })
  polynomial <- reactive({
    newdf <- data.frame(2000:2020,matrix(sapply(2000:2020,function(i){filter(data, Year==i, Country==input$country_var) %>% summarise(sum(Tonnes))})))
    colnames(newdf) <- c("index","tonnes")
    newdf$tonnes <- as.numeric(newdf$tonnes)
    model <- lm(tonnes~ poly(index,2,raw=TRUE), newdf)
    poly_preds <- predict(model)
    return(poly_preds)
  })

  output$p2 <-renderPlotly({
    p <- plot_ly(x=2000:2020, y=matrix(sapply(2000:2020,function(i){filter(data, Year==i, Country==input$country_var) %>% summarise(sum(Tonnes))})),
                 color =2000:2020,colors = c( "#56B1F7","#132B43"), size=22,name="Total Production", mode="markers", type="scatter") %>%
                add_trace(y=regression(),  name = "Regression Line", line = list(color="purple", width=1), mode="lines") %>%
                add_trace(y= polynomial(), name = "Polynomial Line (Power=2)", line= list(color="brown", width=1), mode="lines") 
  })
})
