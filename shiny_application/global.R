#* script name      global.R
#* script goal      manage the global components of the application, such as packages loading, global function loading, etc
#* 
#* naming convention
#* div elements     div_global
#* functions        fc_global
#* variables        var_global
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- global variables ----

# encoding type
var_global_encoding_type <- "UTF-8"

# ----------------------------------------------------------------------------------------- source global scripts ----

print(
  x = "[ GLOBAL.R ] sourcing file: global/log_functions.R"
)
source(
  file = "global/log_functions.R",
  encoding = var_global_encoding_type
)

fc_log(
  message = "sourcing file: global/packages.R",
  script = "global.R"
)
source(
  file = "global/packages.R",
  encoding = var_global_encoding_type
)

fc_log(
  message = "sourcing file: global/javascript.R",
  script = "global.R"
)
source(
  file = "global/javascript.R",
  encoding = var_global_encoding_type
)

fc_log(
  message = "sourcing file: global/json.R",
  script = "global.R"
)
source(
  file = "global/json.R",
  encoding = var_global_encoding_type
)

# ----------------------------------------------------------------------------------------- global settings ----

# httr settings
httr::set_config(httr::config(ssl_verifypeer = FALSE, ssl_verifyhost = FALSE))
