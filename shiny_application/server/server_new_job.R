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
  # modal_active
)

# ----------------------------------------------------------------------------------------- modal ----

# launch modal
fc_new_job_modal_launch <- function(
  dt_jobs = NULL
) {
  
  # if provided dt_jobs will be a single row
  
  # log that modal is shown
  rv_new_job$modal_active <- TRUE
  
  # log job id
  rv_new_job$job_id <- dt_jobs$job_id
  
  # show modal
  shiny::showModal(fc_new_job_modal(
    dt_jobs = dt_jobs
  ))
  
}

# define modal
fc_new_job_modal <- function(
  dt_jobs = NULL
) {
  
  # if provided dt_jobs will be a single row
  
  # modal title
  if (is.null(dt_jobs)) {modal_title <- "Create New Job"}
  if (!is.null(dt_jobs)) {modal_title <- paste0("Update Job ", dt_jobs$job_id)}
  
  # default values
  in_new_job_text_customer <- ""
  in_new_job_text_site <- ""
  in_new_job_text_cs_number <- ""
  in_new_job_text_dwg_number <- ""
  in_new_job_date_start_date <- Sys.Date()
  in_new_job_date_required_by <- Sys.Date() + 28
  in_new_job_numeric_hours_mill <- 0
  in_new_job_numeric_hours_program <- 0
  in_new_job_numeric_hours_cnc <- 0
  in_new_job_numeric_hours_veneer <- 0
  in_new_job_numeric_hours_bench <- 0
  in_new_job_numeric_hours_spray <- 0
  in_new_job_numeric_hours_dispatch <- 0
  
  # capture inputs
  if (!is.null(dt_jobs)) {
    
    in_new_job_text_customer <- dt_jobs$customer
    in_new_job_text_site <- dt_jobs$site
    in_new_job_text_cs_number <- dt_jobs$cs_number
    in_new_job_text_dwg_number <- dt_jobs$dwg_number
    in_new_job_date_start_date <- lubridate::as_date(dt_jobs$start_date)
    in_new_job_date_required_by <- lubridate::as_date(dt_jobs$required_by)
    in_new_job_numeric_hours_mill <- dt_jobs$hours_mill
    in_new_job_numeric_hours_program <- dt_jobs$hours_program
    in_new_job_numeric_hours_cnc <- dt_jobs$hours_cnc
    in_new_job_numeric_hours_veneer <- dt_jobs$hours_veneer
    in_new_job_numeric_hours_bench <- dt_jobs$hours_bench
    in_new_job_numeric_hours_spray <- dt_jobs$hours_spray
    in_new_job_numeric_hours_dispatch <- dt_jobs$hours_dispatch
    
  }
  
  # continue button
  if (is.null(dt_jobs)) {continue_button_label <- "Create Job"}
  if (!is.null(dt_jobs)) {continue_button_label <- "Update Job"}
  
  return(
    shiny::modalDialog(
      title = NULL,
      size = "l",
      easyClose = FALSE,
      footer = NULL,
      
      shiny::fluidRow(
        
        shiny::column(
          width = 6,
          
          h4(modal_title)
          
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
            label = h5("Customer"),
            value = in_new_job_text_customer
          )
          
        ),
        
        shiny::column(
          width = 6,
          
          shiny::textInput(
            inputId = "in_new_job_text_site",
            label = h5("Site"),
            value = in_new_job_text_site
          )
          
        )
        
      ),
      shiny::fluidRow(
        
        shiny::column(
          width = 6,
          
          shiny::textInput(
            inputId = "in_new_job_text_cs_number",
            label = h5("C/S Number"),
            value = in_new_job_text_cs_number
          )
          
        ),
        
        shiny::column(
          width = 6,
          
          shiny::textInput(
            inputId = "in_new_job_text_dwg_number",
            label = h5("DWG Number"),
            value = in_new_job_text_dwg_number
          )
          
        )
        
      ),
      shiny::fluidRow(
        
        shiny::column(
          width = 6,
          
          shiny::dateInput(
            inputId = "in_new_job_date_start_date",
            label = h5("Start Date"),
            value = in_new_job_date_start_date
          )
          
        ),
        
        shiny::column(
          width = 6,
          
          shiny::dateInput(
            inputId = "in_new_job_date_required_by",
            label = h5("Required By"),
            value = in_new_job_date_required_by
          )
          
        )
        
      ),
      
      hr(),
      
      # job hours
      h5("Estimated Hours"),
      
      shiny::fluidRow(
        
        shiny::column(
          width = 3,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_mill",
            label = h5("Mill Hours"),
            value = in_new_job_numeric_hours_mill
          )
          
        ),
        
        shiny::column(
          width = 3,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_program",
            label = h5("program Hours"),
            value = in_new_job_numeric_hours_program
          )
          
        ),
        
        shiny::column(
          width = 3,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_cnc",
            label = h5("CNC Hours"),
            value = in_new_job_numeric_hours_cnc
          )
          
        )
        
      ),
      
      shiny::fluidRow(
        
        shiny::column(
          width = 3,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_veneer",
            label = h5("Veneer Hours"),
            value = in_new_job_numeric_hours_veneer
          )
          
        ),
        
        shiny::column(
          width = 3,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_bench",
            label = h5("Bench Hours"),
            value = in_new_job_numeric_hours_bench
          )
          
        ),
        
        shiny::column(
          width = 3,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_spray",
            label = h5("Spray Hours"),
            value = in_new_job_numeric_hours_spray
          )
          
        ),
        
        shiny::column(
          width = 3,
          
          shiny::numericInput(
            inputId = "in_new_job_numeric_hours_dispatch",
            label = h5("Dispatch Hours"),
            value = in_new_job_numeric_hours_dispatch
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
            label = continue_button_label,
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

# create job
shiny::observeEvent(input$in_new_job_button_continue, {
  
  # loading screen
  shinyjs::show("div_ui_global_loading_screen")
  
  fc_log(
    message = "create job shiny::observeEvent: input$in_new_job_button_continue",
    script = "server_new_job.R"
  )
  
  # static copies
  dt_jobs <- data.table::copy(rv$dt_jobs)
  
  # create new job id if required
  if (is.null(rv_new_job$job_id)) {job_id_new <- max(dt_jobs$job_id, 0) + 1}
  if (!is.null(rv_new_job$job_id)) {job_id_new <- rv_new_job$job_id}
  
  # create new row in dt_jobs
  dt_jobs_new <- data.table::data.table(
    job_id = job_id_new,
    
    customer = as.character(input$in_new_job_text_customer),
    site = as.character(input$in_new_job_text_site),
    cs_number = as.character(input$in_new_job_text_cs_number),
    dwg_number = as.character(input$in_new_job_text_dwg_number),
    start_date = as.numeric(input$in_new_job_date_start_date),
    required_by = as.numeric(input$in_new_job_date_required_by),
    hours_mill = as.numeric(input$in_new_job_numeric_hours_mill),
    hours_program = as.numeric(input$in_new_job_numeric_hours_program),
    hours_cnc = as.numeric(input$in_new_job_numeric_hours_cnc),
    hours_veneer = as.numeric(input$in_new_job_numeric_hours_veneer),
    hours_bench = as.numeric(input$in_new_job_numeric_hours_bench),
    hours_spray = as.numeric(input$in_new_job_numeric_hours_spray),
    hours_dispatch = as.numeric(input$in_new_job_numeric_hours_dispatch),
    
    active = 1,
    created_by = as.character(rv$user),
    created_on = lubridate::as_datetime(Sys.time()),
    updated_by = as.character(rv$user),
    updated_on = lubridate::as_datetime(Sys.time())
  )
  
  # deactivate old row
  if (!is.null(rv_new_job$job_id)) {dt_jobs[job_id == rv_new_job$job_id, active := 0]}
  
  # add new row to dt_jobs
  dt_jobs <- rbind(
    dt_jobs,
    dt_jobs_new,
    fill = TRUE
  )
  
  # update rv
  rv$dt_jobs <- data.table::copy(dt_jobs)
  
  # recalculate
  rv$dt_jobs <- fc_algorithm(
    dt_jobs = rv$dt_jobs,
    non_work_dates = rv$non_work_dates
  )
  
  # clear reactive
  rv_new_job <- NULL
  
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
      "<h5>",
      "Total Hours: ",
      sum(
        input$in_new_job_numeric_hours_mill,
        input$in_new_job_numeric_hours_program,
        input$in_new_job_numeric_hours_cnc,
        input$in_new_job_numeric_hours_veneer,
        input$in_new_job_numeric_hours_bench,
        input$in_new_job_numeric_hours_spray,
        input$in_new_job_numeric_hours_dispatch,
        na.rm = TRUE
      ),
      "</h5>"
    ))
  )
  
})