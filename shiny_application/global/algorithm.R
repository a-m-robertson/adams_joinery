#* script name      algorithm.R
#* script goal      manage algorithm functions
#* 
#* naming convention
#* functions        fc_algorithm_
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# -----------------------------------------------------------------------------------------  ----

fc_algorithm <- function(
  dt_jobs,
  non_work_dates
) {
  
  fc_log(
    message = "fc_algorithm",
    script = "algorithm.R"
  )
  
  # order is
  # mill
  # program
  # cnc
  # veneer
  # bench
  # spray
  # dispatch
  
  # calculate end dates
  dt_jobs <- fc_algorithm_end_dates(
    dt_jobs = dt_jobs,
    non_work_dates = non_work_dates
  )
  
  # calculate required start date
  dt_jobs <- fc_algorithm_recommended_start_date(
    dt_jobs = dt_jobs
  )
  
  return(dt_jobs)
  
}

# ----------------------------------------------------------------------------------------- apply defaults ----

# add required fields
fc_algorithm_apply_defaults <- function(
  dt_jobs
) {
  
  return(dt_jobs)
  
}

# ----------------------------------------------------------------------------------------- calculate end date ----

# calculate end date given start date and hours considering hours in day and working week
fc_algorithm_end_dates <- function(
  dt_jobs,
  non_work_dates,
  hours_in_day = 7
) {
  
  fc_log(
    message = "fc_algorithm_end_dates",
    script = "algorithm.R"
  )
  
  # order is
  # mill
  # program
  # cnc
  # veneer
  # bench
  # spray
  # dispatch
  
  
  # mill
  
  # if start_date_mill is not populate it then default to start_date
  if (!"start_date_mill" %in% colnames(dt_jobs)) {dt_jobs[, start_date_mill := start_date]}
  dt_jobs[is.na(start_date_mill), start_date_mill := start_date]
  
  # calculate number of working days
  dt_jobs[, days_mill := ceiling(hours_mill / hours_in_day)]
  
  # calculate end_date
  dt_jobs[, end_date_mill := start_date_mill + days_mill]
  
  # extend for non work days
  for (i in 1:nrow(dt_jobs)) {
    
    dt_jobs$end_date_mill[i] <- dt_jobs[i, end_date_mill] + length(intersect(
      non_work_dates,
      seq(
        from = as.Date(dt_jobs[i, start_date_mill]),
        to = as.Date(dt_jobs[i, end_date_mill]),
        by = "days"
      )
    ))
    
  }

  # ensure end_date is a work day
  while (dt_jobs[end_date_mill %in% non_work_dates, .N] > 0) {dt_jobs[end_date_mill %in% non_work_dates, end_date_mill := end_date_mill + 1]}
  
  
  # program
  
  # if start_date_program is not populate it then default to end_date_mill
  if (!"start_date_program" %in% colnames(dt_jobs)) {dt_jobs[, start_date_program := end_date_mill]}
  dt_jobs[is.na(start_date_program), start_date_program := end_date_mill]
  
  # calculate number of working days
  dt_jobs[, days_program := ceiling(hours_program / hours_in_day)]
  
  # calculate end_date
  dt_jobs[, end_date_program := start_date_program + days_program]
  
  # extend for non work days
  for (i in 1:nrow(dt_jobs)) {
    
    dt_jobs$end_date_program[i] <- dt_jobs[i, end_date_program] + length(intersect(
      non_work_dates,
      seq(
        from = as.Date(dt_jobs[i, start_date_program]),
        to = as.Date(dt_jobs[i, end_date_program]),
        by = "days"
      )
    ))
    
  }
  
  # ensure end_date is a work day
  while (dt_jobs[end_date_program %in% non_work_dates, .N] > 0) {dt_jobs[end_date_program %in% non_work_dates, end_date_program := end_date_program + 1]}
  
  
  # cnc
  
  # if start_date_cnc is not populate it then default to end_date_program
  if (!"start_date_cnc" %in% colnames(dt_jobs)) {dt_jobs[, start_date_cnc := end_date_program]}
  dt_jobs[is.na(start_date_cnc), start_date_cnc := end_date_program]
  
  # calculate number of working days
  dt_jobs[, days_cnc := ceiling(hours_cnc / hours_in_day)]
  
  # calculate end_date
  dt_jobs[, end_date_cnc := start_date_cnc + days_cnc]
  
  # extend for non work days
  for (i in 1:nrow(dt_jobs)) {
    
    dt_jobs$end_date_cnc[i] <- dt_jobs[i, end_date_cnc] + length(intersect(
      non_work_dates,
      seq(
        from = as.Date(dt_jobs[i, start_date_cnc]),
        to = as.Date(dt_jobs[i, end_date_cnc]),
        by = "days"
      )
    ))
    
  }
  
  # ensure end_date is a work day
  while (dt_jobs[end_date_cnc %in% non_work_dates, .N] > 0) {dt_jobs[end_date_cnc %in% non_work_dates, end_date_cnc := end_date_cnc + 1]}
  
  
  # veneer
  
  # if start_date_veneer is not populate it then default to end_date_cnc
  if (!"start_date_veneer" %in% colnames(dt_jobs)) {dt_jobs[, start_date_veneer := end_date_cnc]}
  dt_jobs[is.na(start_date_veneer), start_date_veneer := end_date_cnc]
  
  # calculate number of working days
  dt_jobs[, days_veneer := ceiling(hours_veneer / hours_in_day)]
  
  # calculate end_date
  dt_jobs[, end_date_veneer := start_date_veneer + days_veneer]
  
  # extend for non work days
  for (i in 1:nrow(dt_jobs)) {
    
    dt_jobs$end_date_veneer[i] <- dt_jobs[i, end_date_veneer] + length(intersect(
      non_work_dates,
      seq(
        from = as.Date(dt_jobs[i, start_date_veneer]),
        to = as.Date(dt_jobs[i, end_date_veneer]),
        by = "days"
      )
    ))
    
  }
  
  # ensure end_date is a work day
  while (dt_jobs[end_date_veneer %in% non_work_dates, .N] > 0) {dt_jobs[end_date_veneer %in% non_work_dates, end_date_veneer := end_date_veneer + 1]}
  
  
  # bench
  
  # if start_date_bench is not populate it then default to end_date_veneer
  if (!"start_date_bench" %in% colnames(dt_jobs)) {dt_jobs[, start_date_bench := end_date_veneer]}
  dt_jobs[is.na(start_date_bench), start_date_bench := end_date_veneer]
  
  # calculate number of working days
  dt_jobs[, days_bench := ceiling(hours_bench / hours_in_day)]
  
  # calculate end_date
  dt_jobs[, end_date_bench := start_date_bench + days_bench]
  
  # extend for non work days
  for (i in 1:nrow(dt_jobs)) {
    
    dt_jobs$end_date_bench[i] <- dt_jobs[i, end_date_bench] + length(intersect(
      non_work_dates,
      seq(
        from = as.Date(dt_jobs[i, start_date_bench]),
        to = as.Date(dt_jobs[i, end_date_bench]),
        by = "days"
      )
    ))
    
  }
  
  # ensure end_date is a work day
  while (dt_jobs[end_date_bench %in% non_work_dates, .N] > 0) {dt_jobs[end_date_bench %in% non_work_dates, end_date_bench := end_date_bench + 1]}
  
  
  # spray
  
  # if start_date_spray is not populate it then default to end_date_bench
  if (!"start_date_spray" %in% colnames(dt_jobs)) {dt_jobs[, start_date_spray := end_date_bench]}
  dt_jobs[is.na(start_date_spray), start_date_spray := end_date_bench]
  
  # calculate number of working days
  dt_jobs[, days_spray := ceiling(hours_spray / hours_in_day)]
  
  # calculate end_date
  dt_jobs[, end_date_spray := start_date_spray + days_spray]
  
  # extend for non work days
  for (i in 1:nrow(dt_jobs)) {
    
    dt_jobs$end_date_spray[i] <- dt_jobs[i, end_date_spray] + length(intersect(
      non_work_dates,
      seq(
        from = as.Date(dt_jobs[i, start_date_spray]),
        to = as.Date(dt_jobs[i, end_date_spray]),
        by = "days"
      )
    ))
    
  }
  
  # ensure end_date is a work day
  while (dt_jobs[end_date_spray %in% non_work_dates, .N] > 0) {dt_jobs[end_date_spray %in% non_work_dates, end_date_spray := end_date_spray + 1]}
  
  
  # dispatch
  
  # if start_date_dispatch is not populate it then default to end_date_spray
  if (!"start_date_dispatch" %in% colnames(dt_jobs)) {dt_jobs[, start_date_dispatch := end_date_spray]}
  dt_jobs[is.na(start_date_dispatch), start_date_dispatch := end_date_spray]
  
  # calculate number of working days
  dt_jobs[, days_dispatch := ceiling(hours_dispatch / hours_in_day)]
  
  # calculate end_date
  dt_jobs[, end_date_dispatch := start_date_dispatch + days_dispatch]
  
  # extend for non work days
  for (i in 1:nrow(dt_jobs)) {
    
    dt_jobs$end_date_dispatch[i] <- dt_jobs[i, end_date_dispatch] + length(intersect(
      non_work_dates,
      seq(
        from = as.Date(dt_jobs[i, start_date_dispatch]),
        to = as.Date(dt_jobs[i, end_date_dispatch]),
        by = "days"
      )
    ))
    
  }
  
  # ensure end_date is a work day
  while (dt_jobs[end_date_dispatch %in% non_work_dates, .N] > 0) {dt_jobs[end_date_dispatch %in% non_work_dates, end_date_dispatch := end_date_dispatch + 1]}
  
  return(dt_jobs)
  
}

# ----------------------------------------------------------------------------------------- recommended start date ----

# calculate start date required to complete job in time
fc_algorithm_recommended_start_date <- function(
  dt_jobs
) {
  
  # calculate days overrun
  dt_jobs[, days_overrun := pmax(end_date_dispatch - required_by, 0)]
  
  # calculate recommended start date
  dt_jobs[, start_date_recommended := start_date - days_overrun]
  
  return(dt_jobs)
  
}