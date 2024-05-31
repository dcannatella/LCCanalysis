#  Part 1 // creating df with LCC time series

# 0. import libraries 

library(terra)
library(sf)
library(dplyr)
library(here)


# 1. import administrative boundaries shapefile and crop ESACCI rasters -------- 

crop_admin <- st_read(here("data/admin_bound.shp"))
frame <- st_read(here("data/PRD_frame.shp"))

WGS84 <- crs(crop_admin)

plot (crop_admin) 


## read tiffs in folder and stack rasters

rasterlist <- list.files(here("data/ESACCI"))
outlist <- list() #create empty list to store outputs from loop

print (rasterlist)

r_stack <- rast(rasterlist)


# 2.extract coordinates and resample raster if needed --------------------------

## reproject admin boundaries in r_stack CRS, if needed

crop_admin <- st_transform(crop_admin, crs(r_stack))

crs(crop_admin)

r_stack <- crop(r_stack, crop_admin)

plot(r_stack)
res(r_stack)


# 3. clip values ---------------------------------------------------------------

r_stack <- mask(r_stack, crop_admin) #clip to admin boundaries shape

plot (r_stack)


# 4. populate Land Cover Change df ---------------------------------------------

## raster reclassification. aggregation performed according to countmax

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


# 5. reproject and create dfs --------------------------------------------------

## this part creates two different df at two different resolutions, the original
## and a custom resolution.
## res sets the desired resolution of the raster before performing the values
## extraction.

res = 100


coord_WGS04 <- as.data.frame(r_stack, xy = TRUE)

coord_WGS84 <- project (r_stack, crs(WGS84), res=res)

plot(coord_WGS84)

coord_WGS84 <- as.data.frame(coord_WGS84, xy = TRUE)

head(coord_WGS84)

cnames <- names(coord_WGS04)

cnames

for (i in 3:length(coord_WGS04)) {
  label <- substring(cnames[[i]], 32,35)
  cnames[i] <- paste("y",label, sep = "")
} 

cnames

colnames(coord_WGS04) <- cnames
colnames(coord_WGS84) <- cnames

head(coord_WGS04)
head(coord_WGS84)


# 6. export table --------------------------------------------------------------

setwd(wd)


## export as .csv

write.csv (coord_WGS04, "data_output/01_landuse_temporal_WGS04.csv")
write.csv (coord_WGS84, "data_output/01_landuse_temporal_WGS84.csv")

# ------------------------------------ END PART 1 ------------------------------
