#* script name      database_functions.R
#* script goal      manage database functions
#* 
#* naming convention
#* functions        fc_database_
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- create dt_jobs from database ----

# ss is URL or ID of google sheet
fc_database_jobs_from <- function(
  ss = "global/database/jobs.xlsx"
) {
  
  # load from workbook
  input <- googlesheets4::read_sheet(
    ss = ss,
    sheet = "jobs"
  ) %>% data.table::setDT()
  
  # default output
  output <- NULL
  
  # loop through rows in input
  for (i in 1:nrow(input)) {
    
    if (fc_json_validate(input[i, job_data])) {
      
      # get job data
      dt_job <- fc_json_from(input[i, job_data])

      # date time columns
      date_time_columns <- intersect(
        colnames(dt_job),
        c(
          "created_on",
          "updated_on"
        )
      )
      dt_job[, (date_time_columns):= lapply(.SD, lubridate::as_datetime), .SDcols = date_time_columns]
      
      # create / add to output
      if (!is.null(output)) {
        
        # add rows to output
        output <- rbind(
          output,
          dt_job,
          fill = TRUE
        )
        
      }
      if (is.null(output)) {
        
        output <- data.table::copy(dt_job)
        
      }  
      
    }
    
  }
  
  # default if no jobs exist
  if (is.null(output)) {
    
    output <- data.table::data.table(
      job_id = as.numeric()
    )
    
  }
  
  return(output)
  
}

# ----------------------------------------------------------------------------------------- send dt_jobs to database ----

# ss is URL or ID of google sheet
fc_database_jobs_to <- function(
  dt_jobs,
  ss = "global/database/jobs.xlsx"
) {
  
  # default output
  output <- NULL
  
  # create data in format for writing to database
  for (i in dt_jobs$job_id) {
    
    if (!is.null(output)) {
      
      output <- rbind(
        output,
        data.table::data.table(
          job_id = dt_jobs[i, job_id],
          job_data = fc_json_to(dt_jobs[i, ])
        ),
        fill = TRUE
      )
      
    }
    if (is.null(output)) {
      
      output <- data.table::data.table(
        job_id = dt_jobs[i, job_id],
        job_data = fc_json_to(dt_jobs[i, ])
      )
      
    }
    
  }
  
  # overwrite existing workbook
  fc_database_write_to(
    input = output,
    ss = ss,
    sheet = "jobs"
  )
  
}

# ----------------------------------------------------------------------------------------- create non_work_dates from database ----

# ss is URL or ID of google sheet
fc_database_dates_from <- function(
  ss = "global/database/dates.xlsx"
) {
  
  # load from workbook
  input <- googlesheets4::read_sheet(
    ss = ss,
    sheet = "dates"
  ) %>% data.table::setDT()
  
  # create output
  output <- fc_json_from(input$dates)
  
  # as date
  output <- as.Date(output)
  
  return(output)
  
}

# ----------------------------------------------------------------------------------------- create dt_users from database ----

# ss is URL or ID of google sheet
fc_database_users_from <- function(
  path = "global/database/users.xlsx"
) {
  
  # load from workbook
  input <- googlesheets4::read_sheet(
    ss = ss,
    sheet = "users"
  ) %>% data.table::setDT()
  
  # create output
  output <- fc_json_from(input$users)
  
  # as data.table
  data.table::setDT(output)
  
  # data types
  output[, id := as.numeric(id)]
  output[, name := as.character(name)]
  output[, role := as.character(role)]
  output[, team := as.character(team)]
  output[, access := as.character(access)]
  
  return(output)
  
}

# ----------------------------------------------------------------------------------------- helper functions ----

# write to database
fc_database_write_to <- function(
  input,
  path,
  sheet
) {
  
  tryCatch(
    {
      
      # overwrite google sheet
      googlesheets4::sheet_write(
        data = input,
        ss = ss,
        sheet = sheet
      )
      
    },
    error = function(message) {
      
      fc_log(
        message = paste0("error: ", message),
        script = "database_functions.R"
      )
      
    }
  )
  
}
