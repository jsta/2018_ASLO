library(tmap)
library(sf)
library(LAGOSNE)
library(USAboundaries)
library(dplyr)

lg <- lagosne_load("1.087.1")


dt <- read.csv("~/Documents/Science/JournalSubmissions/nes_connectivity_p/data/nes_x_lagos-ne.csv")
dt <- st_as_sf(dt, coords = c("lg_long", "lg_lat"), crs = 4326)
# LAGOSNE::query_lagos_names(lg, "lakeconnection")
dt <- left_join(dt, select(lg$lakes.geo, lagoslakeid, lakeconnection))
dt <- mutate(dt, included = !(lakeconnection %in% c("Isolated", "Headwater")))
dt$included[unique(sample(seq_len(nrow(dt)), 20, replace = TRUE))] <- FALSE

us <- USAboundaries::us_boundaries()
us <- us[unlist(lapply(st_intersects(us, dt), function(x) length(x) > 0)),]
us <- filter(us, stusps != "AR")

nes_extent <- group_by(us, jurisdiction_type)
nes_extent <- st_union(nes_extent)
nes_extent <- as_Spatial(nes_extent)

palette <- c(viridis::viridis(1, begin = 0.5),
             viridis::viridis(1, begin = 0))

(m_nes <- tm_shape(us) + tm_polygons() +
          tm_shape(nes_extent) + tm_borders(lwd = 2) +
          tm_shape(dt) + tm_dots("included", palette = palette,
                                 size = 0.2, legend.show = FALSE)) +
          # tm_credits("National Eutrophication Survey") +
          tm_layout(frame = FALSE)

save_tmap(m_nes, "figures/nes_map.png",
          scale = 0.7, width = 3.125)
