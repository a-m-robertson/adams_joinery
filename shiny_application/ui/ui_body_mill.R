#* script name      ui_body_mill.R
#* script goal      manage the user interface (ui) of the body mill section
#* 
#* naming convention
#* div elements     div_body_mill
#* functions        fc_body_mill
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- ui body ----

ui_body_mill <- shiny::fluidPage(
  
  br(),
  
  shinyBS::bsCollapse(
    
    id = "panel_body_mill",
    multiple = TRUE,
    open = c("Quick Start", "Jobs"),
    
    # quick start
    shinyBS::bsCollapsePanel(
      
      title = "Quick Start",
      style = "primary",
      
      shiny::uiOutput(
        outputId = "out_body_mill_ui_quickstart"
      )
      
    ),
    
    # jobs
    shinyBS::bsCollapsePanel(
      
      title = "Jobs",
      style = "primary",
      
      DT::dataTableOutput(
        outputId = "out_body_mill_table_jobs"
      )
      
    )
    
  )
  
)