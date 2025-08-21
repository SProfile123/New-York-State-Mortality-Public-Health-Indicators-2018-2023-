# R Script: Mortality Analysis (NY, 2018–2023)

# Load libraries
library(readr)
library(dplyr)
library(ggplot2)

# Load dataset
df <- read_csv("ny_mortality_by_year.csv")

# Clean missing values
df_clean <- df %>% filter(!is.na(Year), !is.na(`Crude Rate`))

# Summary: total deaths per year
summary_table <- df_clean %>%
  group_by(Year) %>%
  summarise(total_deaths = sum(Deaths), avg_rate = mean(`Crude Rate`))

print(summary_table)

# Save summary table to CSV
write.csv(summary_table, "summary_table.csv", row.names=FALSE)

# Create line plot
p <- ggplot(df_clean, aes(x=Year, y=`Crude Rate`)) +
  geom_line(color="blue", size=1.2) +
  geom_point(color="red", size=2) +
  labs(title="Crude Mortality Rate in New York (2018–2023)",
       x="Year", y="Crude Rate per 100,000")

# Save plot as PNG
ggsave("crude_rate_trend.png", plot=p, width=7, height=5)
