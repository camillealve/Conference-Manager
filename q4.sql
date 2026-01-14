-- Query 4
SET SEARCH_PATH TO A3Conference, public;

-- Drop Intermediate Step Views
DROP VIEW IF EXISTS SubmissionCounts CASCADE;
DROP VIEW IF EXISTS SubmissionCountsAccepted CASCADE;

-- Number of times a submission was submitted
CREATE VIEW SubmissionCounts AS
SELECT sID, count(cID) AS num_conferences_submitted
FROM Application
GROUP BY sID;

-- Accepted submissions and their submission counts
CREATE VIEW SubmissionCountsAccepted AS
SELECT sc.sID, sc.num_conferences_submitted
FROM SubmissionCounts sc JOIN Application a ON sc.sID = a.sID
WHERE CAST(a.decision AS varchar) = 'accepted';

-- The accepted submission that was submitted most
SELECT DISTINCT(a.SID)
FROM Application a, SubmissionCountsAccepted s
WHERE s.sID = a.sID
 AND s.SID = 
    (SELECT sc.sID
    FROM SubmissionCounts sc
    WHERE sc.num_conferences_submitted = 
        (SELECT MAX(num_conferences_submitted) 
        FROM SubmissionCountsAccepted));