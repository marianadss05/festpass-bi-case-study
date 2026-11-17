# FestPass: BI Case Study

## Business problem
FestPass organises several music festivals per year. Tickets are sold online and, at the venue, attendees pay for food, drinks and merchandise with RFID wristbands loaded with credit.

The data is spread across different areas (lineup, ticketing, customers and cashless payments), which makes it hard to answer questions such as:

- How much does each festival earn from tickets and from on-site spending?
- Who are the customers and vendors that generate the most revenue?
- How much unspent credit has to be refunded after each festival?
- Which registered users never bought a ticket?

This project answers these questions step by step, the same way a BI team would.

## Structure

| Folder | Content |
| :--- | :--- |
| [01-database-design](01-database-design/) | ERD, SQL schema and the reasoning behind the model |
| [02-sql-analysis](02-sql-analysis/) | Sample data, 10 business queries and the main findings |

## Approach
- Cancelled tickets are excluded from revenue, and the difference between gross and net revenue is explained.
- Queries are written so that rows are not duplicated by joins and festivals without sales still appear in the results.
- The dataset is small on purpose, so that special cases (cancellations, no-shows, wristbands with no purchases, a future festival) can be checked by hand.
- Assumptions and limitations are written down in each folder.

## Main findings (sample data)
- 2,030.00 € in ticket revenue from the two festivals that already took place. The order total is 250.00 € higher because of one cancelled VIP ticket.
- 330.00 € of credit was left on wristbands and has to be refunded.
- 1 in 3 registered customers never bought a ticket.
- 2 of the 17 tickets sold were never used (no-shows).

## Next steps
- [x] Relational model, ERD and schema
- [x] Business queries in SQL
- [ ] KPIs with CTEs and window functions
- [ ] Power BI dashboard
- [ ] Larger dataset generated with Python and exploratory analysis

## Tools
SQLite, DBeaver, dbdiagram.io, Git/GitHub
