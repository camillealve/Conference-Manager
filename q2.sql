-- Query 2
SET SEARCH_PATH TO A3Conference, public;

-- Number of conferences attended per person
SELECT p.pID, COALESCE(count(a.cID), 0) AS num_conferences_attended 
FROM Person p LEFT JOIN Attendee a ON p.PID = a.pID
GROUP BY p.pID
ORDER BY p.pID;