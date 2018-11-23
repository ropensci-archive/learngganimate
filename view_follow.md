view\_follow
================
Danielle Navarro
22/11/2018

Creating the animation
----------------------

Let's start with the `gapminder` animation from the gganimate github page:

``` r
pic <- gapminder %>%
  ggplot(aes(
    x = log10(gdpPercap), y = lifeExp, 
    size = pop, colour = country
  )) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 16)) +
  facet_grid(. ~ continent) + 
  theme(text = element_text(size = 20))

anim <- pic + 
  labs(
    title = 'Year: {frame_time}', 
    x = 'GDP Per Capita (log10)', 
    y = 'Life Expectancy') +
  transition_time(year) +
  ease_aes('linear')

anim %>% animate(type = "cairo", width = 1200, height = 600)
```

![](view_follow_files/figure-markdown_github/initialanimation-1.gif)

Zooming in with view\_follow
----------------------------

``` r
anim2 <- anim + view_follow()
anim2 %>% animate(type = "cairo", width = 1200, height = 600)
```

![](view_follow_files/figure-markdown_github/viewfollow1-1.gif)
