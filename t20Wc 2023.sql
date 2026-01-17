use t20worldcup2024;
select * from `batting stats`;
select * from `bowling stats`;
select * from `match view`;

-- Batting analysis
-- top 10 scorers of tournament
select  Player, `total runs`
from `batting stats`
order by `total runs` desc limit 3,10;
-- insight:- 10 rows returned


 
 
 -- Avegrage runs per player
 select Player, avg(`total runs`) as avg_runs
from `batting stats`
group by Player
order by avg_runs desc;
-- insight:- 109 rows returned


-- players with 50+ scores
select Player, count(*) as fifty from 
`batting stats` where `Fifties Scored`>=1
group by Player 
order by fifty desc; 
-- insight:- 20 rows returned


-- players with 100+ scores
select Player, count(*) as centuries
from `batting stats`
where `Hundreds Scored`>= 100
group by Player
order by centuries desc;
-- insight:- 0 rows returned


-- Players with highest batting strike rate (min 200 balls faced)
select Player, `Batting Strike Rate`,`Balls Faced`
from `batting stats`
where `Balls Faced` >= 200
order by `Batting Strike Rate` desc;
-- insight:- 2 rows returned


-- batsman with highest runs and lowest runs
SELECT MIN(`total runs`), MAX(`total runs`) from `batting stats`;


-- Bowling analysis
-- top 10 wicket takers of the tournament
select Player, Wickets
 from `bowling stats` 
 order by Wickets desc limit 10;
 -- insight:- 10 rows returned
 

-- Best bowling average (runs conceded per wicket)
select Player, sum(`Runs Conceded`) / sum(Wickets) as bowling_avg
from `bowling stats`
where wickets > 0
group by Player
order by bowling_avg asc;
-- insight:- 100 rows returned

-- Economy rate of bowlers
select Player, sum(`Runs Conceded`) / sum(Overs) as economy_rate
from `bowling stats`
group by Player
order by economy_rate asc;
-- insight:- 100 rows returned


-- Match / tournament analysis
-- teams with highest no of wins
select Winners, count(*) as matches_won
from `match view`
group by Winners
order by matches_won desc;
-- insight:- 17 rows returned

-- Venue with most matches:
select `Venue City`, count(*) as matches_played
from `match view`
group by `Venue City`
order by matches_played desc;
-- insight:- 9 rows returned


-- Highest scoring matches
select `Date of Match`, `1st Team`, `2nd Team`, `First Innings Score` + `Second Innings Score` as total_runs
from `match view`
order by total_runs desc
limit 5;
-- insight:- 5 rows returned


-- -------------------------------------------------------------------------------------------------------------
-- top 5 players with best batting average (runs per innings)
select Player, sum(`total runs`) / count(*) as batting_average
from `batting stats`
group by Player
order by batting_average desc
limit 5;
-- insight:- 5 rows returned


-- most man of the match awards
select `Player Of The Match`, count(*) as awards
from `match view`
where `Player Of The Match` is not null
group by `Player Of The Match`
order by awards desc
limit 5;
-- insight:- 5 rows returned



-- team performance (wins vs total matches):
select Team, 
       sum(case when Team = `Winners` then 1 else 0 end) as wins,
       count(*) as total_matches
from (
    select `1st Team` as team, `Winners` from `match view`
    union all
    select `2nd Team` as team, `Winners` from `match view`
) t
group by team
order by wins desc;
-- insight:- 20 rows returned



--  top run scorer per match with venue
select m.`Match No.`, m.`Date Of Match`, m.`Venue City`, b.Player, b.`total runs`
from `batting stats` b 
join `match view` m on b.`Match id`= m.`Match No.`
where b.`total runs` = (
    select max(`total runs`)
    from `batting stats`
    where `Match id` = m.`Match No.`
);
-- insight:- 34 rows returned


-- Toss decision and winner along with top scorer
select m.`Match No.`, m.`Toss Winning`, m.`Toss Decision`, m.`Winners`, m.`Top Run Scorer`
from `match view` m;
-- insight:- 55 rows returned










