normalize_player_name <- function(player_name) {
  if (!is.character(player_name) || length(player_name) != 1L ||
      is.na(player_name)) {
    stop("`player_name` must be one non-missing character string.", call. = FALSE)
  }
  name <- trimws(player_name)
  if (!grepl("^[A-Za-z]+([[:space:]][A-Za-z]+)*$", name)) {
    stop("`player_name` must contain only letters and spaces.", call. = FALSE)
  }
  if (!grepl("[[:space:]]", name)) return(name)
  words <- strsplit(tolower(name), "[[:space:]]+")[[1]]
  paste0(tools::toTitleCase(words), collapse = "")
}
