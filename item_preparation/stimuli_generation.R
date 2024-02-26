# load packages

library(tidyverse)
library(MASS)
library(Hmisc)
library(bbplot)


# for now, let's just use the same seed as previous work

set.seed(1234)

high_r <- seq(0.5, 0.99, length.out = 45)
low_r <- seq(0, 0.49, length.out = 45)

item_no <- c(1:45)

low_corr_frame <- tibble(item_no, low_r)
high_corr_frame <- tibble(item_no, high_r)

# slope generation function

slope_function <- function(my_desired_r) {
  set.seed(1234)
  
  my_sample_size = 128
  
  mean_variable_1 = 0
  sd_variable_1 = 1
  
  mean_variable_2 = 0
  sd_variable_2 = 1
  
  mu <- c(mean_variable_1, mean_variable_2) 
  
  myr <- my_desired_r * sqrt(sd_variable_1) * sqrt(sd_variable_2)
  
  mysigma <- matrix(c(sd_variable_1, myr, myr, sd_variable_2), 2, 2) 
  
  corr_data = as_tibble(mvrnorm(my_sample_size, mu, mysigma, empirical = TRUE))
  
  corr_model <- lm(V2 ~ V1, data = corr_data)
  
  my_residuals <- abs(residuals(corr_model))
  
  data_with_resid <- round(cbind(corr_data, my_residuals), 2)
  
  slopes <- data_with_resid %>%
    mutate(slope_0.25 = 1-(0.25)^my_residuals) %>%
    mutate(slope_inverted = (1 + (0.25)^ my_residuals)-1) %>%
    mutate(slope_inverted_floored = pmax(0.1,(1+(0.25)^my_residuals)-1))  
  
  return(slopes)
}

# plot generation function

plot_function <- function(slopes, my_desired_r, letter, size_value, theme) {
  
  p <- ggplot(slopes, aes(x = V1, y = V2)) +
    scale_size_identity() +
    scale_alpha_identity() +
    geom_point(aes(size =  4*(size_value+0.2), alpha = 1), shape = 16) +  
    labs(x = "", y = "") +
    theme +
    theme(axis.text = element_blank()) +
    theme(plot.margin = unit(c(0,0,0,0), "cm")) +
    theme(legend.position = "None")
  
  ggsave(p,filename=paste0(counter, letter, ".png"),
         device = "png",
         bg = "white",
         path = "item_preparation/all_plots",
         units = "px",
         width = 1000,
         height = 1000,
  )
  
  return(p)
}

# create BBC and FT themes



# create plots

counter = 1
for(value in high_r) {
  
  slopes <- slope_function(value)
  slopeN <- (slopes$slope_0.25)
  
  plot_function(slopes, value, "heythere", slopeN, bbc_style())
  
  if (counter > 0) {
    counter = counter + 1
  }
}




