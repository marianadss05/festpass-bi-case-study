-- =====================================================================
-- FestPass DB: Schema Creation Script (SQLite 3)
-- ---------------------------------------------------------------------
-- Re-runnable: drops existing tables in reverse dependency order.
-- Run with foreign key enforcement enabled (SQLite has it OFF by default).
-- =====================================================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS CashlessTransaction;
DROP TABLE IF EXISTS Wristband;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS CustomerOrder;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS TicketType;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Artist;
DROP TABLE IF EXISTS Stage;
DROP TABLE IF EXISTS Festival;

-- SECTION 1: EVENTS AND LINEUP
CREATE TABLE Festival (
    FestivalID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Edition VARCHAR(100),
    Location VARCHAR(255),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    CHECK (EndDate >= StartDate)
);

CREATE TABLE Stage (
    StageID INT PRIMARY KEY,
    FestivalID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    FOREIGN KEY (FestivalID) REFERENCES Festival(FestivalID)
);

CREATE TABLE Artist (
    ArtistID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Genre VARCHAR(100),
    Country VARCHAR(100)
);

CREATE TABLE Performance (
    PerformanceID INT PRIMARY KEY,
    StageID INT NOT NULL,
    ArtistID INT NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    CHECK (EndTime > StartTime),
    FOREIGN KEY (StageID) REFERENCES Stage(StageID),
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID)
);

-- SECTION 2: TICKETING AND PRICING
CREATE TABLE TicketType (
    TicketTypeID INT PRIMARY KEY,
    FestivalID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    TotalQuantity INT NOT NULL CHECK (TotalQuantity > 0),
    FOREIGN KEY (FestivalID) REFERENCES Festival(FestivalID)
);

-- SECTION 3: CUSTOMERS AND SALES
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    NIF VARCHAR(9) UNIQUE CHECK (NIF IS NULL OR LENGTH(NIF) = 9),  -- Portuguese tax ID
    BirthDate DATE
);

CREATE TABLE CustomerOrder (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),  -- amount charged at checkout (snapshot)
    PaymentMethod VARCHAR(50) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    TicketTypeID INT NOT NULL,
    Barcode VARCHAR(255) UNIQUE NOT NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'Valid'
        CHECK (Status IN ('Valid', 'Used', 'Cancelled')),
    FOREIGN KEY (OrderID) REFERENCES CustomerOrder(OrderID),
    FOREIGN KEY (TicketTypeID) REFERENCES TicketType(TicketTypeID)
);

-- SECTION 4: CASHLESS OPERATIONS
-- 1 Ticket : N Wristbands -> a lost wristband can be reissued without
-- deleting the transaction history linked to the original one.
CREATE TABLE Wristband (
    WristbandID INT PRIMARY KEY,
    TicketID INT NOT NULL,
    ActivationDate DATETIME,
    Balance DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (Balance >= 0),  -- current unspent credit
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID)
);

CREATE TABLE CashlessTransaction (
    TransactionID INT PRIMARY KEY,
    WristbandID INT NOT NULL,
    VendorName VARCHAR(255) NOT NULL,
    TransactionTime DATETIME NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    ItemDescription VARCHAR(255),
    FOREIGN KEY (WristbandID) REFERENCES Wristband(WristbandID)
);
