######## From the great post by DJ Navaro ########
########    I have changed wake to mark   ########
library(e1071)
library(tidyverse)
library(gganimate)

ntimes <- 20  # how many time points to run the bridge?
nseries <- 10 # how many time series to generate?

# function to generate the brownian bridges
make_bridges <- function(ntimes, nseries) {
  replicate(nseries, c(0,rbridge(frequency = ntimes-1))) %>% as.vector()
}

# construct tibble
tbl <- tibble(
  Time = rep(1:ntimes, nseries),
  Horizontal = make_bridges(ntimes, nseries),
  Vertical = make_bridges(ntimes, nseries),
  Series = gl(nseries, ntimes)
)

glimpse(tbl)
table(tbl$Series)


## Make a base pic
base_pic <- tbl %>%
  ggplot(aes(
    x = Horizontal, 
    y = Vertical, 
    colour = Series)) + 
  geom_point(
    show.legend = FALSE,
    size = 5) + 
  coord_equal() + 
  xlim(-1.5, 1.5) + 
  ylim(-1.5, 1.5)

base_pic + facet_wrap(~Time)

#Base Anim
base_anim <- base_pic + transition_time(time = Time) 

#Single Color mark
mark1<- base_anim + 
  shadow_mark(size = 1, 
              alpha = 0.5,
              colour = "black"
  )
mark1 %>% animate(detail = 5, type = "cairo")


#Multi color mark
#Create a set of colors for us to use. Normally I would match them up (red with light red ect.) but for this example we wont. 
library(fields)
cols<-tim.colors(10)

#Assign each series their own color in the tbl, There is certainly a better way to do this; but I don't know it. 
tbl<-tbl %>% select(Time:Series) %>% mutate(col=case_when(
  Series== 1  ~ cols[1],
  Series== 2  ~ cols[2],
  Series== 3  ~ cols[3],
  Series== 4  ~ cols[4],
  Series== 5  ~ cols[5],
  Series== 6  ~ cols[6],
  Series== 7  ~ cols[7],
  Series== 8  ~ cols[8],
  Series== 9  ~ cols[9],
  Series== 10  ~ cols[10]))

#Arrange the tbl based on the time variable; this is so that the order of the color column matches the order gganimate will turn your data into. 
tbl<-tbl %>% arrange(Time)

#Redo the above
base_pic <- tbl %>%
  ggplot(aes(
    x = Horizontal, 
    y = Vertical, 
    colour = Series)) + 
  geom_point(
    show.legend = FALSE,
    size = 5) + 
  coord_equal() + 
  xlim(-1.5, 1.5) + 
  ylim(-1.5, 1.5)

base_pic + facet_wrap(~Time)

#Base Anim
base_anim <- base_pic + transition_time(time = Time) 

markcol <- base_anim + 
  shadow_mark(alpha=0.6, 
              colour=tbl$col, 
              size = 1.5)
markcol %>% animate()
