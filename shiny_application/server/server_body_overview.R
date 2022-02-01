#* script name      server_body_overview.R
#* script goal      manage the server of the ui_body_overview.R script
#* 
#* naming convention
#* div elements     div_body_overview
#* functions        fc_body_overview
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- reactives ----

# ----------------------------------------------------------------------------------------- observes ----

# hide / show update job button
shiny::observe({
  
  if (is.null(input$out_body_overview_table_jobs_rows_selected)) {shinyjs::hide("div_body_overview_selected_job")}
  if (!is.null(input$out_body_overview_table_jobs_rows_selected)) {shinyjs::show("div_body_overview_selected_job")}
  
})

# update job
shiny::observeEvent(input$in_body_overview_button_update_job, {
  
  req(rv$dt_jobs)
  req(input$out_body_overview_table_jobs_rows_selected)
  
  # loading screen
  shinyjs::show("div_ui_global_loading_screen")
  
  fc_log(
    message = "launch new job modal shiny::observeEvent: input$in_body_overview_button_update_job",
    script = "server_header.R"
  )
  
  # static copy
  dt_jobs <- data.table::copy(rv$dt_jobs)
  
  # reduce to required rows only display
  dt_jobs <- fc_body_overview_display(dt_jobs)
  
  fc_new_job_modal_launch(
    dt_jobs = dt_jobs[input$out_body_overview_table_jobs_rows_selected, ]
  )
  
  # loading screen
  shinyjs::hide("div_ui_global_loading_screen")
  
})

# ----------------------------------------------------------------------------------------- render ui ----

output$out_body_overview_table_jobs <- DT::renderDataTable({
  
  req(rv$dt_jobs)
  
  # static copy
  dt_jobs <- data.table::copy(rv$dt_jobs)
  
  # reduce to required rows only display
  dt_jobs <- fc_body_overview_display(dt_jobs)
  
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

# gantt chart for selected job
output$out_body_overview_plot_gantt_job <- shiny::renderPlot({
  
  req(rv$dt_jobs)
  req(input$out_body_overview_table_jobs_rows_selected)
  
  # static copy
  dt_jobs <- data.table::copy(rv$dt_jobs)
  
  # reduce to required rows only display
  dt_jobs <- fc_body_overview_display(dt_jobs)
  
  # reduce to selected row
  dt_jobs <- dt_jobs[input$out_body_overview_table_jobs_rows_selected, ]
  
  # create table
  output <- fc_body_overview_gantt_data(
    dt_jobs = dt_jobs
  )
  
  # capture required_by
  required_by <- dt_jobs$required_by
  
  return(
    ggplot2::ggplot(
      output,
      ggplot2::aes(value, name, colour = name)
    ) + 
      ggplot2::geom_line(
        size = 6,
        show.legend = FALSE
      ) +
      ggplot2::xlab(NULL) + 
      ggplot2::ylab(NULL) +
      ggplot2::annotate(
        geom = "vline",
        x = required_by,
        xintercept = required_by,
        linetype = "solid"
      ) +
      ggplot2::annotate(
        geom = "text",
        label = paste0("Required by ", required_by),
        x = required_by + 0.1,
        y = 3.5,
        angle = 90, 
        vjust = 1
      )
  )
  
})

# ----------------------------------------------------------------------------------------- helper functions ----

# create data.table for display
fc_body_overview_display <- function(
  dt_jobs
) {
  
  # active rows only
  output <- dt_jobs[active == 1]
  
  return(output)
  
}

# create data.table for use in rendering gantt chart
fc_body_overview_gantt_data <- function(
  dt_jobs
) {
  
  # capture start date
  start_date <- Sys.Date()
  
  # order is
  # mill
  # program
  # cnc
  # veneer
  # bench
  # spray
  # dispatch
  
  # calculate other start and end dates
  start_date_mill <- start_date
  end_date_mill <- start_date_mill + fc_body_overview_working_days(dt_jobs$hours_mill)
  start_date_program <- end_date_mill
  end_date_program <- start_date_program + fc_body_overview_working_days(dt_jobs$hours_program)
  start_date_cnc <- end_date_program
  end_date_cnc <- start_date_cnc + fc_body_overview_working_days(dt_jobs$hours_cnc)
  start_date_veneer <- end_date_cnc
  end_date_veneer <- start_date_veneer + fc_body_overview_working_days(dt_jobs$hours_veneer)
  start_date_bench <- end_date_veneer
  end_date_bench <- start_date_bench + fc_body_overview_working_days(dt_jobs$hours_bench)
  start_date_spray <- end_date_bench
  end_date_spray <- start_date_spray + fc_body_overview_working_days(dt_jobs$hours_spray)
  
  # 
  items <- c(
    "Mill",
    "Program",
    "CNC",
    "Veneer",
    "Bench",
    "Spray"
  )
  
  # create table
  output <- data.table::data.table(
    name = factor(items, levels = items),
    start_date = as.Date(c(
      start_date_mill,
      start_date_program,
      start_date_cnc,
      start_date_veneer,
      start_date_bench,
      start_date_spray
    )),
    end_date = as.Date(c(
      end_date_mill,
      end_date_program,
      end_date_cnc,
      end_date_veneer,
      end_date_bench,
      end_date_spray
    ))
  )
  
  # melt table
  output <- data.table::melt(
    data = output,
    measure.vars = c("start_date", "end_date")
  )
  
  return(output)
  
}

# calculate work days given hours
fc_body_overview_working_days <- function(
  hours,
  hours_in_day = 7
) {
  
  # calculate number of working days
  days <- ceiling(hours / hours_in_day)
  
  return(days)
  
}

