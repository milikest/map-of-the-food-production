Dashboard of The Food Producement

Brief
This is a dashboard application project written in R. Application can work locally but if R is not installed or local calculations not desired then application can be used in: https://c94mnx-mehmet-0l0k.shinyapps.io/Food_Analysis/

Dashboard is mainly about visualization of produced primary and processed crops foods stats. Food stats were gathered from FAO (link shown in below)
In the source All countries in 'Countries' section, Production Quantity in 'Elements' section, Crops Primary >(List), Crops Processed > (List) in 'Items' section and 
2000-2020 in 'Years' section are selected. Dashboard consists of two visual tabs.

First tab: Map Of Production
In this tab producers are shown in choropleth map. When user chooses the food type and year from drop-down lists, choropleth map will be recreated based on the inputs.
Produced Foods are measured as tonnes. Colors on the map will be more darker if the country is produced more than other countries.
Also top 10 producer countries are listed in side bar.

Second tab: Country Summary
Second tab is mainly about visualization based on the country. In sidebar user can choose the country and the year. When chosed the country and year a bar plot will be
generated which is showing top 10 food production of that country in the chosen year. And second graph shows the chosen country's production by years. In second graph 
there are two lines to show trends and give some insight to user. First line is Regression Line and second one is Polynomial Line (Power=2). Regression line is linear
regression line as it can be understood by its' name, and second line is polynomial regression line. In some cases polynomial line shows a better trend and in some cases regression line fits better. So both lines are selected in default. But if one of them is not wanted then clicking on name of the line at the right will make it disappear.

Conclusion
This application can be developed with more food data from fao.org using food stock and live animal stats. But for the first version crops are selected. As you can see 
from the graphs after Covid-19 pandemic nearly all countries produced less food than previous years. Especially in European countries reduction of the food producing are very high rates.

Resources
Food stats from FAO:
https://www.fao.org/faostat/en/#data/QCL

![alt text](https://github.com/milikest/map-of-the-food-production/blob/main/First%20Tab.png)
![alt text](https://github.com/milikest/map-of-the-food-production/blob/main/Second%20Tab.png)
