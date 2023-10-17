library(shiny)
library(tidyverse)

library(stringr)
library(sf)
library(sp)
library(cartography)
library(mapsf) # conseil au chargement le 02 04 22 - cartography est en maintenance
library(raster) # pour le get.data
library(lwgeom)# Pour les étiquettes


# Ensemble de la France
FranceFormes <- getData(name="GADM", country="FRA", level=0)


CNE <- getData(name="GADM", country="FRA", level=5)
NAME <- as.vector(CNE$NAME_5)


