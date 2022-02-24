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
                      )
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
             # tabPanel("Data comparisons",
             #          sidebarLayout(
             #            sidebarPanel(
             #              checkboxGroupInput("data_compare_report_list",
             #                                 label = "Urban Water Reports",
             #                                 choices = c("Annual Supply and Demand Assessment",
             #                                             "Electronic Annual Report",
             #                                             "Monthly Urban Water Conservation Report",
             #                                             "Urban Water Management Plan",
             #                                             "Water Loss Audit",
             #                                             "Water Use Objective"),
             #                                 selected = c("Electronic Annual Report",
             #                                              "Urban Water Management Plan")
             #              ),
             #              selectInput("data_compare_type_dropdown",
             #                          label = "Water data type",
             #                          choices = c("All",
             #                                      "Water Use",
             #                                      "Water Supply",
             #                                      "Other"),
             #                          selected = "All"
             #              ),
             #              selectInput("data_compare_metric_dropdown",
             #                label = "Select comparison metric",
             #                choices = c("Acre feet water reported",
             #                            "Delta in reported acre feet",
             #                            "Percent delta in reported acre feet"),
             #                selected = "Acre feet water reported")
             #              ),
             #            mainPanel())
             #          ),
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
