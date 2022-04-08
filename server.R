server <- function(input, output, session) {
  

# overview tab ------------------------------------------------------------
  output$overview_table <- renderDataTable(overview_dat, rownames = F)
  
  output$project_summary_text <- renderText("The Urban Water Reporting project is being led by the 
                                            California Water Data Consortium (Consortium). The Consortium 
                                            will identify opportunities to align current water 
                                            supply and use data collected and reported by local 
                                            and wholesale water agencies with State agency 
                                            reporting requirements to improve data use, reduce 
                                            reporting burden, and expand access to timely, 
                                            interoperable, high-quality, secure, reliable data. 
                                            In addition to improving public understanding and 
                                            access to core water supply and use data, these 
                                            data services will provide the source data needed 
                                            to generate critical information for managing water 
                                            resources.")
  
  # need to make table headers readable; probably don't need filter; could add 
  # some background/explanation text


# interview tab -----------------------------------------------------------
  output$time_table <- renderDataTable(time %>%
                                         select(-`Parent themes`), rownames = F)
  output$quality_table <- renderDataTable(quality %>%
                                         select(-`Parent themes`), rownames = F)
  output$ethics_table <- renderDataTable(ethics %>%
                                         select(-`Parent themes`), rownames = F)
  output$definitions_interview_table <- renderDataTable(definitions %>%
                                         select(-`Parent themes`), rownames = F)
  output$utility_table <- renderDataTable(utility %>%
                                         select(-`Parent themes`), rownames = F)
  output$recommendations_table <- renderDataTable({
    datatable(recommendations %>%
                select(-`Parent themes`), rownames = F, escape = F)
  })
# definitions tab ---------------------------------------------------------

definitions_filter <- reactive({
  filter <- definitions_dat %>%
    filter(`Report name` %in% input$definitions_report_list,
           `Water type` %in% input$water_type_dropdown,
           `Definition group` %in% input$defintions_group_dropdown) %>%
      pivot_wider(id_cols = `Water type`:Term, names_from = "Report name", values_from = "Definition") 
  })
  
output$definitions_table <- renderDataTable(
  DT::datatable(definitions_filter() %>%
                  select(-c(`Water type`, `Definition group`)),
                rownames = F)
  )
output$definitions_label <- renderText(paste(input$defintions_group_dropdown, "definitions"))

observe({
  water_type <- input$water_type_dropdown
  if(water_type == "Water supply") {
    updateSelectInput(session, "defintions_group_dropdown",
                      "Select definition group",
                      choices = definition_group_supply,
                      selected = "Imported/purchased water suppplied")
  } else {
    updateSelectInput(session, "defintions_group_dropdown",
                      "Select definition group",
                      choices = definition_group_use,
                      selected = "Residential use type")
  }
  
})


# mapping -----------------------------------------------------------------

output$use_type_lookup <- renderDataTable({
  datatable(use_type_mapping_table, rownames = F) %>%
    formatStyle('Urban Water Management Plan', background = styleEqual(NA, 'lightgray')) %>%
    formatStyle('Monthly Urban Water Conservation Report', background = styleEqual(NA, 'lightgray')) %>%
    formatStyle('Electronic Annual Report', background = styleEqual(NA, 'lightgray')) %>%
    formatStyle('Water Loss Audit', background = styleEqual(NA, 'lightgray')) 
})

output$supply_type_mapping <- renderDataTable({
  datatable(supply_type_mapping_table, rownames = F) %>%
    formatStyle('Urban Water Management Plan', background = styleEqual(NA, 'lightgray')) %>%
    formatStyle('Monthly Urban Water Conservation Report', background = styleEqual(NA, 'lightgray')) %>%
    formatStyle('Electronic Annual Report', background = styleEqual(NA, 'lightgray')) %>%
    formatStyle('Water Loss Audit', background = styleEqual(NA, 'lightgray')) 
})
#  quantitative analysis tab ---------------------------------------------------

output$data_source <- renderText(paste(
  tags$div(  
    tags$h4("Electronic Annual Report"),
    tags$ul(
      tags$li("2020 EAR data were downloaded from the", tags$a(href = "https://www.waterboards.ca.gov/drinking_water/certlic/drinkingwater/eardata.html", "EAR Homepage.")),
      tags$li("Water supply data was pulled by filtering QuestionName to include WP. Total supply was calculated as the sum of total potable water, nonpotable water, and recycled water
              minus water sold to another PWS."),
      tags$li("Water demand data was pulled by filtering QuestionName to include WD.")),
    tags$h4("Urban Water Management Plan"),
    tags$ul(
      tags$li("2020 UWMP data were downloaded", tags$a(href = "https://wuedata.water.ca.gov/uwmp_export_2020.asp", "here.")),
      tags$li("Table 6-8 Retail: Water Supplies - Actual was used for water supply data."),
      tags$li("Table 4-1 Retail: Demands for Potable and Non-Potable Water - Actual was used for water demand data.")
    ),
    tags$h4("Monthly Urban Water Conservation Report"),
    tags$ul(
      tags$li("CR data were downloaded", tags$a(href = "https://data.ca.gov/dataset/drinking-water-public-water-system-operations-monthly-water-production-and-conservation-information/resource/0c231d4c-1ea7-43c5-a041-a3a6b02bac5e", "here."))
    ),
    tags$h4("Water Loss Audit"),
    tags$ul(
      tags$li("2020 WLR data were downloaded", tags$a(href = "https://wuedata.water.ca.gov/awwa_export", "here.")),
      tags$li("Water supply data pulled were: WS_OWN_SOURCES_VOL_AF, WS_IMPORTED_VOL_AF, WS_EXPORTED_VOL_AF, WS_WATER_SUPPLIED_VOL_AF. WS_WATER_SUPPLIED_VOL_AF is used as the total supply."),
      tags$li("Water demand data pulled were: AC_BILL_METER_VOL_AF, AC_BILL_UNMETER_VOL_AF, AC_UNBILL_METER_VOL_AF, AC_UNBILL_UNMETER_VOL_AF, AC_AUTH_CONSUMPTION_VOL_AF")
    ))))


output$metric_comparison_plot <- renderPlotly({
  if (input$show_subcategories == FALSE) {
  filtered_data <- volume_metrics_data %>% 
      filter(report %in% report_abbreviations[input$data_compare_report_list],
             metric %in% input$data_compare_type_dropdown, 
             agency == supplier_lookup[input$agency_dropdown])
    plot_ly(filtered_data, y = ~report, x = ~volume_af, fill = ~report,
           type = "bar", marker = list(color = wesanderson::wes_palette("Royal2"))) %>% #TODO fix color 
      layout(xaxis = list(title = input$data_compare_type_dropdown),
             yaxis = list(title = ""))
  } else {
    #TODO improve colors for subcategories 
    filtered_data <- filter(volume_metrics_data_with_subcategories, !grepl("total", use_group)) %>% 
      filter(report_name %in% report_abbreviations[input$data_compare_report_list],
             parent_metric %in% input$data_compare_type_dropdown, 
             supplier_name == supplier_lookup[input$agency_dropdown]) %>%
      mutate(volume_af = ifelse(use_group == "sold", volume_af*-1, volume_af))
    # plot_ly(filtered_data, y = ~report_name, x = ~volume_af, fill = ~use_group,
    #         type = "bar", marker = list(color = colors)) %>% #TODO fix color 
    #   layout(xaxis = list(title = input$data_compare_type_dropdown),
    #          yaxis = list(title = ""))
    
    ggplotly(ggplot(filter(filtered_data, !is.na(use_group)), aes(y = report_name, x = volume_af, fill = use_group)) +
      geom_col() +
      labs(x = "Reported Annual Demand (AF)", y = "") +
      theme_minimal() +
      theme(text = element_text(size=14),
            legend.title = element_blank(),
            legend.text = element_text(size = 10)) +
      scale_fill_manual(values = colors))
  }
})

clean_na = function(x){
  x %>%
    round(2) %>%
    as.character() %>%
    replace_na('-') %>%
    return()
}
  
output$metric_comparison_matrix <- renderFormattable({
  if (input$delta_or_percent_delta_switch == FALSE) {
  dat <- delta_metrics_data %>% 
    filter(report_a %in% report_abbreviations[input$data_compare_report_list],
           report_b %in% report_abbreviations[input$data_compare_report_list],
           metric %in% input$data_compare_type_dropdown,
           agency == supplier_lookup[input$agency_dropdown]) %>% 
    select("Reports" = report_a, report_b, delta) %>%
    pivot_wider(names_from = "report_b", values_from = "delta")  %>%
    mutate_if(is.numeric, clean_na)
  name <- "Difference"
  } else {
    dat <- delta_metrics_data %>% 
      filter(report_a %in% report_abbreviations[input$data_compare_report_list],
             report_b %in% report_abbreviations[input$data_compare_report_list],
             metric %in% input$data_compare_type_dropdown,
             agency == supplier_lookup[input$agency_dropdown]) %>% 
      select("Reports" = report_a, report_b, percent_delta) %>%
      pivot_wider(names_from = "report_b", values_from = "percent_delta")  %>%
      mutate_if(is.numeric, clean_na)
    name <- "Percent Difference"
  }
  formattable(dat, caption = paste(name, input$data_compare_type_dropdown, "Across Reports"), 
              list(area(col = 2:ncol(dat)) ~ color_tile("transparent", "pink")))
})

output$guided_examples <- renderUI({
  includeHTML("guided_examples.html")
})
# resources tab -----------------------------------------------------------

output$awsda_links <- renderText(paste(
  tags$div(
  tags$h4("Annual Supply and Demand Assessment"),
  tags$ul(
    "DWR. 2021. Urban Water Management Plan: Draft Annual Water Supply and Demand Assessment 2021 (Appendix Q).",
    "DWR. 2021. Urban Water Management Plan Guidebook 2020."))))

output$ear_links <- renderText(paste(
  tags$div(  
  tags$h4("Electronic Annual Report"),
  tags$ul(
    tags$li(tags$a(href = "https://www.waterboards.ca.gov/drinking_water/certlic/drinkingwater/ear.html", "EAR Homepage")),
    tags$li(tags$a(href = "https://www.waterboards.ca.gov/drinking_water/certlic/drinkingwater/documents/ear/ear_input_forum/2020_ear_blank.pdf",
           "Full 2020 EAR")),
    tags$li(tags$a(href = "https://ear.waterboards.ca.gov/Content/2020EARHelp.htm", "EAR Help Document and Dictionary")),
    tags$li(tags$a(href = "https://ear.waterboards.ca.gov/PwsUser/ReadFAQ", " EAR FAQ describing uses of data")),
    tags$li("Section 116530 of the Health and Safety Code"),
    tags$ul(
      tags$li(tags$a(href = "https://leginfo.legislature.ca.gov/faces/codes_displaySection.xhtml?lawCode=HSC&sectionNum=116530",
           "Current law")),
      tags$li(tags$a(href = "https://leginfo.legislature.ca.gov/faces/billNavClient.xhtml?bill_id=199519960SB1360#:~:text=116530",
           "Pre-2019 version of the law"))),
    tags$li(tags$a(href = "https://www.waterboards.ca.gov/drinking_water/certlic/drinkingwater/documents/waterpartnerships/what_is_a_public_water_sys.pdf",
           "What is a public water system?"))))))

output$cr_links <- renderText(paste(
  tags$div( 
  tags$h4("Monthly Urban Water Conservation Report"),
  tags$ul(
    tags$li(tags$a(href ="https://www.waterboards.ca.gov/water_issues/programs/conservation_portal/water_conserva	tion_reports/",  "Overview Website")),
    tags$li(tags$a(href = "https://calwaterdata.sharepoint.com/:w:/r/sites/WorkingGroups/Shared%20Documents/General/Pilot%20Projects/2021/Urban%20Water%20Pilot%20Project/Report/Conservation%20Report/Adopted%20Conservation%20Report%20Regulations_Clean_042120.docx?d=wb1b82ddc3f104bef90bc5e0ca0042072&csf=1&web=1&e=yCqOe4",
                   "Regulation text")),
    tags$li(tags$a(href = "https://calwaterdata.sharepoint.com/:b:/r/sites/WorkingGroups/Shared%20Documents/General/Pilot%20Projects/2021/Urban%20Water%20Pilot%20Project/Report/Conservation%20Report/Conservation%20Report%20Rationale.pdf?csf=1&web=1&e=cgYdtc",
                   "Regulation Rationale")),
    tags$li(tags$a(href = "https://www.waterboards.ca.gov/water_issues/programs/conservation_portal/docs/definitions_and_data_dictionary_accessible.pdf",
                   "Definitions and Data Dictionary for the Urban Water Supplier Monthly Reports Dataset")),
    tags$li(tags$a(href = "https://www.waterboards.ca.gov/water_issues/programs/conservation_portal/docs/emergency	_response_data_dictionary_accessible.pdf",
                   "Definitions and Data Dictionary for the Water Shortage Emergency Response Actions Dataset")),
    tags$li(tags$a(href = "https://data.ca.gov/dataset/drinking-water-public-water-system-operations-monthly-water-	production-and-conservation-information",
                   "Data"))))))

output$uwmp_links <- renderText(paste(
  tags$div(
  tags$h4("Urban Water Management Plan"),
  tags$ul(
    tags$li(tags$a(href = "https://water.ca.gov/Programs/Water-Use-And-Efficiency/Urban-Water-Use-Efficiency/Urban-Water-Management-Plans",
                   "Overview Website")),
    tags$li(tags$a(href = "https://wuedata.water.ca.gov/secure/login_auth.asp?msg=inactivity&referer=/secure/Default.asp?",
                   "WUE Data Portal (Water Systems)")),
    tags$li(tags$a(href = "https://wuedata.water.ca.gov/",
                   "WUE Data Portal (public)"))))))
output$wlr_links <- renderText(paste(
  tags$div(
  tags$h4("Water Loss Audit"),
  tags$ul(
    tags$li(tags$a(href = "https://water.ca.gov/Programs/Water-Use-And-Efficiency/Urban-Water-Use-Efficiency/Validated-Water-Loss-Reporting",
                   "DWR Urban Water Loss Webpage")),
    tags$li(tags$a(href = "https://govt.westlaw.com/calregs/Document/IECFD4F5BC02E41D5AC7854B0DC086F2D?viewType=FullText&originationContext=documenttoc&transitionType=CategoryPageItem&contextData=(sc.Default)&bhcp=1",
                   "Regulations for Urban Water Retailers")),
    tags$li(tags$a(href = "https://water.ca.gov/-/media/DWR-Website/Web-Pages/Programs/Water-Use-And-Efficiency/Urban-Water-Use-Efficiency/Validated-Water-Loss-Reporting/Final-of-Wholesale-Water-Loss-Legislative-Report_Feb-18-2020_a.pdf",
                   "Wholesale Reporting Recommendations")),
    tags$li(tags$a(href = "https://www.awwa.org/Portals/0/files/publications/documents/M36LookInside.pdf",
                   "Water industry standard and protocol for water-loss audits in the United States")),
    tags$li(tags$a(href = "https://wuedata.water.ca.gov/public/awwa_uploads/9152234733/AWWA-WAS-v5-09152014_CY2019_VALID.xls",
                   "Water Balance tab of AWWA xlsx")),
    tags$li(tags$a(href = "https://wuedata.water.ca.gov/public/awwa_uploads/9152234733/AWWA-WAS-v5-09152014_CY2019_VALID.xls",
                   "Definitions tab of AWWA xlsx sheet"))))))

output$wuo_links <- renderText(paste(
  tags$div(
  tags$h4("Water Use Objective"),
  tags$ul(
    tags$li(tags$a(href = "https://water.ca.gov/Programs/Water-Use-And-Efficiency/2018-Water-Conservation-Legislation/Urban-Water-Use-Efficiency-Standards-and-Water-Use-Objective",
                   "Water Use Objective Webpage")),
    tags$li(tags$a(href = "https://medium.com/california-data-collaborative/latest-proposals-from-dwr-on-californias-water-efficiency-framework-b078fb300cd7",
                   "Tull, Christopher. 2021. Latest proposals from DWR on California’s Water Efficiency Framework: Over 3 workshops, DWR revealed their most comprehensive outline yet of what will be required of urban water suppliers. Published on Medium. Accessed January 31, 2022."),
            ),
    tags$li("DWR. 2021. Report to the Legislature on the Results of the Indoor Residential Water Use Study."),
    tags$li("DWR. 2021. Appendices A-J of the Report to the Legislature on the Results of the Indoor Residential Water use Study.")
  )
  )
))

}




