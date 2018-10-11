#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(leaflet)
library(ggmap)
library(rjson)
ui <- shinyUI(fluidPage(
  
  ## the area for title
  headerPanel(title = 'Simulated BaiduMap'),   
  
  ## plot the leaflet in the whole page
  leafletOutput(outputId = 'map',width = '1920px',height = '1080px'),
  
  ## control inputs panel and button
  absolutePanel(width = 430,top=200,left = 'auto',draggable = T,
                textInput(inputId = 'Loc',label = 'THE PLACE'),
                textInput(inputId = 'Start',label = 'FROM',width = "50%"),
                textInput(inputId = 'End',label = 'TO',width = "50%"),
                selectInput(inputId = 'selected',label = 'Route or Loc',
                            choices = c('Loc','Route'),selected = 'Loc',
                            multiple = F),
                textOutput(outputId = 'Request'),
                submitButton(text = "Submit")
  )
))