#* script name      log_functions.R
#* script goal      manage log functions
#* 
#* naming convention
#* functions        fc_log
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- log function ----

fc_log <- function(
  message,
  script
) {
  
  output <- paste0(
    "[ ", 
    toupper(script), 
    " ] ",
    message
  )
  
  return(
    cat(file = stderr(), output, "\n")
  )
  
}