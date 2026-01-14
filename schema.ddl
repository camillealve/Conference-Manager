-- CSC343, Introduction to Databases
-- Department of Computer Science, University of Toronto

-- Schema by Camille and Katarina


-- Schemas:
--* conference (cID, name, location, date )
--* person (pID, name, organization, contact)
--* submission (sID, cID, title, submission_type, author_list)
--* authors (sID, pID, rank)
--* review (sID, reviewer(pID), decision_type / key: sID, reviewer)
--* posterSession (sessionID, cID)
--* paperSession (sessionID, cID, sessionChair) 
--* paperSessionSchedule (sessionID, sID, time)
--* posterSessionSchedule (sessionID, sID, time)
--* attendee (pID, cID, age_type)
--* workshop (wID, cID, facilitator(pID), fee)
--* workshopSignUp (wID, pID)
--* organizingCommitte (cID, pID)

-- Completed Constraints:
--  ~ Submission: all paper and posters have at least 1 reviewer
--  ~ Workshop: all workshops have at least 1 facilitator
--  ~ PaperSessionSchedule: every paper must start at a different time
--  ~ PaperSessionSchedule/PosterSessionSchedule: multiple presentations can
--    occur at the same time
--  ~ Submission: a submissions must have unique title, authors, and type
--  ~ Submission: a submission that has been accepted cannot be submitted again
--  ~ Attendee: enforced fee for adults vs fee for students
--  ~ ConferenceSignUp

-- Could Not:
--  ~ Submission: a submission must have 3 reviews before it can have a decision
--      > Would need to use assertions/triggers to count the number of reviews it
--        received before inserting into Application, so we did not implement this,
--        also involves multiple relations.
--  ~ Submission: a submission cannot be accepted unless it is accepted by at 
--                least one reviewer 
--      > Would need to use assertions/triggers to see if it was accepted by a 
--        reviewer before inserting into Application so we did not implement this,
--        involves multiple relations
--  ~ Submission: a paper submission needs to have 1 author also be a reviewer 
--                (not on the submission)
--  ~ Paper/PosterSession: an author can have a paper and a poster presented at 
--                         the same time if they are not the sole author
--      > Would need to use assertions/triggers to check if there is already a
--        paper session with this author before adding a poster session and vice versa.
--  ~ Submission: a submission must have at least 1 author

-- Did Not:
--  ~ Submission: a paper submission needs to have 1 author also be a reviewer 
--                (not on the submission)
--  ~ PaperSession: sessionChair cannot be an Author on a paper in the session
--      > Could add the sessionChair attribute add array of authors into 
--        PaperSessionSchedule to check if sessionChair is in the array of authors
--        but we could not figure it out
--  ~ PaperSession: sessionChair cannot be attending anything else at the same 
--                  time
--      > Could be implemented if there was a relation of a person's itinerary
--        with attributes pID, activity (which could be paper session, poster session,
--        workshop, etc) and time, with UNIQUE pid and time to avoid overlapping events,
--        but it would be far too tedious to update and would have too many tuples

--  ~ Review: reviewer is not reviewing their own paper or affiliated submission
--      > Involves using arrays which we could not figure out


-- Assumptions: 
--  ~ Author: user puts author list in order with the correct ranks


DROP SCHEMA IF EXISTS A3Conference CASCADE;
CREATE SCHEMA A3Conference;
SET SEARCH_PATH TO A3Conference;

CREATE TYPE A3Conference.submission_type AS ENUM (
	'paper', 'poster'
);

CREATE TYPE A3Conference.age_type AS ENUM (
	'adult', 'student'
);

CREATE TYPE A3Conference.decision_type AS ENUM (
	'accepted', 'rejected', 'undecided'
);

CREATE TYPE A3Conference.member_type AS ENUM (
	'member', 'conferenceChair'
);

-- A conference in the Conference system.
CREATE TABLE IF NOT EXISTS Conference (
	-- The id of the conference.
    cID INT PRIMARY KEY,
    -- The name of the conference.
	name TEXT NOT NULL,
    -- The location of the conference.
	location TEXT NOT NULL,
	-- The year of the conference.
	year INT NOT NULL,
    UNIQUE (name, year)
);

-- A person in the Conference system.
CREATE TABLE IF NOT EXISTS Person (
	-- The id of the person.
    pID INT PRIMARY KEY,
    -- The name of the person.
	name TEXT NOT NULL,
    -- The organization that the person belongs to.
	organization TEXT NOT NULL,
	-- The contact number for the person.
	contact CHAR(10) NOT NULL
);

-- An Organizing Committee for a conference.
CREATE TABLE IF NOT EXISTS OrganizingCommittee (
	-- The conference being organized.
    cID INT NOT NULL,
    -- The person on the organizing comittee.
	pID INT NOT NULL,
    -- The role of the person on the organizing comittee.
	role member_type NOT NULL,
    PRIMARY KEY (cID, pID),
	FOREIGN KEY (cID) 
        REFERENCES Conference(cID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pID) 
        REFERENCES Person(pID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A paper or poster submission.
CREATE TABLE IF NOT EXISTS Submission (
	-- The submission ID.
    sID INT PRIMARY KEY,
    -- The title of the submission.
	title TEXT NOT NULL,
    -- The type of submission.
	type submission_type NOT NULL,
    UNIQUE (title, type)
);

-- An author of a submission.
CREATE TABLE IF NOT EXISTS Author (
	-- The submission.
    sID INT NOT NULL,
    -- The author on the submission.
	pID INT NOT NULL,
    -- The rank of the author on the submission.
    rank INT NOT NULL check (rank > 0),
    PRIMARY KEY (sID, pID),
    FOREIGN KEY (pID) 
        REFERENCES Person(pID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sID)                         
        REFERENCES Submission(sID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- An application to a conference.
CREATE TABLE IF NOT EXISTS Application (
	-- The submission ID.
    sID INT,
    -- The conference it is submitted to.
    cID INT NOT NULL,
    -- The decision of the application.
    decision decision_type NOT NULL,
    PRIMARY KEY (sID, cID),
	FOREIGN KEY (cID) 
        REFERENCES Conference(cID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sID)                         
        REFERENCES Submission(sID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A review of a submission.
CREATE TABLE IF NOT EXISTS Review (
	-- The submission.
    sID INT NOT NULL,
    -- The conference it was submitted to.
    cID INT NOT NULL,
    -- The reviewer on the submission.
	pID INT NOT NULL,
    -- The decision of the reviewer on the submission. (TODO: constraint)
    decision decision_type NOT NULL,
    PRIMARY KEY (sID, cID, pID),
	FOREIGN KEY (sID, cID)
        REFERENCES Application(sID, cID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pID) 
        REFERENCES Person(pID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- An attendee of a conference.
CREATE TABLE IF NOT EXISTS Attendee (
	-- The conference.
    cID INT NOT NULL,
    -- The attendee of the conference.
	pID INT NOT NULL,
    -- The age group the attendee belongs to.
    age_group age_type NOT NULL,
    -- The fee according to age group,
    fee INT NOT NULL CHECK (age_group = 'adult' AND fee = 500 OR 
                            age_group = 'student' AND fee = 300),
    PRIMARY KEY (cID, pID),
	FOREIGN KEY (cID) 
        REFERENCES Conference(cID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pID) 
        REFERENCES Person(pID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A workshop at a conference.
CREATE TABLE IF NOT EXISTS Workshop (
	-- The workshop.
    wID INT PRIMARY KEY,
    -- The conference the workshop is held at.
    cID INT NOT NULL,
    -- The name of the workshop.
    name TEXT NOT NULL,
    -- The fee of the workshop.
    fee INT NOT NULL,
    UNIQUE (wID, cID),
    FOREIGN KEY (cID) 
        REFERENCES Conference(cID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A facilitator of a conference workshop.
CREATE TABLE IF NOT EXISTS Facilitator (
	-- The workshop.
    wID INT NOT NULL,
    -- The facilitator of the workshop.
	pID INT NOT NULL,
    -- The conference the workshop is held at.
    cID INT NOT NULL,
    PRIMARY KEY (wID, pID),
    FOREIGN KEY (wID) 
        REFERENCES Workshop(wID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pID, cID) 
        REFERENCES Attendee(pID, cID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A row in this table indicates that an attendee has signed up for a workshop.
CREATE TABLE IF NOT EXISTS WorkshopSignUp (
	-- The workshop being attended.
    wID INT NOT NULL,
    -- The person attending the workshop.
	pID INT NOT NULL,
    -- The conference the workshop is held at.
    cID INT NOT NULL,
    PRIMARY KEY (wID, pID),
	FOREIGN KEY (wID) 
        REFERENCES Workshop(wID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pID, cID) 
        REFERENCES Attendee(pID, cID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A poster session in a conference.
CREATE TABLE IF NOT EXISTS PosterSession (
	-- The sessionID for the poster session.
    posterSessionID INT PRIMARY KEY,
    -- The conference it is submitted to.
    cID INT NOT NULL,
	FOREIGN KEY (cID) 
        REFERENCES Conference(cID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- The schedule for a poster session in a conference.
CREATE TABLE IF NOT EXISTS PosterSessionSchedule (
	-- The sessionID for the poster session.
    posterSessionID INT PRIMARY KEY,
    -- The submission.
	sID INT NOT NULL,
    -- The start time.
    time TIME NOT NULL,
	FOREIGN KEY (posterSessionID) 
        REFERENCES PosterSession(posterSessionID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sID) 
        REFERENCES Submission(sID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A paper session in a conference.
CREATE TABLE IF NOT EXISTS PaperSession (
	-- The sessionID for the paper session.
    paperSessionID INT PRIMARY KEY,
    -- The conference it is submitted to.
    cID INT NOT NULL,
    -- The chair of the paper session.
    sessionChair INT NOT NULL,
	FOREIGN KEY (cID) 
        REFERENCES Conference(cID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sessionChair, cID) 
        REFERENCES Attendee(pID, cID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- The schedule for a paper session in a conference.
CREATE TABLE IF NOT EXISTS PaperSessionSchedule (
	-- The sessionID for the poster session.
    paperSessionID INT,
    -- The submission.
	sID INT NOT NULL,
    -- The start time.
    time TIME NOT NULL,
    PRIMARY KEY (paperSessionID, time),
	FOREIGN KEY (paperSessionID) 
        REFERENCES PaperSession(paperSessionID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sID) 
        REFERENCES Submission(sID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);