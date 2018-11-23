view\_follow
================
Danielle Navarro
22/11/2018

Creating the animation
----------------------

Let's start with the `gapminder` animation from the gganimate github page:

``` r
pic <- gapminder %>% filter(continent == "Africa") %>%
  ggplot(aes(
    x = log10(gdpPercap), y = lifeExp, 
    size = pop, colour = country
  )) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) 

anim <- pic + 
  labs(
    title = 'Year: {frame_time}', 
    x = 'GDP Per Capita (log10)', 
    y = 'Life Expectancy') +
  transition_time(year) +
  ease_aes('linear')

anim %>% animate(type = "cairo")
```

![](view_follow_files/figure-markdown_github/initialanimation-1.gif)

Zooming in with view\_follow
----------------------------

``` r
anim2 <- anim + view_follow()
anim2 %>% animate(type = "cairo")
```

![](view_follow_files/figure-markdown_github/viewfollow1-1.gif)

Interaction with shadow\_wake
-----------------------------

``` r
anim3 <- anim + view_follow() + shadow_wake(.1)
anim3 %>% animate(type = "cairo", detail= 5)
```

![](view_follow_files/figure-markdown_github/viewfollow2-1.gif)
