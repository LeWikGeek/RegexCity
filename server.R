#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$carte <- renderPlot({
    
    input$Trace
    isolate({
    plot(FranceFormes, main="Carte de la France", border = 3, bg="darkblue")
    
     # 
    
    test <- input$regex
    # et ensuite une condition sur le regex
    # test <- case_when(
    #           "1" %in% input$debutfin, test == paste0("^", test),
    #           "3" %in% input$debutfin, test == paste0(test, "$"))
            
    
    indice <- grep(test, NAME)  
    #indice <- grep(input$regex, NAME)
    
    plot(CNE[indice,],col="white", lwd=2, border= "white", add=T)
    })
    
    
  })
  }
