
library(ggplot2)
library(ggimage)
library(gganimate)
library(tidyverse)

dta <- data.frame(y =     c(1, 1),
                  x =     c(1,  5),
                  tstep = c("a" , "b"),
                  image = rep("images/car.png",2))


ga <- ggplot(dta, aes(x,y))
ga <-  ga +geom_image(data=dta, 
                  aes(x, y, image=image), size=0.1) 
ga <- ga +theme_void()
ga+transition_states(tstep,
                     transition_length=1,
                     state_length = 1) +
  ease_aes('quintic-in')
