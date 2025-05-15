USE HouseSalesDB;
GO

-- Si la procédure existe déjà, la supprimer
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

    -- Vérifier si la date de l'appointment est dans le passé
    IF @AppointmentDate < GETDATE()
    BEGIN
        RAISERROR('La date de la journée portes ouvertes ne peut pas être dans le passé.', 16, 1);
        RETURN;
    END

    -- Ajouter la nouvelle maison
    INSERT INTO Houses (HouseID, Address, City, State, ZipCode, Price, SquareFeet, Bedrooms, Bathrooms, ListingDate, Status)
    VALUES (@HouseID, @Address, @City, @State, @ZipCode, @Price, @SquareFeet, @Bedrooms, @Bathrooms, @ListingDate, @Status);

    -- Vérifier la disponibilité de la maison pour la journée portes ouvertes
    DECLARE @OpenHouseExists INT;
    SELECT @OpenHouseExists = COUNT(*)
    FROM Appointments
    WHERE HouseID = @HouseID AND AppointmentDate = @AppointmentDate;

    IF @OpenHouseExists > 0
    BEGIN
        RAISERROR('La maison avec ID %d n''est pas disponible à la date prévue pour la journée portes ouvertes.', 16, 1, @HouseID);
        RETURN;
    END

    -- Planifier la journée portes ouvertes
    INSERT INTO Appointments (AppointmentID, HouseID, CustomerID, AgentID, AppointmentDate, Notes)
    VALUES (@AppointmentID, @HouseID, @CustomerID, @AgentID, @AppointmentDate, @Notes);

    -- Afficher un message de succès
    PRINT 'La maison avec ID ' + CAST(@HouseID AS NVARCHAR) + ' a été ajoutée et une journée portes ouvertes a été planifiée pour la date ' + CONVERT(NVARCHAR(10), @AppointmentDate, 101) + '.';

    SET NOCOUNT OFF;
END;
GO

-- Exécuter la procédure stockée
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