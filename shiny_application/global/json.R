#* script name      json.R
#* script goal      manage functions which apply toJSON or fromJSON
#* 
#* naming convention
#* functions        fc_json
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- fc_json_to ----

fc_json_to <- function(
  input,
  dataframe = "rows",
  digits = 15,
  na = "null",
  null = "null",
  auto_unbox = TRUE
) {
  
  # validate input and results of toJSON and return output
  
  if (length(input) <= 1) {
    
    # if input is NULL then return NULL JSON
    if (is.null(input)) {return(jsonlite::toJSON(NULL))}
    
    # if input is NA then return NA
    if (is.na(input)) {return(NA)}
    
  }
  
  output <- jsonlite::toJSON(
    x = input,
    dataframe = dataframe,
    digits = digits,
    na = na,
    null = null,
    auto_unbox = auto_unbox
  )
  
  output <- as.character(output)
  
  return(output)
  
}

# ----------------------------------------------------------------------------------------- fc_json_from ----

fc_json_from <- function(
  input
) {
  
  # if input is not a json string return NA
  if (!jsonlite::validate(input)) {return(NA)}
  
  # if input is NA then return NA
  if (is.na(input)) {return(NA)}
  
  output <- jsonlite::fromJSON(input)
  
  if (is.data.frame(output)) {data.table::setDT(output)}
  
  return(output)
  
}

# ----------------------------------------------------------------------------------------- fc_json_validate ----

fc_json_validate <- function(
  input
) {
  
  # if length of input is greater than 1 then it is not a json string
  if (length(input) > 1) {return(FALSE)}
  # if item is not text then it is not a json string
  if (!is.character(input)) {return(FALSE)}
  
  return(jsonlite::validate(input))
  
}