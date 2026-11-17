# 01 - Database Design

## Overview
FestPass is a relational database for a company that runs music festivals. It covers the lineup and stages, online ticket sales and the payments made on site with cashless RFID wristbands.

## Entity-Relationship Diagram
![FestPass ERD](festpass-erd.png)

The diagram was created with [dbdiagram.io](https://dbdiagram.io).

## Tables
The model has 10 tables, grouped in 4 areas:

1. **Lineup and venue:** `Festival`, `Stage`, `Artist`, `Performance`
2. **Ticketing:** `TicketType`
3. **Sales and customers:** `Customer`, `CustomerOrder`, `Ticket`
4. **Cashless payments:** `Wristband`, `CashlessTransaction`

## Modelling decisions (3NF)
The model follows the 3rd Normal Form to avoid repeated data:

* **Customer data is stored only once.** `Customer` is separate from `CustomerOrder` and `Ticket`, so a customer who buys 4 tickets has their name, email and tax number (NIF) in a single row.
* **One order, several tickets.** Each order (`CustomerOrder`) can have N tickets (`Ticket`). Each ticket has its own barcode and status (`Valid`, `Used` or `Cancelled`).
* **One ticket, several wristbands (1:N).** If a wristband is lost, a new one can be issued for the same ticket, and the purchases made with the old one are not lost.
* **Ticket types are separate from tickets.** `TicketType` stores the price and available quantity for each festival, and `Ticket` only references it.

## Constraints
* Primary keys and foreign keys on every relationship. Foreign keys are `NOT NULL`, so there can't be a ticket without an order or a payment without a wristband.
* `UNIQUE` on the customer's email and NIF and on the ticket barcode.
* `CHECK` constraints: prices, amounts and balances can't be negative, the end date of a festival can't be before the start date, a performance must end after it starts, and a ticket status can only be `Valid`, `Used` or `Cancelled`.
* The script starts with `PRAGMA foreign_keys = ON` (SQLite doesn't check foreign keys by default) and with `DROP TABLE IF EXISTS`, so it can be run more than once.

## Limitations
Points I would change if the project grew:

* **Ticket price:** revenue uses the current price in `TicketType`. If a price changed, past revenue would change too. Storing the price paid in `Ticket` would solve this.
* **Order total:** `CustomerOrder.TotalAmount` is the amount paid at checkout and is not updated when a ticket is cancelled. A refunds table would make this clearer.
* **Replaced wristbands:** there is no column to mark a wristband as replaced, so an old wristband can't be told apart from an active one.
* **Credit top-ups:** only the current balance is stored, so the total credit loaded onto a wristband can't be calculated.
* **Vendors:** the vendor name is free text. A `Vendor` table would avoid spelling differences and allow vendor categories.

The full SQL code is in [schema.sql](schema.sql).
