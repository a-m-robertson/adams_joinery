#* script name      ui_body_programming.R
#* script goal      manage the user interface (ui) of the body programming section
#* 
#* naming convention
#* div elements     div_body_programming
#* functions        fc_body_programming
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- ui body ----

ui_body_programming <- shiny::fluidPage(
  
  br(),
  
  shinyBS::bsCollapse(
    
    id = "panel_body_programming",
    multiple = TRUE,
    open = c("Quick Start", "Jobs"),
    
    # quick start
    shinyBS::bsCollapsePanel(
      
      title = "Quick Start",
      style = "primary",
      
      shiny::uiOutput(
        outputId = "out_body_programming_ui_quickstart"
      )
      
    ),
    
    # jobs
    shinyBS::bsCollapsePanel(
      
      title = "Jobs",
      style = "primary",
      
      DT::dataTableOutput(
        outputId = "out_body_programming_table_jobs"
      )
      
    )
    
  )
  
)