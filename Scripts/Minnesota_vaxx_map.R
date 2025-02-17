# Minnesota_vaxx_map.R
# created 2025-02-16
# Purpose: Map vaccination rates by county
#
# https://www.geeksforgeeks.org/how-to-create-state-and-county-maps-easily-in-r/
# https://cran.r-project.org/web/packages/maps/index.html
library(tidyverse)
library(stringi)
library(maps)
library(readxl)
data(county.fips)

mn.fips <- county.fips %>% filter(stri_startswith_fixed(polyname,"minnesota," ))

# read the data
county.data.path <- "data/mn_kcounty2324.xlsx"
vaxdata <- read_excel(county.data.path, 
           sheet="K_County",
           skip=1)
# select MMR and enrollment columns
mmrdata <- vaxdata[2:88,] %>%
  mutate(County = paste0('minnesota,',
                         stri_replace_all_fixed(tolower(County),'.',''), 
                         sep="")) %>%
  select(County,`Kindergarten Enrollment`, `MMR % Vaccinated`)

# define color buckets
colors <- c("#ED1C24", "#ED7720","#F4A270","#9DBFDB")
mmrdata$colorBuckets <- as.numeric(cut(mmrdata$`MMR % Vaccinated`, c(0.0,0.82, 0.90,0.95, 1.0)))
leg.txt <- c("<82%*", "82~90%", "90-95%", ">=95%")

# align data with map definitions by (partial) matching state,county
# names, which include multiple polygons for some counties
cnty.names <- mn.fips$polyname[match(map('county','minnesota', plot=FALSE)$names,
                                    mmrdata$County)] 
colorsmatched <- mmrdata$colorBuckets[match(cnty.names, mmrdata$County)]

minnesota <- map('county', 'minnesota', col = colors[colorsmatched], fill = TRUE,
    mar = c(3, 3, par("mar")[4], 0.1), ylim=c(43,49.1),
    myborder=0.11)
title("Kindergarten vaccination rates by county, 2023/2024")
legend("bottom", leg.txt, horiz = TRUE, fill = colors)
text(-97,43.2,"*Gaines Co., TX rate 2023/2024", col="#ED1C24",adj=c(0,0.5))
# https://www.oaoa.com/local-news/the-immunization-partnership-response-to-gaines-county-measles-outbreak/



