CREATE TABLE Users(
       UserID INTEGER PRIMARY KEY,
       name varchar(50)
);

CREATE TABLE Staff(
       UserID INTEGER REFERENCES Users(UserID),
       Department Varchar(100)
);

CREATE TABLE Student(
       UserID INTEGER REFERENCES Users(UserID),
       Programme Varchar(100),
       EnrollmentYear INTEGER
);

CREATE TABLE Friend(
       UserID INTEGER REFERENCES Users(UserID),
       FriendID INTEGER REFERENCES Users(UserID),
       PRIMARY KEY (UserID, FriendID)
);

CREATE TABLE Post(
       PostURL VARCHAR(100) PRIMARY KEY,
       Timestamp TIMESTAMP,
       UserID INTEGER,
       Title VARCHAR(200),
       Place VARCHAR(200),
       BodyText TEXT
);

CREATE TABLE PostTag
       (PostURL VARCHAR(100),
       Tag varchar(50),
       PRIMARY KEY (PostURL, Tag),
       CONSTRAINT id
           FOREIGN KEY(PostURL)
                   REFERENCES Post(PostURL)
);

CREATE TABLE Likes(
       UserID INTEGER REFERENCES Users(UserID),
       PostURL VARCHAR(100) REFERENCES Post(PostURL),
       Timestamp TIMESTAMP,
       PRIMARY KEY (UserID, PostURL)
);

CREATE TABLE Event(
       EventID INTEGER PRIMARY KEY,
       Place Varchar(200),
       StartTime TIMESTAMP,
       EndTime TIMESTAMP,
       creatorID INTEGER REFERENCES Users(UserID),
       Title Varchar(200)
);

CREATE TABLE attending(
       UserID INTEGER REFERENCES Users(UserID),
       EventID INTEGER REFERENCES Event(EventID),
       PRIMARY KEY(UserID, EventID)
);


CREATE TABLE Subscription(
       SubscriptionID INTEGER,
       PaymentMethod Varchar(200),
       UserID INTEGER REFERENCES Users(UserID),
       DateOfPayment DATE,
       ExpiryDate DATE,
       PRIMARY KEY (SubscriptionID)
);

CREATE TABLE Attachment(
       PostURL VARCHAR(100) REFERENCES Post(PostURL),
       AttachmentIndex INTEGER,
       FileExtension VARCHAR(10),
       FileSize INTEGER,
       PRIMARY KEY (PostURL, AttachmentIndex)
);

--drop table users,staff,student,friend,post,posttag,likes,event,attending,subscription,attachment;
