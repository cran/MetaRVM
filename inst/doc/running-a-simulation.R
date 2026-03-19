## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
# Locate the example YAML configuration file
yaml_file <- system.file("extdata", "example_config.yaml", package = "MetaRVM")
print(yaml_file)

## ----results='hide'-----------------------------------------------------------
# Load the metaRVM library
library(MetaRVM)
options(odin.verbose = FALSE)

# Run the simulation
sim_out <- metaRVM(yaml_file)

## -----------------------------------------------------------------------------
# Load configuration from YAML file
config_obj <- MetaRVMConfig$new(yaml_file)

# Examine the configuration
config_obj

## -----------------------------------------------------------------------------
# List all available parameters
param_names <- config_obj$list_parameters()
head(param_names, 10)

# Get a summary of parameter types and sizes
param_summary <- config_obj$parameter_summary()
head(param_summary, 10)

## -----------------------------------------------------------------------------
# Get user-defined demographic category names and values
category_names <- config_obj$get_category_names()
cat("Available categories:", paste(category_names, collapse = ", "), "\n")

# Example: inspect values for one category (if present)
if ("age" %in% category_names) {
  age_categories <- config_obj$get_category_values("age")
  cat("Age categories:", paste(age_categories, collapse = ", "), "\n")
}

## -----------------------------------------------------------------------------
# Method 1: Direct from file path
# sim_out <- metaRVM(config_file)

# Method 2: From MetaRVMConfig object
sim_out <- metaRVM(config_obj)

# Method 3: From parsed configuration list
config_list <- parse_config(yaml_file)
sim_out <- metaRVM(config_list)

## -----------------------------------------------------------------------------
# Look at the structure of formatted results
head(sim_out$results)

# Check unique values for key variables
cat("Disease states:", paste(unique(sim_out$results$disease_state), collapse = ", "), "\n")
cat("Date range:", paste(range(sim_out$results$date), collapse = " to "), "\n")

## -----------------------------------------------------------------------------
# Subset by single criteria
hospitalized_data <- sim_out$subset_data(disease_states = "H")
hospitalized_data$results

# Subset by multiple demographic categories
elderly_data <- sim_out$subset_data(
  age = c("65+"),
  disease_states = c("H", "D")
)
elderly_data$results

# Specific date range
peak_period <- sim_out$subset_data(
  date_range = c(as.Date("2023-10-01"), as.Date("2023-12-31")),
  disease_states = "H"
)
peak_period$results

## -----------------------------------------------------------------------------
# Locate the example YAML configuration file with distributions
yaml_file_dist <- system.file("extdata", "example_config_dist.yaml", package = "MetaRVM")

## ----results='hide', message=FALSE, warning=FALSE-----------------------------
# Run the simulation with the new configuration
sim_out_dist <- metaRVM(yaml_file_dist)

## ----fig.height = 4, fig.width = 8, fig.align = "center"----------------------
library(ggplot2)

# Summarize hospitalizations by age group
hospital_summary_dist <- sim_out_dist$summarize(
  group_by = c("age"),
  disease_states = "n_IsympH",
  stats = c("median", "quantile"),
  quantiles = c(0.05, 0.95)
)

# Plot the summary
hospital_summary_dist$plot() + ggtitle("Daily Hospitalizations by Age Group (with 90% confidence interval)") + theme_bw()

## ----fig.height = 6, fig.width = 8, fig.align = "center"----------------------

# Summary of hospitalizations by two user-defined categories
hospital_summary <- sim_out_dist$summarize(
  group_by = c("age", "zone"),
  disease_states = "n_IsympH",
  stats = c("median", "quantile"),
  quantiles = c(0.05, 0.95)
)
hospital_summary

# visualize the summary
hospital_summary$plot() + ggtitle("Daily Hospitalizations by Age and Zone") + theme_bw()

## -----------------------------------------------------------------------------
# Locate the example YAML configuration file with subgroup parameters
yaml_file_subgroup <- system.file("extdata", "example_config_subgroup_dist.yaml", package = "MetaRVM")

## ----results='hide', message = FALSE------------------------------------------
# Run the simulation with the subgroup configuration
sim_out_subgroup <- metaRVM(yaml_file_subgroup)

## ----fig.height = 6, fig.width = 8, fig.align = "center"----------------------
# Summarize hospitalizations by age group
hospital_summary_subgroup <- sim_out_subgroup$summarize(
  group_by = c("age"),
  disease_states = "H",
  stats = c("median", "quantile"),
  quantiles = c(0.025, 0.975)
)

# Plot the summary
hospital_summary_subgroup$plot() + ggtitle("Daily Hospitalizations by Age Group (Subgroup Parameters)") + theme_bw()

