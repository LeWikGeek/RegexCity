

##########
# Global #
##########


library(shiny)
library(tidyverse)

library(stringr)
library(sf)
library(sp)
library(cartography)
library(mapsf) # conseil au chargement le 02 04 22 - cartography est en maintenance
library(raster) # pour le get.data
#library(lwgeom)# Pour les étiquettes

# https://thinkr.fr/cartographie-interactive-avec-r-la-suite/ 

# Les cartes : 1 - les régions / 5 - les communes
Regions <- getData(name="GADM", country="FRA", level=1)
CNE <- getData(name="GADM", country="FRA", level=5)

NAME <- as.vector(CNE$NAME_5)

######
# UI #
######


ui <- fluidPage(

    # Application title
  titlePanel("CityMap"),
  
  # Sidebar  
  sidebarLayout(
    sidebarPanel(
      
      checkboxGroupInput(inputId = "region",
                         label = "Région (s)",
                         selected = 14,
                         choices = c("Auvergne-Rhône-Alpes" = 1, "Bourgogne-Franche-Comté" = 2, "Bretagne" = 3,
                                     "Centre-Val de Loire" = 4, "Corse" = 5, "Grand-Est" = 6, "Hauts-de-France" = 7,
                                     "Ile-de-France" = 8, "Normandie" = 9, "Nouvelle-Aquitaine" = 10,
                                     "Occitanie" = 11, "Pays de la Loire" = 12, "Provence-Alpes-Côte d'Azur" = 13,
                                     "FRANCE ENTIERE" = 14)),
      
      checkboxGroupInput(inputId = "debutfin",
                         label = "Choisissez",
                         selected = 3,
                         choices = c("Commence par" = 1, "Finit par" = 2, "Expression régulière" = 3)),
     
       textInput(inputId = "regex",
                label = ""),
      
      actionButton(inputId ="Trace", 
                   label = "Situe les communes !")
    ),
    
    # Show a plot of the generated plot
    mainPanel(
      
      plotOutput("carte"),
      textOutput("liste_reg")
      
    )
  )
)

##########
# Server #
##########


# Define server logic required to draw a histogram
server <- function(input, output) {
  # voir si l'on peut mettre tous les calculs communs aux deux Render dans une partie commune
  # ce qui éviterait de passer une variable en global
  
  output$carte <- renderPlot({
    
    input$Trace
    
    isolate({
      
      region_choisie_numeric <- input$region
      
      region_choisie <- ""
      if ("1" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Auvergne-Rhône-Alpes")}
      if ("2" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Bourgogne-Franche-Comté")}
      if ("3" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Bretagne")}
      if ("4" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Centre-Val de Loire")}
      if ("5" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Corse")}
      if ("6" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Grand Est")}
      if ("7" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Hauts-de-France")}
      if ("8" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Île-de-France")}
      if ("9" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Normandie")}
      if ("10" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Nouvelle-Aquitaine")}
      if ("11" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Occitanie")}
      if ("12" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Pays de la Loire")}
      if ("13" %in% region_choisie_numeric) { region_choisie = c(region_choisie, "Provence-Alpes-Côte d'Azur")}
      if ("14" %in% region_choisie_numeric) { region_choisie = c("Auvergne-Rhône-Alpes", "Bourgogne-Franche-Comté",
                                                                  "Bretagne", "Centre-Val de Loire", "Corse", "Grand Est", 
                                                                  "Hauts-de-France", "Île-de-France", "Normandie", 
                                                                  "Nouvelle-Aquitaine", "Occitanie", "Pays de la Loire", 
                                                                  "Provence-Alpes-Côte d'Azur")}
                                                                  
      Region_Affiche <- Regions %>% subset(NAME_1 %in% region_choisie)
      
     # plot(Region_Affiche, main="Carte régionale", border = 3, bg="darkblue")
      
      
      ope_nom <- input$regex
      
      ope_nom = case_when(
        "1" %in% input$debutfin ~ paste0("^", ope_nom),
        "2" %in% input$debutfin ~ paste0(ope_nom, "$"),
        TRUE ~ ope_nom)
      
      indice <- grep(ope_nom, NAME)  
      
      CNE_region <<- CNE[indice,] %>% subset(NAME_1 %in% region_choisie)
      
      if ("14" %in% region_choisie_numeric) {titre_carte = "France entière"} else {titre_carte = region_choisie}
      
      plot(Region_Affiche, main=titre_carte, border = 3, bg="darkblue")
      plot(CNE_region, col="white", lwd=1, border= "white", add=T)
      
      #scalebar(d = 200, xy = c(5,42), type = "bar", below = "km",lwd = 5, divs = 2, col = "black", cex = 1, lonlat = T)
      # scale bar visible seulement en France entière - sa position doit être prévue / à la France
   
      
      
       }) # fin du isolate
    
  }) # Fin du renderPlot
  
  output$liste_reg <- renderText ({ 
    
    input$Trace
    
    isolate({
    
    as.character(CNE_region$NAME_5)  
# voir dans le livre Programmation R distributivité pour mettre des /
  })
  })
  
} # Fin du server


# Run the application 
shinyApp(ui = ui, server = server)

