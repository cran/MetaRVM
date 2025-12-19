## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(MetaRVM)
options(odin.verbose = FALSE)

# Get the example configuration file
example_config <- system.file("extdata", "example_config_checkpoint.yaml", 
                              package = "MetaRVM")

# Create a temporary directory for checkpoints
checkpoint_dir <- tempdir()
cat("Checkpoint directory:", checkpoint_dir, "\n")

## ----create_config------------------------------------------------------------
# Read the example configuration
yml <- yaml::read_yaml(example_config)
yml_tmp <- data.table::copy(yml)

# Assign checkpoint directory
yml_tmp$simulation_config$checkpoint_dir <- checkpoint_dir

# Create a temporary config
temp_config <- tempfile(tmpdir = dirname(example_config), fileext = ".yaml")
yaml::write_yaml(yml_tmp, temp_config)
temp_config <- normalizePath(temp_config)


## ----run_simulation-----------------------------------------------------------

# Run the simulation
results <- metaRVM(temp_config)

# Check what checkpoint files were created
checkpoint_files <- list.files(checkpoint_dir, 
                               pattern = "^chk_.*\\.Rda$",
                               full.names = FALSE)

if (length(checkpoint_files) > 0) {
  for (file in checkpoint_files) {
    cat("  -", file, "\n")
  }
} else {
  cat("  (No checkpoint files found)\n")
}


## ----examine_results----------------------------------------------------------
cat("Number of instances:", results$run_info$n_instances, "\n")
cat("Date range:", format(results$run_info$date_range[1]), "to", 
    format(results$run_info$date_range[2]), "\n")

# Display first few rows
print(head(results$results, 10))

## ----resume_from_checkpoint, eval = T-----------------------------------------
# Get the first checkpoint file
checkpoint_files_full <- list.files(checkpoint_dir, 
                                    pattern = "^chk_.*\\.Rda$",
                                    full.names = TRUE)

if (length(checkpoint_files_full) > 0) {
  checkpoint_to_restore <- checkpoint_files_full[1]
  
  cat(checkpoint_to_restore, "\n\n")
  
  new_start_date <- "12/30/2024"
  yml_tmp <- data.table::copy(yml)
  yml_tmp$simulation_config$start_date <- new_start_date
  yml_tmp$simulation_config$restore_from <- checkpoint_to_restore
  yml_tmp$population_data$initialization <- NULL # ensure that we don't want to reinitialize the population from the initialization file
  
  temp_config_resume <- tempfile(tmpdir = dirname(example_config),fileext = ".yaml")
  yaml::write_yaml(yml_tmp, temp_config_resume)
  temp_config_resume <- normalizePath(temp_config_resume)
  
  
  # Run the resumed simulation
  results_resumed <- metaRVM(temp_config_resume)
  
  cat("Number of instances:", results_resumed$run_info$n_instances, "\n")
  cat("Date range:", format(results_resumed$run_info$date_range[1]), "to", 
      format(results_resumed$run_info$date_range[2]), "\n")
  
} else {
  cat("No checkpoint files found to resume from.\n")
}

## ----plot, eval = T, fig.height = 6, fig.width = 8, fig.align = "center"------
run1_hosp_sum <- results$results[disease_state == "H", .(total = sum(value)), by = "date"]
run2_hosp_sum <- results_resumed$results[disease_state == "H", .(total = sum(value)), by = "date"]

library(ggplot2)
ggplot(rbind(run1_hosp_sum, run2_hosp_sum), aes(date, total)) +
  geom_line(, color = "red") +
  geom_vline(xintercept = as.Date("2024-12-29"), linetype = "dashed") +
  labs(y = "Hospitalizations", x = "Date") + theme_bw()


