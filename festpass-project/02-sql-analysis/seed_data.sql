PRAGMA foreign_keys = ON;

-- 1. FESTIVALS
INSERT INTO Festival (FestivalID, Name, Edition, Location, StartDate, EndDate) VALUES
(1, 'FestPass Summer', '2026 Edition', 'Parque da Cidade, Porto', '2026-07-16', '2026-07-18'),
(2, 'FestPass Beats', '2026 Edition', 'Parque Tejo, Lisboa', '2026-09-04', '2026-09-05'),
(3, 'FestPass Winter Indoor', '2027 Edition', 'Super Bock Arena, Porto', '2027-02-12', '2027-02-13');

-- 2. STAGES
INSERT INTO Stage (StageID, FestivalID, Name, Capacity) VALUES
(1, 1, 'Main Stage Atlantic', 25000),
(2, 1, 'Electronic Tent', 8000),
(3, 1, 'Emerging Talent Stage', 3000),
(4, 2, 'River Main Stage', 20000),
(5, 2, 'Clubbing Dome', 6000),
(6, 3, 'Main Indoor Arena', 8500);

-- 3. ARTISTS
INSERT INTO Artist (ArtistID, Name, Genre, Country) VALUES
(1, 'Arctic Echoes', 'Indie Rock', 'United Kingdom'),
(2, 'DJ Solis', 'Electronic', 'Portugal'),
(3, 'Kairo & The Waves', 'Pop', 'Brazil'),
(4, 'Midnight Pulse', 'Techno', 'Germany'),
(5, 'Lusitano Soul', 'Alternative', 'Portugal'),
(6, 'Velvet Skyline', 'Synth-Pop', 'United States'),
(7, 'Bairro Alto Collective', 'Hip-Hop', 'Portugal'),
(8, 'Neon Horizon', 'Electronic', 'Spain');

-- 4. PERFORMANCES
INSERT INTO Performance (PerformanceID, StageID, ArtistID, StartTime, EndTime) VALUES
(1, 1, 1, '2026-07-16 22:00:00', '2026-07-16 23:45:00'),
(2, 1, 3, '2026-07-17 21:30:00', '2026-07-17 23:00:00'),
(3, 2, 2, '2026-07-17 23:30:00', '2026-07-18 01:30:00'),
(4, 2, 4, '2026-07-18 01:45:00', '2026-07-18 03:30:00'),
(5, 3, 5, '2026-07-16 19:00:00', '2026-07-16 20:15:00'),
(6, 4, 6, '2026-09-04 22:30:00', '2026-09-05 00:00:00'),
(7, 4, 7, '2026-09-05 20:30:00', '2026-09-05 21:45:00'),
(8, 5, 2, '2026-09-05 23:00:00', '2026-09-06 01:00:00');

-- 5. TICKET TYPES
INSERT INTO TicketType (TicketTypeID, FestivalID, Name, Price, TotalQuantity) VALUES
(1, 1, '3-Day General Pass', 120.00, 15000),
(2, 1, '3-Day VIP Experience', 250.00, 2000),
(3, 1, 'Daily Ticket - Friday', 55.00, 5000),
(4, 2, '2-Day Weekend Pass', 95.00, 12000),
(5, 2, '2-Day VIP Weekend', 190.00, 1500),
(6, 3, 'Early Bird Indoor Pass', 75.00, 3000);

-- 6. CUSTOMERS
INSERT INTO Customer (CustomerID, FullName, Email, NIF, BirthDate) VALUES
(1, 'Ana Beatriz Silva', 'ana.silva@email.pt', '245891230', '1998-04-12'),
(2, 'Bruno Miguel Costa', 'bruno.costa@email.pt', '231904512', '1995-09-23'),
(3, 'Carla Sofia Mendes', 'carla.mendes@email.pt', '258741963', '2001-01-15'),
(4, 'Diogo Alexandre Ferreira', 'diogo.ferreira@email.pt', '219834765', '1992-11-30'),
(5, 'Elena Martins', 'elena.martins@email.pt', '267412890', '2000-06-08'),
(6, 'Filipe André Rocha', 'filipe.rocha@email.pt', '224567819', '1996-08-19'),
(7, 'Gabriela Sousa', 'gabriela.sousa@email.pt', '271903456', '2002-03-27'),
(8, 'Henrique Alves', 'henrique.alves@email.pt', '215678901', '1990-12-05'),
(9, 'Inês Carvalho', 'ines.carvalho@email.pt', '263451987', '1999-07-14'),
(10, 'João Pedro Oliveira', 'joao.oliveira@email.pt', '249012345', '1997-02-28'),
(11, 'Kátia Rodrigues', 'katia.rodrigues@email.pt', '255123987', '2003-05-19'),
(12, 'Luís Filipe Santos', 'luis.santos@email.pt', '218765432', '1994-10-02');

-- 7. CUSTOMER ORDERS
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, TotalAmount, PaymentMethod) VALUES
(1, 1, '2026-03-10 14:22:00', 240.00, 'MB WAY'),
(2, 2, '2026-03-22 19:05:00', 250.00, 'Credit Card'),
(3, 3, '2026-04-05 11:40:00', 110.00, 'MB WAY'),
(4, 4, '2026-04-18 16:15:00', 370.00, 'PayPal'),
(5, 1, '2026-05-02 21:10:00', 190.00, 'MB WAY'),
(6, 5, '2026-05-15 09:50:00', 190.00, 'Apple Pay'),
(7, 6, '2026-06-01 18:30:00', 360.00, 'Credit Card'),
(8, 7, '2026-06-14 13:45:00', 95.00, 'MB WAY'),
(9, 8, '2026-07-03 20:00:00', 380.00, 'Credit Card'),
(10, 2, '2026-07-10 10:15:00', 95.00, 'MB WAY');

-- 8. TICKETS
INSERT INTO Ticket (TicketID, OrderID, TicketTypeID, Barcode, Status) VALUES
(1, 1, 1, 'FP26-SUM-0001', 'Used'),
(2, 1, 1, 'FP26-SUM-0002', 'Used'),
(3, 2, 2, 'FP26-SUM-0003', 'Used'),
(4, 3, 3, 'FP26-SUM-0004', 'Used'),
(5, 3, 3, 'FP26-SUM-0005', 'Used'),
(6, 4, 1, 'FP26-SUM-0006', 'Used'),
(7, 4, 2, 'FP26-SUM-0007', 'Cancelled'),
(8, 5, 4, 'FP26-BEA-0008', 'Used'),
(9, 5, 4, 'FP26-BEA-0009', 'Used'),
(10, 6, 5, 'FP26-BEA-0010', 'Used'),
(11, 7, 1, 'FP26-SUM-0011', 'Used'),
(12, 7, 1, 'FP26-SUM-0012', 'Used'),
(13, 7, 1, 'FP26-SUM-0013', 'Valid'),
(14, 8, 4, 'FP26-BEA-0014', 'Valid'),
(15, 9, 5, 'FP26-BEA-0015', 'Used'),
(16, 9, 5, 'FP26-BEA-0016', 'Used'),
(17, 10, 4, 'FP26-BEA-0017', 'Used');

-- 9. WRISTBANDS
INSERT INTO Wristband (WristbandID, TicketID, ActivationDate, Balance) VALUES
(1, 1, '2026-07-16 16:10:00', 35.50),
(2, 2, '2026-07-16 16:12:00', 12.00),
(3, 3, '2026-07-16 17:00:00', 85.00),
(4, 4, '2026-07-17 18:05:00', 5.50),
(5, 6, '2026-07-16 15:45:00', 42.00),
(6, 8, '2026-09-04 17:30:00', 25.00),
(7, 10, '2026-09-04 18:00:00', 60.00),
(8, 11, '2026-07-16 16:40:00', 15.00),
(9, 15, '2026-09-04 19:15:00', 50.00);

-- 10. CASHLESS TRANSACTIONS
INSERT INTO CashlessTransaction (TransactionID, WristbandID, VendorName, TransactionTime, Amount, ItemDescription) VALUES
(1, 1, 'Main Bar North', '2026-07-16 19:30:00', 12.00, '2x Draft Beer 50cl'),
(2, 1, 'Porto Street Burgers', '2026-07-16 21:15:00', 14.50, 'Smash Burger Menu'),
(3, 1, 'Official Merch Store', '2026-07-17 18:40:00', 28.00, 'FestPass 2026 T-Shirt'),
(4, 2, 'Main Bar North', '2026-07-16 19:35:00', 8.00, '2x Cider'),
(5, 2, 'Pizza Artesanal', '2026-07-17 20:50:00', 11.00, 'Pepperoni Slice + Water'),
(6, 3, 'VIP Lounge Bar', '2026-07-16 20:10:00', 24.00, '2x Signature Cocktails'),
(7, 3, 'VIP Lounge Bar', '2026-07-17 22:00:00', 36.00, '3x Signature Cocktails'),
(8, 3, 'Official Merch Store', '2026-07-18 19:20:00', 55.00, 'Limited Edition Hoodie'),
(9, 4, 'Craft Beer Zone', '2026-07-17 20:00:00', 9.50, 'IPA Pint + Nachos'),
(10, 5, 'Porto Street Burgers', '2026-07-16 20:30:00', 16.00, 'Double Bacon Burger + Fries'),
(11, 5, 'Main Bar South', '2026-07-17 23:10:00', 18.00, '3x Draft Beer 50cl'),
(12, 6, 'River Bar Lisboa', '2026-09-04 20:15:00', 12.00, '2x Draft Beer 50cl'),
(13, 6, 'Tacos & Co', '2026-09-04 21:45:00', 13.00, '3x Beef Tacos'),
(14, 7, 'VIP Terrace Bar', '2026-09-04 21:00:00', 30.00, 'Bottle of Sparkling Wine'),
(15, 7, 'Official Merch Store', '2026-09-05 19:50:00', 25.00, 'Festival Tote Bag + Cap'),
(16, 8, 'Main Bar North', '2026-07-16 21:40:00', 15.00, '2x Gin Tonic');