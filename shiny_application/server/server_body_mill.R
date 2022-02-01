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
  output <- data.table::copy(rv$dt_jobs)
  
  # return table
  return(
    DT::datatable(
      data = output,
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

