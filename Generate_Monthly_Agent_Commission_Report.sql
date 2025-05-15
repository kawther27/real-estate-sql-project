ALTER PROCEDURE GenerateAgentCommissionReport
    @Year INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Créer une table temporaire pour stocker les résultats
    CREATE TABLE #AgentCommissionReport (
        AgentID INT,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        TotalCommission DECIMAL(18, 2)
    );

    -- Insérer les données des commissions mensuelles dans la table temporaire
    INSERT INTO #AgentCommissionReport
    SELECT 
        a.AgentID,
        a.FirstName,
        a.LastName,
        SUM(s.Commission) AS TotalCommission
    FROM 
        Agents a
        JOIN Sales s ON a.AgentID = s.AgentID
    WHERE 
        YEAR(s.SaleDate) = @Year
        AND MONTH(s.SaleDate) = @Month
    GROUP BY 
        a.AgentID, a.FirstName, a.LastName;

    -- Sélectionner les résultats pour les afficher
    SELECT * FROM #AgentCommissionReport;

    -- Supprimer la table temporaire
    DROP TABLE #AgentCommissionReport;

    SET NOCOUNT OFF;
END;
GO
 
 select SaleDate from Sales

-- Exécuter la procédure stockée pour tester
EXEC GenerateAgentCommissionReport @Year = 2024, @Month = 4;
