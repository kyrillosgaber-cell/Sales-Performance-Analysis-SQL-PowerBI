# Sales Performance Analysis | SQL & Power BI

## Project Overview

This project presents an end-to-end sales performance analysis using SQL and Microsoft Power BI.

The objective was to transform sales data into meaningful business insights by performing data quality checks, analyzing key performance indicators, preparing the data for reporting, building a dimensional data model, creating DAX measures, and developing an interactive Power BI dashboard.

The analysis focuses on revenue, profitability, sales trends, customer segments, products, customers, and geographic performance.

## Tools & Technologies

- **SQL Server / T-SQL** — Data quality checks, exploratory analysis, KPI calculations, trend analysis, customer and product analysis, and reporting views
- **Power Query** — Data preparation and creation of the date dimension
- **Power BI** — Data modeling, DAX measures, interactive dashboards, and business reporting
- **DAX** — Revenue, profit, profit margin, invoice, quantity, ranking, growth, previous-year, and YTD calculations

## Project Workflow

```text
Sales Database
      ↓
SQL Data Quality Checks
      ↓
SQL Analysis & KPI Calculation
      ↓
SQL Reporting Views
      ↓
Power Query / Data Preparation
      ↓
Dimensional Data Model
      ↓
DAX Measures
      ↓
Power BI Dashboard
      ↓
Business Insights & Recommendations
```

## Data Quality & SQL Analysis

Before building the dashboard, SQL was used to examine the quality and structure of the sales data.

The analysis included:

- Row-count and date-range validation
- NULL-value checks
- Invalid or unexpected value checks
- Duplicate detection
- Referential-integrity checks
- Loss-making transaction analysis
- Revenue, profit, quantity, invoice, and profit-margin KPIs
- Year-over-year revenue analysis using CTEs and `LAG()`
- Monthly sales analysis
- Jan–May year-over-year comparison
- Top products, customers, cities, and customer categories
- Revenue-share analysis
- Repeat-customer analysis
- Average Order Value analysis
- Product profitability analysis

SQL reporting views were also created to support the Power BI reporting layer, including:

- `vw_SalesDetail`
- `vw_MonthlySales`
- `vw_ProductPerformance`
- `vw_CustomerPerformance`

The SQL used in this project is available in the [`SQL`](./SQL/) folder.

## Power Query & Data Preparation

Power Query was used to prepare the reporting model and create a dedicated date dimension.

The `DimDate` query was dynamically generated using the minimum and maximum dates from the dataset and includes:

- Date
- Year
- Month Number
- Month Name
- Quarter

Data profiling was used during preparation to check column quality and validate the resulting date dimension.

## Data Model

The Power BI model follows a dimensional/star-schema approach with `FactSales` at the center of the model.

The main dimension tables are:

- `DimCustomer`
- `DimProduct`
- `DimDate`

Each dimension has a one-to-many relationship with `FactSales`.

![Data Model](Images/04_data_model.png)

## Key Metrics

The dashboard tracks several business KPIs, including:

- **Total Revenue:** €198.04M
- **Total Profit:** €85.73M
- **Overall Profit Margin:** 43.29%
- **Total Invoices:** approximately 71K
- **Total Quantity:** approximately 9M

Additional calculations include previous-year revenue, revenue growth, YTD revenue, customer ranking, product ranking, and profitability measures.

## Dashboard

### 1. Executive Overview

The Executive Overview provides a high-level view of overall business performance, including revenue, profit, profit margin, invoices, quantity, revenue and profit trends, top products, and top customers.

Interactive filters allow the report to be analyzed by year, customer category, and city.

![Executive Overview](Images/01_executive_overview.png)

### 2. Sales Performance Analysis

The second report page provides deeper analysis across customers, products, categories, years, and geographic markets.

It includes:

- Revenue by customer category
- Revenue by category and year
- Revenue by city
- Product revenue versus profitability analysis

![Sales Performance Analysis](Images/02_sales_performance_analysis.png)

## Key Business Insights

### Revenue Growth

Revenue increased from approximately **€52.56M in 2013 to €62.09M in 2015**.

Revenue growth was approximately:

- **+9.24% in 2014**
- **+8.14% in 2015**

### 2016 YTD Performance

Because the available 2016 data only extends through May, 2016 should not be compared with complete prior years.

A like-for-like comparison shows:

- **Jan–May 2015:** approximately €26.08M
- **Jan–May 2016:** approximately €25.97M

This represents a decline of only approximately **0.42%**, indicating relatively stable YTD performance rather than a major annual decline.

### Customer Category Concentration

**Novelty Shops account for approximately 71.5% of total revenue.**

This makes the segment the company's primary revenue driver, but it also indicates significant customer-category concentration.

### Product Performance

The **Air cushion machine (Blue)** is the leading product by revenue, generating approximately **€13M**.

### Customer Diversification

The largest individual customers generate relatively similar revenue levels compared with the much stronger concentration observed at customer-category level.

This suggests that customer concentration risk is more significant at the **segment/category level** than at the individual-customer level.

## Business Recommendations

Based on the analysis:

1. **Protect the Novelty Shop segment** because it represents the largest share of company revenue.

2. **Reduce category concentration risk** by developing revenue from Supermarkets, Gift Stores, Computer Stores, and Corporate customers.

3. **Prioritize products that combine strong revenue and strong profitability**, rather than evaluating products only by sales volume or revenue.

4. **Monitor 2016 performance using like-for-like YTD comparisons** instead of comparing five months of 2016 with full prior years.

5. **Investigate the drivers behind high-performing products and customer segments** and determine whether those characteristics can be replicated across lower-performing areas.

## Final Business Insights

![Key Business Insights](Images/03_key_insights_recommendations.png)

## Repository Structure

```text
Sales-Performance-Analysis-SQL-PowerBI/
│
├── SQL/
│   └── 01_Data_Quality_and_KPIs.sql
│
├── PowerBI/
│   └── Sales_Performance_Analysis.pbix
│
├── Images/
│   ├── 01_executive_overview.png
│   ├── 02_sales_performance_analysis.png
│   ├── 03_key_insights_recommendations.png
│   └── 04_data_model.png
│
└── README.md
```

## Project Summary

This project demonstrates an end-to-end data analytics workflow, starting with SQL-based data validation and analysis and progressing through data preparation, dimensional modeling, DAX calculations, dashboard development, and business-focused interpretation.

The final solution turns transactional sales data into an interactive reporting environment designed to support performance monitoring and commercial decision-making.