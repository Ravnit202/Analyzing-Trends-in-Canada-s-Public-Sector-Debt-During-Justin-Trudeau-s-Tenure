#### Preamble ####
# Purpose: Test data for the cleaned student debt dataset
# Author: Ravnit Lotay
# Date: 16 April 2024
# Contact: ravnit.lotay@mail.utoronto.ca
# License: MIT
# Pre-requisites: The following packages are required: tidyverse, dplyr, testthat, arrow

# Load libraries
library(tidyverse)
library(testthat)
library(dplyr)
library(arrow)

student_debt_data <- read_parquet("./data/analysis_data/cleaned_student_debt_data.parquet")
student_debt_data <- student_debt_data %>%
  mutate(
    ref_date = as.integer(ref_date),  # Ensure ref_date is an integer
    level_of_study = factor(level_of_study),
    geo = factor(geo),
    type_of_debt_source = factor(type_of_debt_source),
    statistics = factor(statistics),
    uom = factor(uom),
    value_dollars = as.numeric(value_dollars),
    value_percent = as.numeric(value_percent),
    normalized_value_dollars = as.numeric(normalized_value_dollars),
    normalized_value_percent = as.numeric(normalized_value_percent)
  )

# Test 1: Check if the dataset has the expected columns
test_that("Data has all expected columns", {
  expected_columns <- c("ref_date", "geo", "level_of_study", "type_of_debt_source", 
                        "statistics", "uom", "value_dollars", "value_percent",
                        "normalized_value_dollars", "normalized_value_percent")
  expect_setequal(names(student_debt_data), expected_columns)
})

# Test 2: Check for no missing values
test_that("No missing values in key columns", {
  key_columns <- c("ref_date", "geo")
  expect_true(all(complete.cases(student_debt_data[key_columns])))
})

# Test 3: Correct data types for each column
test_that("Correct data types for each column", {
  expect_type(student_debt_data$ref_date, "integer")
  expect_type(student_debt_data$value_dollars, "double")
  expect_type(student_debt_data$value_percent, "double")
  expect_type(student_debt_data$geo, "integer")
  expect_type(student_debt_data$level_of_study, "integer")
  expect_type(student_debt_data$type_of_debt_source, "integer")
  expect_type(student_debt_data$statistics, "integer")
  expect_type(student_debt_data$uom, "integer")
  expect_type(student_debt_data$normalized_value_dollars, "double")
  expect_type(student_debt_data$normalized_value_percent, "double")
})

# Test 4: Validate ranges and limits
test_that("Values within expected ranges", {
  expect_true(all(student_debt_data$value_dollars >= 0 | is.na(student_debt_data$value_dollars)))
  expect_true(all(student_debt_data$value_percent >= 0 | is.na(student_debt_data$value_percent)))
  expect_true(all(student_debt_data$normalized_value_dollars >= 0 & student_debt_data$normalized_value_dollars <= 1 | is.na(student_debt_data$normalized_value_dollars)))
  expect_true(all(student_debt_data$normalized_value_percent >= 0 & student_debt_data$normalized_value_percent <= 1 | is.na(student_debt_data$normalized_value_percent)))
})
