# https://drsimonj.svbtle.com/embarking-on-a-tidy-git-analysis
library(tidyverse)

system('git log -3')

log_format_options <- c(datetime = "cd", commit = "h", parents = "p", author = "an", subject = "s")
option_delim <- "\t"
log_format   <- glue("%{log_format_options}") %>% glue_collapse(option_delim)
log_options  <- glue('--pretty=format:"{log_format}" --date=format:"%Y-%m-%d %H:%M:%S" --no-merges')
log_cmd      <- glue('git  log {log_options}')
log_cmd


history_logs <- system(log_cmd, intern = TRUE) %>% 
  str_split_fixed(option_delim, length(log_format_options)) %>% 
  as_tibble( .name_repair = "minimal") %>% 
  setNames(names(log_format_options))




