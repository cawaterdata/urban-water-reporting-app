shinyUI(
  navbarPage("California urban water reporting", id = "main_navbar",
             theme = shinythemes::shinytheme("yeti"),
             tabPanel("Overview",
                      textOutput("project_summary_text"),
                      tags$br(),
                      h3("Summary of reporting requirements"),
                      DT::dataTableOutput("overview_table")
                      ),
             tabPanel("Data comparisons",
                      sidebarLayout(
                        sidebarPanel(
                          conditionalPanel(condition="input.data_compare_tab==1",
                          selectInput("agency_dropdown",
                                      label = "Agency",
                                      choices = c("Agency 1",
                                                  "Agency 2", 
                                                  "Agency 3"),
                                      selected = "Agency 1"
                          ),
                          checkboxGroupInput("data_compare_report_list",
                                             label = "Urban Water Reports",
                                             choices = c("Electronic Annual Report",
                                                         "Monthly Urban Water Conservation Report",
                                                         "Urban Water Management Plan",
                                                         "Water Loss Audit"),
                                             selected = c("Electronic Annual Report",
                                                          "Monthly Urban Water Conservation Report",
                                                          "Urban Water Management Plan",
                                                          "Water Loss Audit")
                          ),
                          selectInput("data_compare_type_dropdown",
                                      label = "Water data type",
                                      choices = c("Total Water Supply",
                                                  "Total Water Demand"),
                                      selected = "Total Water Supply"
                          ),
                          switchInput("show_subcategories",
                                      label = "Show Subcategories"
                          ), 
                          switchInput("delta_or_percent_delta_switch",
                                      label = "Percent Difference"
                          ))),
                        mainPanel(
                          tabsetPanel(id = "data_compare_tab",
                                      type = "tabs",
                                      tabPanel("Explore data",
                                               value = 1,
                                               plotlyOutput("metric_comparison_plot"), 
                                               br(), 
                                               hr(),
                                               br(),
                                               formattable::formattableOutput("metric_comparison_matrix")),
                                      tabPanel("Data Mapping",
                                               value = 2,
                                               "State reporting requirements include definitions for the water use and supply
                                               groups that suppliers are required to report on. In many cases, the name of the 
                                               water use or supply group varies across reporting requirements and the definition
                                               may also vary.",
                                               br(),
                                               br(),
                                               "The creation of an inclusive list of water use and supply groups, and mappings across
                                               reporting requirements was informed by the synthesis of summary documents for 
                                               state reporting requirements (also referred to as templates) and shown below.",
                                               br(),
                                               h2("Water use categories"),
                                               dataTableOutput("use_type_lookup"),
                                               br(),
                                               h2("Water supply categories"),
                                               dataTableOutput("supply_type_mapping"))
                      )))),
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
                                dataTableOutput("definitions_table"))),
             tabPanel("Resources",
                      mainPanel(
                        tabsetPanel(id = "tabselected_resources",
                                    type = "tabs",
                                    tabPanel("Annual Assessment",
                                             htmlOutput("awsda_links")),
                                    tabPanel("Electronic Annual Report",
                                             htmlOutput("ear_links")),
                                    tabPanel("Monthly Conservation Report",
                                             htmlOutput("cr_links")),
                                    tabPanel("Urban Water Management Plan",
                                             htmlOutput("uwmp_links")),
                                    tabPanel("Water Loss Audit",
                                             htmlOutput("wlr_links")),
                                    tabPanel("Water Use Objective",
                                             htmlOutput("wuo_links"))
)
)
)
)
)
