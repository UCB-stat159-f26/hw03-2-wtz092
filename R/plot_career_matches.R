validate_plot_data <- function(career_data) {
  required <- c("player_age", "age_difference", "result", "plot_eligible")
  missing <- setdiff(required, names(career_data))
  if (!is.data.frame(career_data) || length(missing) > 0) {
    stop("`career_data` is not a valid career data frame.", call. = FALSE)
  }
}

plot_title <- function(career_data) {
  if (!"player" %in% names(career_data)) {
    return("Professional tennis matches")
  }
  player <- gsub("([a-z])([A-Z])", "\\1 \\2", career_data$player[1])
  paste0(player, "'s Professional Matches")
}

plot_career_matches <- function(career_data) {
  validate_plot_data(career_data)
  plot_data <- career_data[career_data$plot_eligible, ]
  plot_data$result <- factor(plot_data$result, levels = c("W", "L"))
  if (!nrow(plot_data)) stop("No eligible matches to plot.", call. = FALSE)
  ggplot2::ggplot(plot_data, ggplot2::aes(player_age, age_difference,
    color = result)) +
    ggplot2::geom_hline(yintercept = 0, color = "grey60") +
    ggplot2::geom_point(size = 1.5, alpha = 0.9) +
    ggplot2::scale_color_manual(values = c(W = "#36C3E5", L = "#96358B"),
      labels = c(W = "Match won", L = "Match lost")) +
    ggplot2::scale_x_continuous(position = "top") +
    ggplot2::labs(title = plot_title(plot_data), x = "Player age (years)",
      y = "Player age minus opponent age (years)", color = NULL) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(legend.position = "top")
}