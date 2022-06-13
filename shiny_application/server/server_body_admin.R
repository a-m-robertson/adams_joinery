#* script name      server_body_admin.R
#* script goal      manage the server of the ui_body_admin.R script
#* 
#* naming convention
#* div elements     div_body_admin.R
#* functions        fc_body_admin.R
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- reactives ----

# ----------------------------------------------------------------------------------------- observes ----

# populate in_body_admin_picker_user_id
shiny::observe({
  
  req(rv$dt_users)
  
  # static copy
  dt_users <- data.table::copy(rv$dt_users)
  
  # populate user id picker with ids
  shinyWidgets::updatePickerInput(
    session = session,
    inputId = "in_body_admin_picker_user_id",
    choices = c(
      "New User",
      dt_users$id
    ),
    selected = c(
      "New User"
    )
  )
  
})

# update users
shiny::observeEvent(input$in_body_admin_button_update_user, {
  
  req(rv$dt_users)
  
  # loading screen
  shinyjs::show("div_ui_global_loading_screen")
  
  fc_log(
    message = "add / update users shiny::observeEvent: input$in_body_admin_button_update_user",
    script = "server_body_admin.R"
  )
  
  # static copy
  dt_users <- data.table::copy(rv$dt_users)
  
  # capture inputs
  if (input$in_body_admin_picker_user_id == "New User") {user_id <- as.numeric(max(dt_users$id, na.rm = TRUE) + 1)}
  if (input$in_body_admin_picker_user_id != "New User") {user_id <- as.numeric(input$in_body_admin_picker_user_id)}
  
  user_name <- input$in_body_admin_text_user_name
  user_role <- input$in_body_admin_text_user_role
  user_team <- input$in_body_admin_picker_user_team
  user_access <- input$in_body_admin_picker_user_access
  
  # remove selected id row
  dt_users <- dt_users[id != user_id]
  
  # add new row
  dt_users <- rbind(
    dt_users,
    data.table::data.table(
      id = user_id,
      name = user_name,
      role = user_role,
      team = user_team,
      access = user_access
    ),
    fill = TRUE
  )
  
  # order by id
  data.table::setorder(
    dt_users,
    id
  )
  
  # create data table for storing
  output <- data.table::data.table(
    users = fc_json_to(dt_users)
  )
  
  # overwrite existing workbook
  fc_database_write_to(
    input = output,
    path = "global/database/users.xlsx",
    sheet = "users"
  )
  
  # update rv
  rv$dt_users = fc_database_users_from()
  
  # loading screen
  shinyjs::hide("div_ui_global_loading_screen")
  
})

# add date
shiny::observeEvent(input$in_body_admin_button_add_date, {
  
  req(rv$non_work_dates)
  req(input$in_body_admin_button_date)
  
  # loading screen
  shinyjs::show("div_ui_global_loading_screen")
  
  fc_log(
    message = "add date shiny::observeEvent: input$in_body_admin_button_add_date",
    script = "server_body_admin.R"
  )
  
  # remove date from rv
  rv$non_work_dates <- union(
    x = rv$non_work_dates,
    y = input$in_body_admin_button_date
  ) %>% lubridate::as_date() %>% sort()
  
  # create data table for storing
  output <- data.table::data.table(
    dates = fc_json_to(rv$non_work_dates)
  )
  
  # overwrite existing workbook
  fc_database_write_to(
    input = output,
    path = "global/database/dates.xlsx",
    sheet = "non work dates"
  )
  
  # loading screen
  shinyjs::hide("div_ui_global_loading_screen")
  
})

# remove date
shiny::observeEvent(input$in_body_admin_button_delete_date, {
  
  req(rv$non_work_dates)
  req(input$out_body_admin_table_dates_rows_selected)
  
  # loading screen
  shinyjs::show("div_ui_global_loading_screen")
  
  fc_log(
    message = "remove date shiny::observeEvent: input$in_body_admin_button_delete_date",
    script = "server_body_admin.R"
  )
  
  # capture selection
  selection <- rv$non_work_dates[input$out_body_admin_table_dates_rows_selected]
  
  # remove date from rv
  rv$non_work_dates <- setdiff(
    x = rv$non_work_dates,
    y = selection
  ) %>% lubridate::as_date()
  
  # create data table for storing
  output <- data.table::data.table(
    dates = fc_json_to(rv$non_work_dates)
  )
  
  # overwrite existing workbook
  fc_database_write_to(
    input = output,
    path = "global/database/dates.xlsx",
    sheet = "non work dates"
  )
  
  # loading screen
  shinyjs::hide("div_ui_global_loading_screen")
  
})

# ----------------------------------------------------------------------------------------- render ui ----

# table of users
output$out_body_admin_table_users <- DT::renderDataTable({
  
  req(rv$dt_users)
  
  # static copy
  dt_users <- data.table::copy(rv$dt_users)
  
  # return table
  return(
    DT::datatable(
      data = dt_users,
      rownames = FALSE,
      selection = "single",
      extensions = "Buttons",
      options = list(
        scrollX = TRUE,
        dom = "Blfrtip", 
        buttons = list(
          list(extend = "excel", filename = "Users"),
          list(extend = "copy", filename = "Users")
        )
      )
    )
  )
  
})

# table of dates
output$out_body_admin_table_dates <- DT::renderDataTable({
  
  req(rv$non_work_dates)
  
  # create table
  dt_non_work_dates <- data.table::data.table(
    date = rv$non_work_dates,
    year = lubridate::year(rv$non_work_dates),
    month = lubridate::month(rv$non_work_dates, label = TRUE, abbr = FALSE),
    day = weekdays(rv$non_work_dates)
  )
  
  # return table
  return(
    DT::datatable(
      data = dt_non_work_dates,
      rownames = FALSE,
      selection = "single",
      extensions = "Buttons",
      filter = c("top"),
      options = list(
        scrollX = TRUE,
        dom = "Blfrtip",
        buttons = list(
          list(extend = "excel", filename = "Non-Work Days"),
          list(extend = "copy", filename = "Non-Work Days")
        )
      )
    )
  )
  
})

# upcoming work dates
output$out_body_admin_message_dates <- shiny::renderUI({
  
  req(rv$non_work_dates)
  
  upcoming <- rv$non_work_dates[rv$non_work_dates > Sys.Date()][1:10]
  
  return(HTML(paste0(
    "<h5>", "The upcoming non work days are: ", "</h5>",
    "<h5>", "<b>", paste0(paste(lubridate::wday(upcoming, label = TRUE), upcoming), collapse = ", "), "</b>", "</h5>"
  )))
  
})

# ----------------------------------------------------------------------------------------- helper functions ----

