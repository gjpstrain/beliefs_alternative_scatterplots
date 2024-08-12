library(tidyverse)

# read in dataframes, select relevant columns

beliefs <- read_csv("markant_2023_data/belief_df_noexclusions.csv") %>%
  select(c("user_token", "pre_attitude",
           "post_attitude", "pre_belief",
           "post_belief", "var",
           "vis_condition")) %>%
  mutate(belief_diff = post_belief - pre_belief,
         attitude_diff = post_attitude - pre_attitude)

dc_data <- read_csv("markant_2023_data/survey_df_noexclusions.csv") %>%
  select(c("user_token","defensive_confidence"))

# combine for plotting

df_combined <- left_join(beliefs, dc_data, by = "user_token")

df_combined %>%
  ggplot(aes(x = defensive_confidence, y = belief_diff)) +
  geom_smooth(method = "loess", se = F) +
  theme_ggdist()

