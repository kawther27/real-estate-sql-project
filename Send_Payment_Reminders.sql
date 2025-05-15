Create PROCEDURE SendPaymentReminders
AS
BEGIN
    DECLARE @SaleID INT,
            @CustomerID INT,
            @AmountDue DECIMAL(18, 2),
            @SaleDate DATE;

    -- Table temporaire pour stocker les rappels
    CREATE TABLE #PaymentReminders (
        SaleID INT,
        CustomerID INT,
        AmountDue DECIMAL(18, 2),
        SaleDate DATE,
        ReminderMessage NVARCHAR(255)
    );

    DECLARE payment_cursor CURSOR FOR
    SELECT SaleID, CustomerID, Commission, SaleDate
    FROM Sales
    WHERE SaleDate = CAST(GETDATE() AS DATE);

    OPEN payment_cursor;
    FETCH NEXT FROM payment_cursor INTO @SaleID, @CustomerID, @AmountDue, @SaleDate;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Insérer le message de rappel dans la table temporaire
        INSERT INTO #PaymentReminders
        VALUES (
            @SaleID,
            @CustomerID,
            @AmountDue,
            @SaleDate,
            'Reminder: Payment is due for SaleID ' + CONVERT(VARCHAR(10), @SaleID) +
            ', CustomerID ' + CONVERT(VARCHAR(10), @CustomerID) +
            ', Amount Due ' + CONVERT(VARCHAR(20), @AmountDue) +
            ', Sale Date ' + CONVERT(VARCHAR(10), @SaleDate, 101)
        );

        FETCH NEXT FROM payment_cursor INTO @SaleID, @CustomerID, @AmountDue, @SaleDate;
    END;

    CLOSE payment_cursor;
    DEALLOCATE payment_cursor;

    -- Sélectionner les rappels
    SELECT * FROM #PaymentReminders;

    -- Supprimer la table temporaire
    DROP TABLE #PaymentReminders;
END;

EXEC SendPaymentReminders;
