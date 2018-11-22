
library(ggplot2)
library(ggimage)
library(gganimate)
library(tidyverse)


#########################################

ggdat <- expand.grid(x=0.75 * c(0:14),
                     y=3* c(0:10),
                     fill=NA)


fill <- rep(NA, nrow(ggdat))

for(i in 1:nrow(ggdat)){
  if(ggdat$y[i]<=12){
    fill[i] <- "#009900"
  }
  else if(ggdat$y[i]==15){
    fill[i] <- "#72777f"
  } else
  {fill[i] <- "#4e86e0"}
}

ggdat$fill <- fill

ga <- ggplot(ggdat, aes(x, y)) +
  geom_tile(aes(fill=I(fill)), height=6, width=0.75, colour="white", size=1.2) +theme_void()
ga



dta <- data.frame(y =     c(15, 15),
                  x =     c(0,  10.5),
                  tstep = c("a" , "b"),
                  image = rep("images/car.png",2))

# ga <- ga + geom_point(data=dta, aes(x,y), col="red", size=20)
# 
# ga+transition_states(tstep,
#                      transition_length=1,
#                      state_length = 1) +
#   ease_aes('bounce-in-out')

ga1 <- ga +geom_image(data=dta, aes(x,y, image=image), size=0.5)
ga1 + transition_states(tstep,
                     transition_length=1,
                     state_length = 1) +
  ease_aes('bounce-in-out')

