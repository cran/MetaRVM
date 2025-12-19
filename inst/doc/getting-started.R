## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5
)

## ----eval=FALSE---------------------------------------------------------------
# # install.packages("devtools")
# devtools::install_github("RESUME-Epi/MetaRVM")

## ----setup, eval=FALSE--------------------------------------------------------
# library(MetaRVM)
# library(ggplot2)
# options(odin.verbose = FALSE)

## -----------------------------------------------------------------------------
# Locate the example YAML configuration file
yaml_file <- system.file("extdata", "example_config.yaml", package = "MetaRVM")
print(yaml_file)

## ----results='hide'-----------------------------------------------------------
# Load the metaRVM library
library(MetaRVM)

# Run the simulation
sim_out <- metaRVM(yaml_file)

## -----------------------------------------------------------------------------
print(sim_out)
head(sim_out$results)

