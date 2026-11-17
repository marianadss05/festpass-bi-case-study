# 02 - SQL Analysis

## 1. Objective
This folder contains the SQL analysis of the FestPass database (SQLite). The queries answer business questions in four areas:

1. **Venue and lineup:** stage capacity and main stage schedule.
2. **Customers:** who buys the most and who never bought anything.
3. **Ticketing and payments:** net ticket revenue (without cancellations), payment methods and ticket status.
4. **Cashless payments:** best vendors, spending per customer and credit left on the wristbands.

The analysis is done as of November 2026: *FestPass Summer* (July 2026) and *FestPass Beats* (September 2026) have already happened, and *FestPass Winter Indoor* (February 2027) has no sales yet.

---

## 2. Files and how to run them

```text
02-sql-analysis/
├── README.md               # Rules, assumptions and results
├── seed_data.sql           # Sample data (3 festivals, 2026 and 2027)
└── business_queries.sql    # 10 business queries
```

1. Create an empty SQLite database in DBeaver.
2. Run `../01-database-design/schema.sql`.
3. Run `seed_data.sql`.
4. Run the queries in `business_queries.sql`. Each query has the business question written above it.

The `.db` file is not in the repository because it can be created again from the scripts.

---

## 3. Rules and assumptions

* **Gross vs. net revenue:** Q2 and Q4 use `CustomerOrder.TotalAmount`, the amount paid at checkout (gross). Q5 calculates net ticket revenue and excludes tickets with `Status = 'Cancelled'`. The difference between them is the cancelled VIP ticket: 2,280.00 € - 250.00 € = 2,030.00 €.
* **Ticket price:** ticket revenue uses the price in `TicketType.Price`.
* **Avoiding duplicated rows (Q9):** `Wristband.Balance` already has the credit left on each wristband. If `CashlessTransaction` were joined in the same query, each wristband would appear once per purchase and the balance would be counted several times.
* **Festivals without sales (Q9, Q10):** `LEFT JOIN` and `COALESCE()` keep *FestPass Winter Indoor* in the results with zeros instead of removing it.
* **Grouping by ID:** the queries group by the primary key (`FestivalID`, `CustomerID`, `TicketTypeID`) and not only by the name, so two records with the same name are never merged.
* **Main stages (Q7):** there is no column for the stage type, so main stages are found by the word *Main* in the stage name.

---

## 4. Queries and results (`business_queries.sql`)

| Query | Business question | SQL used | Result |
| :--- | :--- | :--- | :--- |
| **Q1** | Total capacity per festival | `INNER JOIN`, `COUNT`, `SUM`, `GROUP BY` | FestPass Summer has the highest capacity, 36,000 people across 3 stages, followed by FestPass Beats (26,000) and FestPass Winter Indoor (8,500). |
| **Q2** | Customers who bought, number of orders and total spent | `INNER JOIN`, `COUNT`, `SUM` | Ana Beatriz Silva (430.00 €, 2 orders) and Henrique Alves (380.00 €) spent the most. Diogo Ferreira's 370.00 € includes a 250.00 € VIP ticket that was cancelled later, so the real value is lower. |
| **Q3** | Registered customers who never ordered | `LEFT JOIN`, `IS NULL` | 4 of the 12 registered customers (33.3%) never bought a ticket. They could be targeted by an email campaign. |
| **Q4** | Orders, revenue and average order value by payment method | `COUNT`, `SUM`, `AVG`, `ROUND` | MB WAY has half of the orders (5 of 10, 730.00 €), but Credit Card brings more revenue (990.00 €) because the average order is higher (330.00 € vs. 146.00 €). |
| **Q5** | Tickets sold (not cancelled) and ticket revenue per festival | 3-table `INNER JOIN`, `WHERE`, `COUNT`, `SUM` | FestPass Summer made 1,080.00 € from 9 tickets (1 cancelled VIP ticket excluded) and FestPass Beats made 950.00 € from 7 tickets. |
| **Q6** | Vendors with more than 30.00 € in sales | `GROUP BY`, `HAVING` | Official Merch Store (108.00 €) and VIP Lounge Bar (60.00 €) sold the most, followed by Main Bar North (35.00 €) and Porto Street Burgers (30.50 €). |
| **Q7** | Main stage schedule | 4-table `INNER JOIN`, `LIKE`, `ORDER BY` | There are 4 concerts on Main Stage Atlantic and River Main Stage. Main Indoor Arena has no concerts scheduled yet. |
| **Q8** | Cashless spending per customer | 5-table `INNER JOIN`, `COUNT`, `SUM` | Bruno Miguel Costa spent the most on site (115.00 €, 3 purchases), followed by Ana Beatriz Silva (98.50 €, 7 purchases with 3 wristbands at 2 festivals). |
| **Q9** | Activated wristbands and credit left per festival | `LEFT JOIN`, `COUNT`, `COALESCE` | 195.00 € was left on 6 wristbands at FestPass Summer and 135.00 € on 3 wristbands at FestPass Beats, so 330.00 € has to be refunded. |
| **Q10** | Ticket status by festival and ticket type | `LEFT JOIN`, `GROUP BY`, `COALESCE` | Of the 17 tickets, 14 were used, 1 VIP ticket was cancelled and 2 are still `Valid`. Since both festivals are over, these 2 tickets are no-shows. |

---

## 5. Limitations and next steps

* The data in `seed_data.sql` is synthetic and small on purpose, to test special cases (cancelled tickets, no-shows, wristbands without purchases, a festival without sales or lineup). The results show how the analysis works, but they are not statistically meaningful.
* Next step: create KPIs in a `kpis.sql` file using CTEs and window functions, for example total revenue per festival (tickets + cashless) and each vendor's share of sales.
