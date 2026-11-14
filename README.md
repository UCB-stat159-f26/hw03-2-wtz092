# tenniscareer

`tenniscareer` is an R package for downloading, cleaning, and visualizing
a tennis player's career match data from
[Tennis Abstract](https://www.tennisabstract.com/).

The package supports both WTA and ATP career JavaScript files. WTA files
store an opponent's date of birth, while ATP files store an opponent's age
directly. The package processes both formats into one common data frame.

## Installation

Install directly from GitHub:

```r
install.packages("devtools")
devtools::install_github("UCB-stat159-f26/hw03-2-wtz092")
```

Then load the package:

```r
library(tenniscareer)
```

## Usage

The first public function downloads and cleans a player's career matches:

```r
serena <- get_career_data("serena williams")
head(serena)
```

The returned data frame includes match date, tournament, surface, result,
round, opponent, player age, opponent age, and age difference.

The second public function creates the age-based scatter plot:

```r
plot_career_matches(serena)
```

The package accepts names with spaces, different capitalization, or no
spaces:

```r
rafa <- get_career_data("Rafael Nadal")
plot_career_matches(rafa)

serena_again <- get_career_data("SerenaWilliams")
```

An unavailable player gives a meaningful error:

```r
get_career_data("Gaston Sanchez")
```

## Data source

Career match records and player-profile information are retrieved from
[Tennis Abstract](https://www.tennisabstract.com/). An internet connection
is required when calling `get_career_data()`.

## Tests

Automated tests never request live Tennis Abstract data. They use local
mock JavaScript files for female and male players:

```r
devtools::test()
```

The tests verify that female opponent dates of birth are converted into
ages, male opponent ages are used directly, and player names are
normalized correctly.

## Reflection

This assignment showed me why a package is more useful than a set of
scripts for a repeated task. I had to separate downloading, parsing,
cleaning, and plotting into small functions with clear inputs and outputs.
The female and male Tennis Abstract files also showed me that similar
data sources can have important structural differences. Writing local
tests was useful because it let me check the cleaning logic without
relying on a website or internet connection. I also learned that concise
commits make it easier to track a project's development and to find
problems when something breaks.