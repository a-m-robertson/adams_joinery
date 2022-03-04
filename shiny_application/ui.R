#* script name      ui.R
#* script goal      manage the global user interface (ui) of the shiny application
#* 
#* naming convention
#* div elements     div_ui_global
#* css elements     css_ui_global
#* functions        fc_ui_global
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- global css ----

# additional css for in app busy screen shown when busy
css_ui_global_busy_screen <- "
#div_ui_global_busy_screen {
position: fixed;
background: rgba(181, 208, 238, 0.35);
z-index: 10000;
left: 0;
right: 0;
top: 0;
padding-top: 400px;
bottom: 0;
font-size: 50px;
text-align: center;
color: #000000;
}"
# additional css for in app loading screen shown when called
css_ui_global_loading_screen <- "
#div_ui_global_loading_screen {
position: fixed;
background: rgba(181, 208, 238, 0.35);
z-index: 10000;
left: 0;
right: 0;
top: 0;
padding-top: 400px;
bottom: 0;
font-size: 50px;
text-align: center;
color: #000000;
}"
# additional css for initial loading screen shown when called
css_ui_global_init_loading_screen <- "
#div_ui_global_init_loading_screen {
position: fixed;
background: #FFFFFF;
z-index: 10000;
left: 0;
right: 0;
top: 0;
padding-top: 250px;
bottom: 0;
font-size: 50px;
text-align: center;
color: #000000;
}"
# additional css for in app access denied message
css_ui_global_access_denied <- "
#div_ui_global_access_denied {
position: fixed;
background: #FFFFFF;
z-index: 10000;
left: 0;
right: 0;
top: 0;
padding-top: 250px;
bottom: 0;
font-size: 50px;
text-align: center;
color: #000000;
}"

# ----------------------------------------------------------------------------------------- source ui ----

r_files <- list.files(
  path = 'ui', 
  full.names = TRUE
)

for (r_file in r_files) {
  
  fc_log(
    message = paste0("sourcing file: ", r_file),
    script = "ui.R"
  )
  source(
    file = r_file,
    local = TRUE,
    encoding = "UTF-8"
  )
  
} 

# ----------------------------------------------------------------------------------------- ui body ----

shiny::tagList(
  
  # to allow shiny JavaScript interactions
  shinyjs::useShinyjs(),
  
  # source custom JavaScript functions
  shinyjs::extendShinyjs(
    text = js_browseURL,
    functions = "browseURL"
  ),
  
  shiny::tags$head(
    # busy js
    shiny::tags$script(
      "setInterval(function(){
        if ($('html').attr('class')=='shiny-busy') {
          setTimeout(function() {
            if ($('html').attr('class')=='shiny-busy') {
              $('div.busy').show()
            }
          }, 1000)
        } else {
          $('div.busy').hide()
        }
      }, 1000)"
    )
  ),
  
  # to add addition css components such as loading screen
  shinyjs::inlineCSS(
    css_ui_global_busy_screen
  ),
  shinyjs::inlineCSS(
    css_ui_global_loading_screen
  ),
  shinyjs::inlineCSS(
    css_ui_global_init_loading_screen
  ),
  shinyjs::inlineCSS(
    css_ui_global_access_denied
  ),
  
  # in app busy screen div_ui_global_busy_screen
  shiny::div(
    id = "div_ui_global_busy_screen",
    class = "busy",
    shiny::img(
      src = "gifs/loading.gif"
    )
  ),
  # in app loading screen div_ui_global_loading_screen
  shiny::div(
    id = "div_ui_global_loading_screen",
    class = "loading",
    shiny::img(
      src = "gifs/loading.gif"
    )
  ) %>% shinyjs::hidden(),
  # initial loading screen div_ui_global_init_loading_screen
  shiny::div(
    id = "div_ui_global_init_loading_screen",
    br(),
    br(),
    h5('We are preparing your environment, please wait'),
    br(),
    shiny::img(
      src = "gifs/loading.gif"
    )
  ),
  # in app access denied screen div_ui_global_access_denied
  shiny::div(
    id = "div_ui_global_access_denied",
    class = "loading",
    br(),
    br(),
    h4("Access Denied!"),
    br(),
    h5("You do not have permission to view this application. Contact Alex Adkins to request access")
  ) %>% shinyjs::hidden(),
  
  # fluid page
  shiny::fluidPage(
    
    # reference global theme as defined in www/
    theme = "theme/bootstrap.css",
    
    br(),
    
    # header panel
    shiny::div(
      id = "div_ui_global_header",
      class = "simpleDiv",
      ui_header
    ),
    
    # tabset
    shiny::div(

      id = "div_ui_global_body",
      class = "simpleDiv",

      shiny::tabsetPanel(

        id = "in_ui_global_body_navbar",

        # overview
        shiny::tabPanel(

          title = "Overview",

          shiny::div(
            id = "div_ui_global_body_overview",
            class = "simpleDiv",
            ui_body_overview
          )

        ),
        
        # mill
        shiny::tabPanel(
          
          title = "Mill",
          
          shiny::div(
            id = "div_ui_global_body_mill",
            class = "simpleDiv",
            ui_body_mill
          )
          
        ),

        # admin
        shiny::tabPanel(

          title = "Admin",

          shiny::div(
            id = "div_ui_global_body_admin",
            class = "simpleDiv",
            ui_body_admin
          )

        )

      )

    )
    
  )
  
  
)