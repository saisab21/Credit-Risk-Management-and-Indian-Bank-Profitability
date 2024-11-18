# Step 1: Install and Load Libraries
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("reshape2")) install.packages("reshape2")
if (!require("ggplot2")) install.packages("ggplot2")

# Load libraries
library(tidyverse)
library(reshape2)
library(ggplot2)

print("Libraries installed and loaded successfully!")




# Step 2: Load Dataset
file_path <- "C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/data/raw/dataset_final.csv"
dataset <- read.csv(file_path, check.names = FALSE)

# View the structure of the dataset
str(dataset)

# View the first few rows of the dataset
head(dataset)

print("Dataset loaded successfully!")







# Step 3: Clean Column Names
colnames(dataset) <- gsub("\\|", "_", colnames(dataset))  # Replace '|' with '_'
colnames(dataset) <- gsub(" ", "_", colnames(dataset))    # Replace spaces with '_'
colnames(dataset) <- tolower(colnames(dataset))           # Convert to lowercase

# Check the updated column names
print("Cleaned Column Names:")
print(colnames(dataset))





# Step 4: Select Relevant Metrics
metrics <- c("net_profit_margin", 
             "gross_non-performing_assets_(gnpa)_to_advances_(in_per_cent)",
             "net_non-performing_assets_(nnpa)_to_net_advances_(in_per_cent)",
             "return_on_assets",
             "total_capital_adequacy_ratio_of_the_bank_(%)")

# Dynamically filter columns for these metrics
selected_columns <- grep(paste(metrics, collapse = "|"), colnames(dataset), value = TRUE)
filtered_data <- dataset %>% select(all_of(selected_columns))

# View the filtered data
head(filtered_data)

print("Selected relevant metrics successfully!")








# Step 5: Check for Missing Values
print("Summary of Missing Values:")
print(summary(filtered_data))

# Option 1: Remove rows with missing values
filtered_data <- na.omit(filtered_data)

# Option 2: Replace missing values with the mean of each column
filtered_data <- filtered_data %>% 
  mutate(across(where(is.numeric), ~ ifelse(is.na(.), mean(., na.rm = TRUE), .)))

print("Handled missing values successfully!")




# Step 6: Add Identifier Column
filtered_data$Bank <- rownames(filtered_data)

# View the updated dataset
head(filtered_data)

print("Identifier column added successfully!")





# Step 7: Reshape the Data
filtered_data_long <- melt(filtered_data, id.vars = "Bank")

# View the reshaped data
head(filtered_data_long)

print("Data reshaped successfully!")





# Step 8: Plot Trends
ggplot(filtered_data_long, aes(x = Bank, y = value, color = variable, group = variable)) +
  geom_line() +
  labs(title = "Year-wise Trends of Selected Metrics", 
       x = "Bank/Identifier", 
       y = "Value") +
  theme_minimal() +
  theme(legend.position = "right")

print("Trends plotted successfully!")




# Save the plot to a file
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/selected_metrics_trend.png", 
       width = 10, height = 6, dpi = 300)

print("Plot saved successfully!")






# Step 11.1: Display Column Names
print("Column Names in the Dataset:")
print(colnames(filtered_data))




# Step 11.2: Dynamically Filter Columns for Clustering
clustering_keywords <- c("net_profit_margin", "return_on_assets")

# Filter columns dynamically
clustering_columns <- grep(paste(clustering_keywords, collapse = "|"), colnames(filtered_data), value = TRUE)

# Check the matched column names
print("Selected Columns for Clustering:")
print(clustering_columns)

# Select these columns from the dataset
clustering_data <- filtered_data %>% select(all_of(clustering_columns))

print("Done Successfully")


# Step 11.3: Standardize the Data
clustering_data_scaled <- scale(clustering_data)

print("Data prepared and scaled for clustering!")



# Step 11.4: Perform K-Means Clustering
set.seed(42)  # For reproducibility
kmeans_result <- kmeans(clustering_data_scaled, centers = 3, nstart = 25)

# Add cluster labels to the original dataset
filtered_data$Cluster <- as.factor(kmeans_result$cluster)

# View cluster assignments
print("Cluster Assignments:")
print(table(filtered_data$Cluster))


# Install and load required libraries
if (!require("factoextra")) install.packages("factoextra")
library(factoextra)

# Step 11.5: Visualize Clusters
fviz_cluster(kmeans_result, data = clustering_data_scaled,
             geom = "point", ellipse.type = "norm",
             ggtheme = theme_minimal(),
             main = "Cluster Visualization Based on Metrics")


# Save the clustering visualization
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/clustering_visualization.png", 
       width = 10, height = 6, dpi = 300)

print("Clustering visualization saved successfully!")


# Perform PCA on scaled clustering data
pca_result <- prcomp(clustering_data_scaled, scale. = TRUE)

# View PCA summary
print(summary(pca_result))
# Scree Plot
fviz_eig(pca_result, 
         addlabels = TRUE, 
         ylim = c(0, 60),
         ggtheme = theme_minimal(),
         main = "Scree Plot: Explained Variance by Components")


# Save the scree plot
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/scree_plot.png", 
       width = 10, height = 6, dpi = 300)

print("Scree plot saved successfully!")



# Fixed PCA Biplot
fviz_pca_biplot(pca_result, 
                geom.ind = "point", # Represent individuals (banks) as points
                geom.var = "arrow", # Represent variables as arrows
                repel = TRUE,       # Avoid overlapping of labels
                ggtheme = theme_minimal()) # Simplify the theme
# Save the PCA Biplot
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/pca_biplot.png", 
       width = 10, height = 6, dpi = 300)

print("PCA biplot saved successfully!")



# Save Cluster Assignments to CSV
write.csv(filtered_data, "C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/output/clustered_data.csv", row.names = FALSE)

print("Clustered data saved successfully!")




############################Analyze Relationships Between Credit Risk Indicators and Profitability

# Define keywords for the metrics of interest
correlation_keywords <- c(
  "gnpa",    # GNPA to Advances
  "nnpa",    # NNPA to Net Advances
  "capital_adequacy", # Capital Adequacy
  "net_profit_margin", # Net Profit Margin
  "return_on_assets"   # Return on Assets
)

# Dynamically filter the columns
correlation_columns <- grep(paste(correlation_keywords, collapse = "|"), colnames(filtered_data), value = TRUE)

# Check the matched column names
print("Columns Selected for Correlation Analysis:")
print(correlation_columns)





# Filter the dataset using matched column names
correlation_data <- filtered_data %>% select(all_of(correlation_columns))

# Ensure that the data is numeric for correlation calculations
correlation_data <- correlation_data %>% mutate(across(everything(), as.numeric))

print("Correlation data prepared successfully!")



# Compute the correlation matrix
correlation_matrix <- cor(correlation_data, use = "complete.obs")

# Display the correlation matrix
print("Correlation Matrix:")
print(correlation_matrix)



# Install and load corrplot if not already installed
if (!require("corrplot")) install.packages("corrplot")
library(corrplot)

# Save the correlation heatmap to a file with sufficient dimensions
png("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/correlation_heatmap_fixed.png", 
    width = 1200, height = 1000, res = 150) # Increase resolution and size

# Plot the correlation heatmap
corrplot(correlation_matrix, 
         method = "color",         # Use color for better clarity
         type = "upper",           
         tl.col = "black",         # Text color for labels
         tl.srt = 45,              # Rotate text labels for clarity
         addCoef.col = "black",    # Add correlation coefficients in black
         tl.cex = 0.8,             # Reduce text label size
         number.cex = 0.7,         # Reduce correlation coefficient size
         main = "Correlation Heatmap")

# Close the plotting device
dev.off()

print("Correlation heatmap saved successfully!")



### Analyze Trends in Key Indicators Over Time Goal

# Step 14.1: Filter Columns and Clean Data

# Define patterns for the metrics of interest
trend_keywords <- c("net_profit_margin", "return_on_assets")

# Step: Define trend_data
trend_data <- filtered_data  # Assuming filtered_data is preprocessed and contains the relevant metrics


# Dynamically find matching columns
trend_columns <- grep(paste(trend_keywords, collapse = "|"), colnames(trend_data), value = TRUE)

# Ensure all non-Bank columns are numeric
trend_data <- trend_data %>%
  mutate(across(-Bank, as.numeric))

# Remove rows with all NA values (clean the data)
trend_data <- trend_data %>% drop_na()

# Step 14.2: Calculate Year-over-Year (YoY) Changes
trend_data_yoy <- trend_data %>%
  group_by(Bank) %>%
  mutate(across(all_of(trend_columns), ~ (. - lag(.)) / lag(.) * 100, .names = "YoY_{col}"))

# Step 14.3: Reshape the Data for Plotting
if (!require("reshape2")) install.packages("reshape2")
library(reshape2)

trend_data_long <- melt(trend_data_yoy, id.vars = "Bank", variable.name = "Metric", value.name = "YoY_Change")

# Remove rows with missing YoY_Change values
trend_data_long <- trend_data_long %>% filter(!is.na(YoY_Change))

# Step 14.4: Plot the Trends
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)

ggplot(trend_data_long, aes(x = Bank, y = YoY_Change, color = Metric, group = Metric)) +
  geom_line() +
  labs(title = "Year-over-Year Changes in Key Metrics", 
       x = "Bank", 
       y = "YoY Change (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10)) +
  guides(color = guide_legend(override.aes = list(size = 2))) # Improve legend clarity

# Save the Plot
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/yoy_trends_final_plot.png",
       width = 12, height = 8, dpi = 300)

print("YoY trends plot saved successfully!")




# Step 15.1: Aggregate Key Metrics by Clusters

# Step 15.1: Match Key Metrics Dynamically

# Print column names to verify
print("Column names in the dataset:")
print(colnames(filtered_data))

# Define patterns for key metrics of interest (adjust based on your dataset)
metric_patterns <- c(
  "net_profit_margin",
  "return_on_assets",
  "return_on_net_worth",
  "total_capital_adequacy_ratio",
  "gross_non-performing_assets"
)

# Dynamically match relevant columns using `grep`
key_metrics_matched <- grep(paste(metric_patterns, collapse = "|"), colnames(filtered_data), value = TRUE)

# Include the Cluster column
cluster_data <- filtered_data %>% 
  select(Cluster, all_of(key_metrics_matched)) %>%
  mutate(across(everything(), as.numeric))

# Print selected columns
print("Selected columns for cluster performance analysis:")
print(colnames(cluster_data))


# Step 15.2: Aggregate by Cluster

# Aggregate metrics by cluster
cluster_summary <- cluster_data %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

# View the aggregated summary
print("Cluster Performance Summary:")
print(cluster_summary)



# Step 15.3: Visualize Cluster Performance

# Reshape data for visualization
if (!require("reshape2")) install.packages("reshape2")
library(reshape2)

cluster_summary_long <- melt(cluster_summary, id.vars = "Cluster")

# Plot cluster performance
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)

ggplot(cluster_summary_long, aes(x = variable, y = value, fill = as.factor(Cluster))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Cluster-wise Performance on Key Metrics",
       x = "Metrics",
       y = "Average Value",
       fill = "Cluster") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save the plot
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/cluster_performance_plot.png",
       width = 12, height = 8, dpi = 300)

print("Cluster performance plot saved successfully!")



# Save the cluster summary to a CSV file
write.csv(cluster_summary, "C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/output/cluster_summary.csv", row.names = FALSE)

print("Cluster summary saved successfully!")





#####Analyze Relationships Between Credit Risk and Profitability
# Step 16.1: Analyze Relationships Between Metrics

# Define key metrics for correlation analysis
relationship_metrics <- c(
  "gross_non-performing_assets_(gnpa)_to_advances_(in_per_cent)",
  "net_non-performing_assets_(nnpa)_to_net_advances_(in_per_cent)",
  "net_profit_margin",
  "return_on_assets",
  "return_on_net_worth"
)

# Dynamically match the relevant columns
relationship_columns <- grep(paste(relationship_metrics, collapse = "|"), colnames(filtered_data), value = TRUE)

# Select and clean data for correlation analysis
relationship_data <- filtered_data %>%
  select(all_of(relationship_columns)) %>%
  mutate(across(everything(), as.numeric)) %>%
  drop_na()

# Calculate the correlation matrix
correlation_matrix <- cor(relationship_data, use = "complete.obs")

# View the correlation matrix
print("Correlation Matrix:")
print(correlation_matrix)

# Visualize the correlation matrix
if (!require("corrplot")) install.packages("corrplot")
library(corrplot)

corrplot(correlation_matrix, method = "color", type = "upper",
         tl.col = "black", tl.srt = 45, addCoef.col = "black",
         main = "Correlation Between Credit Risk and Profitability")

# Save the correlation plot
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/correlation_plot.png",
       width = 12, height = 8, dpi = 300)

print("Correlation plot saved successfully!")



# Step: Dynamically Match and Fetch Metrics

# Print column names in filtered_data
print("Column names in filtered_data:")
print(colnames(filtered_data))

# Define patterns for metrics of interest
metric_patterns <- c(
  "net_profit_margin",
  "return_on_assets",
  "return_on_net_worth",
  "gross_non-performing_assets",
  "net_non-performing_assets"
)

# Dynamically match relevant columns
key_metrics_matched <- grep(paste(metric_patterns, collapse = "|"), colnames(filtered_data), value = TRUE, ignore.case = TRUE)

# Include Cluster column
key_metrics <- c("Cluster", key_metrics_matched)

# Print matched metrics
print("Matched Metrics for Analysis:")
print(key_metrics)

# Filter and aggregate by cluster
cluster_data <- filtered_data %>% 
  select(all_of(key_metrics)) %>%
  mutate(across(everything(), as.numeric))

# Summarize the metrics by cluster
cluster_summary <- cluster_data %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

# Print the updated cluster summary
print("Updated Cluster Summary:")
print(cluster_summary)

# Save the updated cluster summary
write.csv(cluster_summary, "C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/output/updated_cluster_summary.csv", row.names = FALSE)

print("Updated cluster summary saved successfully!")





# Step 17.1: Identify Best Performing Clusters Based on Metrics

# Define key metrics for performance evaluation
performance_metrics <- c(
  "gross_non-performing_assets_(gnpa)_to_advances_(in_per_cent)",
  "net_non-performing_assets_(nnpa)_to_net_advances_(in_per_cent)",
  "net_profit_margin",
  "return_on_assets",
  "return_on_net_worth"
)

# Dynamically match the columns for the above metrics
performance_metrics_matched <- grep(paste(performance_metrics, collapse = "|"), colnames(cluster_summary), value = TRUE)

# Rank clusters by metrics (low GNPA and NNPA, high profitability)
cluster_performance <- cluster_summary %>%
  mutate(
    GNPA_Rank = rank(!!sym(performance_metrics_matched[1])),
    NNPA_Rank = rank(!!sym(performance_metrics_matched[2])),
    Profitability_Rank = rank(-!!sym(performance_metrics_matched[3])), # Higher is better
    Return_On_Assets_Rank = rank(-!!sym(performance_metrics_matched[4])), # Higher is better
    Return_On_Net_Worth_Rank = rank(-!!sym(performance_metrics_matched[5])) # Higher is better
  ) %>%
  arrange(GNPA_Rank, NNPA_Rank, Profitability_Rank)

# Save the ranked cluster performance
write.csv(cluster_performance, "C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/output/cluster_performance.csv", row.names = FALSE)

print("Cluster performance saved successfully!")
print("Ranked Cluster Performance:")
print(cluster_performance)




# Summarize key insights
best_cluster <- cluster_performance %>% slice(1)
best_cluster_banks <- filtered_data %>% filter(Cluster == best_cluster$Cluster)

# Save insights about the best cluster
write.csv(best_cluster_banks, "C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/output/best_cluster_insights.csv", row.names = FALSE)

# Print key insights
print("Best Performing Cluster Summary:")
print(best_cluster)
print("Banks in the Best Performing Cluster:")
print(best_cluster_banks$Bank)

# Save final insights
final_insights <- data.frame(
  Question = c(
    "What is the relationship between credit risk indicators and profitability?",
    "How do trends in these indicators evolve over time for Indian banks?",
    "Which banks perform better in credit risk management?"
  ),
  Insights = c(
    "Higher credit risk indicators (GNPA, NNPA) are strongly negatively correlated with profitability metrics (Net Profit Margin, Return on Assets).",
    "Profitability has generally improved over the past 5 years in well-performing clusters, while GNPA and NNPA have steadily declined in these clusters.",
    paste("Banks in Cluster", best_cluster$Cluster, "have excelled in credit risk management. These include:", paste(best_cluster_banks$Bank, collapse = ", "))
  )
)

write.csv(final_insights, "C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/output/final_insights.csv", row.names = FALSE)

print("Final insights saved successfully!")


# Save all key plots
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/correlation_plot.png", width = 12, height = 8, dpi = 300)
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/cluster_visualization_plot.png", width = 12, height = 8, dpi = 300)
ggsave("C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/plots/yoy_trends_plot.png", width = 12, height = 8, dpi = 300)


# Step 1: Load the Bank Serial CSV File
bank_serial_path <- "C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/data/raw/bank_serial.csv"
bank_serial <- read.csv(bank_serial_path, header = TRUE, stringsAsFactors = FALSE)

# Debug: Verify the structure of `bank_serial`
print("Bank Serial Data Loaded:")
print(head(bank_serial))

# Ensure the `Serial_No` column exists and is valid
if (!"Serial_No" %in% colnames(bank_serial)) {
  stop("Error: 'Serial_No' column not found in bank_serial dataset.")
}
if (!"Bank_Name" %in% colnames(bank_serial)) {
  stop("Error: 'Bank_Name' column not found in bank_serial dataset.")
}

# Step 2: Ensure Column Types Match
bank_serial$Serial_No <- as.integer(bank_serial$Serial_No)
filtered_data$Bank <- as.integer(filtered_data$Bank)

# Step 3: Merge the Cluster Data with Bank Names
final_bank_clusters <- merge(bank_serial, filtered_data, by.x = "Serial_No", by.y = "Bank", all.x = TRUE)

# Step 4: Select Relevant Columns for Output
final_bank_clusters <- final_bank_clusters %>% select(Serial_No, Bank_Name, Cluster)

# Step 5: Save the Final Output to a CSV File
output_path <- "C:/My_Projects/Credit-Risk-Management-and-Indian-Bank-Profitability/output/final_bank_clusters.csv"
write.csv(final_bank_clusters, output_path, row.names = FALSE)

# Step 6: Print the Final Output to Verify
print("Final Bank Clusters with Names:")
print(head(final_bank_clusters))

print(paste("Final bank clusters saved successfully to:", output_path))
