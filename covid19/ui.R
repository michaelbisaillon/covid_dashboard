


shinyUI(
  navbarPage("Covid-19 dashboard",
             theme = bslib::bs_theme(bootswatch = "darkly"),
             tabPanel(" ",
                      fluidRow(
                        column(2,
                               #wellPanel(
                                 selectInput("etat_select", width="90%",
                                             "1. Select a country", 
                                             multiple = FALSE,
                                             selected = "Canada",
                                             choices = sort(unique(base$administrative_area_level_1)))
                               #)
                        ),
                        column(2,
                               #wellPanel(
                                 selectInput("region_select", width="90%",
                                             "2. Select an administrative area", 
                                             multiple = TRUE,
                                             choices = NULL
                                             )
                               #)
                        ),
                        column(3,
                               #wellPanel(
                                 selectInput("variable_select", width="90%",
                                             "3. Select a variable", 
                                             selected = "confirmed",
                                             multiple = FALSE,
                                             choices = c("confirmed", "deaths", "recovered", "tests", "cases"))
                                             #choices = c(names(base)))
                               #)
                        ),
                        column(5,
                               #wellPanel(
                                 sliderInput("var_date", width="90%",
                                             min = min(base$date),
                                             max = max(base$date),
                                             value = c(min(base$date), max(base$date)),
                                             ticks = TRUE,
                                             label = "4. Select a date range")
                               #)
                        ),
                        #column(2,
                         #      DTOutput("summary_table", height = 200)
                        #)
                        
                        
                      ),
                      fluidRow(
                        column(5, 
                               tags$style(type = "text/css", "#distPlot2 {height: calc(40vh - 80px) !important;}"), 
                               plotOutput("distPlot2")
                        ),
                        column(5,
                               tags$style(type = "text/css", "#boxPlot2 {height: calc(40vh - 80px) !important;}"), 
                               plotOutput("boxPlot2")
                        ),
                        column(2,
                               tags$br(),
                               tags$style(type = "text/css", "#summary_table {height: calc(44vh - 90px) !important;}"), 
                               div(DT::dataTableOutput("summary_table"), style = "font-size: 90%")
                        ),
                      ),
                      fluidRow(
                        column(12,
                               tags$br(),
                               tags$style(type = "text/css", "#loc_map {height: calc(45vh - 80px) !important;}"), 
                               leafletOutput("loc_map")
                        )
                        
                      ),
                      fluidRow(
                        column(12,
                               tags$h6("Source: Guidotti, E., Ardia, D., (2020), COVID-19 Data Hub, Journal of Open Source Software 5(51):2376, doi: 10.21105/joss.02376."
                               )
                        )
                      )
             )
  ))

