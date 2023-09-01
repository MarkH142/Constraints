-- Make the following constraints from these relations:

-- Movies (title, year, length, genre, studioName, producerC)
-- Starsln (movieTitle, movieYear, starName)
-- MovieStar (name, address, gender, birthdate)
-- MovieExec (name, address, cert#, netWorth)
-- Studio (name, address, presC)
DROP DATABASE moviesdatabase;
CREATE DATABASE moviesdatabase;
USE moviesdatabase;
CREATE TABLE MovieExec (name CHAR(30), address VARCHAR(255), cert INT PRIMARY KEY, netWorth INT);
CREATE TABLE Movies (title CHAR(100), year INT, length INT, genre CHAR(10), studioName CHAR(30),
 producerC INT, FOREIGN KEY (producerC) REFERENCES MovieExec(cert), PRIMARY KEY (title, year));
CREATE TABLE MovieStar (name CHAR(30) PRIMARY KEY, address VARCHAR(255), gender CHAR(1), birthdate DATE);
CREATE TABLE StarsIn (movieTitle CHAR(100), movieYear INT, starName CHAR(30), PRIMARY KEY (movieTitle, movieYear, starName));
CREATE TABLE Studio (name CHAR(30) PRIMARY KEY, address VARCHAR(255), presC INT);

-- #1 Write the SQL to declare these constraints when creating the table:
#Normal creation of the tables
#CREATE TABLE MovieExec (name CHAR(30), address VARCHAR(255), cert INT PRIMARY KEY, netWorth INT);
#CREATE TABLE Movies (title CHAR(100), year INT, length INT, genre CHAR(10), studioName CHAR(30), producerC INT, PRIMARY KEY (title, year));
#CREATE TABLE MovieStar (name CHAR(30) PRIMARY KEY, address VARCHAR(255), gender CHAR(1), birthdate DATE);
#CREATE TABLE StarsIn (movieTitle CHAR(100), movieYear INT, starName CHAR(30), PRIMARY KEY (movieTitle, movieYear, starName));
#CREATE TABLE Studio (name CHAR(30) PRIMARY KEY, address VARCHAR(255), presC INT);
-- a) The producer of a movie must be someone mentioned in MovieExec. Modifications to MovieExec that violate this constraint are rejected.
DROP TABLE Movies;
CREATE TABLE Movies (
    title CHAR(100),
    year INT,
    length INT,
    genre CHAR(10),
    studioName CHAR(30),
    producerC INT,
    FOREIGN KEY (producerC)
        REFERENCES MovieExec (cert),
    PRIMARY KEY (title , year)
);
-- b) Repeat (a), but violations result in the producerC in Movie being set to NULL.
DROP TABLE Movies;
CREATE TABLE Movies (
    title CHAR(100),
    year INT,
    length INT,
    genre CHAR(10),
    studioName CHAR(30),
    producerC INT NOT NULL,
    FOREIGN KEY (producerC)
        REFERENCES MovieExec (cert),
    PRIMARY KEY (title , year)
);
-- c) Repeat (a), but violations result in the deletion or update of the offending Movie tuple.
DROP TABLE Movies;
CREATE TABLE Movies (
    title CHAR(100),
    year INT,
    length INT,
    genre CHAR(10),
    studioName CHAR(30),
    producerC INT,
    CONSTRAINT FOREIGN KEY (producerC)
        REFERENCES MovieExec (cert) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (title , year)
);
-- d) A movie that appears in Starsln must also appear in Movie. Handle violations by rejecting the modification.
DROP TABLE StarsIn;
CREATE TABLE StarsIn (
    movieTitle CHAR(100),
    movieYear INT,
    starName CHAR(30),
    CONSTRAINT FOREIGN KEY (movieTitle)
		REFERENCES Movies(title) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (movieTitle , movieYear , starName)
);
-- e) A star appearing in Starsln must also appear in MovieStar. Handle violations by deleting violating tuple.
DROP TABLE StarsIn;
CREATE TABLE StarsIn (
    movieTitle CHAR(100),
    movieYear INT,
    starName CHAR(30),
    CONSTRAINT FOREIGN KEY (starname) REFERENCES MovieStar(name)
		ON DELETE CASCADE,
    PRIMARY KEY (movieTitle , movieYear , starName)
);


-- #2 Write the SQL to ADD these constraints after the table was already created:

-- a) Require that no movie length be less than 60 nor greater than 250.
ALTER TABLE Movies ADD CONSTRAINT MovieLength CHECK (length > 60 AND length < 250);

-- #3 Write the SQL to declare these constraints when creating this table
-- Movies (title, year, length, genre, studioName, producerC)

-- a) The year cannot be before 1915.
DROP TABLE Movies;
CREATE TABLE Movies (
    title CHAR(100),
    year INT CONSTRAINT MovieDate CHECK (year > 1915),
    length INT,
    genre CHAR(10),
    studioName CHAR(30),
    producerC INT,
    PRIMARY KEY (title , year)
);
-- b) The length cannot be less than 60 nor more than 250.
CREATE TABLE Movies (
    title CHAR(100),
    year INT,
    length INT CONSTRAINT MovieLength CHECK (length > 60 AND length < 250),
    genre CHAR(10),
    studioName CHAR(30),
    producerC INT,
    PRIMARY KEY (title , year)
);
-- c) The studio name can only be Disney, Fox, MGM, or Paramount.

CREATE TABLE Movies (
    title CHAR(100),
    year INT,
    length INT,
    genre CHAR(10),
    studioName CHAR(30) CONSTRAINT StudioNameLst CHECK (studioName in ('Disney', 'Fox', 'MGM', 'Paramount')),
    producerC INT,
    PRIMARY KEY (title , year)
);
-- Make the following constraints from these relations:

-- Product (maker, model, type)
-- PC (model, speed, ram, hd, price)
-- Laptop (model, speed, ram, hd, screen, price)
-- Printer (model, color, type, price)

CREATE DATABASE computers;
USE computers;
#CREATE TABLE Product (maker CHAR(30), model INT, type CHAR(7));
#CREATE TABLE PC (model INT, speed FLOAT, ram INT, hd INT, price DECIMAL(5, 2));
#CREATE TABLE Laptop (model INT, speed INT, ram INT, hd INT, screen INT, price DECIMAL(5, 2));
#CREATE TABLE Printer (model INT, color BOOLEAN, type CHAR(30), price DECIMAL(5, 2));
-- #4 Write the SQL to declare these constraints when creating the table:

-- a) The speed of a laptop must be at least 2.0.
CREATE TABLE Laptop (
    model INT,
    speed INT CONSTRAINT speedMin CHECK (speed >= 2.0),
    ram INT,
    hd INT,
    screen INT,
    price DECIMAL(5 , 2 )
);
-- b) The only types of printers are laser, ink-jet, and bubble-jet.
CREATE TABLE Printer (
    model INT,
    color BOOLEAN,
    type CHAR(30) CONSTRAINT allowedTypes CHECK (type in ('laser', 'inkjet', 'bubblejet')),#used the spelling I had in my database
    price DECIMAL(5 , 2 )
);
-- c) The only types of products are PC’s, laptops, and printers.
CREATE TABLE Product (
    maker CHAR(30),
    model INT,
    type CHAR(7) CONSTRAINT pTypes CHECK (type in ('PC', 'Laptop', 'Printer'))#used the spelling I had in my database
);

-- Make the following constraints from these relations:

-- Classes (class, type, country, numGuns, bore, displacement)
-- Ships (name, class, launched)
-- Battles (name, date)
-- Outcomes (ship, battle, result)

CREATE DATABASE ships;
USE ships;
CREATE TABLE Classes (class CHAR(30), type CHAR(2), country CHAR(30), numGuns INT, bore INT, displacenent INT);
CREATE TABLE Ships (name CHAR(30), class CHAR(30),launched INT);
CREATE TABLE Battles (name CHAR(30), date DATE DEFAULT '0000-99-00');
CREATE TABLE Outcomes (ship CHAR(30), battle CHAR(30), result CHAR(7));
-- #5 Write the SQL to ADD these constraints after the table was already created:

-- a) Require that no ship has more than 14 guns.
ALTER TABLE Classes ADD CONSTRAINT MaxGuns CHECK (numGuns <= 14);