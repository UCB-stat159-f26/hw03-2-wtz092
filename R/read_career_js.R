strip_js_wrapper <- function(js_text) {
  js_text <- sub("^\\s*#.*\\n?", "", js_text, perl = TRUE)
  js_text <- sub(
    "^\\s*var\\s+morematchmx\\s*=\\s*",
    "", js_text, perl = TRUE
  )
  sub(";\\s*$", "", js_text, perl = TRUE)
}

parse_career_js <- function(js_text) {
  if (!nzchar(js_text)) stop("Career JS file is empty.", call. = FALSE)
  jsonlite::fromJSON(
    strip_js_wrapper(js_text),
    simplifyVector = FALSE
  )
}

read_career_js <- function(file_path) {
  js_text <- paste(
    readLines(file_path, warn = FALSE, encoding = "UTF-8"),
    collapse = "\n"
  )
  parse_career_js(js_text)
}