library(shiny)
library(shinythemes)
library(DT)
library(shinyWidgets)
library(readr)
library(tidyverse)
library(dplyr)
library(formattable)


# Overview table ----------------------------------------------------------

overview_dat <- read_csv("data/overview_table.csv")
delta_metrics_data <- read_rds("data/urban_water_reporting_data.rds") 
volume_metrics_data <- read_rds("data/supply_and_demand_volume_af.rds")

report_abbreviations <- c("ASADA", "EAR", "CR", "UWMP", "WLR", "WUO")
names(report_abbreviations) <- c("Annual Supply and Demand Assessment", 
                                 "Electronic Annual Report",
                                 "Monthly Urban Water Conservation Report", 
                                 "Urban Water Management Plan",
                                 "Water Loss Audit",
                                 "Water Use Objective")

