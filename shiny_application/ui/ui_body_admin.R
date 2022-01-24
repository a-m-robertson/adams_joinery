#* script name      ui_body_admin.R
#* script goal      manage the user interface (ui) of the body admin section
#* 
#* naming convention
#* div elements     div_body_admin
#* functions        fc_body_admin
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- ui body ----

ui_body_admin <- shiny::fluidPage(
  
  br(),
  
  shinyBS::bsCollapse(
    
    id = "panel_body_admin",
    multiple = TRUE,
    open = c("Users"),
    
    # users
    shinyBS::bsCollapsePanel(
      
      title = "Users",
      style = "primary",
      
      shiny::uiOutput(
        outputId = "out_body_admin_ui_users"
      )
      
    )
    
  )
  
)