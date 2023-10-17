#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("CityMap"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(inputId = "debutfin",
                         label = "Choisissez",
                         selected = 3,
                         choices = c("Commence par" = 1, "Finit par" = 2, "Contient" = 3)),
      textInput(inputId = "regex",
                label = "Expression régulière"),
      actionButton(inputId ="Trace", 
                   label = "Situe les communes !")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      #plotOutput(FranceFormes, main="Carte de la France", border = 3, bg="darkblue")
      plotOutput("carte")
    )
  )
)
