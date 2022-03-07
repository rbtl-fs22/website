# load packages ----------------------------------------------------------------

library(fs)
library(tidyverse)
library(rmarkdown)
library(xaringan)

# update course data ------------------------------------------------------

source(here::here("data/get_course_data.R"))

# non-xaringan -----------------------------------------------------------------

rmds <- dir_info(recurse = 3, glob = "_posts/*.Rmd") %>% 
  filter(!str_detect(path, "slides")) %>%
  pull(path)

walk(rmds, render)

# xaringan ---------------------------------------------------------------------

xaringans <- dir_info(recurse = 3, glob = "slides/*.Rmd") %>% 
  filter(str_detect(path, "slides")) %>%
  filter(!str_detect(path, "setup")) %>%
  pull(path)

walk(xaringans, render)

xaringans_html <- dir_info(recurse = 3, glob = "slides/*.html") %>% 
  filter(str_detect(path, "slides")) %>%
  filter(!str_detect(path, "setup")) %>%
  pull(path)

walk(xaringans_html, pagedown::chrome_print)

# render slides in viewer pane --------------------------------------------

# xaringan::inf_mr(cast_from = "..")
