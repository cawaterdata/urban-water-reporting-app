server <- function(input, output) {
  

# overview tab ------------------------------------------------------------
  overview_filter <- reactive({
    overview_dat %>%
      filter(report %in% input$overview_report_list)
  })
  
  output$overview_table <- renderDataTable(overview_filter())
  
  # need to make table headers readable; probably don't need filter; could add 
  # some background/explanation text
}