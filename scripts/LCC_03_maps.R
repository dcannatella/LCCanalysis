# Part 3 // plotting maps ------------------------------------------------------

# 0. import libraries ----------------------------------------------------------

# 1. set color palettes and labels ---------------------------------------------

pal <- c("#c14e55",
         "#a8aa3d",
         "#62ab85",
         "#c7924a",
         "#5b5e32",
         "#757cad",
         "#93b2b9")

labels <- c("urban areas", "agriculture (cropland)",
            "agriculture (irrigated)", "grassland",
            "forest","forest (wetland)","water")

# 2. Create custom themes-------------------------------------------------------

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


# 3. plot LCC maps -------------------------------------------------------------

df <- read.csv("data_output/02_stmatrix.csv")


ggplot()+
  geom_raster(data=df, aes(x=long, y=lat, fill=factor(y1992)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Land Cover - 1992")+
  scale_fill_manual(values = pal,
                    labels=labels)


ggsave("fig_output/m01a_LCC_1992.jpg", width = 7.5, height = 7.5, dpi = 300)


ggplot()+
  geom_raster(data=df, aes(x=long, y=lat, fill=factor(y2015)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Land Cover - 2015")+
  scale_fill_manual(values = pal,
                    labels=labels)


ggsave("fig_output/m01a_LCC_2015.jpg", width = 7.5, height = 7.5, dpi = 300)


# 2. plot urbanization maps ----------------------------------------------------

for (i in 7:ncol(df)) {
  df[[i]][df[[i]] != 1] <- 0
  
}

df

pal = c("#c6ccc2","#31443e") #,"#82837b","#382920")
labs = c("PRD", "Urbanized areas")

ggplot()+
  geom_raster(data=df, aes(x=long, y=lat, fill=factor(y1992)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 1992")+
  scale_fill_manual(values = pal,
                    labels=labs)

ggsave("fig_output/m02a_UA_1992.jpg", width = 7.5, height = 7.5, dpi = 300)

ggplot()+
  geom_raster(data=df, aes(x=long, y=lat, fill=factor(y1995)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 1995")+
  scale_fill_manual(values = pal,
                    labels=labs)


ggsave("fig_output/m02a_UA_1995.jpg", width = 7.5, height = 7.5, dpi = 300)


ggplot()+
  geom_raster(data=df, aes(x=long, y=lat, fill=factor(y2000)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 2000")+
  scale_fill_manual(values = pal,
                    labels=labs)


ggsave("fig_output/m02a_UA_2000.jpg", width = 7.5, height = 7.5, dpi = 300)

ggplot()+
  geom_raster(data=df, aes(x=long, y=lat, fill=factor(y2005)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 2005")+
  scale_fill_manual(values = pal,
                    labels=labs)

ggsave("fig_output/m02a_UA_2005.jpg", width = 7.5, height = 7.5, dpi = 300)


ggplot()+
  geom_raster(data=df, aes(x=long, y=lat, fill=factor(y2010)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 2010")+
  scale_fill_manual(values = pal,
                    labels=labs)

ggsave("fig_output/m02a_UA_2010.jpg", width = 7.5, height = 7.5, dpi = 300)


ggplot()+
  geom_raster(data=df, aes(x=long, y=lat, fill=factor(y2015)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 2015")+
  scale_fill_manual(values = pal,
                    labels=labs)

ggsave("fig_output/m02a_UA_2015.jpg", width = 7.5, height = 7.5, dpi = 300)

# ------------------------------------ END PART 3 ------------------------------
