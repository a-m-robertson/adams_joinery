#* script name      server.R
#* script goal      manage the global server of the shiny application
#* 
#* naming convention
#* div elements     div_server_global
#* functions        fc_server_global
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- global shiny server function ----

shiny::shinyServer(
  function(
    input,
    output,
    session
  ) {
    
    # create global reactive
    fc_log(
      message = "sourcing file: server/server_reactives.R",
      script = "server.R"
    )
    source(
      file = "server/server_reactives.R",
      local = TRUE,
      encoding = "UTF-8"
    )
    
    # capture user
    if (is.null(isolate(session$user))) {rv$user <- Sys.info()[["user"]] %>% tolower()}
    if (!is.null(isolate(session$user))) {rv$user <- isolate(session$user) %>% tolower()}

    # source files
    fc_log(
      message = "sourcing file: server/server_header.R",
      script = "server.R"
    )
    source(
      file = "server/server_header.R",
      local = TRUE,
      encoding = "UTF-8"
    )
    
    fc_log(
      message = "sourcing file: server/server_new_job.R",
      script = "server.R"
    )
    source(
      file = "server/server_new_job.R",
      local = TRUE,
      encoding = "UTF-8"
    )
    
    fc_log(
      message = "sourcing file: server/server_body_overview.R",
      script = "server.R"
    )
    source(
      file = "server/server_body_overview.R",
      local = TRUE,
      encoding = "UTF-8"
    )
    
    fc_log(
      message = "sourcing file: server/server_body_mill.R",
      script = "server.R"
    )
    source(
      file = "server/server_body_mill.R",
      local = TRUE,
      encoding = "UTF-8"
    )
    
    fc_log(
      message = "sourcing file: server/server_body_admin.R",
      script = "server.R"
    )
    source(
      file = "server/server_body_admin.R",
      local = TRUE,
      encoding = "UTF-8"
    )

    # when server is finished running we close the loading screen
    shinyjs::hide("div_ui_global_init_loading_screen")
    
  }
)