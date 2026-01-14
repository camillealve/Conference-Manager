-- Query 1
SET SEARCH_PATH TO A3Conference, public;

-- Drop Intermediate Step Views
DROP VIEW IF EXISTS TotalSubmissions CASCADE;
DROP VIEW IF EXISTS AcceptedSubmissions CASCADE;
DROP VIEW IF EXISTS ConferenceSubmissionInfo CASCADE;

-- the total num of submissions in the conference
CREATE VIEW TotalSubmissions AS
SELECT c.cID, c.year, count(a.sID) as total_subs
FROM Conference c, Application a
WHERE c.cID = a.cID 
GROUP BY c.cID;

-- the total num of accepted submissions in the conference
CREATE VIEW AcceptedSubmissions AS
SELECT c.cID, c.year, count(a.SID) as accepted_subs
FROM Conference c JOIN Application a ON c.cID = a.cID 
WHERE CAST(a.decision AS varchar) = 'accepted'
GROUP BY c.cID;

-- Percentage of submissions accepted per conference per year
CREATE VIEW ConferenceSubmissionInfo AS
SELECT c.cID, c.year, COALESCE(a.accepted_subs, 0) AS accepted_subs,
	COALESCE(ts.total_subs, 1) total_subs
FROM Conference c LEFT JOIN TotalSubmissions ts ON c.cID = ts.CID
	LEFT JOIN AcceptedSubmissions a ON c.cID = a.cID;

SELECT cID, year, accepted_subs::decimal/total_subs AS percent
FROM ConferenceSubmissionInfo;


