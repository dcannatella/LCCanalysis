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


# 2. plot LCC maps -------------------------------------------------------------

ggplot()+
  geom_raster(data=coord_WGS04, aes(x=x, y=y, fill=factor(y1992)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Land Cover - 1992")+
  scale_fill_manual(values = pal,
                    labels=labels)


ggsave("fig_output/m01a_LCC_1992.jpg", width = 7.5, height = 7.5, dpi = 300)


ggplot()+
  geom_raster(data=coord_WGS04, aes(x=x, y=y, fill=factor(y2015)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Land Cover - 2015")+
  scale_fill_manual(values = pal,
                    labels=labels)


ggsave("fig_output/m01a_LCC_2015.jpg", width = 7.5, height = 7.5, dpi = 300)


# 2. plot urbanization maps ----------------------------------------------------

df <- coord_WGS04

for (i in 3:ncol(df)) {
  df[[i]][df[[i]] != 1] <- 0
  
}

df

pal = c("#c6ccc2","#31443e") #,"#82837b","#382920")
labs = c("PRD", "Urbanized areas")

ggplot()+
  geom_raster(data=df, aes(x=x, y=y, fill=factor(y1992)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 1992")+
  scale_fill_manual(values = pal,
                    labels=labs)

ggsave("fig_output/m02a_UA_1992.jpg", width = 7.5, height = 7.5, dpi = 300)

ggplot()+
  geom_raster(data=df, aes(x=x, y=y, fill=factor(y1995)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 1995")+
  scale_fill_manual(values = pal,
                    labels=labs)


ggsave("fig_output/m02a_UA_1995.jpg", width = 7.5, height = 7.5, dpi = 300)


ggplot()+
  geom_raster(data=df, aes(x=x, y=y, fill=factor(y2000)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 2000")+
  scale_fill_manual(values = pal,
                    labels=labs)


ggsave("fig_output/m02a_UA_2000.jpg", width = 7.5, height = 7.5, dpi = 300)

ggplot()+
  geom_raster(data=df, aes(x=x, y=y, fill=factor(y2005)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 2005")+
  scale_fill_manual(values = pal,
                    labels=labs)

ggsave("fig_output/m02a_UA_2005.jpg", width = 7.5, height = 7.5, dpi = 300)




ggplot()+
  geom_raster(data=df, aes(x=x, y=y, fill=factor(y2010)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 2010")+
  scale_fill_manual(values = pal,
                    labels=labs)

ggsave("fig_output/m02a_UA_2010.jpg", width = 7.5, height = 7.5, dpi = 300)


ggplot()+
  geom_raster(data=df, aes(x=x, y=y, fill=factor(y2015)))+
  coord_quickmap()+
  theme_prd_map()+
  labs(title="Urbanized areas in 2015")+
  scale_fill_manual(values = pal,
                    labels=labs)

ggsave("fig_output/m02a_UA_2015.jpg", width = 7.5, height = 7.5, dpi = 300)

# ------------------------------------ END PART 3 ------------------------------
