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
                          ),
                          br(),
                          br(),
                          "The data presented to the right is pulled from the 2020
                          Water Loss Audit (WLR), Urban Water Management Plan (UWMP),
                          Electronic Annual Report (EAR), and the Monthly Urban Water 
                          Conservation Report (CR). Please refer to the Data Mapping
                          tab to view how data elements are mapped across reports.")),
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
             tabPanel("Interview themes",
                      tabsetPanel(id = "interview_tab",
                                  type = "tabs",
                                  tabPanel("Time and resource constraints",
                      h3("Time and resource constraints"),
                      "Small and large agencies with diverse resources were interviewed. 
                      The quotes below communicate some of the time and resource 
                      constraints that exist, which may vary by agency size. Smaller 
                      agencies discussed challenges in providing timely, high-quality 
                      data due to staff, time, and budget constraints, which larger 
                      agencies also acknowledged as a challenge for smaller agencies. 
                      Larger agencies discussed implementing automated workflows and 
                      processes to meet reporting requirements and the time required 
                      to set up these processes. Some larger agencies discussed the 
                      challenge of coordination within their agency and the time it 
                      takes to ensure consistent reporting agency-wide.",
                      dataTableOutput("time_table")),
                      tabPanel("Data quality",
                      h3("Data quality"),
                      "QA/QC processes were directly asked about in the interviews. 
                      Both large and small agencies deal with data quality issues 
                      though the processes in place to ensure accurate data may vary. 
                      Some agencies have very thorough, almost constant, QA/QC processes; 
                      whereas others have manual checks that happen periodically. 
                      Data quality is also tightly linked with time and resource 
                      constraints. Some agencies have more sophisticated data management 
                      systems whereas others use annually populated excel spreadsheets. 
                      In multiple interviews the monthly timing of the Monthly Urban 
                      Water Conservation Report was mentioned as a challenge, particularly 
                      if the agency was on a bimonthly meter read cycle.",
                      dataTableOutput("quality_table")),
                      tabPanel("Data ethics and community",
                      h3("Data ethics and community"),
                      "Related to the theme of data quality, in many interviews 
                      it was apparent that individuals wanted to provide data of 
                      the highest quality to support better policy. Both small and 
                      large agencies acknowledged the disconnect between state reporting 
                      requirements and the reality of what data is available to the agency.",
                      dataTableOutput("ethics_table")),
                      tabPanel("Definitions",
                      h3("Definitions"),
                      "Some agencies discussed the challenge of fitting their data 
                      into the state’s predefined categories. The quotes below describe 
                      a few specific examples including challenges of land use-based 
                      definitions for budget-based rate structure agencies, difficulties 
                      reporting recycled water, shortages, commercial and residential. 
                      One interviewee had thought about the impact of inconsistent 
                      definitions on reporting and data quality. For instance, if 
                      definitions are interpreted differently and reported differently 
                      across agencies this creates challenges for regional analysis.",
                      dataTableOutput("definitions_interview_table")),
                      tabPanel("Report utility",
                      h3("Utility of state reporting requirements"),
                      "The interviews specifically asked about the state reports 
                      that were most useful internally. All agencies thought the 
                      Urban Water Management Plan had some internal use and there 
                      were mixed responses in terms of the other reports. In most 
                      cases, some parts of the other reports were being used though 
                      the agencies may be summarizing in ways that are more useful 
                      to their agency. A few agencies brought up questions about 
                      the state’s use for the data. A major theme that connects to 
                      the utility of state reporting requirements is the disconnect 
                      between state reporting requirements and local agency characteristics 
                      or the reality of what data are available when.",
                      dataTableOutput("utility_table")),
                      tabPanel("Recommendations",
                      h3("Recommendations"),
                      "In all the interviews, participants recommended having a 
                      centralized repository for reporting state urban water use 
                      and supply data. This would streamline reporting in the sense 
                      that agencies would only have to report their data once a year. 
                      The data being reported would be raw data elements and the states 
                      (or other third parties) could summarize the data in a way that 
                      would be most useful to them. Smaller, short-term recommendations 
                      included auto-populating fields, and not changing the format of 
                      reporting forms. Some also mentioned education and outreach to 
                      improve data quality.",
                      dataTableOutput("recommendations_table"))
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
