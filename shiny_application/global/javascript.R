#* script name      javascript.R
#* script goal      manage JavaScript
#* 
#* naming convention
#* functions        fc_js
#*
#* other conventions
#* snake case is preferred
#* lists are alphabetical
#* 
# ----------------------------------------------------------------------------------------- launch url ----

# open urls in new tab/window
js_browseURL <- "
shinyjs.browseURL = function(url) {
  window.open(url,'_blank');
}
"