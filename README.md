# Cold Chain Logistics Intelligence

## Project Overview

CRYONEX is a data analytics and business intelligence project focused on cold chain logistics operations. The project aims to monitor shipment performance, temperature compliance, product quality, transportation costs, and fleet efficiency through SQL-based data analysis and an interactive Power BI dashboard.

The project simulates a cold chain logistics environment handling temperature-sensitive products, including food and pharmaceutical shipments, helping stakeholders monitor operational performance, identify potential risks, and make data-driven decisions.

## Business Objectives

- Monitor shipment operations and delivery performance.
- Evaluate temperature compliance across shipments.
- Identify temperature violations and potential product quality risks.
- Analyze shipping costs across vehicles and logistics operations.
- Evaluate vehicle utilization and fleet performance.
- Provide actionable insights through an interactive dashboard.

## Tools & Technologies

- Microsoft SQL Server – Database creation, data management, SQL queries, and analytical views.
- SQL – Data analysis, aggregations, business logic, and view creation.
- Microsoft Power BI – Interactive dashboards, KPIs, and data visualization.
- DAX – Measures and calculated metrics.
- Data Modeling – Connecting analytical views and structuring data for reporting.

## Database Structure

The database includes the following tables:

- Customers
- Products
- Facilities
- Vehicles
- Shipments
- Temperature_Readings
- Shipment_Events

## SQL Analysis

SQL was used to prepare analytical views to support different business reporting requirements.

The project includes SQL scripts for:

- Table Creation
- Analytical View Creation
- Shipment Analysis
- Temperature Compliance Analysis
- Delivery Performance Analysis
- Product Analysis
- Vehicle and Fleet Analysis

## Power BI Dashboard

The Power BI report consists of five analytical pages:

### 1. Overview

Provides a high-level summary of logistics operations.

- Total Shipments
- Temperature Compliance
- On-Time Deliveries
- Shipments at Risk
- Shipment Trends
- Shipments by Product Category
- Facilities Performance
- Temperature Monitoring
- Shipments by Region
- Recent Shipments

### 2. Shipment Performance

Analyzes delivery efficiency and shipment execution.

- Total Shipments
- On-Time Delivery Rate
- Delayed Shipments
- Average Delivery Time
- Delivery Delay Rate
- Shipments by Status
- Monthly Delivery Performance
- Average Delay by Vehicle Type
- Shipping Cost by Vehicle Type
- Vehicle Cost and Delay Analysis

### 3. Temperature Monitoring

Focuses on temperature monitoring and compliance throughout the cold chain.

- Average Temperature
- Temperature Compliance Rate
- Total Temperature Readings
- Temperature Violations
- Average Temperature Deviation
- Temperature Trends
- Temperature Compliance Distribution
- Violations by Product
- Temperature Deviation by Category
- Temperature Exceptions Log

### 4. Product Quality & Risk

Analyzes product quality and temperature-related risks.

- Total Products
- Products at Risk
- Affected Shipments
- Product Quality Rate
- Total Quality Violations
- Product Condition Distribution
- Temperature Violations by Category
- Top 10 Products at Risk
- Quality Violations Trend
- Product Risk by Shelf Life
- Product Condition by Category

### 5. Logistics Cost & Fleet Analysis

Evaluates transportation costs and vehicle efficiency.

- Total Vehicles
- Total Shipments
- Total Shipping Cost
- Average Shipping Cost
- Fleet Utilization Rate
- Shipments by Vehicle Type
- Shipping Cost by Vehicle Type
- Vehicle Delivery Performance
- Vehicle Capacity vs Actual Weight
- Shipments by Refrigeration Type
- Vehicle Operational Status

## Key Business Insights

The dashboard is designed to help logistics managers:

- Identify shipments affected by temperature violations.
- Monitor delivery delays and cancellation patterns.
- Detect products and categories with higher temperature-related risks.
- Compare transportation costs across vehicle types.
- Evaluate fleet capacity utilization.
- Monitor operational performance across different logistics activities.

## Project Files

- `SQL/Tables.sql` – Database table creation scripts.
- `SQL/Views.sql` – Analytical SQL views.
- `PowerBI/` – Power BI dashboard file.
- `Screenshots/` – Dashboard screenshots.

## Disclaimer

This project uses a simulated dataset created for educational, analytical, and portfolio purposes. It does not represent actual company records or real-world logistics operations.

## Author

Mahmoud Amin |
Data Analyst | SQL | Power BI | Python

Tools: SQL Server, SQL, Power BI, DAX.
