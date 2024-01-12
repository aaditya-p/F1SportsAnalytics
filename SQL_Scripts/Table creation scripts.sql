CREATE OR REPLACE TABLE constructors (
	constructorId int PRIMARY KEY NOT NULL,
    constructorRef varchar(127),
    name varchar(127),
	nationality varchar(127)
);

-- select count(*) from circuits;

CREATE OR REPLACE TABLE drivers (
	driverId int PRIMARY KEY NOT NULL,
    driverRef varchar(127),
    number int,
    code varchar(10),
    forename varchar(127),
    surname varchar(127),
    dob DATE,
    nationality varchar(127)
);
-- TRUNCATE TABLE constructors;

CREATE OR REPLACE TABLE circuits (
	circuitid int PRIMARY KEY NOT NULL,
    circuitRef varchar(255),
    name varchar(255),
    location varchar(127),
    country varchar(127)
    );

-- ON DELETE CASCADE not implemented since races are tied with circuits which in turn are tied to the results
CREATE OR REPLACE TABLE races(
	raceId int PRIMARY KEY NOT NULL,
    year int,
    round int,
    circuitId int,
    name varchar(255),
    date DATE,
    time varchar(100),
    FOREIGN KEY (circuitId) REFERENCES circuits(circuitId) ON UPDATE CASCADE ON DELETE CASCADE
    );
    
-- select count(*) from races;
-- ON DELETE CASCADE not implemented since qualifying is tied with races, driverId which in turn are tied to the results
 CREATE OR REPLACE TABLE qualifying(
	qualifyId int PRIMARY KEY NOT NULL,
    raceId int,
    driverId int,
    constructorId int,
    number int,
    position int,
    q1 varchar(20),
    q2 varchar(20),
    q3 varchar(20),
    FOREIGN KEY (raceId) REFERENCES races(raceId),
    FOREIGN KEY (driverId) REFERENCES drivers(driverId),
    FOREIGN KEY (constructorId) REFERENCES constructors(constructorId)
    );

-- select count(*) from qualifying;

CREATE OR REPLACE TABLE status(
	statusId int PRIMARY KEY NOT NULL,
    status varchar(100)
    );

-- select count(*) from status;

-- ON DELETE CASCADE not implemented since results is tied with races, driverId 
CREATE OR REPLACE TABLE results(
	resultId int PRIMARY KEY NOT NULL,
    raceId int,
    driverId int,
    constructorId int,
    number int,
    grid int,
    position int,
    positionText varchar(20),
    positionOrder int,
    points int,
    statusId int,
    FOREIGN KEY (raceId) REFERENCES races(raceId),
    FOREIGN KEY (driverId) REFERENCES drivers(driverId),
    FOREIGN KEY (constructorId) REFERENCES constructors(constructorId),
    FOREIGN KEY (statusId) REFERENCES status(statusId)
    );

select count(*) from results;

CREATE OR REPLACE TABLE constructor_standings(
	constructorStandingsId int PRIMARY KEY NOT NULL,
    raceId int,
    constructorId int,
    points int,
    position int,
    positionText varchar(20),
    wins int,
    FOREIGN KEY (raceId) REFERENCES races(raceId) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (constructorId) REFERENCES constructors(constructorId) ON UPDATE CASCADE ON DELETE CASCADE
    ); 

-- select count(*) from constructor_standings;

CREATE OR REPLACE TABLE driver_standings(
	driverStandingsId int PRIMARY KEY NOT NULL,
    raceId int,
    driverId int,
    points int,
    position int,
    positionText varchar(20),
    wins int,
    FOREIGN KEY (raceId) REFERENCES races(raceId) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (driverId) REFERENCES drivers(driverId) ON UPDATE CASCADE ON DELETE CASCADE
    ); 
    
-- select count(*) from driver_standings;
















 










