# Part 2 // creating df with city names and elevation --------------------------

# 0. Import libraries ----------------------------------------------------------

library(tidyr)
library (sf)
library(terra)


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

bound <- bound[,c(5,10)]
print (bound)


## intersect points with administrative boundaries

bound <- st_transform(bound, crs(coord_WGS04_sf))

coord_WGS04_sf <- st_intersection(coord_WGS04_sf, bound)

head(coord_WGS04_sf)


# import elevation

DEM <- rast("data/elevation_USDG.tif")
DEM

bound <- st_transform(bound, crs(DEM))

DEM <- mask(DEM, bound)

crs(DEM)
res (DEM)
class(DEM)
plot(DEM)

## intersect raster (not resampled)

coord_WGS04_sf$elev <- terra::extract(DEM, coord_WGS04_sf, na.rm = TRUE)

head(coord_WGS04_sf)

coord_WGS04_df <- as.data.frame(coord_WGS04_sf)

head(coord_WGS04_df)

# 3. Cleanup and prepare spatiotemporal matrix ---------------------------------

stmatrix <- coord_WGS04_df[,c(1,26,28,29,2:25)]

head(stmatrix)
colnames(stmatrix)
head(stmatrix)

stmatrix$elev[stmatrix$elev <= 10] <- "below"
stmatrix$elev[stmatrix$elev != "below"] <- "above"
stmatrix$elev[is.na(stmatrix$elev)] <- "above"

head(stmatrix)

stmatrix <- stmatrix %>%
  rename(city = NAME_2) %>%
  rename(ID2 = ID) %>%
  unpack(elev) %>%
  select(-c(geometry,ID)) %>%
  rename(ID = ID2) %>%
  rename(AB = elevation_USDG)


# 4. Calculate administrative boundaries area ----------------------------------

crs(bound)

bound$area_km2 <- st_area(bound) #Take care of units
bound$area_km2 <- as.numeric(bound$area_km2/1000000)

head(bound)

admin_area <- as.data.frame(bound[,c(1,4)])

admin_area


# 5. Save to csv ---------------------------------------------------------------

write.csv(stmatrix,"data_output/02_stmatrix.csv")

admin_area %>%
  select(-c(geometry)) %>%
  rename(city = NAME_2) %>%
  write.csv("data_output/03_cities_extent.csv")


# ------------------------------------ END PART 2 ------------------------------
