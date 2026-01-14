SET SEARCH_PATH TO A3Conference;

-- Import Data for Conference
\Copy Conference FROM 'data/Conference.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for Person
\Copy Person FROM 'data/Person.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for OrganizingCommittee
\Copy OrganizingCommittee FROM 'data/OrganizingCommittee.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for Submission
\Copy Submission FROM 'data/Submission.csv' With CSV DELIMITER ',' HEADER;
INSERT INTO Submission (sID, title, type) VALUES (1, 'Student Perspectives on Optional Groups', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (2, 'Experience Report on the Use of Breakout Rooms in Large Online Course', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (3, 'Introducing and Evaluating Exam Wrappers in CS2', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (4, 'Factors for Success in Online CS1', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (5, 'Evaluating Student Teams: Do Educators Know What Students Think?', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (6, 'Drop-In Help Centres: An Alternative to Office Hours', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (7, 'Self-paced Mastery Learning CS1', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (8, 'Building Community in a Competitive Undergraduate Program', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (9, 'Sadia Poster 1', 'poster');
INSERT INTO Submission (sID, title, type) VALUES (10, 'Sadia First Author Paper', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (11, 'Sadia Poster 2', 'poster');
INSERT INTO Submission (sID, title, type) VALUES (12, 'Rejected Paper 1', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (13, 'Rejected Paper 2', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (14, 'Sadia Paper', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (15, 'Michelle Paper 1', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (16, 'Michelle Paper 2', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (17, 'Michelle Paper 3', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (18, 'Michelle Paper 4', 'paper');
INSERT INTO Submission (sID, title, type) VALUES (19, 'Michelle Paper 5', 'paper');


-- Import Data for Author
\Copy Author FROM 'data/Author.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for Application
\Copy Application FROM 'data/Application.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for Review
\Copy Review FROM 'data/Review.csv' With CSV DELIMITER ',' HEADER;

-- Import Attendee for Attendee
\Copy Attendee FROM 'data/Attendee.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for Workshop
\Copy Workshop FROM 'data/Workshop.csv' With CSV DELIMITER ',' HEADER;

INSERT INTO Workshop (wID, cID, name, fee) VALUES (1, 7, 'Coding in R', 10);
INSERT INTO Workshop (wID, cID, name, fee) VALUES (2, 11, 'Coding in C', 200);
INSERT INTO Workshop (wID, cID, name, fee) VALUES (3, 2, 'Coding in Python', 10);
INSERT INTO Workshop (wID, cID, name, fee) VALUES (4, 14, 'Coding in Java', 30);
INSERT INTO Workshop (wID, cID, name, fee) VALUES (5, 28, 'Coding in C#', 50);
INSERT INTO Workshop (wID, cID, name, fee) VALUES (6, 24, 'Coding in JavaScript', 80);


-- Import Data for Facilitator
\Copy Facilitator FROM 'data/Facilitator.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for WorkshopSignUp
\Copy WorkshopSignUp FROM 'data/WorkshopSignUp.csv' With CSV DELIMITER ',' HEADER;

INSERT INTO WorkshopSignup (wID, pID, cID) VALUES (1, 2, 7);
INSERT INTO WorkshopSignup (wID, pID, cID) VALUES (6, 2, 24);


-- Import Data for PosterSession
\Copy PosterSession FROM 'data/PosterSession.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for PosterSessionSchedule
\Copy PosterSessionSchedule FROM 'data/PosterSessionSchedule.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for PaperSession
\Copy PaperSession FROM 'data/PaperSession.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for PaperSessionSchedule
\Copy PaperSessionSchedule FROM 'data/PaperSessionSchedule.csv' With CSV DELIMITER ',' HEADER;