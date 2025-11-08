-- 1 --
SELECT name_first, name_last, shut_outs
FROM mlb_master INNER JOIN mlb_pitching ON mlb_master.player_id = mlb_pitching.player_id
WHERE shut_outs >= 1
ORDER BY shut_outs DESC, name_last ASC;

-- 2 --
SELECT name_first, name_last, ((homeruns * 4) + (triples * 3) + (doubles * 2) + (hits - doubles - triples - homeruns))
FROM mlb_master INNER JOIN mlb_batting ON mlb_master.player_id = mlb_batting.player_id
WHERE lower(name_last) = 'Smith';

-- 3 --
SELECT name, name_first, name_last
FROM mlb_manager INNER JOIN mlb_master ON mlb_manager.player_id = mlb_master.player_id INNER JOIN mlb_team ON mlb_manager.team_id = mlb_team.team_id
WHERE lower(league) = 'NL' AND lower(division) = 'C';

-- 4 --
SELECT throws, COUNT(DISTINCT mlb_master.player_id)
FROM mlb_master INNER JOIN mlb_pitching ON mlb_master.player_id = mlb_pitching.player_id
GROUP BY throws;

-- 5 --
SELECT name, AVG(weight) as weight
FROM mlb_team INNER JOIN mlb_pitching ON mlb_team.team_id = mlb_pitching.team_id INNER JOIN mlb_master ON mlb_pitching.player_id = mlb_master.player_id
GROUP BY mlb_team.team_id, name
ORDER BY weight DESC;

-- 6 --
SELECT name_first, name_last, height, name
FROM mlb_master INNER JOIN mlb_manager ON mlb_master.player_id = mlb_manager.player_id INNER JOIN mlb_team ON mlb_manager.team_id = mlb_team.team_id
WHERE height < 70;

-- 7 --
SELECT mlb_pitching.player_id, name_first, name_last, SUM(outs_pitched/3) as innings_pitched
FROM mlb_master INNER JOIN mlb_pitching ON mlb_master.player_id = mlb_pitching.player_id
GROUP BY player_id
HAVING COUNT(team_id) > 1
ORDER BY innings_pitched DESC;

-- 8 --
SELECT CONCAT(name_first, ' ', name_last) as full_name, SUM(wild_pitches)
FROM mlb_master INNER JOIN mlb_pitching ON mlb_master.player_id = mlb_pitching.player_id
GROUP BY full_name, stint
HAVING sum(wild_pitches) >= 13 AND sum(outs_pitched) >= 500;

-- 9 --
SELECT name_last, AVG(mlb_batting.hits/at_bats), SUM((outs_pitched/3))
FROM mlb_master LEFT OUTER JOIN mlb_batting ON mlb_master.player_id = mlb_batting.player_id LEFT OUTER JOIN mlb_pitching ON mlb_batting.player_id = mlb_pitching.player_id
GROUP BY name_last
HAVING lower(name_last) LIKE 'Z%';