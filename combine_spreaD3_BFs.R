# Load required libraries
library(dplyr)
library(tidyr)
library(readr)


# Read in BF files from directory
file_list <- list.files("./", full.names = TRUE)
data_list <- lapply(file_list, function(file) read.table(file, header = TRUE, sep = "\t", stringsAsFactors = FALSE))


# Initialize an empty data frame to store the aggregated results
result_df <- data.frame(FROM = character(0), TO = character(0), BAYES_FACTOR = numeric(0), POSTERIOR_PROBABILITY = numeric(0))

# Combine all data frames into one
combined_data <- do.call(rbind, data_list)

# Group by "FROM" and "TO" columns and calculate the mean
averaged_data <- combined_data %>%
  group_by(FROM, TO) %>%
  summarize(
    BAYES_FACTOR = median(BAYES_FACTOR),
    POSTERIOR_PROBABILITY = median(POSTERIOR.PROBABILITY)
  )

write_tsv(averaged_data,"aggregated_BF.txt")
