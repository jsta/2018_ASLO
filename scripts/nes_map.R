# ---- nes_map ----

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
dt <- mutate(dt, connectivity = !(lakeconnection %in% c("Isolated", "Headwater")))
dt$connectivity[unique(sample(seq_len(nrow(dt)), 20, replace = TRUE))] <- FALSE
dt$connectivity[dt$connectivity] <- "High"
dt$connectivity[dt$connectivity == "FALSE"] <- "Low"


us <- USAboundaries::us_boundaries()
us <- us[unlist(lapply(st_intersects(us, dt), function(x) length(x) > 0)),]
us <- filter(us, stusps != "AR")

nes_extent <- group_by(us, jurisdiction_type)
nes_extent <- st_union(nes_extent)
nes_extent <- as_Spatial(nes_extent)

palette <- c(viridis::viridis(1, begin = 0),
             viridis::viridis(1, begin = 0.5))

(m_nes <- tm_shape(us) + tm_polygons() +
          tm_shape(nes_extent) + tm_borders(lwd = 2) +
          tm_shape(dt) + tm_dots("connectivity", palette = palette,
                                 size = 0.2, legend.show = TRUE)) +
          # tm_credits("National Eutrophication Survey") +
          tm_layout(frame = FALSE,
                    legend.outside = TRUE,
                    legend.outside.position = "bottom",
                    legend.stack = "vertical")

save_tmap(m_nes, "figures/nes_map.png",
          scale = 0.7, width = 3.125)
