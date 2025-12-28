
rm(list = ls())

library(leaflet)
library(shiny)
library(sp)
library(rsconnect)


# read in cities data
library(readxl)

data <- read_excel("euroTravels-master/data/cities.xls")

# set long and lat as numerics
data$long <- as.numeric(data$long)
data$lat <- as.numeric(data$lat)

# create passport icon to use as marker
passportIcon <- makeIcon(
  iconUrl = "https://img.icons8.com/plasticine/30/000000/place-marker.png",
  iconAnchorX = 15, iconAnchorY = 15
)

ui <- fluidPage(fillPage(tags$style(type = "text/css",
                                    "#mymap {height: 100vh !important;
                                    width: 100vw !important;
                                    margin-left: -15px; !important;}"),
                         leafletOutput("mymap", width = "100%",height = "100%")))

server <- function(input, output) {
  output$mymap <- renderLeaflet({ leaflet() %>%
      addTiles() %>%
      addMarkers(data = data, lng = ~long, lat = ~lat,icon = passportIcon, popup = ~paste("<b>City</b>", data$city, "<br>",
                                                                                          "<b>Country:</b>", data$country, "<br>")) %>%
      addProviderTiles(providers$CartoDB.Positron)
    
  })
}

shinyApp(ui, server)


