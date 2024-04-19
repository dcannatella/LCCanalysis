# ------------------------------------------------------------------------------
# ------------------------------- LANDUSE SCRIPT -------------------------------
# ----------------------- using ESACCI data time series ------------------------

# ------------------------------------------------------------------------------
# ----------------------------------- Part 3 -----------------------------------
# --------------------- formatting the table for alluvial ----------------------



# first calculations -----------------------------------------------------------
# count samples in df ----------------------------------------------------------

library(here)
library(summarytools)
library(sf)
library(dplyr)
library(ggplot2)


stmatrix <- read.csv(here("data_output/02_stmatrix.csv"))
head(stmatrix)
cities <- st_read("data/admin_bound.shp") # import from data

class (cities)
print (cities, n=3)

cities <- cities[,c(5,10)]
print (cities)

## 

cities$area_km2 <- st_area(cities) #Take care of units #still to run
cities$area_km2 <- as.numeric(cities$area_km2/1000000)

cities_df <- as.data.frame(cities)
cities_df <- cities_df[c(1,4)]
cities_df

cities_df$perc <- round(cities_df$area_km2*100/sum(cities_df$area_km2),2)
cities_df$area_km2 <- round (cities_df$area_km2,2)
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


cities <- subset(stmatrix, select = c(3,4))

head (cities)

cities_obs <- cities %>%
  group_by(city) %>%
  summarize(count=n(),
            perc=round(n()/nrow(cities)*100,2)
            )

head(cities_obs)
head(cities_df)

cities_df2 <- merge(cities_df, cities_obs, by.x = "NAME_2", by.y = "city")

cities_df2$pdiff <- cities_df2$perc.x-cities_df2$perc.y

cities_df2

cities_df2$cwaffle <- round(cities_df2$count/1000,0)

cities_df2 %>%
  rename(cities_df2, city=NAME_2)

library(waffle)

ggplot(cities_df2, aes(fill=NAME_2, values=cwaffle))+
  geom_waffle(n_rows = 25, size=0.2, colour="white")+
  scale_fill_manual(name = NULL,
                    values = c("#c9b42f",
                               "#a54be0",
                               "#6cd03a",
                               "#cc5baf",
                               "#6dac46",
                               "#797bd2",
                               "#da5f22",
                               "#52b980",
                               "#d45170",
                               "#ad9144",
                               "#d35b47"))+
  coord_equal()+
  theme_void()



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

