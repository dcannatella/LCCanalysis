# ------------------------------------------------------------------------------
# ------------------------------- LANDUSE SCRIPT -------------------------------
# ----------------------- using ESACCI data time series ------------------------

# ------------------------------------------------------------------------------
# ----------------------------------- Part 1 -----------------------------------
# ----------------------- creating df with time series -------------------------


# 0. libraries -----------------------------------------------------------------
# install libraries

library(terra)
library(sf)
library(dplyr)


# 1. import crop shapefile and ESACCI rasters ----------------------------------

crop_admin <- st_read("data/admin_bound.shp")
frame <- st_read("data/PRD_frame.shp")

WGS84 <- crs(crop_admin)

plot (crop_admin) 

wd <- getwd()
setwd("data/ESACCI")

rasterlist <- list.files()
outlist <- list() #create empty list to store outputs from loop

print (rasterlist)

r_stack <- rast(rasterlist)


# 2.extract coordinates and resample raster-------------------------------------

crop_admin <- st_transform(crop_admin, crs(r_stack))

crs(crop_admin)

r_stack <- crop(r_stack, crop_admin)

plot(r_stack)
res(r_stack)


# 3. clip values ---------------------------------------------------------------

r_stack <- mask(r_stack, crop_admin) #clip to admin boundaries shape

plot (r_stack)

# 4. fill LANDCOVER dataframe ------------------------------------------------------
## first reclassify raster, then aggregate;
## aggregation according to countmax

v_reclass <- c(0,8,0,
               9,18,2, #agriculture/cropland
               19,28,3,#agriculture/irrigated
               29,48,2,#agriculture/cropland
               49,108,5,#forest
               109,118,5,#forest
               119,128,4,#shrubland
               129,138,4,#grassland
               139,158,4,#sparse vegetation
               159,178,6,#forest/wetland (check)
               179,188,4,#shrubland
               189,198,1,#urban areas
               199,208,4,#bare areas
               209,218,7,#water
               219,228,8) #permanent snow and ice


m_reclass <- matrix(v_reclass, ncol=3, byrow = TRUE)

r_stack <- classify(r_stack, m_reclass, include.lowest=TRUE)

r_stack

# 5. reproject and create df ---------------------------------------------------

coord_WGS04 <- as.data.frame(r_stack, xy = TRUE)

coord_WGS84 <- project (r_stack, crs(WGS84), res=100)

plot(coord_WGS84)

coord_WGS84 <- as.data.frame(coord_WGS84, xy = TRUE)

head(coord_WGS84)

cnames <- names(coord_WGS04)

cnames

for (i in 3:length(coord_WGS04)) {
  label <- substring(cnames[[i]], 32,35)
  cnames[i] <- label
} 

cnames

colnames(coord_WGS04) <- cnames
colnames(coord_WGS84) <- cnames

head(coord_WGS04)
head(coord_WGS84)


# export table to csv ----------------------------------------------------------

setwd(wd)

coord_WGS04_sf <- st_as_sf(coord_WGS04, coords = c("x","y"), crs = 4302)
coord_WGS84_sf <- st_as_sf(coord_WGS84, coords = c("x","y"), crs = WGS84)

st_write(coord_WGS04_sf, "data_output/01_coord_WGS04.shp", append = FALSE)

write.csv (coord_WGS04, "data_output/01_landuse_temporal_WGS04.csv")
write.csv (coord_WGS84, "data_output/01_landuse_temporal_WGS84.csv")


# ------------------------------------------------------------------------------
# ------------------------------------ END PART 1 ------------------------------
# ------------------------------------------------------------------------------

