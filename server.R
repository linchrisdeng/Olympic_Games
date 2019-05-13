library(shinydashboard)
library(shiny)
library(rbokeh)
library(highcharter)
library(DT)
library(viridisLite)
library(treemap)
library(wordcloud)
function(input, output, session){
  
  ## Welcome!
  output$datatable = DT::renderDT(athlete, options = list(pageLength = 5))
  
  output$str = renderPrint(glimpse(athlete))
  
  output$summary = renderPrint(summary(athlete))
  
  
  ## Distribution
  ## Year
  
  # observeEvent(
  #   input$season0,{
  #   updatePickerInput(session = session, "year0",
  #                     choices = sort(unique(athlete_w_region1$Year[athlete_w_region1$Season %in% input$season0]),decreasing = TRUE))}
  #   )
  

  yeardata = reactive(athlete_w_region1 %>% 
                        filter(region %in% input$region0, Season == input$season0) %>%
                        group_by(Year, region) %>% 
                        summarise(Mean = round(mean(!! rlang::sym(input$characteristic0)), digits = 2), 
                                  Medium = round(median(!! rlang::sym(input$characteristic0)), digits = 2))
                      )
  
  
  output$yearvis = renderHighchart({
      hchart(yeardata(), "line", hcaes(x = Year, y = !! rlang::sym(input$attribute0), group = region)) %>%
      hc_add_theme(hc_theme_flat())
    })
  
  
  ## Characteristic
  dist_1 = reactive(athlete_w_region1 %>% 
                      filter(Sex %in% input$sex, region %in% input$region, Sport %in% input$sport, Medal %in% input$medal, Year %in% input$year))
  
  ## pairwith actionButton
  # mydata = eventReactive(input$show,
  #                        {dist_1()})
  
  output$distribution = renderHighchart({
    ## easy way to plot without legend
    # hc = tapply(mydata()[[input$target]], mydata()$region, density) %>%
    #   reduce(.f = hc_add_series, .init = highchart())
    
    ds <- map(unique(dist_1()$region), function(x){
      dt <- density(dist_1()[[input$target]][dist_1()$region %in% x])[1:2]
      dt <- list_parse2(as.data.frame(dt))
      list(data = dt, name = x)
    })
    
    highchart() %>% 
      hc_add_series_list(ds) %>% 
      hc_add_theme(hc_theme_elementary())
    
    ## With actionButton
    # ds <- map(unique(mydata()$region), function(x){
    #   dt <- density(mydata()[[input$target]][mydata()$region == x])[1:2]
    #   dt <- list_parse2(as.data.frame(dt))
    #   list(data = dt, name = x)
    # })
    # 
    # highchart() %>% 
    #   hc_add_series_list(ds) 
  })
  
  ## Sport
    sport_1 = reactive(athlete_w_region %>% 
                         filter(Sex == input$sex2, region %in% input$region2, Medal %in% input$medal2,
                                Season %in% c(input$season2), Year %in% c(input$year2)))
    output$treemap = renderHighchart({
      df2 <- sport_1() %>%
        group_by(Sport) %>%
        summarise(n = n(), unique = length(unique(ID))) 
      # %>%
      #   arrange(-n, -unique)
      # hchart(df2, "treemap", hcaes(x = Sport, value = n, color = unique))
      tm <- treemap(df2, index = "Sport",
                    vSize = "n", vColor = "unique",
                    type = "value", palette = viridis(length(unique(df2$Sport)), alpha = 0.6, option = sample(c('A', 'B', 'C', 'D', 'E'), 1)))
      hctreemap(tm)
      })
    
    
 ## Medal Map
    # map1data = reactive(athlete_w_region %>% group_by(Season, NOC) %>% 
    #           count(Medal) %>% filter(Medal %in% input$medal3, Season %in% input$season3))
    ## pairwith actionButton
    mapdata = eventReactive(input$show,{
      athlete_w_region %>% group_by(Season, NOC) %>% 
        count(Medal) %>% filter(Medal %in% input$medal3, Season %in% input$season3) %>% mutate(Total = sum(n))
      })
    output$map1 = renderHighchart({
      
      hcmap("custom/world-highres2", data = mapdata(), value = "Total", 
            joinBy = c("iso-a3", "NOC"), name = paste0(unique(mapdata()$Medal), "_Medal"),
            dataLabels = list(enabled = TRUE, format = '{point.name}'),
            borderColor = "#191919", borderWidth = 0.1,
            tooltip = list(valueDecimals = 0, valuePrefix = NULL)) %>%
         
        hc_colorAxis(dataClasses = color_classes(c(seq(0, 300, by = 20), 2500))) %>% 
        hc_legend(layout = "vertical", align = "right",
                  floating = FALSE, valueDecimals = 0) 
    })
    clouddata = reactive(sample(athlete$Name, input$samplesize, replace = FALSE))
    output$wordcloudplot = renderPlot({
      wordcloud(clouddata(), scale = c(4, 0.5),
                min.freq = input$freq, 
                max.words=input$max,
                colors=brewer.pal(8, "Dark2"))
    })

  
}