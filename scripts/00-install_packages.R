#### Preamble ####
# Purpose: Installs packages needed to run scripts and Quarto document
# Author: Ravnit Lotay
# Date: 16 April 2024
# Contact: ravnit.lotay@mail.utoronto.ca
# License: MIT
# Pre-requisites: NA

#### Workspace setup ####

## Install packages ##
install.packages("tidyverse") # Contains data-related packages
install.packages("knitr") # To make tables
install.packages("janitor") # To clean datasets
install.packages("dplyr")
install.packages("ggplot2") # To make graphs
install.packages("arrow") # For Parquet files
install.packages("testthat") # To test
install.packages("lintr") # To check styling of code
install.packages("styler") # Styles code
install.packages("rstanarm") 
install.packages("loo")