-- =====================================================================
-- FestPass: Operational & Business Queries (SQLite 3)
-- ---------------------------------------------------------------------
-- Prerequisites: ../01-database-design/schema.sql + seed_data.sql
-- Each query is self-contained and preceded by the business question.
-- =====================================================================

-- 1. What is the total audience capacity of each festival?
SELECT
	f.FestivalID,
	f.Name AS FestivalName,
	COUNT(s.StageID) AS NumberOfStages,
	SUM(s.Capacity) AS TotalCapacity
FROM
	Festival f
INNER JOIN Stage s ON
	f.FestivalID = s.FestivalID
GROUP BY
	f.FestivalID,
	f.Name
ORDER BY
	TotalCapacity DESC;

-- 2. Which customers have made purchases, how many orders did each place, and what is their total spend (ordered from highest to lowest)?
--    Note: based on CustomerOrder.TotalAmount (gross amount charged at checkout, before cancellations).
SELECT
	c.CustomerID,
	c.FullName,
	COUNT(co.OrderID) AS CustomerOrders,
	SUM(co.TotalAmount) AS CustomerTotalSpend
FROM
	Customer c
INNER JOIN CustomerOrder co ON
	c.CustomerID = co.CustomerID
GROUP BY
	c.CustomerID,
	c.FullName
ORDER BY
	CustomerTotalSpend DESC;

-- 3. Which registered customers have never placed an order (show their CustomerID, FullName, and Email)?
SELECT 
	c.CustomerID,
	c.FullName,
	c.Email
FROM
	Customer c 
LEFT JOIN CustomerOrder co ON
	c.CustomerID = co.CustomerID 
WHERE
	co.OrderID IS NULL;

-- 4. What is the total number of orders, total revenue, and average order value for each payment method, ordered from highest to lowest revenue?
--    Note: gross order value (cancelled tickets are not deducted here; see Q5 for net ticket revenue).
SELECT 
	PaymentMethod,
	COUNT(OrderID) AS NumberOfOrders,
	SUM(TotalAmount) AS TotalRevenue,
	ROUND(AVG(TotalAmount),2) AS AvgOrderValue
FROM
	CustomerOrder
GROUP BY
	PaymentMethod 
ORDER BY 
	TotalRevenue DESC;

-- 5. How many non-cancelled tickets were sold and what is the total ticket revenue for each festival, ordered from highest to lowest revenue?
--    Note: revenue is valued at the ticket type's list price (TicketType.Price).
SELECT 
	f.FestivalID,
	f.Name,
	COUNT(t.TicketID) AS SoldTickets,
	SUM(tt.Price) AS TotalTicketRevenue
FROM
	Festival f
INNER JOIN TicketType tt ON 
	f.FestivalID = tt.FestivalID  
INNER JOIN Ticket t ON
	tt.TicketTypeID = t.TicketTypeID 
WHERE 
	t.Status != 'Cancelled'
GROUP BY 
	f.FestivalID,
	f.Name
ORDER BY
	TotalTicketRevenue DESC;

-- 6. Which cashless vendors generated more than 30 euros in total revenue (show the vendor name, number of transactions, and total revenue, ordered from highest to lowest)?
SELECT 
	VendorName,
	COUNT(TransactionID) AS TotalTransactions,
	SUM(Amount) AS VendorsTotalRevenue
FROM
	CashlessTransaction
GROUP BY 
	VendorName 
HAVING
	SUM(Amount) > 30
ORDER BY 
	VendorsTotalRevenue DESC;

-- 7. List all scheduled performances at the main stages across all festivals, showing the festival name, stage name, artist name, start time and end time (ordered chronologically).
--    Assumption: main stages are identified by the word 'Main' in the stage name (no explicit stage-type attribute in the model).
SELECT 
	f.Name AS FestivalName,
	s.Name AS StageName,
	a.Name AS ArtistName,
	p.StartTime,
	p.EndTime
FROM 
	Festival f 
INNER JOIN Stage s ON 
	f.FestivalID = s.FestivalID 
INNER JOIN Performance p ON 
	s.StageID = p.StageID 
INNER JOIN Artist a ON 
	p.ArtistID = a.ArtistID 
WHERE 
	s.Name LIKE '%Main%'
ORDER BY
	p.StartTime;
	
-- 8. Calculate the total cashless spending per customer (for customers who made at least one cashless purchase): show CustomerID, FullName, total number of cashless transactions, and total cashless amount spent (rounded to 2 decimal places), ordered from highest to lowest total spent.
SELECT 
	c.CustomerID,
	c.FullName,
	COUNT(ct.TransactionID) AS TotalTransactions,
	ROUND(SUM(ct.Amount), 2) AS TotalAmountCashless
FROM
	Customer c
INNER JOIN CustomerOrder co ON 
	c.CustomerID = co.CustomerID 
INNER JOIN Ticket t ON 
	co.OrderID = t.OrderID 
INNER JOIN Wristband w ON 
	t.TicketID = w.TicketID 
INNER JOIN CashlessTransaction ct ON
	w.WristbandID = ct.WristbandID 
GROUP BY 
	c.CustomerID,
	c.FullName
ORDER BY
	TotalAmountCashless DESC;

-- 9. How many wristbands were activated and what is the total remaining unspent balance for each festival (including festivals with zero activated wristbands), ordered from highest to lowest remaining balance?
SELECT 
	f.FestivalID,
	f.Name AS FestivalName,
	COUNT(w.ActivationDate) AS TotalActivatedWristbands,  -- counts only wristbands with an activation date
	COALESCE(ROUND(SUM(w.Balance), 2), 0) AS RemainingBalance
FROM
	Festival f
LEFT JOIN TicketType tt ON
	f.FestivalID = tt.FestivalID
LEFT JOIN Ticket t ON 
	tt.TicketTypeID = t.TicketTypeID 
LEFT JOIN Wristband w ON 
	t.TicketID = w.TicketID 
GROUP BY 
	f.FestivalID,
	f.Name 
ORDER BY 
	RemainingBalance DESC;

-- 10. Breakdown of ticket statuses by festival and ticket type: show the festival name, ticket type name, ticket status, and total number of tickets, ordered by festival name, ticket type name, and ticket count descending.
SELECT 
	f.FestivalID,
	f.Name AS FestivalName,
	tt.TicketTypeID,
	tt.Name AS TicketTypeName,
	COALESCE(t.Status, 'No Tickets Sold') AS TicketStatus,
	COUNT(t.TicketID) AS TicketCount
FROM
	Festival f 
LEFT JOIN TicketType tt ON 
	f.FestivalID = tt.FestivalID 
LEFT JOIN Ticket t ON
	tt.TicketTypeID = t.TicketTypeID 
GROUP BY 
	f.FestivalID,
	f.Name,
	tt.TicketTypeID,
	tt.Name,
	t.Status
ORDER BY 
	f.Name,
	tt.Name,
	TicketCount DESC;
