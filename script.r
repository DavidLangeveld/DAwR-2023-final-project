# Setting working directory
setwd("$pwd/DAwR-2023-final-project")

# Loading required libraries
library(readxl)
library(tidyverse)
library(readr)

# Loading excel sheets 
frame1 <- read_excel("Datafiles/participants100.xlsx")
frame2 <- read_excel("Datafiles/participants200.xlsx")
frame3 <- read_excel("Datafiles/participants300.xlsx")

# Merging all sheets into a single dataframe
esim_data <- rbind(frame1, frame2, frame3)

# Exploring dataframe columns
glimpse(esim_data)

# Taking random 20 rows sample
sample <- esim_data[sample(nrow(esim_data), 20), ]
sample

# Exploring unique values for variables

# What are the types of medals
length(unique(esim_data$medal))
unique(esim_data$medal)

# What are the competition roles?
length(unique(esim_data$ChampRole))
unique(esim_data$ChampRole)
# there are some roles, but this data doesn't make much sense in current context

# How many teams identifiers in the dataset
length(unique(esim_data$fk_command)) 
# might be useful for interpreting results

# How many organizations represented by competitors in the dataset?
length(unique(esim_data$organization))
unique(esim_data$organization) 
# variable is useless

# Is there any results marked with nok identifier?
length(unique(esim_data$nok))
unique(esim_data$nok)
length(esim_data$nok[esim_data$nok == "1"]) 
# at least 207 observaions are for demonstration exams

# Is there any results marked for exclusion from competition?
length(unique(esim_data$excludeFromResault))
unique(esim_data$excludeFromResault)
esim_data[!is.na(esim_data$excludeFromResault), ]
# there are 13076 observations, might be useful for results interpretation  

# Is there any group markers for competitors?
length(unique(esim_data$competitorMarker))
unique(esim_data$competitorMarker) 
# variable is useless

# Is there any group markers for experts?
length(unique(esim_data$expertGroupMarker))
unique(esim_data$expertGroupMarker) 
# there are some markers, but in the current context this variable is useless

# Removing columns which won't be used for research
esim_data <- subset(esim_data, 
                   select = -c(ChampRole,
                               fkUserAdd,
                               competitorMarker,
                               expertGroupMarker,
                               fk_quotaCategory,
                               FK_USER_CP,
                               ACCESS_RKC,
                               organization,
                               participant_updated_at,
                               is_requested,
                               is_accepted))

# Moving mark700 column after mark500 for convenience
esim_data <- esim_data %>% relocate(mark700, .after = mark500)

glimpse(esim_data)

# How many observations where mark100 is missing?
esim_data[is.na(esim_data$mark100), ]

# Removing observations where mark100 is missing (NA or 0)
esim_data <- esim_data %>% 
  drop_na(mark100) %>% 
  filter(mark100 > 0)

# Renaming some of the columns for convenience
colnames(esim_data) <- c("result", 
                         "competitor", 
                         "competition", 
                         "skill", 
                         "region", 
                         "mark100", 
                         "mark500", 
                         "mark700", 
                         "medal", 
                         "timestamp", 
                         "guest", 
                         "team", 
                         "expert", 
                         "nok")