library(shinydashboard)
library(shiny)
library(dashboardthemes)
library(shinyWidgets)
library(highcharter)
library(DT)

logo_poor_mans_flatly <- shinyDashboardLogoDIY(
  boldText = "Olympics Games",
  mainText = NULL,
  textSize = 16,
  badgeText = NULL,
  badgeTextColor = "black",
  badgeTextSize = 2,
  badgeBackColor = "#40E0D0",
  badgeBorderRadius = 3
  )

header = dashboardHeader(
  title = logo_poor_mans_flatly,

  dropdownMenu(type = "messages",
               messageItem(
                 from = "Lin Deng",
                 message = "Learn more about Olympics",
                 href = "http://olympstats.com/"
               ))
)


sidebar = dashboardSidebar(
  shinyDashboardThemes(theme = 'poor_mans_flatly'),
  
  sidebarUserPanel(name = "LIN DENG",
                   subtitle = a(icon("thumbs-up"), "PUBH 7462"),
                   image = "https://cdn.iconscout.com/icon/premium/png-256-thumb/olympic-rings-4-629117.png"),
  
  sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                    label = "Search..."),
  sidebarMenu(
    menuItem("Welcome!",
             tabName = "welcome", icon = icon("home")),
    
    menuItem("Distribution", tabName = "dist", icon = icon("chart-bar"),
             menuItem("By Year", tabName = "byyear", icon = icon('calendar-alt')),
             menuItem("By Characteristic", tabName = "bytarget", icon = icon("child")),
             menuItem("By Sport", tabName = "bysport", icon = icon("dumbbell"))),
    menuItem("Map", 
             tabName = "map", icon = icon("globe"),
             menuItem("Medal Winners", tabName = 'medalwinner', icon = icon("medal"))),
    menuItem("Word Cloud", tabName = "wordcloud", icon = icon("cloudversify"))
  ),
  hr(),
  h5("Developed by ", 
           a("Lin Deng", href = "https://linkedin.com/in/lin-deng-280200137/"),
           style = "padding-left:1em; padding-right:1em;position:absolute; color: white"),
  br(),br(),
  h5("Built by",
     a(img(src = "https://wp-assets.highcharts.com/blog/wp-content/uploads/2017/08/28160952/highcharts_logo.png", height = "30px"),
       href = "https://api.highcharts.com/highcharts/"),
     style = "padding-left:1em; padding-right:1em;position:absolute; color: white",
     "and",
     a(img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
       href = "https://shiny.rstudio.com/")
     )
)  

body = dashboardBody(
  shinyDashboardThemes(theme = 'poor_mans_flatly'),
  
  tabItems(
    tabItem(
      tabName = "welcome",
      fluidRow(
        box(
          width = 12,
          title = NULL,
          status = "primary",
          includeMarkdown("md/introduction.md")
          )
        ),
      
      fluidRow(
        box(
          width = 7,
          div(style = 'overflow-x: scroll', DT::dataTableOutput("datatable", width = "100%")) 
          ),
        box(
          width = 5,
          tabBox(
            width = 12,
            height = NULL,
            title = "",
            tabPanel("STR", verbatimTextOutput('str')),
            tabPanel("Summary", verbatimTextOutput('summary')),
            tags$head(tags$style("#str{color:black; font-size:12px;; overflow-y:scroll; max-height: 500px; background: ghostwhite;}")),
            tags$head(tags$style("#summary{color:black; font-size:12px; overflow-y:scroll; max-height: 500px; background: ghostwhite;}"))
          )
        )
      )
      ),
    tabItem(
      tabName = "byyear",
      fluidRow(
        box(
          width = 3,
          status = "info",
          title = NULL,
          selectizeInput('season0', "Season", choices = unique(athlete_w_region$Season), selected = "Summer"),
          
          # pickerInput('year0', "Year", choices = "", multiple = TRUE, 
          #             options = pickerOptions(actionsBox = TRUE, selectAllText = "Select All", selectedTextFormat = 'count > 3')),
          
          pickerInput('region0', 'Region', choices = sort(unique(athlete_w_region1$region)), selected = c("USA", "China", "France", "Russia"), 
                      multiple = TRUE, options = pickerOptions(actionsBox = TRUE, selectedTextFormat = 'count > 3')),
          
          selectInput("attribute0", "Attribute", choices = c("Mean", "Medium"), selected = "Medium"),
          
          selectInput("characteristic0", "Characteristic", choices = c("Age", "Height", "Weight"))
        ),
        
        box(
          width = 9,
          status = "success",
          title = NULL,
          highchartOutput("yearvis")
        )
      )
    ),
    tabItem(
      tabName = "bytarget",
      fluidRow(
        box(
            width = 3,
            status = "warning",
            title =  NULL,
            selectizeInput('target', 'Characteristic', choices = c("Age", "Height", "Weight")),
            selectizeInput('sex', '1. Sex', choices = unique(athlete$Sex), multiple = TRUE, selected = "M"),
            # pickerInput('region', '2. Team', choices = sort(unique(athlete_w_region$region)), multiple = TRUE, selected = c("USA")),
            selectizeInput('sport', '4. Sport', choices = sort(unique(athlete$Sport)), selected = "Basketball"),
            multiInput('region', '2. Team', choices = sort(unique(athlete_w_region$region)), selected = c("USA", "China", "Argentina", "France")),
            sliderTextInput('year', "3. Year", choices = sort(unique(athlete$Year)), selected = c("2012", "2016"), grid = TRUE),
            
            pickerInput('medal', '5. Medal', choices = c("other", "Gold", "Silver", "Bronze"), multiple = TRUE, options = pickerOptions(actionsBox = TRUE), selected = c("other", "Gold", "Silver", "Bronze"))
            # ,
            # actionButton("show", "Show")
            ),
        box(
            width = 9,
            status = "warning",
            highchartOutput("distribution")
            )
          )
        ),
    tabItem(tabName = "bysport",
            fluidRow(
              box(
                width = 3,
                status = "warning",
                title = NULL,
                selectizeInput('region2', 'Region', choices = sort(unique(athlete_w_region$region)), selected = c("USA")),
                selectizeInput('season2', "Season", choices = unique(athlete_w_region$Season), selected = "Summer"),
                selectizeInput('sex2', "Sex", choices = unique(athlete$Sex), multiple = TRUE, selected = "M"),
                sliderTextInput('year2', "Year", choices = sort(unique(athlete$Year)), selected = c("2012", "2016"), grid = TRUE),
                pickerInput('medal2', 'Medal', choices = c("other", "Gold", "Silver", "Bronze"), multiple = TRUE, options = pickerOptions(actionsBox = TRUE), selected = c("other", "Gold", "Silver", "Bronze"))
              ),
              box(
                width = 9,
                status = "warning",
                highchartOutput("treemap")
                )
              )
            ),
    
    tabItem(
      tabName = "medalwinner",
      fluidRow(
        box(
          width = 3,
          status = "success",
          title = NULL,
          pickerInput('medal3', 'Medal', choices = c("Gold", "Silver", "Bronze"), multiple = TRUE, 
                      options = pickerOptions(actionsBox = TRUE), selected = c("Gold")),
          selectizeInput('season3', "Season", choices = unique(athlete_w_region$Season), selected = "Summer", multiple = TRUE),
          actionButton("show", "Show")
        ),
        box(
          width = 9,
          status = "success",
          highchartOutput("map1")
        )
      )
    ),
    
    tabItem(
      tabName = "wordcloud",
      fluidRow(
        box(
          width = 3,
          numericInput('samplesize', 
                       "Sample Size:", value = 10000),
          sliderInput("freq",
                      "Minimum Frequency:",
                      min = 1,  max = 50, value = 10),
          sliderInput("max",
                      "Maximum Number of Words:",
                      min = 1,  max = 300,  value = 200)
        ),
        box(
          width = 9,
          plotOutput("wordcloudplot")
        )
      )
    )
    
  

  )
  )

  
dashboardPage(title = "Olympics Games", header = header, sidebar = sidebar, body = body)