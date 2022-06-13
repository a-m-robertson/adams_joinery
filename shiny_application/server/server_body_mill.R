#* script name      server_body_mill.R
#* script goal      manage the server of the ui_body_mill.R script
#* 
#* naming convention
#* div elements     div_body_mill
#* functions        fc_body_mill
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- reactives ----

# ----------------------------------------------------------------------------------------- observes ----

# ----------------------------------------------------------------------------------------- render ui ----

output$out_body_mill_table_jobs <- DT::renderDataTable({
  
  req(rv$dt_jobs)
  
  # static copy
  dt_jobs <- data.table::copy(rv$dt_jobs)
  
  # reduce to required rows only display
  dt_jobs <- fc_body_overview_jobs_display(
    dt_jobs = dt_jobs,
    format = TRUE
  )
  
  # return table
  return(
    DT::datatable(
      data = dt_jobs,
      rownames = FALSE,
      selection = "single",
      extensions = "Buttons",
      options = list(
        scrollX = TRUE,
        dom = "Blfrtip", 
        buttons = list(
          list(extend = "excel", filename = "Active Jobs"),
          list(extend = "copy", filename = "Active Jobs")
        )
      )
    )
  )
  
})

# ----------------------------------------------------------------------------------------- helper functions ----

