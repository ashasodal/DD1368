-- task 1

-- Måste jag använda CTE:s ? 
SELECT
    Country.Name,
    COUNT(Country.Code) as num
FROM Country
JOIN borders ON Country.Code IN (borders.Country1, borders.Country2)
GROUP BY Country.Code
ORDER BY RANK () OVER (ORDER BY COUNT(Country.Code));

-- task 2

SELECT * 
FROM 
    (SELECT 
        Spoken.Language,
        ROUND(SUM(Country.population * Spoken.Percentage / 100)) AS numberspeaker --Måste det se ut exakt som i expected? Avrundning och
    FROM Spoken
    JOIN Country ON Spoken.Country = Country.Code
    GROUP BY Spoken.Language)
WHERE numberspeaker >= 0
ORDER BY numberspeaker DESC;

-- task 3
SELECT * 
FROM 
    (SELECT 
        borders.Country1, 
        Country1.gdp AS gdp1, 
        borders.Country2, 
        Country2.gdp AS gdp2, 
        ROUND(GREATEST(Country1.gdp/Country2.gdp, Country2.gdp/Country1.gdp)) AS ratio

    FROM borders
    JOIN Economy Country1 ON Country1.Country = borders.Country1
    JOIN Economy Country2 ON Country2.Country = borders.Country2)
WHERE gdp1 IS NOT NULL AND gdp2 IS NOT NULL
ORDER BY ratio DESC;

-- p+ 1
WITH RECURSIVE recursion AS (
    SELECT 
        Country.code, 
        Country.Name, 
        path_length = 1
    FROM Country
    WHERE Country.code = 'SE'

    UNION 

    SELECT 
        Country.code, 
        Country.Name, 
        path_length = recursion.path_length + 1
    FROM Country
    JOIN borders ON Country.code IN (borders.Country1, borders.Country2)
    JOIN recursion ON recusion.code = Country.code
    WHERE path_length <=5
)

SELECT * FROM recursion;