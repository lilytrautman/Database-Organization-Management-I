DROP PROCEDURE IF EXISTS gameProfitByRegion;
DROP PROCEDURE IF EXISTS genreRankingByRegion;
DROP PROCEDURE IF EXISTS publishedReleases;
DROP PROCEDURE IF EXISTS addNewRelease;

DELIMITER //
CREATE PROCEDURE gameProfitByRegion(IN minProfit INT, IN regionCode CHAR(2))
BEGIN  
	IF regionCode = 'WD' THEN
		SELECT game_name, (NA_Sales + EU_Sales + JP_Sales + Other_Sales) as WD_Sales
        FROM vg_release INNER JOIN vg_game ON vg_release.game_id = vg_game.game_id
        WHERE (NA_Sales + EU_Sales + JP_Sales + Other_Sales) > minProfit;
	ELSEIF regionCode = 'NA' THEN
		SELECT game_name, NA_Sales
        FROM vg_release INNER JOIN vg_game ON vg_release.game_id = vg_game.game_id
        WHERE NA_Sales > minProfit;
	ELSEIF regionCode = 'EU' THEN
		SELECT game_name, EU_Sales
        FROM vg_release INNER JOIN vg_game ON vg_release.game_id = vg_game.game_id
        WHERE EU_Sales > minProfit;
	ELSEIF regionCode = 'JP' THEN
		SELECT game_name, JP_Sales
        FROM vg_release INNER JOIN vg_game ON vg_release.game_id = vg_game.game_id
        WHERE JP_Sales > minProfit;
	END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE genreRankingByRegion(IN genre VARCHAR(20), IN regionCode VARCHAR(2))
BEGIN
	IF regionCode = 'WD' THEN        
		SELECT RANK () OVER (
		ORDER BY (NA_Sales + EU_Sales + JP_Sales + Other_Sales) DESC) AS Ranking,
            game_name, (NA_Sales + EU_Sales + JP_Sales + Other_Sales) AS WD_Sales
		FROM vg_release INNER JOIN vg_game ON vg_release.game_id = vg_game.game_id INNER JOIN vg_genre ON vg_genre.genre_id = vg_game.genre_id
		WHERE genre_name = genre;       
	ELSEIF regionCode = 'NA' THEN
		SELECT RANK () OVER (
        ORDER BY NA_Sales DESC) AS Ranking, game_name, NA_Sales
		FROM vg_release INNER JOIN vg_game ON vg_release.game_id = vg_game.game_id INNER JOIN vg_genre ON vg_genre.genre_id = vg_game.genre_id
		WHERE genre_name = genre;
	ELSEIF regionCode = 'EU' THEN
		SELECT RANK () OVER (
        ORDER BY EU_Sales DESC) AS Ranking, game_name, EU_Sales
		FROM vg_release INNER JOIN vg_game ON vg_release.game_id = vg_game.game_id INNER JOIN vg_genre ON vg_genre.genre_id = vg_game.genre_id
		WHERE genre_name = genre;
	ELSEIF regionCode = 'JP' THEN
		SELECT RANK () OVER (
        ORDER BY JP_Sales DESC) AS Ranking, game_name, JP_Sales
		FROM vg_release INNER JOIN vg_game ON vg_release.game_id = vg_game.game_id INNER JOIN vg_genre ON vg_genre.genre_id = vg_game.genre_id
		WHERE genre_name = genre;
	END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE publishedReleases(IN publisher VARCHAR(50), IN genre VARCHAR(20))
BEGIN
	SELECT publisher_name, genre_name, COUNT(*)
    FROM vg_release INNER JOIN vg_publisher ON vg_release.publisher_id = vg_publisher.publisher_id INNER JOIN vg_game ON vg_release.game_id = vg_game.game_id INNER JOIN vg_genre ON vg_genre.genre_id = vg_game.genre_id
    GROUP BY publisher_name, genre_name
    HAVING publisher_name = publisher AND genre_name = genre;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addNewRelease(IN game VARCHAR(150), IN platform VARCHAR(10), IN genre VARCHAR(20), IN publisher VARCHAR(50))
BEGIN
    DECLARE new_genre_id INT;
    DECLARE new_game_id INT;
    DECLARE new_platform_id INT;
    DECLARE new_publisher_id INT;

    -- Check if the genre already exists
    SELECT genre_id INTO new_genre_id
    FROM vg_genre
    WHERE genre_name = genre;

    -- If the genre doesn't exist, insert the new genre
    IF new_genre_id IS NULL THEN
        INSERT INTO vg_genre(genre_name)
        VALUES (genre);
        SET new_genre_id = LAST_INSERT_ID();
    END IF;

    -- Check if the game already exists
    SELECT game_id INTO new_game_id
    FROM vg_game
    WHERE game_name = game;

    -- If the game doesn't exist, insert the new game
    IF new_game_id IS NULL THEN
        INSERT INTO vg_game(genre_id, game_name)
        VALUES (new_genre_id, game);
        SET new_game_id = LAST_INSERT_ID();
    END IF;

    -- Check if the platform already exists
    SELECT platform_id INTO new_platform_id
    FROM vg_platform
    WHERE platform_name = platform;

    -- If the platform doesn't exist, insert the new platform
    IF new_platform_id IS NULL THEN
        INSERT INTO vg_platform(platform_name)
        VALUES (platform);
        SET new_platform_id = LAST_INSERT_ID();
    END IF;

    -- Check if the publisher already exists
    SELECT publisher_id INTO new_publisher_id
    FROM vg_publisher
    WHERE publisher_name = publisher;

    -- If the publisher doesn't exist, insert the new publisher
    IF new_publisher_id IS NULL THEN
        INSERT INTO vg_publisher(publisher_name)
        VALUES (publisher);
        SET new_publisher_id = LAST_INSERT_ID();
    END IF;

    -- Insert into vg_release
    INSERT INTO vg_release(game_id, publisher_id, platform_id)
    VALUES (new_game_id, new_publisher_id, new_platform_id);

    -- Return statement indicating success
    SELECT 'Data added successfully' AS result;
END //
DELIMITER ;