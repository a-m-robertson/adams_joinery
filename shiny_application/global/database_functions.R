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

# path is location of workbook database
fc_database_jobs_from <- function(
  path = "global/database/jobs.xlsx"
) {
  
  # load from workbook
  input <- readxl::read_xlsx(path) %>% data.table::setDT()
  
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

# path is location of workbook database
fc_database_jobs_to <- function(
  dt_jobs,
  path = "global/database/jobs.xlsx"
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
    path = path,
    sheet = "jobs"
  )
  
}

# ----------------------------------------------------------------------------------------- create non_work_dates from database ----

# path is location of workbook database
fc_database_dates_from <- function(
  path = "global/database/dates.xlsx"
) {
  
  # load from workbook
  input <- readxl::read_xlsx(path) %>% data.table::setDT()
  
  # create output
  output <- fc_json_from(input$dates)
  
  # as date
  output <- as.Date(output)
  
  return(output)
  
}

# ----------------------------------------------------------------------------------------- create dt_users from database ----

# path is location of workbook database
fc_database_users_from <- function(
  path = "global/database/users.xlsx"
) {
  
  # load from workbook
  input <- readxl::read_xlsx(path) %>% data.table::setDT()
  
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
  
  # create workbook
  wb <- openxlsx::createWorkbook()
  
  # add sheet
  openxlsx::addWorksheet(
    wb = wb, 
    sheetName = sheet
  )
  
  # write data to workbook
  openxlsx::writeData(
    wb = wb,
    sheet = sheet,
    x = input,
    startRow = 1,
    startCol = 1,
    colNames = TRUE,
    rowNames = FALSE
  )
  
  tryCatch(
    {
      
      # create temp copy of old database
      temp_path <- gsub(
        x = path,
        pattern = ".xl",
        replacement = "-temp.xl"
      )
      file.copy(
        from = path,
        to = temp_path
      )
      
      # create new workbook
      openxlsx::saveWorkbook(
        wb = wb, 
        file = path,
        overwrite = TRUE
      )
      
      # delete old
      file.remove(temp_path)
      
    },
    error = function(message) {
      
      fc_log(
        message = paste0("error: ", message),
        script = "database_functions.R"
      )
      
    }
  )
  
}
