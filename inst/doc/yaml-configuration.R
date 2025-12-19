## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----mapping_example, echo=FALSE----------------------------------------------
mapping_file <- system.file("extdata", "demographic_mapping_n24.csv", package = "MetaRVM")
mapping_data <- read.csv(mapping_file)
cat("First 10 rows of demographic_mapping_n24.csv:\n\n")
print(head(mapping_data, 10))
cat("\n... (", nrow(mapping_data), " total rows)\n", sep = "")

## ----init_example, echo=FALSE-------------------------------------------------
init_file <- system.file("extdata", "population_init_n24.csv", package = "MetaRVM")
init_data <- read.csv(init_file)
cat("First 10 rows of population_init_n24.csv:\n\n")
print(head(init_data, 10))
cat("\n... (", nrow(init_data), " total rows)\n", sep = "")

## ----vac_example, echo=FALSE--------------------------------------------------
vac_file <- system.file("extdata", "vaccination_n24.csv", package = "MetaRVM")
vac_data <- read.csv(vac_file)
cat("First 10 rows of vaccination_n24.csv:\n\n")
print(head(vac_data, 10))
cat("\n... (", nrow(vac_data), " total rows)\n", sep = "")
cat("\nNote: Columns represent vaccination counts for each population_id (1-24)\n")

## ----mixing_example, echo=FALSE-----------------------------------------------
mixing_file <- system.file("extdata", "m_weekday_day.csv", package = "MetaRVM")
mixing_data <- read.csv(mixing_file, header = FALSE)
cat("First 10 rows and 10 columns of m_weekday_day.csv:\n\n")
print(head(mixing_data[, 1:10], 10))
cat("\nMatrix dimensions:", nrow(mixing_data), "x", ncol(mixing_data), "\n")
cat("Row sums (should all equal 1):\n")
row_sums <- rowSums(mixing_data)
print(head(row_sums, 10))

