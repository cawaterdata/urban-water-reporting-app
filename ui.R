shinyUI(
  navbarPage("California urban water reporting", id = "main_navbar",
             theme = shinythemes::shinytheme("lumen"),
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
                          mainPanel(DT::dataTableOutput("overview_table"))
                        )
                      ),
             # tabPanel("Data reported",
             #          sidebarLayout(
             #            sidebarPanel(
             #              checkboxGroupInput("data_report_list",
             #               label = "Urban Water Reports",
             #                choices = c("Annual Supply and Demand Assessment",
             #                            "Electronic Annual Report",
             #                            "Monthly Urban Water Conservation Report",
             #                            "Urban Water Management Plan",
             #                            "Water Loss Audit",
             #                            "Water Use Objective"),
             #                selected = c("Electronic Annual Report",
             #                             "Urban Water Management Plan")
             #              ),
             #              selectInput("data_type_dropdown",
             #                label = "Water data type",
             #                choices = c("All",
             #                            "Water Use",
             #                            "Water Supply",
             #                            "Other"),
             #                selected = "All"
             #              ),
             #              shinyWidgets:switchInput("data_overlap_switch",
             #                label = "Show only data similarities",
             #                value = T,
             #                onStatus = ,
             #                offStatus = 
             #              )),
             #              mainPanel(DT:datatable())
             #            )
             #          ),
             tabPanel("Data comparisons",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("agency_dropdown",
                                      label = "Agency",
                                      choices = c("City of Napa",
                                                  "Santa Fe Irrigation District"),
                                      selected = "City of Napa"
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
                          switchInput("delta_or_percent_delta_switch",
                                      label = "Percent Delta"
                          )),
                        mainPanel(plotOutput("metric_comparison_plot"), 
                                  br(), 
                                  hr(),
                                  br(),
                                  formattable::formattableOutput("metric_comparison_matrix"))
                      ))
             # tabPanel("Definitions",
             #          sidebarPanel(
             #            checkboxGroupInput("definitions_report_list",
             #                               label = "Urban Water Reports",
             #                               choices = c("Annual Supply and Demand Assessment",
             #                                           "Electronic Annual Report",
             #                                           "Monthly Urban Water Conservation Report",
             #                                           "Urban Water Management Plan",
             #                                           "Water Loss Audit",
             #                                           "Water Use Objective"),
             #                               selected = c("Electronic Annual Report",
             #                                            "Urban Water Management Plan")),
             #            shinyWidgets::switchInput("definitions_data_type_switch",
             #                                      label = "Select water use or supply definitions",
             #                                      value = T,
             #                                      onStatus = ,
             #                                      offStatus = 
             #                                      ),
             #            selectInput("defintions_group_dropdown",
             #                        "Select definition group",
             #                        choices = c(""),
             #                        selected = c("")),
             #            selectInput("definition_term_dropdown",
             #                        "Select the definition term",
             #                        choices = c(""),
             #                        selected = c(""))),
             #          mainPanel()),
             # tabPanel("Documentation")
             )
)
