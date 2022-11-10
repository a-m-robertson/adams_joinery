#* script name      ui_body_program.R
#* script goal      manage the user interface (ui) of the body program section
#* 
#* naming convention
#* div elements     div_body_program
#* functions        fc_body_program
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- ui body ----

ui_body_program <- shiny::fluidPage(
  
  br(),
  
  shinyBS::bsCollapse(
    
    id = "panel_body_program",
    multiple = TRUE,
    open = c("Quick Start", "Jobs"),
    
    # quick start
    shinyBS::bsCollapsePanel(
      
      title = "Quick Start",
      style = "primary",
      
      shiny::uiOutput(
        outputId = "out_body_program_ui_quickstart"
      )
      
    ),
    
    # jobs
    shinyBS::bsCollapsePanel(
      
      title = "Jobs",
      style = "primary",
      
      DT::dataTableOutput(
        outputId = "out_body_program_table_jobs"
      )
      
    )
    
  )
  
)