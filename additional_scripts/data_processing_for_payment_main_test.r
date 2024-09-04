library(tidyverse)

# read in csv files for both experiments
# strip alpha characters from unique item no columns
# rename unique item no column for use in function

main_test_A <- read_csv("data/main_test_A.csv") %>%
  mutate(unique_item_no_A = str_replace_all(unique_item_no_A, "[A-Za-z]", "")) %>%
  rename(unique_item_no = unique_item_no_A)

main_test_T <- read_csv("data/main_test_T.csv") %>%
  mutate(unique_item_no_T = str_replace_all(unique_item_no_T, "[A-Za-z]", "")) %>%
  rename(unique_item_no = unique_item_no_T)

# function to output passed dfs

check_responses <- function(anon) {

  just_columns <- anon %>%
    select(c("participant",
             "unique_item_no",
             "slider.response")) %>%
    filter(unique_item_no %in% c(46, 46, 47, 47)) %>%
    mutate_all(~replace(., is.na(.), 0)) # replace non-responses with zero, as slider defaults at zero
  
  id <- unique(just_columns$participant)
  
  just_columns$answer = NULL
  
  new_df <- just_columns %>%
    mutate(answer = case_when(
      unique_item_no == 46 ~ 0.1,
      unique_item_no == 47 ~ 0.1,
      unique_item_no == 48 ~ 0.9,
      unique_item_no == 49 ~ 0.9
    )) %>%
    mutate(correct = case_when(
      unique_item_no < 48 ~ slider.response < answer,
      unique_item_no > 47 ~ slider.response > answer 
    )) %>%
    group_by(participant) %>%
    summarise(total_correct = sum(correct)) %>%
    arrange(-total_correct)
  
  new_df$passed <- new_df$total_correct >= 2
  
  write_csv(new_df,file.path("data", paste0(unique(anon$expName), "_passed.csv")))

}

# use function on data csvs

check_responses(main_test_A)
check_responses(main_test_T)
