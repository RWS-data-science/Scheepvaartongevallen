library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)
library(plotly)
library(DT)
library(rgdal)

load("sch_niet_sig.RData")
load("sch_sig.RData")
load("gewonden_per_jaar_sign.RData")
load("gewonden_per_jaar_niet_sign.RData")

beheerders<- c("Alle","Midden Nederland","Noord Nederland","Oost Nederland","RWS Centraal Nautisch Beheer","West Nederland Noord",
               "West Nederland Zuid", "Zee & Delta","Zuid Nederland")
beheerders2<- c("Midden Nederland","Noord Nederland","Oost Nederland","RWS Centraal Nautisch Beheer","West Nederland Noord",
                "West Nederland Zuid", "Zee & Delta","Zuid Nederland")
jaren<- c("Alle",2008:2017)

shiny::runApp("dashboard")
