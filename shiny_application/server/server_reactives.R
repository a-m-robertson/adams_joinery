#* script name      server_reactives.R
#* script goal      manages the global reactives. Reactives are server specific so are not truely global
#* 
#* naming convention
#* div elements     div_reactives
#* functions        fc_reactives
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- reactives ----

rv <- shiny::reactiveValues(
  dt_jobs = fc_database_from()
)