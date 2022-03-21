library(shiny)
library(shinythemes)
library(DT)
library(shinyWidgets)
library(readr)
library(tidyverse)
library(dplyr)
library(formattable)
library(plotly)


# Overview table ----------------------------------------------------------

overview_dat <- read_csv("data/overview_table.csv")


# Definitions -------------------------------------------------------------

definitions_dat_raw <- read_csv("data/data_dictionary.csv")
definitions_dat <- definitions_dat_raw %>%
  pivot_longer(cols = UWMP:AWSDA, names_to = "Report name", values_to = "Definition") %>%
  filter(!is.na(Definition))

definition_group_supply <- filter(definitions_dat, `Water type` == "Water supply") %>%
  distinct(`Definition group`) %>%
  arrange(`Definition group`)
definition_group_supply <- definition_group_supply$`Definition group`

definition_group_use <- filter(definitions_dat, `Water type` == "Water use") %>%
  distinct(`Definition group`) %>%
  arrange(`Definition group`)
definition_group_use <- definition_group_use$`Definition group`

# TODO update data after we finish quantitative analysis 
delta_metrics_data <- read_rds("data/urban_water_reporting_data.rds") 
volume_metrics_data <- read_rds("data/supply_and_demand_volume_af.rds")
volume_metrics_data_with_subcategories <- read_rds("data/supply_and_demand_volume_af_with_subcategories.rds") %>% 
  mutate(supplier_name = case_when(supplier_name == "Santa Fe Irrigation District" ~ "Santa Fe Irrigation District",
                                   supplier_name == "City of Napa" ~ "City of Napa",
                                   supplier_name == "SANTA FE I.D." ~ "Santa Fe Irrigation District",
                                   supplier_name == "NAPA, CITY OF" ~ "City of Napa",
                                   supplier_name == "Napa  City of" ~ "City of Napa",
                                   supplier_name == "Napa  City Of" ~ "City of Napa"))

report_abbreviations <- c("ASADA", "EAR", "CR", "UWMP", "WLR", "WUO")
names(report_abbreviations) <- c("Annual Supply and Demand Assessment", 
                                 "Electronic Annual Report",
                                 "Monthly Urban Water Conservation Report", 
                                 "Urban Water Management Plan",
                                 "Water Loss Audit",
                                 "Water Use Objective")

colors <- c("#9A8822", "#899DA4", "#C93312", "#F8AFA8", "#DC863B", "#FDDDA0", "#74A089", "#E1BD6D", "#FAEFD1", "#DC863B") 

