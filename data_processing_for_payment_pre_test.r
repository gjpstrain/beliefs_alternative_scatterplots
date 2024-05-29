library(tidyverse)

just_columns <- read_csv("data/pre_test_raw.csv") %>%
  select(c("participant",
           "item_no",
           "slider_emotion.response",
           "slider_belief.response")) %>%
  filter(item_no %in% c(26, 27, 28, 29, 30, 31))

id <- unique(just_columns$participant)

just_columns$answer_emotion = NULL

just_columns$answer_belief = NULL

new_df <- just_columns %>%
  mutate(answer_emotion = case_when(
    item_no == 26 ~ 6,
    item_no == 27 ~ 6,
    item_no == 28 ~ 6,
    item_no == 29 ~ 2,
    item_no == 30 ~ 2,
    item_no == 31 ~ 2
  )) %>%
  mutate(answer_belief = case_when(
    item_no == 26 ~ 6,
    item_no == 27 ~ 6,
    item_no == 28 ~ 6,
    item_no == 29 ~ 2,
    item_no == 30 ~ 2,
    item_no == 31 ~ 2
  )) %>%
  mutate(correct = case_when(
    item_no < 29 ~ slider_emotion.response >= answer_emotion & slider_belief.response >= answer_belief,
    item_no > 28 ~ slider_emotion.response <= answer_emotion & slider_belief.response <= answer_belief
  )) %>%
  group_by(participant) %>%
  summarise(total_correct = sum(correct)) %>%
  arrange(-total_correct)

new_df$passed <- new_df$total_correct > 3

write_csv(new_df, "data/pre_test_passed.csv")











