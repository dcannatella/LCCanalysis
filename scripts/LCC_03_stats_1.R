# Part 3 // calculating initial stats

# libraries --------------------------------------------------------------------

library(here)
library(summarytools)
library(sf)
library(dplyr)
library(ggplot2)
library(forcats)
library(leaflet)
library(tidyr)
library(reshape2)
library(scales)
library(ggthemes)
library(gridExtra)


# Create custom theme ----------------------------------------------------------

theme_prd <- function() {
  theme_minimal()+
  theme(panel.background = element_blank(),
        axis.ticks.x=element_blank(), 
        axis.ticks.y=element_blank(),
        axis.text = element_text(size=6),
        axis.title = element_text(size=8),
        legend.title = element_text(size=8, face="bold"),
        legend.text = element_text(size=6),
        legend.key.size = unit(.75,'line'),
        title = element_text(size=8),
        plot.margin = margin(2, 2, 2, 2, "cm"))
}


theme_prd_map <- function() {
  theme_prd()+
    theme(panel.grid = element_blank(),
          legend.position = "bottom",
          axis.text = element_blank(),
          axis.title = element_blank(),
          legend.title = element_blank())
}

# first calculations -----------------------------------------------------------

stmatrix <- read.csv(here("data_output/02_stmatrix.csv"))
head(stmatrix)
cities <- st_read("data/admin_bound.shp") # import from data

## count samples in df 

class (cities)
print (cities, n=3)

cities <- cities[,c(5,10)]
print (cities)

cities$area_km2 <- st_area(cities) #Take care of units #still to run
cities$area_km2 <- as.numeric(cities$area_km2/1000000)

cities_df <- as.data.frame(cities)
cities_df <- cities_df[c(1,4)]
cities_df

cities_df$perc <- round(cities_df$area_km2*100/sum(cities_df$area_km2),2)
cities_df$area_km2 <- round (cities_df$area_km2,2)
cities_df

# print cities extent lollipop chart -------------------------------------------

colors = c("#c6ccc2","#82837b","#31443e","#382920")

cities_df %>%
  mutate(NAME_2 = fct_reorder(NAME_2, area_km2))%>%
  ggplot(aes(x=NAME_2, y=area_km2, label=comma(area_km2, accuracy = 0.01)))+
  geom_segment(color="#31443e", aes(x=NAME_2,
                   xend=NAME_2,
                   y=0,
                   yend=area_km2))+
  geom_point(size=3, colour = "#31443e")+
  geom_text(hjust=-0.15, vjust=.5, size=2.5, nudge_x = .25, nudge_y = .25)+
  labs(title="Cities in the Pearl River Delta",
       subtitle="Extent of the cities in the PRD region, in square kilometers",
       y = "area (km2)") +
  coord_flip()+
  theme_prd()+
  scale_x_discrete(expand = c(0, .5)) +  # Add padding to x-axis
  scale_y_continuous(expand = c(0.12, 5)) +  # Add padding to y-axis
  theme(axis.line.x = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major.y = element_blank())

ggsave("fig_output/01_PRDcities_area.jpg", width = 7.5, height = 7.5, dpi = 300)


# Plot above and below ---------------------------------------------------------

ABstats <- stmatrix %>%
  group_by(city, AB) %>%
  count()

ABstats$count <- ifelse(ABstats$AB == 'below', ABstats$n*-1, ABstats$n)
ABstats$fct <- ifelse(ABstats$AB == 'below', ABstats$n*-1, NA)
ABstats <- merge(x = ABstats, y = cities_df, by.x = "city", by.y = "NAME_2", all = TRUE)

ABstats_above <- ABstats %>%
  filter(AB == 'above')

ABstats_below <- ABstats %>%
  filter(AB == 'below')

brks <- seq (-200000, 200000, 50000)
lbls <- paste0(as.character(c(seq(200, 0, -50), seq (50, 200, 50))))

colors = c("#c6ccc2","#31443e")
  
ab1 <- ABstats %>%
  mutate(city = fct_reorder(city, area_km2), desc=TRUE)%>%
  ggplot(aes(x=city, y=count, fill=AB))+
  geom_bar(stat="identity", width = 0.3)+
  coord_flip() +
  labs(title="Number of cells in LECZ by municipality",
       subtitle="(x1000)",
       y = "number of cells",
       fill = "LECZ")+
  theme_prd()+
  theme(panel.grid.major.y = element_blank(),
        legend.title = element_blank(),
        legend.position = c(0.85,0.05),
        legend.background = element_rect(fill="white", colour="white"))+
  scale_x_discrete(expand = c(0, .5)) +  # Add padding to x-axis
  scale_y_continuous(limits = c(-200000, 200000), breaks = brks, labels=lbls,
                     expand = c(0.12, 5))+
  scale_fill_manual(values=colors,
                    labels=c("no LECZ", "LECZ"))+
  guides(fill = guide_legend(reverse = TRUE))

ab2 <- ab1+
  geom_text(data = ABstats_above, aes(x=city, y=count, label = comma(n)),
            hjust=-0.1, vjust=0.5, size =2.5)

ab3 <- ab2+
  geom_text(data = ABstats_below, aes(x=city, y=count, label = comma(n)),
            hjust=1.25, vjust=0.5, size =2.5)


ab3

ggsave("fig_output/02_PRD_cities_lecz.jpg", width = 7.5, height = 7.5, dpi = 300)

# plot land use 1992-2015 ------------------------------------------------------

head(stmatrix)

## 1992

lctot1992 <- stmatrix %>%
  group_by(y1992) %>%
  count()

lctot1992$norm <- round(lctot1992$n/sum(lctot1992$n),4)*100

lctot1992 <- lctot1992 %>%
mutate(n2 = as.integer(norm),
       n3 = as.integer(round(norm)),
       n4 = n3-norm)
       
lctot1992$n5 <- ifelse(lctot1992$n4==max(lctot1992$n4), lctot1992$n3-1, lctot1992$n3)
  
sum(lctot1992$n5)

## 2015

lctot2015 <- stmatrix %>%
  group_by(y2015) %>%
  count()

lctot2015$norm <- round(lctot2015$n/sum(lctot2015$n),4)*100

lctot2015 <- lctot2015 %>%
  mutate(n2 = as.integer(norm),
         n3 = as.integer(round(norm)),
         n4 = n3-norm)

lctot2015$n5 <- ifelse(lctot2015$n4==max(lctot2015$n4), lctot2015$n3-1, lctot2015$n3)

sum(lctot2015$n3)

library(waffle)

pal <- c("#bd4d44","#c18e3a", "#83a442", "#965baa","#407c2e","#59ca94")

pal <- c("#c14e55",
         "#a8aa3d",
         "#62ab85",
         "#c7924a",
         "#5b5e32",
         "#5ca0b7",
         "#5ca0b7")
  
labels <- c("urban areas", "agriculture (cropland)",
            "agriculture (irrigated)", "grassland",
            "forest","forest (wetland)","water")

  
p1 <- ggplot(lctot1992, aes(fill=y1992, values=n5))+
  geom_waffle(n_rows = 10, size=5, colour="white", flip= T, radius = unit(0.25, "npc"))+
  scale_fill_manual(name = NULL,
                    values = pal,
                    labels = labels)+
  coord_equal()+
  theme_prd()+
  labs(title="Land Cover distribution",
       subtitle = "1992")+
  theme(legend.position = "bottom",
        axis.line = element_blank(),
        axis.line.y = element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank())
  
#plot waffle 2015

p2 <- ggplot(lctot2015, aes(fill=y2015, values=n3))+
  geom_waffle(n_rows = 10, size=5, colour="white", flip= T, radius = unit(0.25, "npc"))+
  scale_fill_manual(name = NULL,
                    values = pal,
                    labels = labels)+
  coord_equal()+
  theme_prd()+
  labs(title="Land Cover distribution",
       subtitle = "2015")+
  theme(legend.position = "bottom",
        axis.line = element_blank(),
        axis.line.y = element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank())

ggsave("fig_output/03a_lc_distr_1992.jpg", p1, width = 7.5, height = 7.5, dpi = 300)
ggsave("fig_output/03a_lc_distr_2015.jpg", p2, width = 7.5, height = 7.5, dpi = 300)

# plot in grid (in progress)
grid.arrange(p1, p2, ncol = 2)


# plot urbanization trends------------------------------------------------------

# Function to transform numeric values to 0 if they are not equal to 1
transform_values <- function(df) {
  for (col in names(df)) {
    if (is.numeric(df[[col]])) {
      df[[col]][df[[col]] != 1] <- 0
    }
  }
  return(df)
}

# Apply the function to the dataframe
st_urb <- transform_values(stmatrix)

st_urb <- st_urb %>%
  group_by(city) %>%
  summarise(across(where(is.numeric), sum)) %>%
  dplyr::select(-c(2, 3)) %>%
  melt()

df_labs_start <- st_urb %>%
  filter(variable == 'y1992')

df_labs_end <- st_urb %>%
  filter(variable == 'y2015')

labels = seq(1992, 2015, 1)

ggplot(st_urb, aes(variable, value, group = city))+
  geom_line(linewidth=0.25, colour = "#31443e")+
  geom_point(size=.75, colour = "#31443e")+
  geom_text(data = df_labs_start, aes(x= variable, y=value, label = city),
            hjust=1, vjust=0.5, nudge_x = -.5, size =2, check_overlap = T)+
  geom_text(data = df_labs_end, aes(x=variable, y=value, label = city),
            hjust=0, vjust=0.5, nudge_x = .5, size =2, check_overlap = T)+
  labs(title="Urbanization in the PRD",
       subtitle = "number of cells")+
  scale_x_discrete(labels = labels,
                   expand = c(.15, .15))+
  theme_prd()+
  theme(axis.text.x = element_text(angle = 90, hjust = 0))

ggsave("fig_output/04_urb_temp.jpg", width = 7.5, height = 7.5, dpi = 300)  

st_urb <- transform_values(stmatrix)

st_urb <- st_urb %>%
  group_by(city, AB) %>%
  summarise(across(where(is.numeric), sum)) %>%
  dplyr::select(-c(3, 4)) %>%
  melt()

st_urb$value <- ifelse(st_urb$AB == 'below', st_urb$value*-1, st_urb$value)

ABstats <- merge(x = ABstats, y = cities_df, by.x = "city", by.y = "NAME_2", all = TRUE)

colors = c("#c6ccc2","#31443e")
brks <- seq (-10, 10, 5)
lbls <- c(10,5,0,5,10)
labels = seq(1992, 2015, 1)

ggplot(st_urb, aes(variable, value/1000, fill=AB)) +
  geom_bar(stat = "identity", width = 0.5) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) + 
  coord_flip()+
  facet_wrap(~ city, nrow = 3)+
  labs(title="Number of cells in LECZ by municipality",
       subtitle="(x1000)",
       y = "number of cells",
       fill = "LECZ")+
  scale_fill_manual(values=colors,
                    labels=c("no LECZ", "LECZ"))+
  scale_y_continuous(limits = c(-12, 12),breaks = brks, labels=lbls)+
  scale_x_discrete(labels = labels)+
  theme_prd()+
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        legend.position = c(0.85,0.05),
        legend.title = element_blank(),
        legend.background = element_rect(fill="white", colour="white"),
        axis.title.y = element_blank(),
        axis.text.y = element_text(size=3))+
  guides(fill = guide_legend(reverse = TRUE))

ggsave("fig_output/05_urb_city_lecz.jpg", width = 7.5, height = 7.5, dpi = 300) 
  
