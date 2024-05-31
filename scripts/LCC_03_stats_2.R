library(ggalluvial)
library(dplyr)

stmatrix <- read.csv(here("data_output/02_stmatrix.csv"))
head(stmatrix)


df <- stmatrix %>%
  dplyr::select(city,y1992,y2015)%>%
  group_by(city, y1992,y2015)%>%
  count()

df

pal <- c("#bd4d44","#c18e3a", "#83a442", "#965baa","#407c2e","#59ca94", "#59ca94")

ggplot(df,
       aes(axis1 = y1992, axis2 = y2015, y=n))+
  geom_alluvium(aes(fill=as.factor(y1992)),
                curve_type = "quintic", width = 1/12)+
  geom_stratum(size = 0, color="white", width = 1/12, alpha = .5,
               aes(fill = after_stat(stratum)))+
  #geom_text(stat = "stratum",
            #aes(label = after_stat(stratum))) +
  scale_x_discrete(limits = c("y1992","y2015"),
                   expand = c(.75, .05)) +
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
        axis.text.y=element_blank())


# transition matrix ------------------------------------------------------------

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
  geom_text(aes(label=round(Freq,3)),color = "white", size = 3)+
  scale_fill_gradientn(colors = c("#c6ccc2","#82837b","#31443e","#382920"
                                  ), 
                       values = scales::rescale(c(0, 0.05,0.25, 0.75, 1)), 
                       breaks = c(0, 0.5, 1))+
  scale_x_discrete(labels=labels)+
  scale_y_discrete(labels=rev(labels))+
  theme_prd()+
  xlab("land cover 2015")+
  ylab("land cover 1992")+
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.key.height = unit(0.05,"npc") 
          )

