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
fc_database_from <- function(
  path = "global/database.xlsx"
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
      
      # date columns
      date_columns <- c("required_by")
      dt_job[, (date_columns):= lapply(.SD, as.Date), .SDcols = date_columns]
      
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
fc_database_to <- function(
  dt_jobs,
  path = "global/database.xlsx"
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
  
  # create workbook
  wb <- openxlsx::createWorkbook()
  
  # add database sheet
  openxlsx::addWorksheet(
    wb = wb, 
    sheetName = "database"
  )
  
  # write data to workbook
  openxlsx::writeData(
    wb = wb,
    sheet = "database",
    x = output,
    startRow = 1,
    startCol = 1,
    colNames = TRUE,
    rowNames = FALSE
  )
  
  # overwrite existing workbook
  openxlsx::saveWorkbook(
    wb = wb, 
    file = path,
    overwrite = TRUE
  )
  
}

