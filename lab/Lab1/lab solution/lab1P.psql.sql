CREATE SCHEMA IF NOT EXISTS kthsocial;
SET search_path TO kthsocial;


DROP TABLE IF EXISTS Subscriptions;
DROP TABLE IF EXISTS EventAttendents;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Attachments;
DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS Tags;
DROP TABLE IF EXISTS Posts;
DROP TABLE IF EXISTS Friendships;
DROP TABLE IF EXISTS Staffs;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    userID int PRIMARY KEY,
    fullName varchar(255) NOT NULL
);

CREATE TABLE Students(
    userID int PRIMARY KEY,
    enrollmentYear int NOT NULL,
    programme varchar(255) NOT NULL,
    FOREIGN KEY (userID) REFERENCES Users(userID)
);

CREATE TABLE Staffs(
    userID int PRIMARY KEY,
    department varchar(255) NOT NULL   CHECK (department IN ('ABE', 'EECS', 'ITM', 'CBH', 'SCI')),
    FOREIGN KEY (userID) REFERENCES Users(userID)
  
);

CREATE TABLE Friendships(
    user1ID int NOT NULL,
    user2ID int NOT NULL,
    FOREIGN KEY (user1ID) REFERENCES Users(userID),
    FOREIGN KEY (user2ID) REFERENCES Users(userID),
    PRIMARY KEY (user1ID, user2ID), 
    CHECK(user1ID < user2ID)
);

CREATE TABLE Posts(
    postURL varchar(255) PRIMARY KEY,
    userID int NOT NULL,
    title varchar(255) ,
    timePosted timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    place varchar(255) ,
    bodyText text ,
    FOREIGN KEY (userID) REFERENCES Users(userID)
);

CREATE TABLE Tags(
    postURL varchar(255) NOT NULL,
    tagName varchar(255) NOT NULL,
    PRIMARY KEY (postURL, tagName),
    FOREIGN KEY (postURL) REFERENCES Posts(postURL)
);

CREATE TABLE Likes(
    postURL varchar(255) NOT NULL,
    userID int NOT NULL,
    timeLiked timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (postURL) REFERENCES Posts(postURL),
    FOREIGN KEY (userID) REFERENCES Users(userID),
    PRIMARY KEY (postURL, userID) 
);

CREATE TABLE Attachments(
    postURL varchar(255),
    attachmentIndex int GENERATED ALWAYS AS IDENTITY,
    fileExtention varchar(255) NOT NULL,
    fileSize int NOT NULL,
    PRIMARY KEY (postURL, attachmentIndex), -- same problem as above
    FOREIGN KEY (postURL) REFERENCES Posts(postURL),
    CHECK (attachmentIndex >= 1),
    CHECK (fileExtention IN ('jpg', 'mp4', 'm4a', 'pdf'))
);

CREATE TABLE Events(
    eventID int PRIMARY KEY,
    creatorUserID int NOT NULL,
    title varchar(255) NOT NULL,
    place varchar(255) NOT NULL,
    startTime timestamp NOT NULL,
    endTime timestamp NOT NULL,
    FOREIGN KEY (creatorUserID) REFERENCES Users(userID),
    CHECK (startTime <= endTime)
);

CREATE TABLE EventAttendents(
    eventID int NOT NULL,
    userID int NOT NULL,
    PRIMARY KEY (eventID, userID),
    FOREIGN KEY (eventID) REFERENCES Events(eventID),
    FOREIGN KEY (userID) REFERENCES Users(userID)
);

CREATE TABLE Subscriptions(
    subscriptionID int PRIMARY KEY,
    paymentDate timestamp NOT NULL,
    userID int NOT NULL,
    paymentMethod varchar(255) NOT NULL,
    FOREIGN KEY (userID) REFERENCES Users(userID),
    -- check no active subscriptions when puting in new data
    CHECK (paymentMethod IN ('Klarna', 'Swish', 'Card', 'Bitcoin'))
);

-- Create users

INSERT INTO Users VALUES (1, 'Elias Nyström');
INSERT INTO Users VALUES (2, 'Wilmer Hällerå');
INSERT INTO Users VALUES (3, 'Tore Hamberg');
INSERT INTO Users VALUES (4, 'Tilde Magni');
INSERT INTO Users VALUES (5, 'Bella Pedersen');
INSERT INTO Users VALUES (6, 'William Holmberg');

-- Make students

INSERT INTO Students VALUES (1, 2024, 'mathematics');
INSERT INTO Students VALUES (2, 2024, 'indek');
INSERT INTO Students VALUES (3, 2024, 'fysik');
INSERT INTO Students VALUES (4, 2024, 'kemi');
INSERT INTO Students VALUES (6, 2024, 'design');

-- make staffs

INSERT INTO Staffs VALUES (1, 'SCI');
INSERT INTO Staffs VALUES (5, 'EECS');

-- friendships
INSERT INTO Friendships VALUES (1, 2);
INSERT INTO Friendships VALUES (1, 5);
INSERT INTO Friendships VALUES (3, 4);
INSERT INTO Friendships VALUES (4, 6);

-- make posts

INSERT INTO Posts (postURL, userID, bodyText) VALUES('http://www.kthsocial', 1, 'bodytext is cool');
INSERT INTO Posts (postURL, userID) VALUES('http://www.kthverysocial', 4);
INSERT INTO Posts (postURL, userID) VALUES('http://www.kthunsocial', 6);

-- attachments

INSERT INTO Attachments (postURL, fileExtention, fileSize) VALUES ('http://www.kthsocial', 'jpg', 5);
INSERT INTO Attachments (postURL, fileExtention, fileSize) VALUES ('http://www.kthverysocial', 'mp4', 55);

-- create tags
INSERT INTO Tags VALUES('http://www.kthsocial', 'coola ganget');
INSERT INTO Tags VALUES('http://www.kthverysocial', 'kanske dyker upp');
INSERT INTO Tags VALUES('http://www.kthverysocial', 'be queit');

-- create likes

INSERT INTO Likes VALUES('http://www.kthsocial', 2);
INSERT INTO Likes VALUES('http://www.kthsocial', 3);
INSERT INTO Likes VALUES('http://www.kthsocial', 4);
INSERT INTO Likes VALUES('http://www.kthunsocial', 1);
INSERT INTO Likes VALUES('http://www.kthverysocial', 1);
INSERT INTO Likes VALUES('http://www.kthverysocial', 4);

-- create event
INSERT INTO Events VALUES(1, 1, 'party', 'hemma', '2026-07-21 18:00:00', '2026-07-22 01:00:01');

-- create attendants
INSERT INTO EventAttendents VALUES(1, 2);
INSERT INTO EventAttendents VALUES(1, 5);

-- create subscriptions
INSERT INTO Subscriptions VALUES(1, '2026-07-21 18:00:00', 1, 'Swish');
INSERT INTO Subscriptions VALUES(2, '2026-07-22 18:00:00', 2, 'Klarna');
INSERT INTO Subscriptions VALUES(3, '2026-08-21 18:00:00', 3, 'Swish');
INSERT INTO Subscriptions VALUES(4, '2026-08-21 18:00:00', 1, 'Swish');
INSERT INTO Subscriptions VALUES(5, '2025-01-01 18:00:00', 5, 'Card');
INSERT INTO Subscriptions VALUES(6, '2021-03-14 12:01:20', 6, 'Bitcoin');

-- Querying
SELECT fullName FROM Users;

SELECT * FROM Students;
SELECT * FROM Staffs; 

SELECT * FROM Friendships;

SELECT * FROM Posts;

SELECT * FROM Events;

SELECT * FROM Subscriptions;

SELECT * FROM Attachments WHERE fileExtention = 'mp4';



