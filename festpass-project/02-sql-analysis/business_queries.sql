-- 1. What is the total audience capacity of each festival?
SELECT
	f.Name,
	SUM(s.Capacity) AS TotalCapacity
FROM
	Festival f
INNER JOIN Stage s ON
	f.FestivalID = s.FestivalID
GROUP BY
	f.Name
ORDER BY
	TotalCapacity DESC;

-- 2. Which customers have made purchases, how many orders did each place, and what is their total spend (ordered from highest to lowest)?
SELECT
	c.FullName,
	c.CustomerID,
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

-- 7. List all scheduled performances at the main stages across all festivals, showing the festival name, artist name, performance date, start time, and end time (ordered chronologically).
SELECT 
	f.Name AS FestivalName,
	s.Name AS StageName,
	a.Name AS ArtistName,
	p.startTime,
	p.endTime
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
	COUNT(w.WristbandID) AS TotalActivatedWristbands,
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
	f.Name as FestivalName,
	tt.TicketTypeID,
	tt.Name as TicketTypeName,
	COALESCE(t.Status, 'No Tickets Sold') AS TicketStatus,
	COUNT(t.TicketID) AS TicketCount
FROM
	Festival f 
LEFT JOIN TicketType tt ON 
	f.FestivalID = tt.FestivalID 
LEFT JOIN Ticket t ON
	tt.TicketTypeID = t.TicketTypeID 
GROUP BY 
	t.Status,
	f.FestivalID,
	f.Name,
	tt.TicketTypeID,
	tt.Name
ORDER BY 
	f.Name,
	tt.Name,
	TicketCount DESC;