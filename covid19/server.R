

shinyServer(function(input, output, session) {
  thematic::thematic_shiny() #enable ggplot dark theme
  
  
  #-------------------------
  # filters
  #-------------------------
  
  #reactive etat filter
  etat_filter <- reactive({
    base <- base %>% filter(administrative_area_level_1 == input$etat_select) 
  }) 
  
  #update region from etat
  observeEvent(etat_filter(), {
    updateSelectInput(inputId = "region_select", choices = sort(unique(etat_filter()$administrative_area_level_2)),
                      selected = etat_filter()[1,]
    ) 
  })
  
  #filter region data from updated region
  region_filter <- reactive({
    req(input$region_select)
    base <- etat_filter() %>% filter(administrative_area_level_2 == input$region_select, 
                                    date >= as.Date(min(input$var_date)) & date <= as.Date(max(input$var_date)))
  }) 
  
  #filter variable data
  var_filter <- reactive({
    base <- region_filter() %>% st_drop_geometry() %>% select(input$variable_select, date)
  })
  
  
  
  
  #------------------------
  #visuals
  #------------------------
  
  
  output$distPlot2 <- renderPlot({
    
    ggplot(data = region_filter(), aes_string(x =  "date", y = input$variable_select, color = "administrative_area_level_2")) + 
      geom_line(size = 1) +
      theme_void() +
      labs(x = NULL, color = "Administrative area") +
      theme(axis.text.x = element_text(colour = "white", size = 12), axis.text.y = element_text(colour = "white", size = 12), text = element_text(colour = "white", size = 12)) +
      ggtitle(paste("Time series chart"))
  })
  
  output$boxPlot2 <- renderPlot({
    
    ggplot(data= region_filter(), aes_string(input$variable_select, color = "administrative_area_level_2")) +
      geom_boxplot() +
      theme_void() +
      theme(axis.text.x = element_text(colour = "white", size = 12), axis.text.y = element_blank(), text = element_text(colour = "white", size = 12)) +
      labs(x = NULL, color = "Administrative area") +
      ggtitle(paste("Box plot chart")) 
      #coord_flip()
  })
  
  
  
  #summary table
  output$summary_table <- DT::renderDT({
    
    req(input$region_select)
    
    summary_data <- data.frame(Mesure = unclass(summary(var_filter())), check.names = FALSE, stringsAsFactors = FALSE) %>% 
      remove_rownames() %>% select(1)
    
    summary_data <-  summary_data %>% 
      mutate_if(is.numeric, funs(round(Mesure, 0)))
    
    datatable(summary_data, class = 'cell-border stripe', rownames = FALSE,
                               colnames = c("Summary table"),
                               style = "bootstrap4", 
                               options = list(
                                 dom = 't')) 
  
    
  })
  
  
  #lealfet
  
  output$loc_map <- renderLeaflet({
    
    req(input$etat_select, input$region_select)
    
    leaflet(region_filter()) %>% 
      addProviderTiles(providers$CartoDB.DarkMatter) 
  })
  
  observe({
    
    etat <- region_filter()
    
    bbox <- etat %>% st_bbox(etat) %>% 
      as.vector()
    
    
    leafletProxy("loc_map", data = etat) %>% 
      clearMarkers() %>% 
      addCircleMarkers(color = "white", fillColor = "#03719C", fillOpacity = 1, opacity = 1, weight = 1,
                       popup = paste("<b>", etat$administrative_area_level_2, ", ", etat$administrative_area_level_1,"</b><br>",
                                     "Population: ", format(etat$population, big.mark = " "))) %>% 
      fitBounds(bbox[1], bbox[2], bbox[3], bbox[4], options = list(maxZoom = 5, amimate = FALSE))
    
  })
  
  
  
  
})
