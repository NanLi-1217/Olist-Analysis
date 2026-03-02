# 📊 Olist E-Commerce Analytics Engineering & Power BI Dashboard

![SQL](https://img.shields.io/badge/SQL-SQLite-blue?style=flat)
![Analytics Engineering](https://img.shields.io/badge/Analytics_Engineering-Data%20Marts-success)
![Data Visualization](https://img.shields.io/badge/Data_Visualization-Power%20BI-orange?style=flat\&logo=powerbi)

## 📌 Executive Summary

This repository contains an end-to-end analytics project using the **Olist Brazilian e-commerce dataset**.
Rather than focusing only on visualization, this project demonstrates an **Analytics Engineering workflow**: SQL-based data profiling & validation → metric modeling via lightweight data marts → an interactive Power BI dashboard for monitoring revenue trends, category performance, and payment behaviors.

---

## 🎯 Business Objectives

* **Revenue Health Monitoring:** Track daily revenue trends, 7-day moving averages, and Average Order Value (AOV).
* **Category Strategy Optimization:** Compare “profit-driving” categories (high revenue) vs. “traffic-driving” categories (high delivered volume).
* **Payment Localization:** Analyze payment method preference patterns in the Brazilian market (e.g., credit card vs boleto).

---

## 🛠️ Data Architecture & Pipeline

To improve dashboard performance and ensure data reliability, raw tables were transformed into lightweight **data marts** using modular SQL scripts:

1. **`01_data_quality_checks.sql` (Data Profiling & QA)**

   * Validates row counts across core tables
   * Checks missingness in key fields (PK/FK, timestamps)
   * Detects duplicates
   * Validates join integrity (e.g., orphan payments/items)
     **Output:** `dq_summary`

2. **`02_kpi_daily_mart.sql` (Time-Series KPI Mart)**

   * Aggregates daily metrics using CTEs
   * Produces daily Orders, Customers, Revenue, and AOV
   * Handles null values and zero-division cases
     **Output:** `kpi_daily`

3. **`03_category_marts.sql` (Category-Level Marts)**

   * Builds category-level rollups for **payment value** and **delivered volume**
   * **Payment allocation logic:** since payments are recorded at the **order level** while categories are at the **item level**, order payments are allocated to items proportionally by item price within each order, then aggregated to category
     **Outputs:** `category_payment`, `category_delivered`

---

## 💡 Key Business Insights

### 1) Overall Revenue & Growth Trend

![Daily Trend](images/dashboard_trend.png)

* **Upward Momentum:** The 7-day moving average (7DMA) shows steady growth across the analyzed period, smoothing out strong day-to-day volatility.
* **Core Metrics:** The dashboard tracks total revenue, total orders, total customers, and AOV across the selected date range.

> Note: Currency and units follow the dataset’s original context. If needed, metrics can be labeled explicitly (e.g., BRL) for clarity.

### 2) Category Performance & Payment Preferences

![Category & Payment](images/dashboard_category_payment.png)

* **Profit Drivers vs. Traffic Drivers:** Some categories dominate **payment value** while others dominate **delivered volume**, indicating different roles in revenue vs. demand generation.
* **Payment Localization:** Credit card transactions dominate, while **boleto** represents a meaningful share, highlighting the importance of supporting local payment methods.

🔗 **Interactive Dashboard Link:** *(optional — add your Power BI published link here)*

---

## 📁 Repository Structure

```text
├── Olist_data/
│   ├── 01_data_quality_checks.sql
│   ├── 02_kpi_daily_mart.sql
│   └── 03_category_marts.sql
│
├── scripts/
│   ├── dq_summary.csv
│   ├── kpi_daily.csv
│   ├── category_delivered.csv
│   └── category_payment.csv
│
├── images/
│   ├── Daily Trend.png
│   └── Category Performence & Payments.png
│
└── README.md
```

---

## ▶️ How to Run (Reproducibility)

### Option A — Run SQL to build marts (recommended)

1. Open your SQLite database containing the raw Olist tables.
2. Run scripts in order:

   * `sql/01_data_quality_checks.sql`
   * `sql/02_kpi_daily_mart.sql`
   * `sql/03_category_marts.sql`
3. Export mart tables to CSV if desired:

   * `dq_summary`, `kpi_daily`, `category_payment`, `category_delivered`

### Option B — Use exported marts directly

If you only want to review results quickly, use the CSVs in `data_marts/` and connect Power BI to them.

---

## ✅ Definitions / Assumptions

* **Revenue:** Sum of `payments.payment_value` (aggregated at order level).
* **AOV:** `Revenue / Orders` (daily).
* **Category Payment Value:** Order-level payment allocated to items by `item_price / order_total_price`, then aggregated to category.
* **Delivered Count:** Item-level count within delivered orders (a proxy for delivered unit volume).

---

## 🚀 Future Improvements (Optional)

* Delivery performance: late delivery rate and delivery duration distribution (requires delivery timestamps).
* Review/score analysis (requires adding reviews table).
* Cohort analysis / repeat purchase behavior.
