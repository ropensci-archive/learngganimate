Harvest of Field
================
Emi Tanaka
22 November 2018

``` r
library(tidyverse)
```

    ## ── Attaching packages ──────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.7
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ─────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(gganimate)
library(ggimage)

# make data set for movement of the tractor 
harvest_df <- data.frame(
  x=c(-0.375 + 0.75*(0:15), rep(-0.375 + 0.75*15, 3), -0.375 + 0.75*(15:0), rep(-0.375+0, 3),
      -0.375 + 0.75*(0:15), rep(-0.375 + 0.75*15, 3), -0.375 + 0.75*(15:0), rep(-0.375+0, 3),
      -0.375 + 0.75*(0:15), rep(-0.375 + 0.75*15, 3), -0.375 + 0.75*(15:0), rep(-0.375+0, 3),
      -0.375 + 0.75*(0:15), rep(-0.375 + 0.75*15, 3), -0.375 + 0.75*(15:0)
      ),
  y=6 * c(rep(-1, 16), 0:2, rep(3, 16), 3:5,
          rep(6, 16), 6:8, rep(9, 16), 10:12,
          rep(12,16), 12:14, rep(15, 16), 16:18,
          rep(18,16), 18:20, rep(21, 16)),
  image=c(rep("images/tractor_right.png", 16),
          rep("images/tractor_vertical.png", 3),
          rep("images/tractor_left.png", 16),
          rep("images/tractor_vertical.png", 3),
          rep("images/tractor_right.png", 16),
          rep("images/tractor_vertical.png", 3),
          rep("images/tractor_left.png", 16),
          rep("images/tractor_vertical.png", 3),
          rep("images/tractor_right.png", 16),
          rep("images/tractor_vertical.png", 3),
          rep("images/tractor_left.png", 16),
          rep("images/tractor_vertical.png", 3),
          rep("images/tractor_right.png", 16),
          rep("images/tractor_vertical.png", 3),
          rep("images/tractor_left.png", 16)),
  xpos=c(0:15, rep(15,3), 15:0, rep(0, 3),
         0:15, rep(15,3), 15:0, rep(0, 3),
         0:15, rep(15,3), 15:0, rep(0, 3),
         0:15, rep(15,3), 15:0),
  ypos=c(rep(-1, 16), 0:2, rep(3, 16), 3:5,
          rep(6, 16), 6:8, rep(9, 16), 10:12,
          rep(12,16), 12:14, rep(15, 16), 16:18,
          rep(18,16), 18:20, rep(21, 16))
  )
harvest_df$time <- 1:nrow(harvest_df) 

# make the field with change of color as it gets harvested
ggdat <- expand.grid(x=0.75 * c(0:14),
                     y=6 * c(0:21),
                     time=1:nrow(harvest_df),
                     fill="#009900") %>% mutate(fill=as.character(fill)) # green
ggdat$xpos <- ggdat$x/0.75
ggdat$ypos <- ggdat$y/6
for(atime in 1:nrow(harvest_df)) {
  ggdat <- ggdat %>% mutate(
    fill=case_when(
      ypos==0 & xpos < (atime - 1) & time==atime & time %in% 2:16 ~ "#8B4513",
      ypos==0 & xpos %in% 0:14 & time > 16 ~ "#8B4513",
      ypos %in% 1:3 & (14 - xpos) <= atime%%21 & time==atime & time %in% 21:35 ~ "#8B4513",
      ypos %in% 1:3 & xpos %in% 0:14 & time > 35 ~ "#8B4513",
      ypos %in% 4:6 & xpos <= atime%%39 & time==atime & time %in% 39:54 ~ "#8B4513",
      ypos %in% 4:6 & xpos %in% 0:14 & time > 54 ~ "#8B4513",
      ypos %in% 7:9 & (14 - xpos)  <= atime%%58 & time==atime & time %in% 58:73 ~ "#8B4513",
      ypos %in% 7:9 & xpos %in% 0:14 & time > 73 ~ "#8B4513",
      ypos %in% 10:12 & xpos <= atime%%77 & time==atime & time %in% 77:92 ~ "#8B4513",
      ypos %in% 10:12 & xpos %in% 0:14 & time > 92 ~ "#8B4513",
      ypos %in% 13:15 & (14 - xpos) <= atime%%96 & time==atime & time %in% 96:111 ~ "#8B4513",
      ypos %in% 13:15 & xpos %in% 0:14 & time > 111 ~ "#8B4513",
      ypos %in% 16:18 & xpos <= atime%%115 & time==atime & time %in% 115:130 ~ "#8B4513",
      ypos %in% 16:18 & xpos %in% 0:14 & time > 130 ~ "#8B4513",
      ypos %in% 19:21 & (14 - xpos) <= atime%%134 & time==atime & time %in% 134:149 ~ "#8B4513",
      ypos %in% 19:21 & xpos %in% 0:14 & time > 149 ~ "#8B4513",
      TRUE ~ fill
    ))
}
```

``` r
ga <- ggplot(ggdat, aes(x, y)) +
  geom_tile(aes(fill=I(fill)), height=6, width=0.75, colour="white", size=1.2) +
  geom_image(data=harvest_df, 
             aes(x, y, image=image), size=0.09)  +
  theme_void() + transition_time(time) +
  ease_aes('linear')
```

    ## Warning: Ignoring unknown parameters: image_colour

``` r
animate(ga, width=400)
```

![](example_harvest_animation_files/figure-gfm/unnamed-chunk-2-1.gif)<!-- -->
