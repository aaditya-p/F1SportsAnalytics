-- Q1 Which teams have consistently scored points in most of the races?

SELECT
    team_name,
    AVG(points) as average_points
FROM (
    SELECT
        constructors.name as team_name,
        constructor_standings.points
    FROM constructor_standings
    JOIN constructors ON constructor_standings.constructorId = constructors.constructorId
    JOIN races ON constructor_standings.raceId = races.raceId
    WHERE races.year >= 2014
) as team_points
GROUP BY
    team_name
HAVING
    average_points > 0
ORDER BY
    average_points DESC
LIMIT 15;

-- ---------------------------------------------------------------------------------------------------------

-- Q2 Are there certain circuits where specific drivers tend to excel?
SELECT
    d.forename AS driver_first_name,
    d.surname AS driver_last_name,
    c.name AS circuit_name,
    AVG(rw.position) AS average_position
FROM
    drivers d
JOIN results rw ON d.driverId = rw.driverId
JOIN races r ON rw.raceId = r.raceId
JOIN circuits c ON r.circuitId = c.circuitId
WHERE d.driverId  IN (1,830,822,844,4,817,846,815,832,847,807,848,840,825,852,857,839,842,858,855)
GROUP BY d.driverId, c.circuitId
HAVING AVG(rw.position) <= 6
ORDER BY circuit_name, average_position;


-- -----------------------------------------------------------------------------------------------
-- Q3 Based on historical data and current form, which drivers should users consider for their fantasy teams?​

SELECT
    drivers.driverId,
    drivers.forename as first_name,
    drivers.surname as last_name,
    AVG(driver_standings.points) as average_points_in_a_season,
    COUNT(DISTINCT driver_standings.raceId) as races_participated,
    MAX(driver_standings.points) as max_points_in_a_season,
    AVG(results.positionOrder) as average_finishing_position
FROM
    drivers
JOIN driver_standings ON drivers.driverId = driver_standings.driverId
JOIN results ON driver_standings.raceId = results.raceId AND drivers.driverId = results.driverId
WHERE
    driver_standings.points IS NOT NULL
    AND results.positionOrder IS NOT NULL 
    AND drivers.driverId IN (1,830,822,844,4,817,846,815,832,847,807,848,840,825,852,857,839,842,858,855) -- this line filter all 20 drivers from current grid
GROUP BY
    drivers.driverId, drivers.forename, drivers.surname
ORDER BY
    average_points_in_a_season DESC, races_participated DESC, average_finishing_position ASC;
    
-- ------------------------------------------------------------------------------------------------------------

-- Q4 Who has the highest number of wins/podiums?

SELECT
    d.forename AS first_name,
    d.surname AS last_name,
    COUNT(CASE WHEN rw.position = 1 THEN 1 END) AS total_wins,
    COUNT(CASE WHEN rw.position <= 3 THEN 1 END) AS total_podiums
FROM drivers d, results rw, races
WHERE d.driverId = rw.driverId AND rw.raceId = races.raceId 
GROUP BY     d.driverId, d.forename, d.surname
ORDER BY     total_wins DESC;

-- ----------------------------------------------------------------------------

-- Q5 Which drivers have won chamionship in what years?​

SELECT
    winner_first_name,
    winner_last_name,
    championship_year,
    total_points
FROM (
    SELECT
        races.year AS championship_year,
        d.forename AS winner_first_name,
        d.surname AS winner_last_name,
        SUM(rw.points) AS total_points,
        RANK() OVER (PARTITION BY races.year ORDER BY SUM(rw.points) DESC) AS ranking
    FROM drivers d
    JOIN results rw ON d.driverId = rw.driverId
    JOIN races ON rw.raceId = races.raceId
    GROUP BY races.year, d.surname
) AS ranked
WHERE ranking = 1
ORDER BY championship_year DESC;
    
-- --------------------------------------------------------------------------------------------------

-- Q6 Which teams excelled in which era or year?


WITH TeamPoints AS (
    SELECT
        cs.constructorId,
        c.name AS constructorName,
        r.year,
        RANK() OVER (PARTITION BY r.year ORDER BY SUM(cs.points) DESC) AS position
    FROM
        constructor_standings cs
    JOIN races r ON cs.raceId = r.raceId
    JOIN constructors c ON cs.constructorId = c.constructorId
    GROUP BY
        cs.constructorId, constructorName, r.year
)

SELECT
    constructorId,
    constructorName,
    year AS championshipYear
FROM TeamPoints
WHERE position = 1
ORDER BY year DESC;