# ---- distribution_cartoons ----

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

(res <- plot_grid(
  gg_base +
    stat_function(fun = dnorm,
                  color = viridis::viridis(1, begin = 0)) +
    stat_function(fun = dnorm_shift_small,
                  color = viridis::viridis(1, begin = 0.5)) +
    ggtitle("No Connectivity Effect"),
  gg_base +
    stat_function(fun = dnorm,
                  color = viridis::viridis(1, begin = 0)) +
    stat_function(fun = dnorm_shift_big,
                  color = viridis::viridis(1, begin = 0.5)) +
    ggtitle("Connectivity Effect"),
ncol = 1))

ggsave("figures/distribution_cartoon.png", res, scale = 0.8, width = 4.125)

palette <- c(viridis::viridis(1, begin = 0.5),
      viridis::viridis(1, begin = 0))
