USE HouseSalesDB;
GO

-- Si le d�clencheur existe d�j�, le supprimer
IF OBJECT_ID('trg_PreventHouseDeletion', 'TR') IS NOT NULL
    DROP TRIGGER trg_PreventHouseDeletion;
GO

CREATE TRIGGER trg_PreventHouseDeletion
ON dbo.Houses
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @HouseID INT;

    -- D�claration du curseur pour r�cup�rer les IDs des maisons � supprimer
    DECLARE house_cursor CURSOR FOR
    SELECT HouseID FROM DELETED;

    OPEN house_cursor;

    FETCH NEXT FROM house_cursor INTO @HouseID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- V�rifier s'il y a des rendez-vous pour cette maison
        IF EXISTS (SELECT 1 FROM Appointments WHERE HouseID = @HouseID)
        BEGIN
            RAISERROR('La maison avec ID %d ne peut pas �tre supprim�e car elle a des rendez-vous en cours.', 16, 1, @HouseID);
            CLOSE house_cursor;
            DEALLOCATE house_cursor;
            RETURN;
        END

        -- V�rifier s'il y a des ventes pour cette maison
        IF EXISTS (SELECT 1 FROM Sales WHERE HouseID = @HouseID)
        BEGIN
            RAISERROR('La maison avec ID %d ne peut pas �tre supprim�e car elle a des ventes en cours.', 16, 1, @HouseID);
            CLOSE house_cursor;
            DEALLOCATE house_cursor;
            RETURN;
        END

        FETCH NEXT FROM house_cursor INTO @HouseID;
    END


    CLOSE house_cursor;
    DEALLOCATE house_cursor;

    -- Si aucune contrainte n'est viol�e, proc�der � la suppression
    DELETE FROM dbo.Houses
    WHERE HouseID IN (SELECT HouseID FROM DELETED);

    SET NOCOUNT OFF;
END;
GO

--les maison qu'on peut pas les supprimer
SELECT DISTINCT h.HouseID, h.Address, h.City, h.State, h.ZipCode
FROM Houses h
LEFT JOIN Sales s ON h.HouseID = s.HouseID
LEFT JOIN Appointments a ON h.HouseID = a.HouseID
WHERE s.SaleID IS NOT NULL OR a.AppointmentID IS NOT NULL;

delete  from Houses where  HouseID=4
 --les maisons qu'on peut les supprimer
SELECT h.HouseID, h.Address, h.City, h.State, h.ZipCode
FROM Houses h
LEFT JOIN Sales s ON h.HouseID = s.HouseID
LEFT JOIN Appointments a ON h.HouseID = a.HouseID
WHERE s.SaleID IS NULL AND a.AppointmentID�IS�NULL;

