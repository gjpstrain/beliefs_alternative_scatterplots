# load packages, read data

library(tidyverse)

author_A_statements <- read_csv("item_preparation/statements_A.csv")

author_B_statements <- read_csv("item_preparation/statements_B.csv")

library(irr)

# set plausibility vectors

author_A_plaus <- author_A_statements$Plausibility
author_B_plaus <- author_B_statements$Plausibility

# set emotionality vectors

author_A_topic_emotionality <- author_A_statements$Topic_Emotionality
author_B_topic_emotionality <- author_B_statements$Topic_Emotionality

# set strength of relatedness vectors

author_A_strength <- author_A_statements$Strength_of_Correlation
author_B_strength <- author_B_statements$Strength_of_Correlation

## IRR Calculations

kappa2(matrix(c(author_A_plaus, author_B_plaus), ncol = 2), "squared")    

kappa2(matrix(c(author_A_topic_emotionality, author_B_topic_emotionality), ncol = 2), "squared")    

kappa2(matrix(c(author_A_strength, author_B_strength), ncol = 2), "squared")    
