# load packages, read data

library(tidyverse)
library(irr)

# Create dataframes for each rater

author_A_statements <- read_csv("item_preparation/statements_A.csv") %>%
  rename(Topic_Emotionality_A = Topic_Emotionality,
         Strength_of_Correlation_A = Strength_of_Correlation) %>%
  select(-Notes)
  

author_B_statements <- read_csv("item_preparation/statements_B.csv") %>%
  rename(Topic_Emotionality_B = Topic_Emotionality,
         Strength_of_Correlation_B = Strength_of_Correlation) %>%
  select(-Notes)

# Bind dataframes together

all_ratings <- left_join(author_A_statements, author_B_statements, by = c("Number", "Statements"))

## IRR Calculations

kappa2(matrix(c(all_ratings$Topic_Emotionality_A,
                all_ratings$Topic_Emotionality_B), ncol = 2), "squared")    

kappa2(matrix(c(all_ratings$Strength_of_Correlation_A,
                all_ratings$Strength_of_Correlation_B), ncol = 2), "squared")    

# both show moderate levels of agreement, with strength of belief having higher kappa
# calculate absolute difference between raters

all_ratings_diff <- all_ratings %>%
  mutate(emot_diff = abs(Topic_Emotionality_A - Topic_Emotionality_B),
         corr_diff = abs(Strength_of_Correlation_A - Strength_of_Correlation_B))

# produce df with average ratings

ratings_ranks <- all_ratings_diff %>%
  mutate(avg_emot = (Topic_Emotionality_A + Topic_Emotionality_B)/2,
         avg_corr = (Strength_of_Correlation_A + Strength_of_Correlation_B)/2) %>%
  select(-c(ends_with("A"), ends_with("B")))

# select high corr strength candidate items

high_corr_candidates <- ratings_ranks %>%
  filter(avg_corr > 5 & between(avg_emot, 3, 5) & emot_diff < 3 & corr_diff < 3) %>%
  mutate(label = "high_corr")

# select low corr strength candidate items
# note selecting for corr below 3 produces only 3 items, so select for corr below 4

low_corr_candidates <- ratings_ranks %>%
  filter(avg_corr < 4 & between(avg_emot, 3, 5) & emot_diff < 3 & corr_diff < 3) %>%
  mutate(label = "low_corr")

# create df with attention check items

statement <- rep(c("Please set both sliders to 7.",
                   "Please set both sliders to 1."),
                 times = c(3,3))

attention_data <- data.frame(statement) %>%
  mutate(colour = "red",
         item_no = 26:31,
         label = "AC") 

# bind low and high corr datasets, then save in data folder

experimental_data <- rbind(high_corr_candidates, low_corr_candidates) %>%
  mutate(colour = "black") %>%
  rename(item_no = Number,
         statement = Statements) %>%
  mutate(item_no = 1:25)

pre_test_data <- bind_rows(experimental_data, attention_data) %>%
  write_csv(file = "data/pre_test_data.csv")



















