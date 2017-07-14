

server <- function(input, output) {
  
  #create dataset based on filters NIET SIGNIFICANT
  data<- reactive({
    if(input$beheerder == "Alle" & input$jaar == "Alle" ){
      sch_niet_sig[which(sch_niet_sig$NAUTISCH_BEHEERDER %in% beheerders2),]
    }
    else if (input$beheerder != "Alle" & input$jaar == "Alle"){
    sch_niet_sig[which(sch_niet_sig$NAUTISCH_BEHEERDER %in% input$beheerder),]
      }
    else if (input$beheerder == "Alle" & input$jaar != "Alle"){
      sch_niet_sig[which(sch_niet_sig$NAUTISCH_BEHEERDER %in% beheerders2 & 
                           sch_niet_sig$JAAR_VOORVAL %in% input$jaar),]
      }
    else {
      sch_niet_sig[which(sch_niet_sig$NAUTISCH_BEHEERDER %in% input$beheerder & 
                           sch_niet_sig$JAAR_VOORVAL %in% input$jaar),]
    }
    
  })

  ##Plot analysetab
  output$plot1 <- renderPlot({
    dat<-as.data.frame(sch_niet_sig[which(sch_niet_sig$NAUTISCH_BEHEERDER %in% beheerders2),])
    ggplot(dat,aes(x=as.factor(JAAR_VOORVAL)))+
      geom_histogram(stat="count")+xlab("Jaar")
  })
  output$plot2 <- renderPlot({
    dat<-as.data.frame(sch_niet_sig[which(sch_niet_sig$NAUTISCH_BEHEERDER %in% beheerders),])
    ggplot(dat,aes(x=as.factor(JAAR_VOORVAL),fill=NAUTISCH_BEHEERDER))+
      geom_histogram(stat="count")+facet_wrap(~NAUTISCH_BEHEERDER)+theme(legend.position = "none")+xlab("Jaar")
  })
  
  ###leaflet
  output$map <- renderLeaflet({
    
    #dat<- as.data.frame(data())
    #pal <- colorpal()
    pal <- colorNumeric(
      palette = "Spectral",
      c(2008:2017)
    )
    dat<- data()[order(data()$JAAR_VOORVAL),]
    leaflet() %>%
      addProviderTiles("CartoDB.Positron"
      ) %>%
      setView(lng = 5, lat = 52.2, zoom = 7) %>%
      clearShapes() %>%
      addCircles(data=dat, weight=5,color =  ~pal(JAAR_VOORVAL),#"#777777",
                 fillColor = ~pal(JAAR_VOORVAL), fillOpacity = 0.7, popup = ~paste("Voorvalnummer:",VOORVALNUMMER, "<br>",
                                                                                   "Datum ongeval:",DATUM_ONGEVAL,"<br>",
                                                                                   "Aantal schepen:",AANTAL_SCHEPEN,"<br>",
                                                                                   "Aard voorval:",AARD_VOORVAL_OMSCHRIJVING
                                                                                  )
                 ) %>%
      addLegend("bottomright", pal = pal, values = c(2008:2017),
                title = "Jaar voorval",
                labFormat = labelFormat(big.mark=""),
                opacity = 1
      )
    
    
  })
  data3<- reactive({
    if (input$jaar =="Alle"){
      aggregate(cbind(`Licht gewond`,`Zwaar gewond`,`Gewond Overig`,Vermist,Dood) ~ Jaar,data=Gewonden_per_jaar_niet_sign,FUN="sum")
    }
    else {

      Gewonden_per_jaar_niet_sign[which(Gewonden_per_jaar_niet_sign$Jaar %in% input$jaar),]
    }
    
  })
  

  output$table1 <- renderTable({
    data3()},
    spacing="s",digits = 0
    
  )
  
  
  ######Leaflet 2 tab###### (significant)
  
  #create dataset2 based on filters SIGNIFICANT
  data2<- reactive({
    if(input$beheerder2 == "Alle" & input$jaar2 == "Alle"){
      sch_sig[which(sch_sig$NAUTISCH_BEHEERDER %in% beheerders2),]
    }
    else if (input$beheerder2 != "Alle" & input$jaar2 == "Alle"){
      sch_sig[which(sch_sig$NAUTISCH_BEHEERDER %in% input$beheerder2),]
    }
    else if (input$beheerder2 == "Alle" & input$jaar2 != "Alle"){
      sch_sig[which(sch_sig$NAUTISCH_BEHEERDER %in% beheerders2 & 
                      sch_sig$JAAR_VOORVAL %in% input$jaar2),]
    }
    else {
      sch_sig[which(sch_sig$NAUTISCH_BEHEERDER %in% input$beheerder2 & 
                      sch_sig$JAAR_VOORVAL %in% input$jaar2),]
    }
    
  })
  
  ##Plot analysetab
  output$plot3 <- renderPlot({
    dat<-as.data.frame(sch_sig[which(sch_sig$NAUTISCH_BEHEERDER %in% beheerders),])
    ggplot(dat,aes(x=as.factor(JAAR_VOORVAL)))+
      geom_histogram(stat="count")+xlab("Jaar")
  })
  output$plot4 <- renderPlot({
    dat<-as.data.frame(sch_sig[which(sch_sig$NAUTISCH_BEHEERDER %in% beheerders),])
    ggplot(dat,aes(x=as.factor(JAAR_VOORVAL),fill=NAUTISCH_BEHEERDER))+
      geom_histogram(stat="count")+facet_wrap(~NAUTISCH_BEHEERDER)+theme(legend.position = "none")+xlab("Jaar")
  })
  
  output$map2 <- renderLeaflet({
    
    pal <- colorNumeric(
      palette = "Spectral",
      c(2008:2017)
    )
    dat<- data2()[order(data2()$JAAR_VOORVAL),]
    leaflet() %>%
      addProviderTiles("CartoDB.Positron"
      ) %>%
      setView(lng = 5, lat = 52.2, zoom = 7) %>%
      clearShapes() %>%
      addCircles(data=dat, weight=5,color =  ~pal(JAAR_VOORVAL),#"#777777",
                 fillColor = ~pal(JAAR_VOORVAL), fillOpacity = 0.7, popup = ~paste("Voorvalnummer:",VOORVALNUMMER, "<br>",
                                                                                   "Datum ongeval:",DATUM_ONGEVAL,"<br>",
                                                                                   "Aantal schepen:",AANTAL_SCHEPEN,"<br>",
                                                                                   "Aard voorval:",AARD_VOORVAL_OMSCHRIJVING
                 )
      ) %>%
      addLegend("bottomright", pal = pal, values = c(2008:2017),
                title = "Jaar voorval",
                labFormat = labelFormat(big.mark=""),
                opacity = 1
      )
    
    
  })

  data4<- reactive({
    if (input$jaar2 =="Alle"){
      aggregate(cbind(`Licht gewond`,`Zwaar gewond`,`Gewond Overig`,Vermist,Dood) ~ Jaar,data=Gewonden_per_jaar_sign,FUN="sum")
    }
    else {

    Gewonden_per_jaar_sign[which(Gewonden_per_jaar_sign$Jaar %in% input$jaar2),]
    }
  })

  # output$table1 <- renderDataTable({
  #   datatable(data3())
  # })
  output$table2 <- renderTable({
    data4()
  },
  spacing = "s", digits = 0
  )
}