# install.packages("leaflet", "tidyverse", "sp", "sf", "maps")
library(leaflet) # for interactive maps
library(magrittr) # set of operators which make your code more readable, including the pipe (%>%) operator

m <- leaflet() %>% addTiles()
m  # a map with the default OSM tile layer

# first map
m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = -123.085269, lat = 49.281178, popup = "Prototype Cafe; on the want to try list")
m

# zooming
t1 <- leaflet(options = leafletOptions(minZoom = 7, maxZoom = 18)) %>% # we can focus the map -- play around with different zoom levels focused on the same
  addTiles() %>% 
  addAwesomeMarkers(lng=-123.085269, lat=49.281178, icon = , popup ="Prototype Cafe; on the want-to-try list")
t1

# adjusting size
t2 <- leaflet(width = 600, height = 400, options = leafletOptions(minZoom = 7, maxZoom = 18)) %>% # width/height in pixels
  addTiles() %>%
  addMarkers(lng=-123.085269, lat=49.281178, popup="Prototype Cafe; on the want-to-try list")
t2

# basemap with a link
t3 <- leaflet(width = 600, height = 400) %>% 
  addTiles("http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png", # this example on p49 of leaflet documentation #can copy paste from CartoDB
           attribution = paste(
             "&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors", # the attribution text of the tile layer (HTML)   
             "&copy; <a href=\"http://cartodb.com/attributions\">CartoDB</a>"
           )
  ) %>% setView(-123.085, 49.281, zoom = 15) %>%
  addMarkers(lng=-123.085269, lat=49.281178, popup="Prototype Cafe; on the want-to-try list")
t3


# basemap via tile providers
t4 <- leaflet(width = 600, height = 400) %>% 
  setView(-123.085, 49.281, zoom = 15) %>%
  addMarkers(lng=-123.085269, lat=49.281178, popup="Prototype Cafe; on the want-to-try list") %>%
  addProviderTiles(providers$Stamen.Watercolor) # ?providers to open the list in the console; attributes automatically
t4

# changing markers
t5 <- leaflet(width = 600, height = 400) %>%
  setView(-123.08, 49.281, zoom = 13) %>%
  addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
  addCircleMarkers(color = c("blueviolet"), fill = FALSE, opacity = 0.7, # ?addCircleMarkers
                   radius = 4, weight = 2,                         # customizing colors use colors() function to pull up list in the console
                   lng=-123.085269, lat=49.281178,                  # https://mgimond.github.io/ES218/Week04d.html
                   popup="Prototype Cafe; on the want-to-try list")
t5

# adding data to a webmap using web map service tiles https://leafletjs.com/examples/wms/wms.html
trails <- leaflet() %>% 
  addTiles() %>% setView(-123.08, 49.281, zoom = 10) %>% 
  addProviderTiles(providers$CartoDB.DarkMatter) %>%
  addWMSTiles("https://openmaps.gov.bc.ca/geo/pub/WHSE_FOREST_TENURE.FTEN_RECREATION_LINES_SVW/ows?service=WMS&", # the base WMS URL is simply the GetCapabilities URL, without any parameters, like so:
              layers = "WHSE_FOREST_TENURE.FTEN_RECREATION_LINES_SVW", # helpful to view capabilities in a software to see what layers are available in the service, but will use trails
              options = WMSTileOptions(format = "image/png", transparent = TRUE))  # this option allows layers to have transparency
trails

# adding a shapefile
library(sf)

nbh <- st_read("C:/Users/Jaimy/Dropbox/PhD/Peer GIS/Workshop 2 Web Mapping with R/webmapr/local-area-boundary/local-area-boundary.shp") # C:/Users/Jaimy/Dropbox/PhD/Peer GIS/Workshop 2 Web Mapping with R/webmapr/local-area-boundary/local-area-boundary.shp

van <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Voyager) %>% # tile providers
  setView(-123.08, 49.281, zoom = 11) %>%         #focus the map
  addPolygons(data = nbh, color = "#444444", weight = 1, smoothFactor = 0.5, 
              opacity = 1.0, fillOpacity = 0.3,
              fillColor = "brown",
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = TRUE))
van

# add points to the map
cafes <- read.csv("C:/Users/Jaimy/Dropbox/PhD/Peer GIS/Workshop 2 Web Mapping with R/webmapr/Cafes.csv", header = TRUE)
van2 <- leaflet() %>% 
  addProviderTiles(providers$CartoDB.Voyager) %>% 
  setView(-123.08, 49.281, zoom = 12) %>% 
  addPolygons(data = nbh, color = "#444444", weight = 1, smoothFactor = 0.5,
              fill = "brown") %>% 
  addCircleMarkers(data = cafes, lat = cafes$Lat, lng = cafes$Long,
                   color = "black", fill = TRUE, opacity = 1,
                   radius = 4, weight = 2,
                   popup = paste("Cafe:", 
                                 cafes$Cafe, 
                                 "<br>", # <br>  starts a new line
                                 "Visited:", 
                                 cafes$Visit, "<br>"))
van2
