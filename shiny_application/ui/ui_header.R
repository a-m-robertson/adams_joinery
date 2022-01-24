#* script name      ui_header.R
#* script goal      manage the user interface (ui) of the header section
#* 
#* naming convention
#* div elements     div_ui_header
#* functions        fc_ui_header
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- ui body ----

ui_header <- shiny::fluidPage(
  
  shiny::fluidRow(
    
    shiny::column(
      width = 4,
      h4("Adams Joinery Production Schedule")
    ),
    
    shiny::column(
      width = 3,
      offset = 5,
      
      shiny::wellPanel(
        
        shiny::fluidRow(
          
          shiny::column(
            width = 3,
            align = "center",
            shiny::actionLink(
              inputId = "in_header_button_new_job",
              label = HTML("<img class= 'animatedImage' src='./icons/icon_new_job.png' height='40' width='40' data-toggle='popover' title='Create New Job'/>")
            )
          )
          
        )
        
      )
      
    )
    
  ), 
  
  hr()
  
)