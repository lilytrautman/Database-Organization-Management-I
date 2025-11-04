-- Step 1 --
DROP TABLE IF EXISTS vg_release;
DROP TABLE IF EXISTS vg_game;
DROP TABLE IF EXISTS vg_publisher;
DROP TABLE IF EXISTS vg_platform;
DROP TABLE IF EXISTS vg_genre;

-- Step 2 --
CREATE TABLE vg_genre (
	genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(20)
);

CREATE TABLE vg_game (
	game_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_id INT,
    game_name VARCHAR(150),
	CONSTRAINT vg_genre_id_fk FOREIGN KEY (genre_id) REFERENCES vg_genre(genre_id)
);

CREATE TABLE vg_publisher (
	publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(50)
);

CREATE TABLE vg_platform (
	platform_id INT AUTO_INCREMENT PRIMARY KEY,
    platform_name VARCHAR(10)
);

CREATE TABLE vg_release (
	release_id INT AUTO_INCREMENT PRIMARY KEY,
	game_id INT,
    publisher_id INT,
    platform_id INT,
    year INT,
    NA_Sales DECIMAL(5, 2),
    EU_Sales DECIMAL(5, 2),
    JP_Sales DECIMAL(5, 2),
    Other_Sales DECIMAL(5, 2),
    CONSTRAINT vg_game_id_fk FOREIGN KEY (game_id) REFERENCES vg_game(game_id),
    CONSTRAINT vg_publisher_id_fk FOREIGN KEY (publisher_id) REFERENCES vg_publisher(publisher_id),
    CONSTRAINT vg_platform_id_fk FOREIGN KEY (platform_id) REFERENCES vg_platform(platform_id)
);

-- Step 3 --
-- Inserting unique genres into vg_genre table --
INSERT INTO vg_genre(genre_name)
SELECT DISTINCT genre
FROM vg_csv;

-- Inserting unique game names into vg_game table --
INSERT INTO vg_game(genre_id, game_name)
SELECT DISTINCT genre_id, name
FROM vg_csv INNER JOIN vg_genre ON genre = genre_name;

-- Inserting unique publisher names into vg_publisher table --
INSERT INTO vg_publisher(publisher_name)
SELECT DISTINCT publisher
FROM vg_csv;

-- Inserting unique platform names into vg_publisher table --
INSERT INTO vg_platform(platform_name)
SELECT DISTINCT platform
FROM vg_csv;

-- Inserting video game information into vg_release table --
INSERT INTO vg_release(game_id, publisher_id, platform_id, year, NA_Sales, EU_Sales, JP_Sales, Other_Sales)
SELECT game_id, publisher_id, platform_id, CASE WHEN year REGEXP '^[0-9]+$' THEN year ELSE NULL END, NA_Sales, EU_Sales, JP_Sales, Other_Sales
FROM vg_game INNER JOIN vg_csv ON game_name = name INNER JOIN vg_publisher ON publisher = publisher_name INNER JOIN vg_platform ON platform = platform_name;

