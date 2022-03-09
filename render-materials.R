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

# generate PDFs -----------------------------------------------------------

for (i in seq_along(slide_paths)) {
  fs::file_copy(path = "slides/slides.css", new_path = slide_paths[i])
  fs::file_copy(path = "slides/xaringan-themer.css", new_path = slide_paths[i])
}

walk(xaringans, pagedown::chrome_print)

for (i in seq_along(slide_paths)) {
  fs::file_delete(path = paste0(slide_paths[i], "/slides.css"))
  fs::file_delete(path = paste0(slide_paths[i], "/xaringan-themer.css"))
}

# render slides in viewer pane --------------------------------------------

# xaringan::inf_mr(cast_from = "..")
