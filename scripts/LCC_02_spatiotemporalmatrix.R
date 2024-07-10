# Part 2 // creating df with city names and elevation --------------------------

# 0. Import libraries ----------------------------------------------------------

require(tidyr)
require(sf)
require(terra)
require(tidyverse)


# 1. Import csv ----------------------------------------------------------------

coord_WGS04_df <- read.csv("data_output/01_landuse_temporal_WGS04.csv")

coord_WGS04_df <- coord_WGS04_df %>% rename(ID = 1)

head(coord_WGS04_df)

coord_WGS04_sf <- st_as_sf(coord_WGS04_df, coords = c("x","y"), crs = 4326)

coord_WGS04_sf


# 2. Import and clip admin boundaries and elevation raster ---------------------

## Import cities administrative boundaries

bound <- st_read("data/admin_bound.shp") # import from data

class (bound)
print (bound, n=3)

bound2 <- bound[,c(6,10)]
print (bound2)


## intersect points with administrative boundaries

bound2 <- st_transform(bound2, crs(coord_WGS04_sf))

coord_WGS04_sf <- st_intersection(coord_WGS04_sf, bound2)

head(coord_WGS04_sf)


## import elevation

DEM <- rast("data/elevation_USDG.tif")
DEM

bound2 <- st_transform(bound2, crs(DEM))

DEM <- mask(DEM, bound2)

crs(DEM)
res (DEM)
class(DEM)
plot(DEM)

## intersect raster (not resampled)

coord_WGS04_sf$elev <- terra::extract(DEM, coord_WGS04_sf, na.rm = TRUE)

head(coord_WGS04_sf)

coord_WGS04_df <- as.data.frame(coord_WGS04_sf) %>%
  mutate(long = unlist(map(coord_WGS04_df$geometry,1)),
         lat = unlist(map(coord_WGS04_df$geometry,2)))

head(coord_WGS04_df)

colnames(coord_WGS04_df)

# 3. Cleanup and prepare spatiotemporal matrix ---------------------------------

stmatrix <- coord_WGS04_df[,c(1,30,31,26,29,2:25)]

head(stmatrix)
colnames(stmatrix)

stmatrix$elev[stmatrix$elev <= 10] <- "below"
stmatrix$elev[stmatrix$elev != "below"] <- "above"
stmatrix$elev[is.na(stmatrix$elev)] <- "above"

head(stmatrix)

stmatrix <- stmatrix %>%
  rename(city = NAME_2) %>%
  rename(ID2 = ID) %>%
  unpack(elev) %>%
  select(-c(ID)) %>%
  rename(ID = ID2) %>%
  rename(AB = elevation_USDG)

head(stmatrix)
colnames(stmatrix)


# 4. Calculate administrative boundaries area ----------------------------------

crs(bound2)

bound2

bound2$area_m2 <- st_area(bound2) #Take care of units

head(bound2)

bound2$area_km2 <- as.numeric(bound2$area_m2/1000000)

head(bound2)

admin_area <- as.data.frame(bound2[,c(1,4)])

admin_area


# 5. Save to csv ---------------------------------------------------------------

write.csv(stmatrix,"data_output/02_stmatrix.csv")

admin_area %>%
  select(-c(geometry)) %>%
  rename(city = NAME_2) %>%
  write.csv("data_output/03_cities_extent.csv")


# ------------------------------------ END PART 2 ------------------------------
