transition\_manual
================
Adam Gruer + Saskia Freytag
22/11/2018

Explain transistion\_manual

A static plot

``` r
cars_plot <- ggplot(mtcars, aes(disp, mpg), ) + 
  geom_point(colour = "purple", size = 3) 
cars_plot
```

![](transition_manual_files/figure-markdown_github/static%20plot-1.png)

Facet by cylinder

``` r
cars_plot + facet_wrap(~cyl)
```

![](transition_manual_files/figure-markdown_github/a%20facet-1.png)

Animate Transition manual will show one frame per level of the supplied variable. the `{current_frame}` can be used anywhere that accepts a string (I think!) to display the value of the 'frame' variable at each step of the animation.

``` r
cars_plot + transition_manual(cyl) +
  labs(title = "{current_frame}")
```

    ## nframes and fps adjusted to match transition

![](transition_manual_files/figure-markdown_github/animate-1.gif)

More complex example
