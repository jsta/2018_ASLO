library(tmap)
library(nesRdata)
library(sf)

dt <- nesRdata::nes
dt <- st_as_sf(dt, coords = c("long", "lat"), crs = 4326)

tm_shape(dt) + tm_dots()
