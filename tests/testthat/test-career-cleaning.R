testthat::test_that("female rows derive opponent age from date of birth", {
  rows <- tenniscareer:::read_career_js(
    testthat::test_path("fixtures", "FemalePlayerCareer.js")
  )
  matches <- tenniscareer:::clean_career_rows(rows, "1981-09-26")

  testthat::expect_equal(nrow(matches), 3)
  testthat::expect_true(tenniscareer:::is_wta_career(rows))
  testthat::expect_equal(matches$opponent[1], "Anne Miller")
  testthat::expect_equal(round(matches$opponent_age[1], 3), 18.777)
  testthat::expect_true(all(matches$plot_eligible))
})

testthat::test_that("male rows use provided opponent age values", {
  rows <- tenniscareer:::read_career_js(
    testthat::test_path("fixtures", "MalePlayerCareer.js")
  )
  matches <- tenniscareer:::clean_career_rows(rows, "1986-06-03")

  testthat::expect_equal(nrow(matches), 3)
  testthat::expect_false(tenniscareer:::is_wta_career(rows))
  testthat::expect_equal(
    sort(matches$opponent_age),
    sort(c(22.264202601, 24.2902121834, 18.7597535934))
  )
})

testthat::test_that("player names normalize without web access", {
  testthat::expect_equal(
    tenniscareer:::normalize_player_name("serena williams"),
    "SerenaWilliams"
  )
  testthat::expect_equal(
    tenniscareer:::normalize_player_name("SerenaWilliams"),
    "SerenaWilliams"
  )
  testthat::expect_error(
    tenniscareer:::normalize_player_name(""),
    "letters"
  )
})

testthat::test_that("player metadata dates parse without web access", {
  testthat::expect_equal(
    tenniscareer:::extract_birth_date("var dob = 19810926;"),
    "19810926"
  )
})

testthat::test_that("player names allow hyphens and apostrophes", {
  testthat::expect_equal(
    tenniscareer:::normalize_player_name("Jo-Wilfried Tsonga"),
    "JoWilfriedTsonga"
  )
  testthat::expect_equal(
    tenniscareer:::normalize_player_name("O'Connell"),
    "OConnell"
  )
})