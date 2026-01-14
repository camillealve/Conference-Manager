-- Query 3
SET SEARCH_PATH TO A3Conference, public;

-- Drop Intermediate Step Views
DROP VIEW IF EXISTS ConferenceAcceptedPapers CASCADE;
DROP VIEW IF EXISTS ConferenceAcceptedCount CASCADE;
DROP VIEW IF EXISTS MaxAcceptedConference CASCADE;

-- Accepted paper submissions
CREATE VIEW ConferenceAcceptedPapers AS
SELECT a.cID, a.sID
FROM Application a JOIN Submission s ON a.sID = s.sID
WHERE CAST(a.decision AS varchar) = 'accepted' 
    and CAST(s.type AS varchar) = 'paper';

CREATE VIEW ConferenceAcceptedCount AS
SELECT cID, count(sID) AS accepted_count
FROM ConferenceAcceptedPapers
GROUP BY cID;

-- Conference with the most accepted papers
CREATE VIEW MaxAcceptedConference AS
SELECT cID 
    FROM ConferenceAcceptedCount
    WHERE accepted_count = 
        (SELECT MAX(accepted_count) FROM ConferenceAcceptedCount);


-- All first authors from every accepted paper at that conference
-- *** Q: Remove person if names aren't necessary
SELECT p.name
FROM MaxAcceptedConference c 
    JOIN ConferenceAcceptedPapers cap ON c.cID = cap.cID
    JOIN Author a ON a.sID =  cap.sID
    JOIN Person p ON a.pID = p.PID
WHERE a.rank = 1;
