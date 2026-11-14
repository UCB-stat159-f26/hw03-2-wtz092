extract_column <- function(rows, column) {
  vapply(rows, function(row) {
    if (length(row) < column || is.null(row[[column]])) return(NA_character_)
    as.character(row[[column]])
  }, character(1))
}

calculate_age <- function(on_date, birth_date) {
  as.numeric(as.Date(on_date) - as.Date(birth_date)) / 365.2425
}

make_match_table <- function(rows) {
  data.frame(
    source_date = as.Date(extract_column(rows, 1), format = "%Y%m%d"),
    tournament = extract_column(rows, 2),
    surface = extract_column(rows, 3),
    result = extract_column(rows, 5),
    round = extract_column(rows, 9),
    opponent = extract_column(rows, 12),
    stringsAsFactors = FALSE
  )
}

get_opponent_age <- function(rows, match_dates) {
  values <- extract_column(rows, 17)
  if (any(grepl("^\\d{8}$", values))) {
    return(calculate_age(match_dates, as.Date(values, format = "%Y%m%d")))
  }
  as.numeric(values)
}

clean_career_rows <- function(rows, player_birth_date) {
  matches <- make_match_table(rows)
  matches$player_age <- calculate_age(matches$source_date, player_birth_date)
  matches$opponent_age <- get_opponent_age(rows, matches$source_date)
  matches$age_difference <- matches$player_age - matches$opponent_age
  matches$plot_eligible <- !is.na(matches$player_age) &
    !is.na(matches$opponent_age)
  matches <- matches[order(matches$source_date), ]
  rownames(matches) <- NULL
  matches
}

is_wta_career <- function(rows) {
  values <- extract_column(rows, 17)
  any(grepl("^\\d{8}$", values))
}
