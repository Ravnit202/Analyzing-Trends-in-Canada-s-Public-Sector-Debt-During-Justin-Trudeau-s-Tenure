#### Preamble ####
# Purpose: Test data for the cleaned student debt dataset
# Author: Ravnit Lotay
# Date: 16 April 2024
# Contact: ravnit.lotay@mail.utoronto.ca
# License: MIT
# Pre-requisites: The following packages are required: tidyverse, arrow, rstanarm

# Load libraries
library(rstanarm)  
library(tidyverse)
library(arrow)  

# Load the data from Parquet file
student_debt_data <- read_parquet("./data/analysis_data/cleaned_student_debt_data.parquet")


student_debt_data <- student_debt_data %>%
  mutate(
    level_of_study = factor(level_of_study),
    type_of_debt_source = factor(type_of_debt_source),
    geo = factor(geo),
    statistics = factor(statistics)  # Treat 'statistics' as a categorical variable
  )

# Filter data 
percent_data <- student_debt_data %>%
  filter(uom == "Percentage" & !is.na(normalized_value_percent))

# Bayesian model 
percent_model <- stan_glm(
  normalized_value_percent ~ level_of_study + type_of_debt_source + geo + ref_date + statistics,
  data = percent_data,
  family = gaussian(),
  prior = normal(0, 2.5, autoscale = TRUE),
  prior_intercept = normal(0, 2.5, autoscale = TRUE),
  seed = 2000,
  chains = 4,
  cores = 4,
  control = list(adapt_delta = 0.95)
)

saveRDS(percent_model, file = "./models/percent_student_debt_model.rds")

dollar_data <- student_debt_data %>%
  filter(uom == "Dollars" & !is.na(normalized_value_dollars))

# Bayesian model
dollar_model <- stan_glm(
  normalized_value_dollars ~ level_of_study + type_of_debt_source + geo + ref_date + statistics,
  data = dollar_data,
  family = gaussian(),
  prior = normal(0, 2.5, autoscale = TRUE),
  prior_intercept = normal(0, 2.5, autoscale = TRUE),
  seed = 2000,
  chains = 4,
  cores = 4,
  control = list(adapt_delta = 0.95)
)

saveRDS(dollar_model, file = "./models/dollar_student_debt_model.rds")

