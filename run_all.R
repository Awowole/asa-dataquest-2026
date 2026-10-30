# ==============================================================================
# MASTER RUN SCRIPT: THE SILVER TSUNAMI REPRODUCIBILITY PIPELINE
# ==============================================================================
# Competition: ASA DataQuest 2026
# Team: Data Architects
# Lead: Awowole uthman (usmanawowole@gmail.com)
#
# Instructions:
# Run this script directly from the project root directory in R or from terminal:
# Rscript run_all.R
# ==============================================================================

cat("==============================================================================\n")
cat("EXECUTING COMPLETE REPRODUCIBILITY PIPELINE: THE SILVER TSUNAMI\n")
cat("==============================================================================\n\n")

# Ensure subdirectories exist
dirs <- c("figures", "figures_cropped", "tables", "presentation")
for (d in dirs) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}

# 1. Data Audit & Filtering
source("scripts/00_data_audit_and_filtering.R")

# 2. Spatial Clustering & Migration (Figure 2)
source("scripts/01_spatial_clustering_migration.R")

# 3. Sub-Replacement Fertility Ratchet (Figure 3)
source("scripts/02_subreplacement_fertility_ratchet.R")

# 4. Econometric Drivers & Diagnostics (Figure 4 & Figure 5)
source("scripts/03_econometric_drivers_and_diagnostics.R")

# 5. Bootstrap Crossover Simulation
source("scripts/04_bootstrap_crossover_analysis.R")

cat("==============================================================================\n")
cat("ALL REPRODUCIBILITY SCRIPTS EXECUTED SUCCESSFULLY!\n")
cat("Figures exported to 'figures/' and 'figures_cropped/'\n")
cat("Data tables exported to 'tables/'\n")
cat("==============================================================================\n")

