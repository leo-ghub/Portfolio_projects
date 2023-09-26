library(rvest)
library(tidyverse)
data <- read_html('realestate.html')


head(data)
# PRICE class="property-price "
# ADDRESS class="details-link residential-card__details-link" 
# ROOMS, BATHROOMS, PARKING class="View__PropertyDetail-sc-11ysrk6-0 gIMwxl" 
# DATE class="PropertyCardLayout__StyledPipedContent-sc-1qkhjdh-0 hHFkUu"

# Objects are contained between <span> after the class tags

# Checking that classes for sold date are the same

"Inline__InlineContainer-sc-lf7x8d-0 cLUjmi" == "Inline__InlineContainer-sc-lf7x8d-0 cLUjmi"
"View__PropertyDetail-sc-11ysrk6-0 gIMwxl" == "View__PropertyDetail-sc-11ysrk6-0 gIMwxl" 

# Find all elements with prices

data %>%
  html_elements('.property-price') %>%
  View() -> pprice

class(pprice)

price <- html_text(pprice) # Changing type from XML_nodeset to character 
class(price)

head(price, 5) # Inspecting price object

data.frame(price) # Transforming object price into a data frame 
head(price)

# Obtaining addresses and turning the into a data frame

address <- data %>%
  html_elements(".residential-card__address-heading") %>%
  html_text %>%
  data.frame()


# Inspecting addresses data frame

head(address)

# Obtain number of bedrooms and turn into a data frame

bedrooms <- html_nodes(data, ".View__PropertyDetail-sc-11ysrk6-0.gIMwxl:nth-child(1) p") %>% html_text() %>% data.frame()

# Preview extracted numbers

head(bedrooms)

# assign row numbers to data frame

bedrooms2 <- bedrooms %>% mutate(ID = row_number())
head(bedrooms2)

# Remove comas and currency symbols from Price and turn into a dataframe

price <- as.numeric(gsub("[\\$,]", "", price)) %>%
  data.frame()  
View(price)

# add row numbers to data frame in order to be able to merge columns later on

price2 <- price %>% mutate(ID = row_number())


# merging columns based on a common attribute

dataset <- merge(price2, bedrooms2, by = "ID")
View(dataset)

# Renaming columns

colnames(dataset)[2] ="Price"
colnames(dataset)[3] ="Bedrooms"
View(dataset)

# download CSV containing house prices

write.csv(dataset, "houseprice.csv", row.names=FALSE) 

# Frequency plot

hist(dataset$Price)

# Creating boxplot

boxplot(dataset$Price)

# statistical summary

summary(dataset$Price)

# Making all variables numeric


dat <- sapply( dataset, as.numeric )

# Exploring if exists a correlation between variables


res <- cor(dat)
round(res, 2)

library(corrplot)
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)



