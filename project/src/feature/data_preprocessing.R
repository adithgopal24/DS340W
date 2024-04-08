# Front Matter ##########

# Load libraries
library(tidyverse)
library(tidymodels)

# Read in data
no_swing <- read.csv("project/volume/data/interim/no_swing.csv")
swing <- read.csv("project/volume/data/interim/swing.csv")



# Calculate Run Values ##########
no_swing_rvs <- no_swing %>%
  group_by(description, pitch_count) %>%
  summarise(run_value = mean(delta_run_exp, na.rm = TRUE))

swing_rvs <- swing %>%
  group_by(description, pitch_count) %>%
  summarise(run_value = mean(delta_run_exp, na.rm = TRUE))



# Data Partition ##########
no_swing <- no_swing %>%
  select(plate_x, plate_z, p_throws, stand, pitch_group, description) %>%
  drop_na()

swing <- swing %>%
  select(plate_x, plate_z, p_throws, stand, pitch_group, description) %>%
  drop_na()

set.seed(3)
no_swing_data_split <- initial_validation_split(no_swing, prop = c(0.6, 0.2), strata = description)
no_swing_train <- training(no_swing_data_split)
no_swing_val <- validation(no_swing_data_split)
no_swing_val_set <- validation_set(no_swing_data_split)
no_swing_test <- testing(no_swing_data_split)

swing_data_split <- initial_validation_split(swing, prop = c(0.6, 0.2), strata = description)
swing_train <- training(swing_data_split)
swing_val <- validation(swing_data_split)
swing_val_set <- validation_set(swing_data_split)
swing_test <- testing(swing_data_split)



# Save Data ##########
write.csv(no_swing, "project/volume/data/processed/no_swing.csv", row.names = FALSE)
write.csv(no_swing_train, "project/volume/data/processed/no_swing_train.csv", row.names = FALSE)
write.csv(no_swing_val, "project/volume/data/processed/no_swing_val.csv", row.names = FALSE)
saveRDS(no_swing_val_set, "project/volume/data/processed/no_swing_val_set.rds")
write.csv(no_swing_test, "project/volume/data/processed/no_swing_test.csv", row.names = FALSE)

write.csv(swing, "project/volume/data/processed/swing.csv", row.names = FALSE)
write.csv(swing_train, "project/volume/data/processed/swing_train.csv", row.names = FALSE)
write.csv(swing_val, "project/volume/data/processed/swing_val.csv", row.names = FALSE)
saveRDS(swing_val_set, "project/volume/data/processed/swing_val_set.rds")
write.csv(swing_test, "project/volume/data/processed/swing_test.csv", row.names = FALSE)