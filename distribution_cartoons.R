library(ggplot2)
library(cowplot)

x_values <- data.frame(x = c(-3, 3))

dnorm_shift_small <- function(x){
  dnorm(x, mean = 0.5)
}

dnorm_shift_big <- function(x){
  dnorm(x, mean = 3.5)
}

gg_base <- ggplot(x_values, aes(x)) +
  theme(axis.text = element_blank()) +
  ylab("Density") + xlab("Coefficient Value") +
  xlim(-4, 7)

plot_grid(
  gg_base +
    stat_function(fun = dnorm) +
    stat_function(fun = dnorm_shift_small) +
    ggtitle("No Connectivity Effect"),
  gg_base +
    stat_function(fun = dnorm) +
    stat_function(fun = dnorm_shift_big) +
    ggtitle("Connectivity Effect")
)
