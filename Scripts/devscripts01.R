# devscripts01.R
# created 2025-02-18
# Scripts to create README file, etc.
library(devtools)

use_readme_rmd()

rmarkdown::render("README.Rmd")
