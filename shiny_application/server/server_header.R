#* script name      server_header.R
#* script goal      manage the server of the ui_header.R script
#* 
#* naming convention
#* div elements     div_body_header
#* functions        fc_body_header
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- reactives ----

# ----------------------------------------------------------------------------------------- observes ----

# new job
shiny::observeEvent(input$in_header_button_new_job, {
  
  # loading screen
  shinyjs::show("div_ui_global_loading_screen")
  
  fc_log(
    message = "launch new job modal shiny::observeEvent: input$in_header_button_new_job",
    script = "server_header.R"
  )
  
  fc_new_job_modal_launch()
  
  # loading screen
  shinyjs::hide("div_ui_global_loading_screen")
  
})

# update database
shiny::observeEvent(input$in_header_button_update_database, {
  
  # loading screen
  shinyjs::show("div_ui_global_loading_screen")
  
  fc_log(
    message = "update database shiny::observeEvent: input$in_header_button_update_database",
    script = "server_header.R"
  )
  
  tryCatch(
    {
      
      # update database
      fc_database_jobs_to(
        dt_jobs = rv$dt_jobs
      )
      
      # update rv
      rv$dt_jobs = fc_database_jobs_from()
      
      # notify user
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "Update Database",
        text = "Complete!",
        type = "info"
      )
      
    },
    error = function(cond) {
      
      # log error message
      fc_log(
        message = paste0("error: ", cond),
        script = "server_header.R"
      )
      
      # notify user
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "Update Database",
        text = paste0("Database update failed: ", cond),
        type = "warning"
      )
      
    }
  )

  # loading screen
  shinyjs::hide("div_ui_global_loading_screen")
  
})

# ----------------------------------------------------------------------------------------- render ui ----


# ----------------------------------------------------------------------------------------- helper functions ----

