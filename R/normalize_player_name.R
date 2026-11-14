normalize_player_name <- function(player_name) {
  if (!is.character(player_name) || length(player_name) != 1L ||
      is.na(player_name)) {
    stop("`player_name` must be one non-missing character string.", call. = FALSE)
  }
  name <- gsub("[-']", " ", trimws(player_name))
  if (!grepl("^[A-Za-z ]+$", name) || !grepl("[A-Za-z]", name)) {
    stop("`player_name` must contain letters, spaces, hyphens, or apostrophes.",
         call. = FALSE)
  }
  if (!grepl(" ", name, fixed = TRUE)) return(name)
  words <- strsplit(tolower(name), "[[:space:]]+")[[1]]
  words <- paste0(toupper(substr(words, 1, 1)), substring(words, 2))
  paste0(words, collapse = "")
}