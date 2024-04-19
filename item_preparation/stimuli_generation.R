# load packages

library(tidyverse)
library(MASS)
library(Hmisc)
library(bbplot)
library(png)
library(gtools)

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
  
  mean_variable_1 = 5
  sd_variable_1 = 1
  
  mean_variable_2 = 76
  sd_variable_2 = 5
  
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
    mutate(slope_inverted_floored = pmax(0.1,(1+(0.25)^my_residuals)-1)) %>%
    mutate(typical = 0.033)
  
  return(slopes)
}

# covid plot generation function

plot_function_covid <- function(slopes, my_desired_r, name, size_value, theme) {
  
    p <- ggplot(slopes, aes(x = V1, y = V2)) +
    scale_size_identity() +
    scale_alpha_identity() +
    geom_point(aes(size =  6*(size_value + 0.3), alpha = 1), shape = 16) +  
    geom_hline(yintercept = 68, size = 1, colour="#333333") +
    geom_segment(x = 0, xend = 10, y = 66.2, yend = 66.2, size = 0.3, colour="#585858") +
    bbc_style() +
    theme(axis.text.x = element_blank(),
          title = element_text(size = 14),
          plot.subtitle = element_text(size = 11),
          plot.caption = element_text(size = 9, hjust = -.1)) +
    labs(title = "Lockdown Gains",
         subtitle = "More Covid-19 lockdowns were associated\nwith a higher life expectancy among the elderly",
         caption = "Source: NHS England") +
    annotate("text", x = 3, y = 67, label = "Fewer lockdowns") +
    annotate("text", x = 7, y = 67, label = "More lockdowns") +
    coord_cartesian(clip = "off")
  
  ggsave(p,filename=paste0(counter, "_covid_", name, ".png"),
         device = "png",
         bg = "white",
         path = "item_preparation/all_plots",
         units = "px",
         width = 1500,
         height = 1500,
  )
  
  return(p)
}

# reading plot generation function

plot_function_reading <- function(slopes, my_desired_r, name, size_value, theme) {
  
  p <- ggplot(slopes, aes(x = V1, y = V2)) +
    scale_size_identity() +
    scale_alpha_identity() +
    geom_point(aes(size =  6*(size_value + 0.3), alpha = 1), shape = 16) +  
    geom_hline(yintercept = 68, size = 1, colour="#333333") +
    geom_segment(x = 0, xend = 10, y = 66.2, yend = 66.2, size = 0.3, colour="#585858") +
    bbc_style() +
    theme(axis.text.x = element_blank(),
          title = element_text(size = 14),
          plot.subtitle = element_text(size = 11),
          plot.caption = element_text(size = 9, hjust = -.1)) +
    labs(title = "Book Worms",
         subtitle = "People who read more books per year tend to live longer",
         caption = "Source: The British Library") +
    annotate("text", x = 3, y = 67, label = "Fewer books read") +
    annotate("text", x = 7, y = 67, label = "More books read") +
    coord_cartesian(clip = "off")
  
  ggsave(p,filename=paste0(counter,"_books_", name, ".png"),
         device = "png",
         bg = "white",
         path = "item_preparation/all_plots",
         units = "px",
         width = 1500,
         height = 1500,
  )
  
  return(p)
}

# create plots for high r

counter = 1
for(value in high_r) {
  
  slopes <- slope_function(value)
  slopeI <- (slopes$slope_inverted)
  typical <- (slopes$typical)
  
  plot_function_covid(slopes, value, "A_hi", slopeI, bbc_style())
  plot_function_covid(slopes, value, "T_hi", typical, bbc_style())
  plot_function_reading(slopes, value, "A_hi", slopeI, bbc_style())
  plot_function_reading(slopes, value, "T_hi", typical, bbc_style())
  
  if (counter > 0) {
    counter = counter + 1
  }
}

# create plots for low r

counter = 1
for(value in low_r) {
  
  slopes <- slope_function(value)
  slopeI <- (slopes$slope_inverted)
  typical <- (slopes$typical)
  
  plot_function(slopes, value, "A_lo", slopeI, bbc_style())
  plot_function(slopes, value, "T_lo", typical, bbc_style())
  plot_function_reading(slopes, value, "A_lo", slopeI, bbc_style())
  plot_function_reading(slopes, value, "T_lo", typical, bbc_style())
  
  if (counter > 0) {
    counter = counter + 1
  }
}

# build csv file

images_typical <- mixedsort(list.files(path = "item_preparation/all_plots", pattern = "_T_", full.names = F))

images_atypical <- mixedsort(list.files(path = "item_preparation/all_plots", pattern = "_A_", full.names = F))

plot_labels <- rep(c("all_plots/"), each = 180)

plots_with_labels <- paste(plot_labels, images, sep = "")

final_data <- full_data %>%
  
  select(-c(item_no, my_ss))
unique_item_no <- c(1:180)

instructions <- rep(c("Please look at the following plot and use the slider to estimate the correlation"), each = 180)

data_with_plots <- cbind(unique_item_no, final_data, plots_with_labels, images, instructions)
