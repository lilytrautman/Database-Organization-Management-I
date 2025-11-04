-- Calls to game profit by region
CALL gameProfitByRegion(35, 'WD');
-- Results:
-- Wii Sports	82.74
-- Super Mario Bros.	40.24
-- Mario Kart Wii	35.83

CALL gameProfitByRegion(12, 'EU');
-- Results:
-- Wii Sports	29.02
-- Mario Kart Wii	12.88

CALL gameProfitByRegion(10, 'JP');
-- Results:
-- Pokemon Red/Pokemon Blue	10.22

-- Calls to genre ranking by region
CALL genreRankingByRegion('Sports', 'WD');
-- Results: The first 10
-- 1	Wii Sports	82.74
-- 2	Wii Sports Resort	33.00
-- 3	Wii Fit	22.72
-- 4	Wii Fit Plus	22.00
-- 5	FIFA 16	8.49
-- 6	Mario & Sonic at the Olympic Games	8.05
-- 7	FIFA 14	6.90
-- 8	Zumba Fitness	6.81
-- 9	FIFA 12	6.69
-- 10	FIFA 15	6.60

CALL genreRankingByRegion('Role-playing', 'NA');
-- Results: The first 10
-- 1	Pokemon Red/Pokemon Blue	11.27
-- 2	Pokemon Gold/Pokemon Silver	9.00
-- 3	Pokemon Diamond/Pokemon Pearl	6.42
-- 4	Pokemon Ruby/Pokemon Sapphire	6.06
-- 5	PokÃ©mon Yellow: Special Pikachu Edition	5.89
-- 6	Pokemon Black/Pokemon White	5.57
-- 7	Pokemon X/Pokemon Y	5.17
-- 8	The Elder Scrolls V: Skyrim	5.03
-- 9	Pokemon FireRed/Pokemon LeafGreen	4.34
-- 10	Pokemon Omega Ruby/Pokemon Alpha Sapphire	4.23

CALL genreRankingByRegion('Role-playing', 'JP');
-- Results:
-- 1	Pokemon Red/Pokemon Blue	10.22
-- 2	Pokemon Gold/Pokemon Silver	7.20
-- 3	Pokemon Diamond/Pokemon Pearl	6.04
-- 4	Pokemon Black/Pokemon White	5.65
-- 5	Pokemon Ruby/Pokemon Sapphire	5.38
-- 6	Monster Hunter Freedom 3	4.87
-- 7	Dragon Quest IX: Sentinels of the Starry Skies	4.35
-- 8	Pokemon X/Pokemon Y	4.34
-- 9	Monster Hunter Freedom Unite	4.13
-- 10	Dragon Quest VII: Warriors of Eden	4.10

-- Calls to published releases
CALL publishedReleases('Electronic Arts', 'Sports');
-- Results:
-- Electronic Arts	Sports	561

CALL publishedReleases('Electronic Arts', 'Action');
-- Results:
-- Electronic Arts	Action	183

 -- Calls to add new release
CALL addNewRelease('Foo Attacks', 'X360', 'Strategy', 'Stevenson Studios');

-- No duplicate of Strategy genre
SELECT *
FROM vg_genre;
-- Result:
-- 12	Strategy

-- New game added with correct genre id
SELECT *
FROM vg_game
WHERE game_name = 'Foo Attacks';
-- Result:
-- 16384	12	Foo Attacks

-- No duplicate of X360 platform
SELECT *
FROM vg_platform;
-- Result:
-- 5	X360

-- New publisher added
SELECT *
FROM vg_publisher
WHERE publisher_name = 'Stevenson Studios';
-- Result:
-- 1024	Stevenson Studios

-- Entry with the same game_id, publisher_id and platform_id as shown in other tables
SELECT *
FROM vg_release
WHERE game_id = 16384 AND publisher_id = 1024 AND platform_id = 5;


