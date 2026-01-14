-- Query 5
SET SEARCH_PATH TO A3Conference, public;

-- Drop Intermediate Step Views
DROP VIEW IF EXISTS PapersInPaperSession CASCADE;
DROP VIEW IF EXISTS PostersInPosterSession CASCADE;
DROP VIEW IF EXISTS AveragePapersPerSessionPerConference CASCADE;
DROP VIEW IF EXISTS AveragePostersPerSessionPerConference CASCADE;


-- Number of papers in each PaperSession
CREATE VIEW PapersInPaperSession AS
SELECT paperSessionID, count(sID) AS num_papers
FROM PaperSessionSchedule
GROUP BY paperSessionID;

-- Number of papers in each PosterSession
CREATE VIEW PostersInPosterSession AS
SELECT posterSessionID, count(sID) AS num_posters
FROM PosterSessionSchedule
GROUP BY posterSessionID;

-- Average Number of Papers in each paper session per conference
CREATE VIEW AveragePapersPerSessionPerConference AS
SELECT s.cID, avg(ps.num_papers) AS average_paper_count
FROM PapersInPaperSession ps 
    JOIN PaperSession s ON ps.paperSessionID = s.paperSessionID
GROUP BY s.cID;

-- Average Number of Papers in each paper session per conference
CREATE VIEW AveragePostersPerSessionPerConference AS
SELECT s.cID, avg(ps.num_posters) AS average_poster_count
FROM PostersInPosterSession ps 
    JOIN PosterSession s ON ps.posterSessionID = s.posterSessionID
GROUP BY s.cID;


-- The average number of papers per paper session and average number of posters
-- per poster session in each conference
SELECT c.cID, COALESCE(pap.average_paper_count, 0) AS average_paper_count , 
                COALESCE(pos.average_poster_count, 0) AS average_poster_count
FROM Conference c 
    LEFT JOIN 
    AveragePapersPerSessionPerConference pap ON c.cID = pap.cID 
    LEFT JOIN
    AveragePostersPerSessionPerConference pos ON c.cID = pos.cID;

