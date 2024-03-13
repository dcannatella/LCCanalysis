# ------------------------------------------------------------------------------
# ------------------------------- LANDUSE SCRIPT -------------------------------
# ----------------------- using ESACCI data time series ------------------------

# ------------------------------------------------------------------------------
# ----------------------------------- Part 2 -----------------------------------
# ----------------- creating df with city names and elevation ------------------

################################################################################
#################                                          #####################
################# Something is wrong with the final csv :( #####################
#################                                          #####################
################################################################################

# Install libraries

library(dplyr)
library (sf)
library(stars)

#library (mapview)
#library(spatialEco)
#library(tidyverse)

# import output CSV from part1, if needed --------------------------------------

coord_WGS04_df <- read.csv("data_output/01_landuse_temporal_WGS04.csv")

coord_WGS04_df <- coord_WGS04_df %>% rename(ID = 1)
  
head(coord_WGS04_df)

colnames(coord_WGS04_df)

coord_WGS04_df <- rename(coord_WGS04_df, c(
  "1992" = X1992,
  "1993" = X1993,
  "1994" = X1994,
  "1995" = X1995,
  "1996" = X1996,
  "1997" = X1997,
  "1998" = X1998,
  "1999" = X1999,
  "2000" = X2000,
  "2001" = X2001,
  "2002" = X2002,
  "2003" = X2003,
  "2004" = X2004,
  "2005" = X2005,
  "2006" = X2006,
  "2007" = X2007,
  "2008" = X2008,
  "2009" = X2009,
  "2010" = X2010,
  "2011" = X2011,
  "2012" = X2012,
  "2013" = X2013,
  "2014" = X2014,
  "2015" = X2015)
)

head (coord_WGS04_df)

coord_WGS04_sf <- st_as_sf(coord_WGS04_df, coords = c("x","y"), crs = 4302)


# import and clip admin boundaries and elevation raster ------------------------

# import cities

bound <- st_read("data/admin_bound.shp") # import from data

class (bound)
print (bound, n=3)

bound <- bound[,c(5,10)]
print (bound)


# import elevation

DEM <- rast("data/elevation_USDG.tif")

DEM <- mask(DEM, bound)

e <- ext(bound)
as.vector(e)
as.character(e)

ext(DEM) <- ext(bound) 


crs(DEM)
res (DEM)
class(DEM)
plot(DEM)



# intersect vector

bound <- st_transform(bound, crs(coord_WGS04_sf))
bound$area_km2 <- st_area(bound) #Take care of units #still to run
bound$area_km2 <- as.numeric(bound$area_km2/1000000)

head(bound)

coord_WGS04_sf <- st_intersection(coord_WGS04_sf, bound)

head(coord_WGS04_sf)


# intersect raster, not resampled

coord_WGS04_sf$elev <- extract(DEM, coord_WGS04_sf, na.rm = TRUE)

coord_WGS04_sf$elev <- st_extract(DEM, coord_WGS04_sf)

head(coord_WGS04_sf)


# assign coordinates -----------------------------------------------------------

## assign coordinates to coord

crs(DEM)

crsDEM <- crs(DEM)

crs(rtot)

coord <- subset (rtot, select = c(2,3)) #if needed

head(coord)

crs(coord)

coordinates(coord)= ~ x + y

crs(coord) <- crsWGS

crs(coord)

coord <- st_as_sf(coord)

## reproject admin

admin <- st_transform(admin, crsWGS)

class(elev)
crs(elev)


# intersect --------------------------------------------------------------------

df <- st_intersection(coord, admin)

df$ab <- raster::extract(elev, df)


##retrieve coordinate

df <- cbind(df, st_coordinates(df))

head(df)

##intersect

stmatrix <- left_join(df, rtot, by=c('X', 'Y'))

head(stmatrix)

colSums(is.na(stmatrix))

colnames(stmatrix)[1] <- "city"
colnames(stmatrix)[2] <- "area_sqkm"

stmatrix <- stmatrix[, c(6, 4, 5, 1, 2, 3, 7:length(stmatrix))]



order(stmatrix2)

head(stmatrix2)













.rs.unloadPackage("tidyr") #in case it does not work



coordinates(coord)= ~ x + y

head(coord)

# assign same CRS as others ----------------------------------------------------

print (crs(admin))
print (crs(coord))

crs <- crs(admin)

proj4string(coord) <- crs

print (crs(coord))

coord <- spTransform(coord, crs(admin))

coord <- st_as_sf(coord)

class(coord)
head(coord)
plot(coord)
plot()

coord <- SpatialPointsDataFrame(coord, data.frame(row.names=row.names(coord),
                                                    ID=1:length(coord)))


head(coord)

# intersect everything!!! ------------------------------------------------------
df <- overlay(coord, admin)

df <- st_intersection(coord, admin)

class(coord_sp)
class(admin)

admin <- st_as_sf(admin)

class(coord_sp)
class(admin)
crs(coord_sp)
crs(admin)

plot(coord_sp)
plot(admin)

intrsct <- st_intersection(coord_sp, admin)

print(intersect)

crs(elev)
crs(coord_sp)

library(raster)

elev_value <- raster::extract(elev, coord_sp, df = TRUE, sp = T)

class(elev_value)

elev_value <- st_as_sf(elev_value)

class(elev_value)

elev_value <- as.data.frame(elev_value)
intersect <- as.data.frame(intersect)

class(intersect)
head(intersect)

class(elev_value)
head(elev_value)

cities_elev <-  st_join(intersect, elev_value)

class(cities_elev)
head(cities_elev)


# why these two?
cities_elev <- cities_elev[,-6]
cities_elev <- cities_elev[,c(1,4,2,5)]


head(rtot)
xy <- rtot[,c(1,2)]
head(xy)

rtot2 <- SpatialPointsDataFrame(coords = xy, data=rtot)
rtot2 <- st_as_sf(rtot2)
rtot2 <- as.data.frame(rtot2)
rtot2$ID <- seq.int(nrow(rtot2))

head(rtot2)
class(rtot2)

# why?
cities_elev <- cities_elev %>% 
  rename(
    geometry = geometry.x
  )

head(rtot2, n=3)
head(cities_elev, n=3)

cities_elev <- SpatialPointsDataFrame(cities_elev, data.frame(row.names=row.names(cities_elev),
                                                     ID=1:length(cities_elev)))



class(rtot2)
class(cities_elev)

cities_elev$coord <- do.call(rbind, st_geometry(cities_elev )) %>% 
  as_tibble() %>% setNames(c("x","y"))

cities_elev <- as.data.frame(cities_elev)

head(cities_elev)

stmatrix <-  left_join(cities_elev, rtot2, by="geometry")


# cleanup the final df ---------------------------------------------------------

head(stmatrix)

stmatrix <- stmatrix[ , c(1,2,3,4,5,6,7:20)]

head(stmatrix)

colnames(stmatrix)[2] <- "geometry"
colnames(stmatrix)[3] <- "city"
colnames(stmatrix)[4] <- "above/below s.l."

head(stmatrix)

stmatrix$`above/below s.l.`[stmatrix$`above/below s.l.` <= 10] <- "below"
stmatrix$`above/below s.l.`[stmatrix$`above/below s.l.` != "below"] <- "above"
stmatrix$`above/below s.l.`[is.na(stmatrix$`above/below s.l.`)] <- "above"

#check with plot ---------------------------------------------------------------

library(ggplot2)

head(stmatrix)

ggplot(stmatrix, aes(x=x, y=y, color=above.below.s.l.))+
  geom_point()


#save to csv -------------------------------------------------------------------

write.csv (stmatrix, "output/stmatrix.csv")
