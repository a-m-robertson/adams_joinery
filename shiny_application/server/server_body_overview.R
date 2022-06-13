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
    script = "server_body_overview.R"
  )
  
  # static copy
  dt_jobs <- data.table::copy(rv$dt_jobs)
  
  # reduce to required rows only display
  dt_jobs <- fc_body_overview_jobs_display(dt_jobs)
  
  fc_new_job_modal_launch(
    dt_jobs = dt_jobs[input$out_body_overview_table_jobs_rows_selected, ]
  )
  
  # loading screen
  shinyjs::hide("div_ui_global_loading_screen")
  
})

# ----------------------------------------------------------------------------------------- render ui ----

# table of jobs
output$out_body_overview_table_jobs <- DT::renderDataTable({
  
  req(rv$dt_jobs)
  
  # static copy
  dt_jobs <- data.table::copy(rv$dt_jobs)
  
  # reduce to required rows only display and format columns
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
    ) %>%
      # highlight overrun rows
      formatStyle(
        columns = "days_overrun",
        target = "row",
        backgroundColor = DT::styleInterval(
          c(0),
          c("#FFFFFF", "#FFD6DE")
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
  dt_jobs <- fc_body_overview_jobs_display(dt_jobs)
  
  # reduce to selected row
  dt_jobs <- dt_jobs[input$out_body_overview_table_jobs_rows_selected, ]
  
  # create table
  output <- fc_body_overview_gantt_data(
    dt_jobs = dt_jobs
  )
  
  # capture required_by as date
  required_by <- lubridate::as_date(dt_jobs$required_by)
  
  # x axis breaks and labels
  x_axis_breaks <- seq(
    lubridate::as_date(min(output$value)),
    lubridate::as_date(max(required_by, output$value)),
    by = "days"
  )
  x_axis_labels <- seq(
    lubridate::as_date(min(output$value)),
    lubridate::as_date(max(required_by, output$value)),
    by = "days"
  ) %>% lubridate::as_date() %>% format(format = "%b %d") %>% as.character()
  
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
      ) + 
      ggplot2::scale_x_date(
        breaks = x_axis_breaks,
        labels = x_axis_labels
      )
  )
  
})

# ----------------------------------------------------------------------------------------- helper functions ----

# create data.table for display
fc_body_overview_jobs_display <- function(
  dt_jobs,
  format = FALSE
) {
  
  # active rows only
  output <- dt_jobs[active == 1]
  
  if (format) {
    
    # format date columns
    date_columns <- c(
      "start_date",
      "required_by",
      "start_date_mill",
      "end_date_mill",
      "start_date_program",
      "end_date_program",
      "start_date_cnc",
      "end_date_cnc",
      "start_date_veneer",
      "end_date_veneer",
      "start_date_bench",
      "end_date_bench",
      "start_date_spray",
      "end_date_spray",
      "start_date_dispatch",
      "end_date_dispatch",
      "start_date_recommended"
    )
    output[, (date_columns)] <- lapply(
      output[, (date_columns), with = FALSE],
      lubridate::as_date
    ) %>% data.table::as.data.table()
    
  }
  
  return(output)
  
}

# create data.table for use in rendering gantt chart
fc_body_overview_gantt_data <- function(
  dt_jobs
) {
  
  # 
  items <- c(
    "Mill",
    "Program",
    "CNC",
    "Veneer",
    "Bench",
    "Spray",
    "Dispatch"
  )
  
  # create table
  output <- data.table::data.table(
    name = factor(items, levels = items),
    start_date = lubridate::as_date(c(
      dt_jobs$start_date_mill,
      dt_jobs$start_date_program,
      dt_jobs$start_date_cnc,
      dt_jobs$start_date_veneer,
      dt_jobs$start_date_bench,
      dt_jobs$start_date_spray,
      dt_jobs$start_date_dispatch
    )),
    end_date = lubridate::as_date(c(
      dt_jobs$end_date_mill,
      dt_jobs$end_date_program,
      dt_jobs$end_date_cnc,
      dt_jobs$end_date_veneer,
      dt_jobs$end_date_bench,
      dt_jobs$end_date_spray,
      dt_jobs$end_date_dispatch
    ))
  )
  
  # melt table
  output <- data.table::melt(
    data = output,
    measure.vars = c("start_date", "end_date")
  )
  
  return(output)
  
}



