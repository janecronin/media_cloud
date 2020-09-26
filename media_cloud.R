# Sample code for loading, cleaning and joining Media Cloud datasets

library(tidyverse)
library(lubridate)

## Create dataframes

sources <- read_csv("us_national_sources.csv", col_names = TRUE)
us_stories <- read_csv("all_stories.csv", col_names = TRUE)
c_right_stories <- read_csv("tigerking.csv", col_names = TRUE)

head(sources)
head(us_stories)
# Note that there is some duplication across datasets

## Join stories and source datasets 

# Deduping and removing unneeded data
sources <- sources %>% select(-pub_country, -pub_state, -about_country, -public_notes, -editor_notes, -url)
us_stories <- us_stories %>% select(-language, -themes, -media_name)

# Joining datasets

us_stories <- us_stories %>% left_join(sources, by = "media_id")

# Filtering on languages

us_stories %>% group_by(language) %>% summarise(n = n())
us_stories <- us_stories %>% filter(language == "en")

# Creating new date columns and counting stories by date

us_stories <- us_stories %>%
  mutate(year = year(publish_date)) %>%
  mutate(month = month(publish_date)) %>%
  mutate(day = day(publish_date)) %>%
  filter(year != 'NA')

us_stories %>% group_by(month) %>% summarise(n = n())

# Filter by media_type

us_stories %>% filter(media_type == "digital_native")

# Use join to find US stories in centre right stories list

c_right_stories <- c_right_stories %>% inner_join(sources)
