
-- Create the database
CREATE DATABASE HouseSalesDB;
GO

USE HouseSalesDB;
GO

-- Agents Table
CREATE TABLE Agents (
    AgentID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);
GO

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);
GO

-- Houses Table
CREATE TABLE Houses (
    HouseID INT PRIMARY KEY,
    Address NVARCHAR(255),
    City NVARCHAR(100),
    State NVARCHAR(50),
    ZipCode NVARCHAR(10),
    Price DECIMAL(18, 2),
    SquareFeet INT,
    Bedrooms INT,
    Bathrooms INT,
    ListingDate DATE,
    Status NVARCHAR(50)
);
GO

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    HouseID INT FOREIGN KEY REFERENCES Houses(HouseID),
    AgentID INT FOREIGN KEY REFERENCES Agents(AgentID),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    SalePrice DECIMAL(18, 2),
    Commission DECIMAL(18, 2),
    SaleDate DATE
);
GO

-- Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    HouseID INT FOREIGN KEY REFERENCES Houses(HouseID),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    AgentID INT FOREIGN KEY REFERENCES Agents(AgentID),
    AppointmentDate DATE,
    Notes NVARCHAR(MAX)
);
GO

-- Reviews Table
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY,
    AgentID INT FOREIGN KEY REFERENCES Agents(AgentID),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    Rating DECIMAL(3, 2),
    Comment NVARCHAR(255)
);
GO
