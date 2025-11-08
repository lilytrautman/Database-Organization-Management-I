-- 1 --
SELECT name_last
FROM mlb_master INNER JOIN mlb_batting ON mlb_master.player_id = mlb_batting.player_id
WHERE doubles > 45;

-- 2 --
SELECT name_last
FROM mlb_master
WHERE player_id IN (SELECT player_id FROM mlb_batting WHERE doubles > 45);

-- 3 --
SELECT name_last, doubles
FROM mlb_master INNER JOIN mlb_batting ON mlb_master.player_id = mlb_batting.player_id
WHERE doubles > 45;

-- 4 --
SELECT name, wins
FROM mlb_team
WHERE wins > (SELECT AVG(wins) FROM mlb_team)
ORDER BY wins DESC;

-- 5 --
SELECT name_first, name_last, hit_by_pitch
FROM mlb_master INNER JOIN mlb_pitching ON mlb_master.player_id = mlb_pitching.player_id
WHERE hit_by_pitch = (SELECT MAX(hit_by_pitch) FROM mlb_pitching);

-- 6 --
SELECT name_first, name_last, height, name
FROM mlb_master INNER JOIN mlb_manager ON mlb_master.player_id = mlb_manager.player_id INNER JOIN mlb_team ON mlb_manager.team_id = mlb_team.team_id
WHERE height = (SELECT MIN(height) FROM mlb_master INNER JOIN mlb_manager ON mlb_master.player_id = mlb_manager.player_id);

-- 7 --
SELECT name_first, name_last, (strikeouts/walks) as K_BB
FROM mlb_master INNER JOIN mlb_pitching ON mlb_master.player_id = mlb_pitching.player_id
WHERE walks >= 1 AND games >= 25
ORDER BY K_BB DESC
LIMIT 10;

SELECT name_first, name_last, (SUM(strikeouts)/SUM(walks)) as K_BB
FROM mlb_master INNER JOIN mlb_pitching ON mlb_master.player_id = mlb_pitching.player_id
WHERE walks >= 1 AND games >= 25
GROUP BY stint, name_first, name_last
ORDER BY K_BB DESC
LIMIT 10;

-- 8 --
SELECT team_id
FROM mlb_batting
WHERE homeruns > 35
UNION
SELECT team_id
FROM mlb_batting
WHERE stolen_bases > 40;

-- 9 --
SELECT DISTINCT mlb_pitching.player_id
FROM mlb_pitching
WHERE mlb_pitching.player_id IN (SELECT player_id FROM mlb_batting WHERE homeruns > 10);

-- 10 --
CREATE OR REPLACE VIEW mlb_national AS
SELECT * 
FROM mlb_team
WHERE league = 'NL';