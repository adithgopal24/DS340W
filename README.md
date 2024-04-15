# DS340W: Estimating Swing Decision Quality in Major League Baseball

We aim to improve upon existing measurements of batter plate discipline, or swing decision quality, in Major League Baseball. For every pitch a batter sees, he has the decision to swing at or take that pitch. Taking a pitch can result in a ball, a strike, or a hit by pitch. Swinging at a pitch can result in a miss, foul, out, or various batted ball types ranging from weak contact to barrels. By using two separate machine learning models, one for no swings and one for swings, we can estimate the probability of each event occuring given the location of the pitch. Knowing the value of each outcome using run values (barrels are good, outs are bad, etc.), we can combine this information with the probabilities calculated to determine the Swing Decision Grade (SDG) for every pitch thrown in the league. These results can be aggregated for each player to estimate SDG for all MLB batters. We compare SDG to EAGLE and Z-O Swing% via the comparison measures of descriptiveness, predictiveness, and reliability.

Within the overall `project` folder are `src` and `volume`, which each contain subfolders. Here's a description of the project/code structure:

`src` contains all source code
`src/feature` contains scripts that pull data from SQL data base (data_pull.R), preprocessing data (data_preprocessing.R), and performs Exploratory Data Analysis (eda.Rmd)
`src/model` contains script for training both "no swing" and "swing" models using tidymodels and XGBoost (train_models.R)
`src/validate` contains script for comparing the final SDG metric to existing plate discipline metrics (SDG_vs_EAGLE.Rmd) alongside necessary data files

`volume` contains the data for modeling and the outputs of the source code
`volume/data` contains the `raw`, `interim`, and `processed` data subfolders
`volume/models` contains the final no swing model (no_swing.rds), final swing model (swing.rds), and the validation errors from Bayesian optimization (no_swing_val_error.csv and swing_vaL_error.csv)
`volume/plots` contains the feature importance scores of both the final no swing model (no_swing_vip.png) and the final swing model (swing_vip.png)

