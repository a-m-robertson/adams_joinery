#* script name      server_new_job.R
#* script goal      define and manage modal for new jobs
#* 
#* naming convention
#* div elements     div_new_job
#* functions        fc_new_job
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- reactives ----

rv_new_job <- shiny::reactiveValues(
  # dt_quotes
  # modal_active
)

# ----------------------------------------------------------------------------------------- modal ----

# launch modal
fc_new_job_modal_launch <- function() {
  
  # log that modal is shown
  rv_new_job$modal_active <- TRUE
  
  # show modal
  shiny::showModal(fc_new_job_modal())
  
}

# define modal
fc_new_job_modal <- function() {
  
  return(
    shiny::modalDialog(
      title = NULL,
      size = "l",
      easyClose = FALSE,
      footer = NULL,
      
      shiny::fluidRow(
        
        shiny::column(
          width = 6,
          
          h4("Create New Job")
          
        ),
        
        # close button
        shiny::column(
          width = 1,
          offset = 5,
          align = "right",
          
          shinyBS::bsButton(
            inputId = "in_new_job_button_close",
            label = "",
            icon = icon("times"),
            style = "primary"
          )
          
        )
        
      ),
      
      hr(),
      
      # job info
      shiny::fluidRow(
        
        shiny::column(
          width = 6,
          
          shiny::textInput(
            inputId = "in_new_job_text_customer",
            label = h5("Customer")
          )
          
        ),
        
        shiny::column(
          width = 6,
          
          shiny::textInput(
            inputId = "in_new_job_text_site",
            label = h5("Site")
          )
          
        )
        
      ),
      shiny::fluidRow(
        
        shiny::column(
          width = 6,
          
          shiny::textInput(
            inputId = "in_new_job_text_cs_number",
            label = h5("C/S Number")
          )
          
        ),
        
        shiny::column(
          width = 6,
          
          shiny::textInput(
            inputId = "in_new_job_text_dwg_number",
            label = h5("DWG Number")
          )
          
        )
        
      ),
      shiny::fluidRow(
        
        shiny::column(
          width = 6,
          
          shiny::dateInput(
            inputId = "in_new_job_date_required_by",
            label = h5("Required By"),
            value = Sys.Date() + 28
          )
          
        )
        
      ),
      
      hr(),
      
      # job hours
      h5("Estimated Hours"),
      
      shiny::fluidRow(
        
        shiny::column(
          width = 4,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_mill",
            label = h5("Mill Hours"),
            value = 0
          )
          
        ),
        
        shiny::column(
          width = 4,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_programming",
            label = h5("Programming Hours"),
            value = 0
          )
          
        ),
        
        shiny::column(
          width = 4,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_cnc",
            label = h5("CNC Hours"),
            value = 0
          )
          
        )
        
      ),
      
      shiny::fluidRow(
        
        shiny::column(
          width = 4,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_veneer",
            label = h5("Veneer Hours"),
            value = 0
          )
          
        ),
        
        shiny::column(
          width = 4,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_bench",
            label = h5("Bench Hours"),
            value = 0
          )
          
        ),
        
        shiny::column(
          width = 4,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_spray",
            label = h5("Spray Hours"),
            value = 0
          )
          
        )
        
      ),
      
      shiny::uiOutput(
        outputId = "out_new_job_hours_total"
      ),
      
      hr(),
      
      # continue button
      shiny::fluidRow(
        
        shiny::column(
          width = 12,
          align = "right",
          
          shinyBS::bsButton(
            inputId = "in_new_job_button_continue",
            label = "Create Job",
            style = "primary"
          )
          
        )
        
      )
      
    )
  )
  
}

# ----------------------------------------------------------------------------------------- observes ----

# close modal
shiny::observeEvent(input$in_new_job_button_close, {
  
  # clear reactive
  rv_new_job <- NULL
  
  shiny::removeModal(session)
  
})

# load quote
shiny::observeEvent(input$in_new_job_button_continue, {
  
  # loading screen
  shinyjs::show("div_ui_global_loading_screen")
  
  fc_log(
    message = "load quote shiny::observeEvent: input$in_existing_button_load",
    script = "server_existing.R"
  )
  
  # clear reactive
  rv_existing <- NULL
  
  shiny::removeModal(session) 
  
  # loading screen
  shinyjs::hide("div_ui_global_loading_screen")
  
})

# ----------------------------------------------------------------------------------------- render ui ----

# total hours
output$out_new_job_hours_total <- shiny::renderUI({
  
  req(rv_new_job$modal_active)
  
  return(
    HTML(paste0(
      "Total Hours: ",
      sum(
        input$in_new_job_numeric_hours_mill,
        input$in_new_job_numeric_hours_programming,
        input$in_new_job_numeric_hours_cnc,
        input$in_new_job_numeric_hours_veneer,
        input$in_new_job_numeric_hours_bench,
        input$in_new_job_numeric_hours_spray,
        na.rm = TRUE
      )
    ))
  )
  
})