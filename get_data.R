library(tidyverse)
dat_file <-'C:/Users/gabri/OneDrive - CZU v Praze/czu/intrplEU/Midolo.et.al_Interpolation.EU/interpolated_S_change/data/preds/preds_stdpltsz.rf.csv'

# Load prediction data
dat <- dat_file %>%
  read_csv(show_col_types = FALSE) %>%
  dplyr::select(x, y, habitat, year, contains('S_pred_')) %>%
  filter(year >= 1960 & year <= 2020)

# Manually centering plots by rounding coordinates
fact = 1000*10 # 10 km distance
dat <- dat %>%
  mutate(x = round(x / fact) * fact,
         y = round(y / fact) * fact) %>%
  group_by(x, y, habitat) %>%
  summarise(
    n = n(), # number of plots
    across(where(is.numeric), mean, .names = "{.col}"), # average predictions across nearest plots per year
    .groups = 'drop'
  )

write_rds(dat, 'data.rds', compress = 'gz')