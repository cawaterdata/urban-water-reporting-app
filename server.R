server <- function(input, output) {
  

# overview tab ------------------------------------------------------------
  overview_filter <- reactive({
    overview_dat %>%
      filter(report %in% input$overview_report_list)
  })
  
  output$overview_table <- renderDataTable(overview_filter())
  
  # need to make table headers readable; probably don't need filter; could add 
  # some background/explanation text


#  quantitative analysis tab ---------------------------------------------------

output$metric_comparison_plot <- renderPlot({
  ggplot(volume_metrics_data %>% 
           filter(report %in% report_abbreviations[input$data_compare_report_list],
                  metric %in% input$data_compare_type_dropdown, 
                  agency == input$agency_dropdown ),
         aes(y = report, x = volume_af, fill = report)) +
    geom_col() + 
    labs(x = input$data_compare_type_dropdown, y = "") +
    theme_minimal() +
    theme(legend.position="none", text = element_text(size=18)) + 
    scale_fill_manual(values = wesanderson::wes_palette("Royal2"))
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