server <- function(input, output, session) {
  

# overview tab ------------------------------------------------------------
  overview_filter <- reactive({
    overview_dat %>%
      filter(`Report Name` %in% input$overview_report_list)
  })
  
  output$overview_table <- renderDataTable(overview_filter())
  
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

# definitions tab ---------------------------------------------------------

definitions_filter <- reactive({
  filter <- definitions_dat %>%
    filter(`Report name` %in% input$definitions_report_list,
           `Water type` %in% input$water_type_dropdown,
           `Definition group` %in% input$defintions_group_dropdown) %>%
      pivot_wider(id_cols = `Water type`:Term, names_from = "Report name", values_from = "Definition") 
  })
  
output$definitions_table <- renderDataTable(definitions_filter() %>%
                                              select(-c(`Water type`, `Definition group`)))
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

#  quantitative analysis tab ---------------------------------------------------

output$metric_comparison_plot <- renderPlot({
  if (input$show_subcategories == FALSE) {
  filtered_data <- volume_metrics_data %>% 
      filter(report %in% report_abbreviations[input$data_compare_report_list],
             metric %in% input$data_compare_type_dropdown, 
             agency == input$agency_dropdown )
    ggplot(filtered_data,
         aes(y = report, x = volume_af, fill = report)) +
    geom_col() + 
    labs(x = input$data_compare_type_dropdown, y = "") +
    theme_minimal() +
    theme(legend.position="none", text = element_text(size=18)) + 
    scale_fill_manual(values = wesanderson::wes_palette("Royal2"))
  } else {
    #TODO improve colors for subcategories 
    filtered_data <- volume_metrics_data_with_subcategories %>% 
      filter(report_name %in% report_abbreviations[input$data_compare_report_list],
             parent_metric %in% input$data_compare_type_dropdown, 
             supplier_name == input$agency_dropdown)
    ggplot(filter(filtered_data, !is.na(use_group)), aes(y = report_name, x = volume_af, fill = use_group)) +
      geom_col() + 
      labs(x = "Reported Annual AF Demand", y = "", 
           title = "Reported Annual Water Demand Across Reporting Requirements") +
      theme_minimal() +
      theme(text = element_text(size=18)) + 
      scale_fill_manual(values = c(wesanderson::wes_palette("Royal2"), wesanderson::wes_palette("Royal1"), "#E1BD6D")) 
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
           agency == input$agency_dropdown) %>% 
    select("Reports" = report_a, report_b, delta) %>%
    pivot_wider(names_from = "report_b", values_from = "delta")  %>%
    mutate_if(is.numeric, clean_na)
  name <- "Delta"
  } else {
    dat <- delta_metrics_data %>% 
      filter(report_a %in% report_abbreviations[input$data_compare_report_list],
             report_b %in% report_abbreviations[input$data_compare_report_list],
             metric %in% input$data_compare_type_dropdown,
             agency == input$agency_dropdown) %>% 
      select("Reports" = report_a, report_b, percent_delta) %>%
      pivot_wider(names_from = "report_b", values_from = "percent_delta")  %>%
      mutate_if(is.numeric, clean_na)
    name <- "Percent Delta"
  }
  formattable(dat, caption = paste(name, input$data_compare_type_dropdown, "Across Reports"), 
              list(area(col = 2:ncol(dat)) ~ color_tile("transparent", "pink")))
})

}