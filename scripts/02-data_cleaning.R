#### Preamble ####
# Purpose: Cleans and prepares the student debt dataset for detailed analysis
# Author: Ravnit Lotay
# Date: 16 April 2024
# Contact: ravnit.lotay@mail.utoronto.ca
# License: MIT
# Pre-requisites: The following packages are required: tidyverse, janitor, and arrow 

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)

#### Load and clean data ####
student_debt_data <- read_csv("./data/raw_data/student_debt_canada.csv", show_col_types = FALSE) %>%
  clean_names() %>%
  select(-matches("dguid|scalar_id|vector|coordinate|symbol|terminated|status|scalar_factor|uom_id|decimals")) %>%  # Drop unnecessary columns
  drop_na(value) %>%
  mutate(
    ref_date = as.integer(ref_date),  
    value = as.numeric(value),  
    level_of_study = case_when(
      level_of_study == "Bachelor's" ~ "Undergraduate",
      level_of_study == "Master's" ~ "Postgraduate",
      level_of_study == "Doctorate" ~ "Postgraduate",
      TRUE ~ as.character(level_of_study)  
    ),
    geo = str_replace_all(geo, " ", ""),  # Remove spaces from geographical locations
    type_of_debt_source = str_trim(type_of_debt_source),  # Trim whitespace from debt source descriptions
    statistics = str_trim(statistics),  # Trim whitespace from statistics descriptions
    uom = if_else(uom == 'Percent', 'Percentage', as.character(uom))  # Fix the uom values
  ) %>%
  mutate(
    value_dollars = if_else(uom == "Dollars", value, NA_real_),
    value_percent = if_else(uom == "Percentage", value, NA_real_)
  ) %>%
  select(-value)


# Normalize values separately for dollars and percentages
max_value_dollars <- max(student_debt_data$value_dollars, na.rm = TRUE)
min_value_dollars <- min(student_debt_data$value_dollars, na.rm = TRUE)
student_debt_data$normalized_value_dollars <- (student_debt_data$value_dollars - min_value_dollars) / (max_value_dollars - min_value_dollars)

max_value_percent <- max(student_debt_data$value_percent, na.rm = TRUE)
min_value_percent <- min(student_debt_data$value_percent, na.rm = TRUE)
student_debt_data$normalized_value_percent <- (student_debt_data$value_percent - min_value_percent) / (max_value_percent - min_value_percent)


write_parquet(student_debt_data, "./data/analysis_data/cleaned_student_debt_data.parquet")
