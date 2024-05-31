library(ggalluvial)

stmatrix <- read.csv(here("data_output/02_stmatrix.csv"))
head(stmatrix)


df <- stmatrix %>%
  select(city,y1992,y2015)%>%
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
  


