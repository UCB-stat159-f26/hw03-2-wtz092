get_career_data <- function(player_name) {
  player_slug <- normalize_player_name(player_name)
  js_text <- download_career_js(player_slug)
  rows <- parse_career_js(js_text)
  is_wta <- is_wta_career(rows)
  player_dob <- download_player_birth_date(player_slug, is_wta)
  matches <- clean_career_rows(rows, player_dob)
  matches$player <- player_slug
  matches
}