ALTER PROCEDURE GenerateAgentCommissionReport
    @Year INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Cr�er une table temporaire pour stocker les r�sultats
    CREATE TABLE #AgentCommissionReport (
        AgentID INT,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        TotalCommission DECIMAL(18, 2)
    );

    -- Ins�rer les donn�es des commissions mensuelles dans la table temporaire
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

    -- S�lectionner les r�sultats pour les afficher
    SELECT * FROM #AgentCommissionReport;

    -- Supprimer la table temporaire
    DROP TABLE #AgentCommissionReport;

    SET NOCOUNT OFF;
END;
GO
 
 select SaleDate from Sales

-- Ex�cuter la proc�dure stock�e pour tester
EXEC GenerateAgentCommissionReport @Year = 2024, @Month = 4;
