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
      
      DT::dataTableOutput(
        outputId = "out_body_admin_table_users"
      ),
      
      hr(),
      
      shiny::HTML(paste0(
        "<h5>", "<b>", "Add / Update User", "</b>", "</h5>",
        "<h5>", "User Team is used for allocating users to jobs", "</h5>",
        "<h5>", "User Access Read allows users to view the application", "</h5>",
        "<h5>", "User Access Write allows users to view the application and update jobs", "</h5>",
        "<h5>", "User Access Admin allows users to view the application, update jobs and view the admin tab", "</h5>"
      )),
      
      shiny::fluidRow(
        
        shiny::column(
          
          width = 2,
          
          shinyWidgets::pickerInput(
            inputId = "in_body_admin_picker_user_id",
            label = h5("ID"),
            choices = c(),
            selected = c()
          )
          
        ),
        
        shiny::column(
          
          width = 2,
          
          shiny::textInput(
            inputId = "in_body_admin_text_user_name",
            label = h5("Name")
          )
          
        ),
        
        shiny::column(
          
          width = 2,
          
          shiny::textInput(
            inputId = "in_body_admin_text_user_role",
            label = h5("Role")
          )
          
        ),
        
        shiny::column(
          
          width = 2,
          
          shinyWidgets::pickerInput(
            inputId = "in_body_admin_picker_user_team",
            label = h5("Team"),
            choices = c(
              "Bench",
              "CNC",
              "Mill",
              "Program",
              "Spray",
              "Veneer"
            ),
            selected = c()
          )
          
        ),
        
        shiny::column(
          
          width = 2,
          
          shinyWidgets::pickerInput(
            inputId = "in_body_admin_picker_user_access",
            label = h5("Access"),
            choices = c(
              "Read",
              "Write",
              "Admin"
            ),
            selected = c(
              "Read"
            )
          )
          
        )
        
      ),
      
      br(),
      
      shiny::fluidRow(
        
        shiny::column(
          
          width = 3,
          
          shinyBS::bsButton(
            inputId = "in_body_admin_button_update_user",
            label = "Add / Update User",
            style = "primary"
          )
          
        )
        
      )
      
    ),
    
    # dates
    shinyBS::bsCollapsePanel(
      
      title = "Dates",
      style = "primary"
      
    )
    
  )
  
)