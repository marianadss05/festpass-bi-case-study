# 02 — SQL Operational & Business Analysis (`FestPass`)

## 1. Objective & Business Context

This module implements the exploratory and operational SQL reporting layer for **FestPass**, a multi-event festival management platform. Using **SQLite**, the queries in this directory translate raw transactional records across 9 relational entities into actionable insights covering four core business areas:

1. **Venue & Lineup Operations:** Stage capacity planning and main stage scheduling across festival editions.
2. **Customer Acquisition & Retention:** Identifying high-value buyers and dormant registered users for targeted marketing.
3. **Ticketing & Payment Performance:** Net ticket revenue (excluding cancellations), payment gateway adoption, and ticket lifecycle tracking.
4. **On-Site Cashless Economy:** Top-performing vendors, attendee cashless spending, and unspent wristband balances (post-event refund liability).

---

## 2. Repository Structure & Execution Guide

```text
02-sql-analysis/
├── README.md               # Analytical documentation, business rules, and key findings
├── seed_data.sql           # Controlled synthetic dataset covering 3 festivals (2026–2027)
├── business_queries.sql    # 10 core operational & business SQL queries
└── kpis.sql                # [Upcoming] Executive KPIs using CTEs & Window Functions
```

### How to Reproduce Locally
1. Execute the DDL script (`../01-database-design/schema.sql`) in **DBeaver** or any SQLite 3 client with `PRAGMA foreign_keys = ON;`.
2. Populate the database by running `seed_data.sql`.
3. Execute `business_queries.sql` sequentially; each query is self-contained and preceded by its corresponding business question.

---

## 3. Analytical Assumptions & Data Integrity Rules

To ensure metric consistency across reporting layers, the following business rules are enforced in SQL:

* **Net Ticket Revenue (Query 5):** Tickets with `Status = 'Cancelled'` are explicitly excluded (`t.Status != 'Cancelled'`) so that refunded/voided orders do not inflate festival revenue.
* **Fan-Out Prevention in Cashless Balances (Query 9):** Because `Wristband.Balance` stores the current remaining balance per wristband, joining `CashlessTransaction` directly would duplicate wristband rows and overstate unspent balances. Aggregation stops at the `Wristband` grain.
* **Null Handling for Upcoming Events (Queries 9 & 10):** `LEFT JOIN` combined with `COALESCE()` is used so that future events with zero ticket sales or unactivated wristbands (*FestPass Winter Indoor 2027*) remain visible in operational reports rather than being silently dropped.
* **Entity Granularity in Grouping (Queries 2, 5, 8, 9, 10):** Primary keys (`CustomerID`, `FestivalID`, `TicketTypeID`) are included alongside descriptive names in `GROUP BY` clauses to prevent accidental aggregation of homonymous records.

---

## 4. Query Matrix & Key Business Insights (`business_queries.sql`)

| Query | Business Question | SQL Techniques | Key Analytical Finding |
| :--- | :--- | :--- | :--- |
| **Q1** | Total audience capacity per festival | `INNER JOIN`, `SUM`, `GROUP BY`, `ORDER BY` | **FestPass Summer** leads capacity with **36,000** spots across 3 stages, followed by **FestPass Beats** (**26,000**) and **FestPass Winter Indoor** (**8,500**). |
| **Q2** | Active buyers, order frequency, and total ticket spend | `INNER JOIN`, `COUNT`, `SUM`, multi-column `GROUP BY` | **Ana Beatriz Silva** (**430.00 €** across 2 orders) and **Henrique Alves** (**380.00 €**) rank as top ticket purchasers. |
| **Q3** | Registered customers with zero orders | `LEFT JOIN`, `WHERE ... IS NULL` | **4 out of 12 registered users** (33.3%) have never purchased a ticket, representing an immediate conversion opportunity for email remarketing. |
| **Q4** | Order volume, revenue, and AOV by payment method | `COUNT`, `SUM`, `AVG`, `ROUND` | **MB WAY** drives **50% of transaction volume** (5 orders; 730.00 €), while **Credit Card** leads total revenue (**990.00 €**) due to higher average order values (**330.00 €** vs. **146.00 €**). |
| **Q5** | Non-cancelled tickets sold and net ticket revenue per festival | 3-table `INNER JOIN`, `WHERE !=`, `COUNT`, `SUM` | **FestPass Summer** generated **1,090.00 €** from 9 active tickets (excluding 1 cancelled VIP pass), ahead of **FestPass Beats** (**950.00 €** from 7 tickets). |
| **Q6** | Cashless vendors exceeding 30.00 € in revenue | `GROUP BY`, `HAVING`, `SUM` | **Official Merch Store** (**108.00 €**) and **VIP Lounge Bar** (**60.00 €**) are the top revenue generators, followed by **Main Bar North** (**35.00 €**) and **Porto Street Burgers** (**30.50 €**). |
| **Q7** | Main stage performance schedule across all festivals | 4-table `INNER JOIN`, `LIKE '%Main%'`, chronological `ORDER BY` | 4 headline sets are scheduled across **Main Stage Atlantic** and **River Main Stage**; **Main Indoor Arena** has no performances scheduled yet. |
| **Q8** | Total on-site cashless spending per customer | 5-table `INNER JOIN` chain, `COUNT`, `SUM`, `ROUND` | **Bruno Miguel Costa** leads on-site consumption with **115.00 €** across 3 transactions, followed by **Ana Beatriz Silva** (**73.50 €**). |
| **Q9** | Activated wristbands and remaining unspent balance per festival | Multi-table `LEFT JOIN`, `COUNT`, `COALESCE`, `ROUND` | **210.00 €** remains unspent across 6 wristbands at **FestPass Summer** and **135.00 €** across 3 wristbands at **FestPass Beats** (345.00 € total refund liability). |
| **Q10** | Ticket status distribution by festival and ticket tier | `LEFT JOIN`, multi-column `GROUP BY`, `COALESCE` | Out of 17 issued tickets, **14 are `Used`**, **2 remain `Valid`** (pending entry), and **1 VIP pass was `Cancelled`**. |

---

## 5. Dataset Limitations & Next Steps

* **Synthetic Scale:** The current dataset (`seed_data.sql`) is a controlled sample designed to validate relational edge cases (cancelled tickets, unactivated wristbands, future festivals without lineups) prior to scaling.
* **Next Phase (`kpis.sql`):** Upcoming work extends this analysis with **Common Table Expressions (CTEs)**, **Subqueries**, and **Window Functions** (`RANK()`, `SUM() OVER()`) to compute combined event revenue, ticket sell-through rates, and vendor revenue share.