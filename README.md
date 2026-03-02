# 🛒 Olist E-Commerce Analytics Pipeline & Dashboard

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue?style=flat&logo=postgresql)
![Data Quality](https://img.shields.io/badge/Data_Quality-Validated-success)
![BI](https://img.shields.io/badge/Data_Visualization-PowerBI%20%2F%20Tableau-orange)

## 📌 Project Overview
This project showcases an end-to-end data analytics workflow using the **Olist E-commerce dataset** (the largest department store in Brazilian marketplaces). It goes beyond simply plotting charts by demonstrating a complete data pipeline: from rigorous **Data Quality Checks (DQ)** and **ETL/ELT modeling** via SQL, to extracting actionable business insights through an interactive Business Intelligence (BI) dashboard.

## 🎯 Business Objectives
1. **Monitor Revenue Health:** Track daily sales trends, moving averages, and Average Order Value (AOV) throughout 2017.
2. **Optimize Category Strategy:** Identify which product categories drive the highest revenue versus the highest delivery volume.
3. **Understand Local Payment Behavior:** Analyze the distribution of payment methods specific to the Brazilian market.

---

## 🛠️ Data Architecture & Methodology

Instead of loading millions of raw rows directly into a BI tool, I adopted an Analytics Engineering approach. The heavy lifting is done via modular SQL scripts to create lightweight, optimized **Data Marts**:

1. **Data Profiling & Quality (`01_data_quality_checks.sql`):** - Validated table row counts, identified missing keys, checked for duplicate primary keys, and ensured join integrity (no orphan records between orders, items, and payments).
2. **Time-Series Modeling (`02_kpi_daily_mart.sql`):** - Built CTEs to calculate daily active customers, total revenue, and AOV, handling nulls and zero-division cases.
3. **Dimensional Aggregation (`03_category_marts.sql`):** - Apportioned payment values across different items within the same order using weighted price ratios, providing a highly accurate revenue-per-category view.

---

## 📊 Dashboards & Key Business Insights

### 1. Overall Revenue Trend (2016 - 2017)
*(Replace this text with your image: e.g., `![Daily Trend](images/dashboard_trend.png)`)*
> **Insight:** The business experienced robust, consistent growth in 2017. The 7-Day Moving Average (7DMA) of daily revenue grew from under $10K in early 2017 to consistently tracking between $20K and $30K by Q4, with an overall AOV stabilized at **$164.86**.

### 2. Category Performance & Payment Preferences
*(Replace this text with your image: e.g., `![Category & Payment](images/dashboard_category_payment.png)`)*
> **Insights:**
> * **The Profit vs. Traffic Drivers:** `health_beauty` is the absolute leader in revenue generation (>$1.5M), while `bed_bath_table` leads in actual units delivered (>10K items). This suggests a bifurcated strategy: use home goods to drive traffic and health/beauty to drive profit margins.
> * **Brazilian Market Localization:** While **Credit Cards** dominate (78.29%), **Boleto** (a popular cash-based payment method in Brazil) accounts for nearly **19%** of transactions. This highlights the absolute necessity of supporting local payment gateways for LATAM market penetration.

---

## 📁 Repository Structure

```text
├── sql/
│   ├── 01_data_quality_checks.sql    # Data profiling and integrity validation
│   ├── 02_kpi_daily_mart.sql         # Aggregation for daily trend analysis
│   └── 03_category_marts.sql         # Apportionment logic for category revenue
│
├── data/
│   ├── dq_summary.csv                # Output of the Data Quality check
│   ├── kpi_daily.csv                 # Cleaned daily metrics dataset
│   ├── category_delivered.csv        # Volume by category dataset
│   └── category_payment.csv          # Revenue by category dataset
│
├── images/
│   ├── dashboard_trend.png           # (Add your screenshot here)
│   └── dashboard_category.png        # (Add your screenshot here)
│
└── README.md
