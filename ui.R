shinyUI(
  navbarPage("California urban water reporting", id = "main_navbar",
             theme = shinythemes::shinytheme("yeti"),
             tabPanel("Overview",
                      sidebarLayout(
                        sidebarPanel(
                          checkboxGroupInput("overview_report_list",
                            label = "Urban Water Reports",
                            choices = c("Annual Water Supply and Demand Assessment",
                                        "Electronic Annual Report",
                                        "Monthly Urban Water Conservation Report",
                                        "Urban Water Management Plan",
                                        "Water Loss Audit",
                                        "Water Use Objective"),
                            selected = c("Electronic Annual Report",
                                         "Urban Water Management Plan")
                          )),
                          mainPanel(textOutput("project_summary_text"),
                                    tags$br(),
                                    h3("Summary of reporting requirements"),
                                    DT::dataTableOutput("overview_table"))
                        )
                      ),
             tabPanel("Data comparisons",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("agency_dropdown",
                                      label = "Agency",
                                      choices = c("Agency 1",
                                                  "Agency 2", 
                                                  "Agency 3"),
                                      selected = "Agency 1"
                          ),
                          checkboxGroupInput("data_compare_report_list",
                                             label = "Urban Water Reports",
                                             choices = c("Annual Supply and Demand Assessment",
                                                         "Electronic Annual Report",
                                                         "Monthly Urban Water Conservation Report",
                                                         "Urban Water Management Plan",
                                                         "Water Loss Audit",
                                                         "Water Use Objective"),
                                             selected = c("Electronic Annual Report",
                                                          "Monthly Urban Water Conservation Report",
                                                          "Urban Water Management Plan",
                                                          "Water Loss Audit")
                          ),
                          selectInput("data_compare_type_dropdown",
                                      label = "Water data type",
                                      choices = c("Total Water Supply",
                                                  "Total Water Demand",
                                                  "Other"),
                                      selected = "Total Water Supply"
                          ),
                          switchInput("show_subcategories",
                                      label = "Show Subcategories"
                          ), 
                          switchInput("delta_or_percent_delta_switch",
                                      label = "Percent Difference"
                          )),
                        mainPanel(plotlyOutput("metric_comparison_plot"), 
                                  br(), 
                                  hr(),
                                  br(),
                                  formattable::formattableOutput("metric_comparison_matrix"))
                      )),
             tabPanel("Definitions",
                      sidebarPanel(
                        checkboxGroupInput("definitions_report_list",
                                           label = "Urban Water Reports",
                                           choices = c("Annual Supply and Demand Assessment",
                                                       "Electronic Annual Report",
                                                       "Monthly Urban Water Conservation Report",
                                                       "Urban Water Management Plan",
                                                       "Water Loss Audit",
                                                       "Water Use Objective"),
                                           selected = c("Annual Supply and Demand Assessment",
                                                        "Electronic Annual Report",
                                                        "Monthly Urban Water Conservation Report",
                                                        "Urban Water Management Plan",
                                                        "Water Loss Audit",
                                                        "Water Use Objective")),
                        selectInput("water_type_dropdown",
                                    "Select water use or supply",
                                    choices = c("Water supply",
                                                "Water use"),
                                    selected = "Water use"),
                        selectInput("defintions_group_dropdown",
                                    "Select definition group",
                                    choices = definition_group_use,
                                    selected = "Residential use type",
                                    multiple = T)),
                      mainPanel(textOutput("definitions_label"),
                                tags$br(),
                                DT::dataTableOutput("definitions_table"))),
             tabPanel("Resources",
                      mainPanel(
                        htmlOutput("resources_links")))
)
)
