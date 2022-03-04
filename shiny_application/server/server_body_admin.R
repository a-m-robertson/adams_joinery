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
    sheet = "jobs"
  )
  
  # update rv
  rv$dt_users = fc_database_users_from()
  
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

# ----------------------------------------------------------------------------------------- helper functions ----

