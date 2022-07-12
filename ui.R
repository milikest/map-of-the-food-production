library(shiny)
library(plotly)
library(DT)

#FOOD DATA -----------

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

# UI for application that creates a world map
shinyUI(fluidPage(
  tabsetPanel(
    tabPanel("Introduction",
             
               
               mainPanel(
                 h2("Brief"),
                 h4("Dashboard is mainly about visualization of produced primary and processed crops foods stats. Food stats are gathered from FAO (link shown in below)
                     In the source All countries in 'Countries' section, Production Quantity in 'Elements' section, Crops Primary >(List), Crops Processed > (List) in 'Items' section and 
                     2000-2020 in 'Years' section are selected. Dashboard consists of two visual tabs.", align="filled"),
                 h2("First tab: Map Of Production", align="filled"),
                 h4("In this tab producers are shown in choropleth map. When user chooses the food type and year from drop-down lists, choropleth map will be recreated based on the inputs.
                     Produced Foods are measured as tonnes. Colors on the map will be more darker if the country is produced more than other countries.",align="filled"),
                 h4("Also top 10 producer countries are listed in side bar.", align="filled"),
                 h2("Second tab: Country Summary"),
                 h4("Second tab is mainly about visualization based on the country. In sidebar user can choose the country and the year. When chosed the country and year a bar plot will be
                    generated which is showing top 10 food production of that country in the chosen year. And second graph shows the chosen country's production by years. In second graph 
                    there are two lines to show trends and give some insight to user. First line is Regression Line and second one is Polynomial Line (Power=2). Regression line is linear
                    regression line as it can be understood by its' name, and second line is polynomial regression line. In some cases polynomial line shows a better trend and in some cases 
                    regression line fits better. So both lines are selected in default. But if one of them is not wanted then clicking on name of the line at the right will make it disappear.
                    ",align="filled"),
                 h2("Conclusion"),
                 h4("This application can be developed with more food data from fao.org using food stock and live animal stats. But for the first version crops are selected. As you can see 
                    from the graphs after Covid-19 pandemic nearly all countries produced less food than previous years. Especially in European countries reduction of the food producing are 
                    very high rates.",align="filled"),
                 h2("Resources"),
                 h4("For the code of the dashboard:"),
                 tags$a(href="https://github.com/milikest/map-of-the-food-production", "https://github.com/milikest/map-of-the-food-production"),
                 h4("Food stats from FAO:"),
                 tags$a(href="https://www.fao.org/faostat/en/#data/QCL", "https://www.fao.org/faostat/en/#data/QCL"),
                 h4("Mehmet İLİK"),
                 h4("12/07/2022")
                 
               )
             
    ),
    tabPanel("Map Of Production",
             titlePanel("Producer Countries By Food Type"),
             
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
    
    tabPanel("Country Summary",
             # Sidebar with country and year input
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
                 # Bar plot 
                 h3("Top 10 Food Production"),
                 plotlyOutput(outputId = "p"),
                 # Scatter Plot with Trend Lines Added
                 h3("Total Food Production By Years"),
                 plotlyOutput(outputId = "p2")
               )
             )
    )
  )
))
