read_url_text <- function(url) {
  tryCatch(
    paste(
      suppressWarnings(readLines(url, warn = FALSE, encoding = "UTF-8")),
      collapse = "\n"
    ),
    error = function(error) NA_character_
  )
}

download_career_js <- function(player_slug) {
  url <- sprintf(
    "https://www.tennisabstract.com/jsmatches/%sCareer.js",
    player_slug
  )
  js_text <- read_url_text(url)
  if (is.na(js_text) || !grepl("morematchmx", js_text)) {
    stop(sprintf("No career data found for '%s'.", player_slug), call. = FALSE)
  }
  js_text
}

extract_birth_date <- function(profile_text) {
  if (length(profile_text) != 1L || is.na(profile_text)) {
    return(NA_character_)
  }
  match <- regexec(
    "var\\s+dob\\s*=\\s*([0-9]{8})",
    profile_text
  )
  values <- regmatches(profile_text, match)[[1]]
  if (length(values) == 2) return(values[2])

  match <- regexec("\\(([0-9]{2}-[A-Za-z]{3}-[0-9]{4})\\)", profile_text)
  values <- regmatches(profile_text, match)[[1]]
  if (length(values) == 2) return(values[2])
  NA_character_
}

get_profile_url <- function(player_slug, is_wta) {
  page <- if (is_wta) "wplayer-classic.cgi" else "player-classic.cgi"
  sprintf("https://www.tennisabstract.com/cgi-bin/%s?p=%s", page, player_slug)
}

download_player_birth_date <- function(player_slug, is_wta) {
  metadata_url <- if (is_wta) {
    sprintf(
      "https://www.tennisabstract.com/jsmatches/%s.js",
      player_slug
    )
  } else {
    get_profile_url(player_slug, is_wta)
  }
  date_text <- extract_birth_date(read_url_text(metadata_url))
  birth_date <- as.Date(date_text, format = "%Y%m%d")
  if (is.na(birth_date)) {
    birth_date <- as.Date(date_text, format = "%d-%b-%Y")
  }
  if (is.na(birth_date)) {
    stop(sprintf("Could not find a birth date for '%s'.", player_slug),
         call. = FALSE)
  }
  birth_date
}
