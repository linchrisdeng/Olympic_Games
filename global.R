library(tidyverse)
library(DT)
athlete = read_csv("Datasets/athlete_events.csv")
# athlete$Year = as.numeric(athlete$Year)
athlete$Medal = ifelse(is.na(athlete$Medal), "other", athlete$Medal)

region = read_csv("Datasets/noc_regions.csv")
athlete_w_region = athlete%>%left_join(region,by=c("NOC"="NOC")) 

athlete_w_region1 = athlete_w_region%>% 
                            filter(Height > 0, Weight > 0, !is.na(Sport))

