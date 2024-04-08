# Front Matter #########

# Load libraries
library(tidyverse)
library(tidymodels)
library(xgboost)
library(vip)

# Load processed data
no_swing_train <- read.csv("project/volume/data/processed/no_swing_train.csv")
no_swing_val <- read.csv("project/volume/data/processed/no_swing_val.csv")
no_swing_val_set <- readRDS("project/volume/data/processed/no_swing_val_set.rds")

swing_train <- read.csv("project/volume/data/processed/swing_train.csv")
swing_val <- read.csv("project/volume/data/processed/swing_val.csv")
swing_val_set <- readRDS("project/volume/data/processed/swing_val_set.rds")



# Train Models ##########
train_run_value_model <- function(train, val, val_set, model_name) {
  
  spec <- boost_tree(trees = tune(), min_n = tune(), tree_depth = tune(), learn_rate = tune(), sample_size = tune(), mtry = tune()) %>%
    set_mode("classification") %>%
    set_engine("xgboost")
  
  num_predictors <- ncol(select(train, -description))
  mtry_param <- mtry(range = c(1, num_predictors))
  params <- parameters(spec) %>% update(mtry = mtry_param)
  
  rec <- recipe(description ~ ., data = train) %>%
    step_dummy(all_nominal_predictors(), one_hot = TRUE)
  
  wf <- workflow() %>%
    add_model(spec) %>%
    add_recipe(rec)
  
  tune_res <- wf %>%
    tune_bayes(resamples = val_set,
               initial = 10,
               iter = 100,
               param_info = params,
               control = control_bayes(verbose = TRUE, no_improve = 10, seed = 3),
               metrics = metric_set(roc_auc))
  
  validation_error <- tune_res %>%
    collect_metrics() %>%
    filter(.metric == "roc_auc")
  
  write.csv(validation_error, paste0("project/volume/models/", model_name, "_val_error.csv"), row.names = FALSE)
  
  best_params <- select_best(tune_res, "roc_auc")

  train <- rbind(train, val)
  
  set.seed(3)
  final_model <- wf %>%
    finalize_workflow(best_params) %>%
    fit(data = train)
  
  saveRDS(final_model, paste0("project/volume/models/", model_name, ".rds"))
  
  vip_plot <- final_model %>% 
    extract_fit_parsnip() %>% 
    vip() +
    ggtitle("Feature Importance")
  
  ggsave(filename = paste0("project/volume/plots/", model_name, "_vip.png"), plot = vip_plot, width = 10, height = 8, dpi = 300)
  
}

# Use function to train models
train_run_value_model(train = no_swing_train, val = no_swing_val, val_set = no_swing_val_set, model_name = "no_swing")
train_run_value_model(train = swing_train, val = swing_val, val_set = swing_val_set, model_name = "swing")
