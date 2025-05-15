use HouseSalesDB
alter PROCEDURE GenerateYearlyAgentPerformanceReport
    @Year INT
AS
BEGIN
    -- Cr�er une table temporaire globale pour stocker les r�sultats
    CREATE TABLE ##Performance (
        AgentID INT,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        TotalSales INT,
        TotalSalesAmount DECIMAL(18, 2),
        TotalCommission DECIMAL(18, 2),
        AverageRating DECIMAL(18, 2)
    );

    -- Ins�rer les donn�es des performances annuelles dans la table temporaire
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

    -- S�lectionner les r�sultats pour les afficher
    SELECT * FROM ##Performance;

    -- Exporter les r�sultats vers un fichier CSV
    DECLARE @sql NVARCHAR(4000);
    DECLARE @chemin NVARCHAR(260); 
    DECLARE @servername NVARCHAR(128);

    -- Obtenir le nom du serveur
    SET @servername = @@SERVERNAME;

    -- D�finir le chemin du fichier de sortie
    SET @chemin = 'C:\Users\PC\OneDrive - Coll�ge la Cit�\Desktop\UA3\Performance.csv';



    -- D�finir la commande BCP
    SET @sql = 'bcp "SELECT * FROM tempdb..##Performance" queryout "' + @chemin + '" -c -t, -S ' + @servername + ' -T';

    -- Ex�cuter la commande SQL
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


-- D�sactiver les options avanc�es de configuration apres execution du procedure
EXEC sp_configure 'show advanced options', 0;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 0;
RECONFIGURE;