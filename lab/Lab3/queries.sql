-- task 1

-- Vill jag bara ha den med minst (alltså 1 granne) eller ordna i minst till flest? 
-- Måste jag använda CTE:s ? 
SELECT * 
FROM 
    (SELECT
        Country.Name,
        COUNT(Country.Code) as num
    FROM Country
    JOIN borders ON Country.Code IN (borders.Country1, borders.Country2)
    GROUP BY Country.Code)
ORDER BY num; 

-- ALTERNATIV IFALL VI BARA VILL VISA MINST ANTAL

WITH temp AS 
    (SELECT
        Country.Name,
        COUNT(Country.Code) as num
    FROM Country
    JOIN borders ON Country.Code IN (borders.Country1, borders.Country2)
    GROUP BY Country.Code)

SELECT * 
FROM temp
WHERE (
    SELECT MIN(num)
    FROM temp
) = num
ORDER BY num; 


-- task 2

SELECT * 
FROM 
    (SELECT 
        Spoken.Language,
        ROUND(SUM(Country.population * Spoken.Percentage / 100)) AS numberspeaker 
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

-- p+ task 1
WITH RECURSIVE recursion AS (
    SELECT 
        Country.code, 
        Country.Name, 
        0 as path_length
    FROM Country
    WHERE Country.code = 'S'

    UNION
    
    SELECT 
        Country.code, 
        Country.Name, 
        recursion.path_length + 1 as path_length
    FROM recursion
    JOIN borders ON recursion.code IN (borders.Country1, borders.Country2)
    JOIN Country ON Country.code <> recursion.code AND Country.code IN (borders.Country1, borders.Country2)
    WHERE recursion.path_length <5
)

SELECT * 
FROM (
    SELECT DISTINCT ON (recursion.code)
    recursion.code, 
    recursion.Name, 
    recursion.path_length as min
    FROM recursion
    ORDER BY recursion.code, min)
WHERE min > 0
ORDER BY min;

-- p+ task 2
