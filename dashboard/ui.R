ui <- dashboardPage(
  dashboardHeader(title = "Scheepvaartongevallen rapportage"),
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Niet Significante ongevallen", tabName = "niet_sign", icon = icon("ship")),
      menuItem("Significante ongevallen", tabName = "sign", icon = icon("flash"))
      
    )
    
    #a(br(),href="mailto:martijn.koole@rws.nl",icon("info-circle"),"Martijn Koole")
  ),
  
  
  dashboardBody(
    tabItems(
      # First tab content

      
      tabItem(tabName = "niet_sign",
              h3("Visualisatie"),
              p("Deze tool geeft analyseresultaten van scheepvaartongevallen, interactief weergegeven in grafiekvorm en op een kaart"),
              box(
                h5("Scheepvaartongevallen (totaal)"),
                plotOutput("plot1"),
                h5("Scheepvaartongevallen per regio"),
                plotOutput("plot2")),
              box(
                selectInput("beheerder","Nautisch Beheerder:",choices=beheerders, selected="Alle"),
                selectInput("jaar","Jaar: ",choices = jaren,selected = "Alle"),
                leafletOutput("map")),
              box(
                #dataTableOutput('table1')
                tableOutput("table1")
              ),
              
              
              a(href="mailto:martijn.koole@rws.nl",icon("info-circle"),"Martijn Koole")
      
      ),
      tabItem(tabName = "sign",
              h3("Visualisatie"),
              p("Deze tool geeft analyseresultaten van scheepvaartongevallen, interactief weergegeven in grafiekvorm en op een kaart"),
              box(
                h5("Scheepvaartongevallen (totaal)"),
                plotOutput("plot3"),
                h5("Scheepvaartongevallen per regio"),
                plotOutput("plot4")),
              box(
                selectInput("beheerder2","Nautisch Beheerder:",choices=beheerders, selected="Alle"),
                selectInput("jaar2","Jaar: ",choices = jaren,selected = "Alle"),
                leafletOutput("map2")),
              box(
                #dataTableOutput('table1')
                tableOutput("table2")
              ),
              
              
              a(href="mailto:martijn.koole@rws.nl",icon("info-circle"),"Martijn Koole")
      )
    )
  )
)

