# ------------------------------------------------------------------------------
# ------------------------------- LANDUSE SCRIPT -------------------------------
# ----------------------- using ESACCI data time series ------------------------

# ------------------------------------------------------------------------------
# ----------------------------------- Part 3 -----------------------------------
# --------------------- formatting the table for alluvial ----------------------

stmatrix <- read.csv("output/stmatrix.csv")
head(stmatrix)

# first calculations -----------------------------------------------------------
# count samples in df ----------------------------------------------------------

# Install libraries

library(summarytools)
library(sf)
library(dplyr)
library(ggplot2)


cities <- st_read("data/admin_bound.shp") # import from data
class (cities)
print (cities, n=3)

cities <- cities[,c(5,10)]
print (cities)
cities$area_km2 <- st_area(cities) #Take care of units #still to run
cities$area_km2 <- as.numeric(cities$area_km2/1000000)

cities_df <- as.data.frame(cities)
cities_df <- cities_df[c(1,4)]
cities_df

cities_df$perc <- round(cities_df$area_km2*100/sum(cities_df$area_km2),3)
cities_df

# Donut plot

cities_df$ymax <- cumsum(cities_df$perc)
cities_df$ymin <- c(0,head(cities_df$ymax, n=-1))
cities_df

# Compute label position
cities_df$labelPosition <- (cities_df$ymax + cities_df$ymin) / 2

# Compute a good label
cities_df$label <- paste0(cities_df$NAME_2, "\n", round(cities_df$area_km2,2), " kmq")

ggplot(cities_df, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=NAME_2))+
  geom_rect()+
  geom_label(x=2, aes(y=labelPosition, label=label), size=3)+
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3)+
  coord_polar(theta = "y")+
  xlim(c(-1,4))+
  theme_void()+
  theme(legend.position = "none")


head(stmatrix)



# lollipop chart

cities_df %>%
  arrange(area_km2) %>%
  mutate(NAME_2 = factor(NAME_2, levels=NAME_2)) %>%
  ggplot(aes(x=NAME_2, y=area_km2))+
  geom_point(size=5, alpha=0.9)+
  geom_segment(aes(x=NAME_2,
                   xend=NAME_2,
                   y=0,
                   yend=area_km2))+
  coord_flip()+
  labs(title="cities of the PRD")+
  theme_minimal()


cities <- subset(stmatrix, select = c(1,4))

head (cities)

stats <- as.data.frame(freq(cities$city))

stats <- round(stats[2:5], 2)

head(stats)

grouped_cities <- aggregate(cities, by=list(cities$city), FUN=length)

head(grouped_cities)

# count areas proportion in shapefile ------------------------------------------


head(admin)

admin@data

admin$area_sqkm <- round(st_area(admin) / 1000000, 2)

df_shape <- as.data.frame(admin)

head(df_shape)

df_shape <- subset(df_shape, select = c(1,4))

total <- sum(df_shape$area_sqkm)

df_shape$perc <- round(df_shape$area_sqkm/total*100, 2)

head(df_shape)

write.csv(df_shape, "output/cities_area_perc.csv")

# count above/below slm in df --------------------------------------------------

head(stmatrix)

slm <- subset(stmatrix, select = c(4,5))

head (slm)

grouped_data <- aggregate(slm, by=list(slm$city, slm$above.below.s.l.), FUN=length)

sum(grouped_data$city)

head(grouped_data)

above <-  grouped_data[ which(grouped_data$Group.2=='above'),] 
below <-  grouped_data[ which(grouped_data$Group.2=='below'),] 

cities <- grouped_cities

head(cities)

cities <- subset(cities, select = c(1,3))

colnames(cities)[1] <- "city"
colnames(cities)[2] <- "total"

head(cities)

head(above)
above <- subset(above, select = c(1,3))
colnames(above)[1] <- "city"
colnames(above)[2] <- "above"

head(above)

below <- subset(below, select = c(1,3))
colnames(below)[1] <- "city"
colnames(below)[2] <- "below"

head(below)

cities <- cities %>% right_join(above, by="city")

head(cities)

cities <- cities %>% right_join(below, by="city")

head(cities)

#if 0 vector, then it is correct
cities$total-(cities$above+cities$below)

cities$p_above <- round(cities$above/cities$total*100, 2)
cities$p_below <- round(100-cities$p_above, 2) # considering NA as above

head(cities)


write.csv (cities, "output/cities_elevation.csv")

