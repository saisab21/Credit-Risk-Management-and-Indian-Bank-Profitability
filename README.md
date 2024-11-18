# Credit Risk Management and Its Impact on Indian Bank Profitability

## Project Overview
This project explores the intricate relationship between credit risk management (CRM) and profitability in Indian banks. Leveraging a robust dataset spanning 15 years, we investigate key financial ratios and metrics to assess risk exposure, capital adequacy, profitability, and operational efficiency. The analysis provides actionable insights into how effective CRM practices contribute to the financial health of banks.

**This project is part of the Money, Banking, and Finance (MBFM) course at IISER Bhopal. For any queries, please contact:**  
- **Saisab Sadhu**: [saisab21@iiserb.ac.in](mailto:saisab21@iiserb.ac.in)  
- **Ashim Dhor**: [ashim21@iiserb.ac.in](mailto:ashim21@iiserb.ac.in)

## Objectives
- **Analyze the financial health and credit risk exposure of Indian banks.**
- **Calculate and interpret key financial ratios and metrics.**
- **Understand the impact of credit risk management on profitability.**
- **Identify patterns and trends through data-driven insights.**

## Data Sources
- **Financial Data**: Collected from *ProwessIQ*, a comprehensive database provided by the Centre for Monitoring Indian Economy (CMIE).  
- **Bank List**: Sourced from the official Reserve Bank of India (RBI) website.  
- The data includes financial statements such as balance sheets, profit and loss accounts, and key performance metrics over 15 years.

## Key Financial Ratios and Metrics
The analysis focuses on critical financial ratios categorized into risk, profitability, and operational metrics:

### Essential Ratios
1. **Gross Non-Performing Assets (GNPA) Ratio**: Indicates the proportion of gross loans classified as non-performing.
2. **Net Non-Performing Assets (NNPA) Ratio**: Reflects residual credit risk after accounting for provisions.
3. **Capital Adequacy Ratio (CAR)**: Measures the bank's ability to absorb losses relative to its risk-weighted assets.
4. **Net Interest Margin (NIM)**: Assesses the spread between interest income and expenses.
5. **Return on Assets (ROA)**: Gauges overall profitability relative to total assets.
6. **Return on Equity (ROE)**: Indicates profitability relative to shareholder equity.
7. **Credit-to-Deposit Ratio (CDR)**: Measures the proportion of deposits utilized for lending, reflecting liquidity and risk.

### Additional Metrics
1. **Loan Loss Reserve Ratio**: Indicates provisions relative to total loans.
2. **Provision Coverage Ratio (PCR)**: Demonstrates adequacy of provisions against NPAs.
3. **Debt-to-Equity Ratio**: Represents financial leverage.

## Analysis Approach
### Step 1: Data Collection
- Gather data on financial metrics for 33 banks from *ProwessIQ* and RBI.
- Preprocess and clean the data to ensure consistency and accuracy.

### Step 2: Ratio Calculations
- Use statistical and programming tools (R) to compute essential financial ratios.
- Employ clustering methods (K-Means) and dimensionality reduction (PCA) for comparative analysis.

### Step 3: Exploratory Data Analysis (EDA)
- Visualize trends using heatmaps, scree plots, and line graphs.
- Examine correlations between credit risk indicators and profitability metrics.

### Step 4: Insights and Recommendations
- Compare public and private sector banks on their CRM and profitability metrics.
- Identify patterns, trends, and outliers to recommend actionable strategies.

## Key Insights
- **Strong Negative Correlation**: High GNPA and NNPA ratios adversely impact profitability metrics like ROA and NIM.
- **Cluster Analysis**: Banks categorized into three performance tiers highlight disparities in CRM practices.
- **Actionable Recommendations**: Enhanced governance frameworks and technology integration for underperforming banks.

## Dependencies
This project uses the R programming language. The following R libraries are required:
- `tidyverse`: Data manipulation and analysis.
- `ggplot2`: Data visualization.
- `corrplot`: Heatmap visualizations.
- `reshape2`: Data reshaping for analysis.

Ensure these libraries are installed using the following command in R:
```R
install.packages(c("tidyverse", "ggplot2", "corrplot", "reshape2"))
```
## Repository Structure
The repository is organized as follows:

```plaintext
Credit-Risk-Management-and-Indian-Bank-Profitability/
├── data/
│   ├── raw/                # Raw datasets (e.g., `dataset_final.csv`)
│   └── processed/          # Processed datasets for analysis
├── plots/                  # Generated visualizations (e.g., heatmaps, PCA plots)
├── scripts/                # R scripts for data processing and analysis
│   ├── eda_analysis.R      # Exploratory Data Analysis
│   ├── ratio_calculations.R # Ratio calculations
│   └── clustering.R        # Clustering and visualization
├── output/
│   ├── insights.csv        # Extracted insights and findings
│   └── recommendations.txt # Summary recommendations
├── README.md               # Project overview and instructions
```

## How to Use This Repository
```bash
git clone https://github.com/saisab21/Credit-Risk-Management-and-Indian-Bank-Profitability
cd Credit-Risk-Management-and-Indian-Bank-Profitability

```

## Future Enhancements
- Automated Data Collection: Incorporate APIs for real-time data retrieval.
- Expanded Metrics: Add advanced financial ratios and risk metrics.
- Interactive Dashboards: Develop web-based dashboards for visualizing trends and recommendations.
