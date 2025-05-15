USE HouseSalesDB;
GO

-- Si la proc�dure existe d�j�, la supprimer
IF OBJECT_ID('AddHouseAndScheduleOpenHouse', 'P') IS NOT NULL
    DROP PROCEDURE AddHouseAndScheduleOpenHouse;
GO

CREATE PROCEDURE AddHouseAndScheduleOpenHouse
    @HouseID INT,
    @Address NVARCHAR(255),
    @City NVARCHAR(100),
    @State NVARCHAR(50),
    @ZipCode NVARCHAR(10),
    @Price DECIMAL(18, 2),
    @SquareFeet INT,
    @Bedrooms INT,
    @Bathrooms INT,
    @ListingDate DATE,
    @Status NVARCHAR(50),
    @CustomerID INT,
    @AgentID INT,
    @AppointmentID INT,
    @AppointmentDate DATE,
    @Notes NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- V�rifier si la date de l'appointment est dans le pass�
    IF @AppointmentDate < GETDATE()
    BEGIN
        RAISERROR('La date de la journ�e portes ouvertes ne peut pas �tre dans le pass�.', 16, 1);
        RETURN;
    END

    -- Ajouter la nouvelle maison
    INSERT INTO Houses (HouseID, Address, City, State, ZipCode, Price, SquareFeet, Bedrooms, Bathrooms, ListingDate, Status)
    VALUES (@HouseID, @Address, @City, @State, @ZipCode, @Price, @SquareFeet, @Bedrooms, @Bathrooms, @ListingDate, @Status);

    -- V�rifier la disponibilit� de la maison pour la journ�e portes ouvertes
    DECLARE @OpenHouseExists INT;
    SELECT @OpenHouseExists = COUNT(*)
    FROM Appointments
    WHERE HouseID = @HouseID AND AppointmentDate = @AppointmentDate;

    IF @OpenHouseExists > 0
    BEGIN
        RAISERROR('La maison avec ID %d n''est pas disponible � la date pr�vue pour la journ�e portes ouvertes.', 16, 1, @HouseID);
        RETURN;
    END

    -- Planifier la journ�e portes ouvertes
    INSERT INTO Appointments (AppointmentID, HouseID, CustomerID, AgentID, AppointmentDate, Notes)
    VALUES (@AppointmentID, @HouseID, @CustomerID, @AgentID, @AppointmentDate, @Notes);

    -- Afficher un message de succ�s
    PRINT 'La maison avec ID ' + CAST(@HouseID AS NVARCHAR) + ' a �t� ajout�e et une journ�e portes ouvertes a �t� planifi�e pour la date ' + CONVERT(NVARCHAR(10), @AppointmentDate, 101) + '.';

    SET NOCOUNT OFF;
END;
GO

-- Ex�cuter la proc�dure stock�e
EXEC AddHouseAndScheduleOpenHouse
    @HouseID = 120,
    @Address = '789 Pine St',
    @City = 'Testtown',
    @State = 'TX',
    @ZipCode = '54321',
    @Price = 350000.00,
    @SquareFeet = 2000,
    @Bedrooms = 4,
    @Bathrooms = 3,
    @ListingDate = '2024-08-01',
    @Status = 'Sold',
    @CustomerID = 3,
    @AgentID = 3,
    @AppointmentID = 165,
    @AppointmentDate = '2024-10-02',
    @Notes = 'Open house event for a new listing';
select * from Appointments