#* script name      ui_body_overview.R
#* script goal      manage the user interface (ui) of the body overview section
#* 
#* naming convention
#* div elements     div_body_overview
#* functions        fc_body_overview
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- ui body ----

ui_body_overview <- shiny::fluidPage(
  
  br(),
  
  shinyBS::bsCollapse(
    
    id = "panel_body_overview",
    multiple = TRUE,
    open = c("Quick Start", "Jobs"),
    
    # quick start
    shinyBS::bsCollapsePanel(
      
      title = "Quick Start",
      style = "primary",
      
      shiny::uiOutput(
        outputId = "out_body_overview_ui_quickstart"
      )
      
    ),
    
    # jobs
    shinyBS::bsCollapsePanel(
      
      title = "Jobs",
      style = "primary",
      
      DT::dataTableOutput(
        outputId = "out_body_overview_table_jobs"
      ),
      
      br(),
      
      shiny::div(
        id = "div_body_overview_selected_job",
        class = "simpleDiv",
       
        shinyBS::bsButton(
          inputId = "in_body_overview_button_update_job",
          label = "Update Job",
          style = "primary"
        ),
        
        hr(),
        
        shiny::plotOutput(
          outputId = "out_body_overview_plot_gantt_job",
          height = "600px"
        )
         
      ) %>% shinyjs::hidden()
      
    )
    
  )
  
)