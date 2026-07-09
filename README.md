# 🛒 Zepto Inventory Analysis using PostgreSQL

## 📌 Project Overview

This project demonstrates how SQL can be used to analyze an e-commerce inventory dataset. Using PostgreSQL, I explored product pricing, discounts, stock availability, and inventory distribution to generate business insights similar to those required in a Data Analyst role.

The objective was to work with a raw inventory dataset, clean the data, perform exploratory analysis, and answer business questions using SQL.

---

## 🎯 Objectives

* Design an inventory database in PostgreSQL
* Import and clean raw CSV data
* Perform exploratory data analysis (EDA)
* Analyze pricing, discounts, and inventory
* Generate business insights using SQL
* Practice SQL concepts used in real Data Analyst interviews

---

## 📂 Dataset

The dataset contains inventory information for products listed on Zepto's platform.

Each record represents a single product SKU and includes details such as product category, pricing, available stock, product weight, discounts, and stock status.

### Dataset Columns

| Column                 | Description                        |
| ---------------------- | ---------------------------------- |
| sku_id                 | Unique identifier for each product |
| category               | Product category                   |
| name                   | Product name                       |
| mrp                    | Maximum Retail Price               |
| discountPercent        | Discount percentage                |
| discountedSellingPrice | Selling price after discount       |
| availableQuantity      | Current inventory available        |
| weightInGms            | Product weight                     |
| outOfStock             | Stock availability status          |
| quantity               | Quantity per package               |

---

## 🛠 Tech Stack

* PostgreSQL
* pgAdmin 4
* SQL
* CSV Dataset
* Git
* GitHub

---

## ⚙️ Project Workflow

### 1. Database Setup

* Created the inventory table
* Defined appropriate data types
* Added a primary key

### 2. Data Import

* Imported the CSV into PostgreSQL
* Resolved encoding and formatting issues
* Validated successful data loading

### 3. Data Cleaning

Performed multiple quality checks including:

* Removing invalid price records
* Checking NULL values
* Validating discount calculations
* Standardizing price values
* Reviewing duplicate products

### 4. Exploratory Data Analysis

Explored the dataset to understand:

* Total products
* Product categories
* Inventory distribution
* Stock availability
* Duplicate product listings
* Discount patterns

---

# 📊 Business Analysis

The project answers multiple business questions, including:

* Top discounted products
* Categories with the highest average discounts
* Products currently out of stock
* Estimated revenue by category
* Inventory weight across categories
* Price per gram comparison
* High-value products with low discounts
* Product segmentation by weight
* Revenue loss from unavailable products
* Most common package sizes
* Pricing inconsistencies
* Category-wise revenue ranking
* Stock availability analysis
* Inventory optimization opportunities

Overall, more than **20 SQL queries** were written to extract meaningful business insights.

---

## 📈 SQL Concepts Used

* SELECT
* WHERE
* ORDER BY
* GROUP BY
* HAVING
* Aggregate Functions
* CASE WHEN
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions
* Ranking Functions
* Mathematical Functions
* String Functions

---

## 📚 Key Learnings

Working on this project helped strengthen my understanding of:

* Data cleaning using SQL
* Exploratory Data Analysis
* Business-oriented SQL queries
* Inventory and pricing analysis
* Writing optimized SQL queries
* Translating raw data into business insights

---

## 🚀 Project Outcome

This project simulates a practical Data Analyst workflow, beginning with raw inventory data and ending with business insights that support pricing, inventory management, and stock planning.

It also demonstrates proficiency in PostgreSQL, SQL querying, data cleaning, and analytical thinking, making it a valuable portfolio project for Data Analyst interviews.

---

## 👨‍💻 Author

**Aman Virkhare**

* Aspiring Data Analyst
* Skilled in SQL, PostgreSQL, Excel, Power BI, and Python
* Passionate about solving business problems using data
