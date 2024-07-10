# Part 4.2 // calculating stats ------------------------------------------------

# 0. import libraries ----------------------------------------------------------

library(ggalluvial)
library(dplyr)


# 1. LCC sankey plot -----------------------------------------------------------

stmatrix <- read.csv(here("data_output/02_stmatrix.csv"))

head(stmatrix)


df <- stmatrix %>%
  dplyr::select(city,y1992,y2015)%>%
  group_by(city, y1992,y2015)%>%
  count()

df

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

ggplot(df,
       aes(axis1 = y1992, axis2 = y2015, y=n))+
  geom_alluvium(aes(fill=as.factor(y1992)),
                curve_type = "quintic", width = 1/12, alpha = .5)+
  geom_stratum(size = 0, color="white", width = 1/12, alpha = .95,
              aes(fill = after_stat(stratum)))+
  labs(title="Land Cover Change flow",
       subtitle = "1992-2015")+
  scale_x_discrete(limits = c("y1992","y2015"),
                   expand = c(.75, .05),
                   labels = c(1992,2015)) +
  scale_fill_manual(values = pal,
                    labels=labels)+
  theme_prd()+
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.key.size = unit(0.5,"lines"),
        axis.line = element_blank(),
        axis.line.y = element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        axis.text.y=element_blank(),
        axis.title.y = element_blank())


ggsave("fig_output/06_LCC_sankey.jpg", width = 7.5, height = 7.5, dpi = 300)

# 2. transition matrix ---------------------------------------------------------

df <- stmatrix %>%
  dplyr::select(y1992,y2015)

df

transition_matrix <- table(df)

print(transition_matrix)

transition_matrix_normalized <- round(prop.table(transition_matrix, 1),4)

print(transition_matrix_normalized)

tmn_df <- as.data.frame(transition_matrix_normalized)

tmn_df

labels <- c("uas", "agr/crop",
            "agr/irr", "grass",
            "for","for/w","wat")

ggplot(tmn_df, aes(x =factor(y2015), y=rev(factor(y1992)), fill= Freq)) + 
  geom_tile(color = "white",
            lwd = 1.5,
            linetype = 1)+
  labs(title="Transition matrix",
       subtitle="1992-2015")+
  geom_text(aes(label=round(Freq,3)),color = "white", size = 3)+
  scale_fill_gradientn(colors = c("#c6ccc2","#82837b","#31443e","#382920"
                                  ), 
                       values = scales::rescale(c(0, 0.05,0.25, 0.75, 1)), 
                       breaks = c(0, 0.5, 1))+
  scale_x_discrete(labels=labels, position = "top")+
  scale_y_discrete(labels=rev(labels))+
  theme_prd()+
  xlab("land cover 2015")+
  ylab("land cover 1992")+
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        panel.grid = element_blank()
          )+
  coord_equal()

ggsave("fig_output/07_trans_m.jpg", width = 7.5, height = 7.5, dpi = 300)

write.csv(transition_matrix_normalized, "data_output/04_transition_matrix.csv", row.names=TRUE)
