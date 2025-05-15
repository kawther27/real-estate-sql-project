use HouseSalesDB
alter PROCEDURE GenerateYearlyAgentPerformanceReport
    @Year INT
AS
BEGIN
    -- Créer une table temporaire globale pour stocker les résultats
    CREATE TABLE ##Performance (
        AgentID INT,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        TotalSales INT,
        TotalSalesAmount DECIMAL(18, 2),
        TotalCommission DECIMAL(18, 2),
        AverageRating DECIMAL(18, 2)
    );

    -- Insérer les données des performances annuelles dans la table temporaire
    INSERT INTO ##Performance
    SELECT 
        a.AgentID,
        a.FirstName,
        a.LastName,
        COUNT(s.SaleID) AS TotalSales,
        SUM(s.SalePrice) AS TotalSalesAmount,
        SUM(s.Commission) AS TotalCommission,
        AVG(r.Rating) AS AverageRating
    FROM 
        Agents a
        LEFT JOIN Sales s ON a.AgentID = s.AgentID
        LEFT JOIN Reviews r ON a.AgentID = r.AgentID
    WHERE 
        YEAR(s.SaleDate) = @Year
    GROUP BY 
        a.AgentID, a.FirstName, a.LastName
    ORDER BY 
        TotalSales DESC;

    -- Sélectionner les résultats pour les afficher
    SELECT * FROM ##Performance;

    -- Exporter les résultats vers un fichier CSV
    DECLARE @sql NVARCHAR(4000);
    DECLARE @chemin NVARCHAR(260); 
    DECLARE @servername NVARCHAR(128);

    -- Obtenir le nom du serveur
    SET @servername = @@SERVERNAME;

    -- Définir le chemin du fichier de sortie
    SET @chemin = 'C:\Users\PC\OneDrive - Collège la Cité\Desktop\UA3\Performance.csv';



    -- Définir la commande BCP
    SET @sql = 'bcp "SELECT * FROM tempdb..##Performance" queryout "' + @chemin + '" -c -t, -S ' + @servername + ' -T';

    -- Exécuter la commande SQL
    EXEC xp_cmdshell @sql;

    -- Supprimer la table temporaire
    DROP TABLE ##Performance;
END;
 
EXEC GenerateYearlyAgentPerformanceReport @Year = 2024;



-- Activer xp_cmdshell avant la creation du procedure 
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;


-- Désactiver les options avancées de configuration apres execution du procedure
EXEC sp_configure 'show advanced options', 0;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 0;
RECONFIGURE;