#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

server <- shinyServer(function(input, output) {
  output$map <- renderLeaflet({
    m<- leaflet(mydata) %>%
    addProviderTiles(providers$CartoDB.Positron, options = providerTileOptions(noWrap = TRUE))%>%
    addCircles(
      lng=~MAR_LONGITUDE, # Longitude coordinates
      lat=~MAR_LATITUDE, # Latitude coordinates
      color=~pal(mydata$TYPE), # color circle by museum type
      
      # Popup content
      popup= paste("Museum Name:",mydata$NAME,"<br/>",
                   "Address:",mydata$MAR_MATCHADDRESS,"<br/>",
                   "Type:",mydata$MAR_MATCHADDRESS,"<br/>",
                   "Introduction:",mydata$FEATURES,"<br/>",
                   "To Learn More:",mydata$WEBSITE,"<br/>")
      
      
    )%>%
    addLegend(
      "bottomleft", # Legend position
      pal=pal, # color palette
      values=~mydata$TYPE, # legend values
      opacity = 1,
      title="Type of Museums")
  })
    
  
  ## acquire the coordinate from rjson file
  output$map <- renderLeaflet({
  getcoord <- function(x){## x is a name of some place
    x <- qmap(location=x)
    return(x)
  }
  
  ## output leaflet map to the id:map
    
    m <- m%>%addTiles()
    
    if(input$selected == 'Loc'){
      temp <- getcoord(input$Loc)
      if(temp$status!=0){
        output$Request <- renderText({
          c('The location failed to be found')
        })
        m
      }else{
        output$Request <- renderText({
          c('The location is found successfully')
        })
        m %>% addMarkers(lng=temp$result$location$lng,
                         lat=temp$result$location$lat,
                         popup = paste0(input$Loc,'--',temp$result$level))
      }
    }else{
      temp1 <- getcoord(input$Start)
      temp2 <- getcoord(input$End)
      if(temp1$status==0&temp2$status==0){
        output$Request <- renderText({
          c('Both start point and end point are valid')
        })
        route <- getRoute(input$Start,input$End)
        m%>%addPolylines(route$lon,route$lat)%>%
          addMarkers(lng=route$lon[c(1,nrow(route))],
                     lat=route$lat[c(1,nrow(route))],
                     popup = c(paste0(input$Start,'--',temp1$result$level),
                               paste0(input$End,'--',temp2$result$level)))
      }else{
        output$Request <- renderText({
          c('One or both of origin and destination is invalid')
        })
      }
    }
})
})
  