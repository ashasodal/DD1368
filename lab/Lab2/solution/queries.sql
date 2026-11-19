SET search_path TO kthsocial;

-- Task 1
SELECT 
    Post.title, 
    STRING_AGG(PostTag.Tag, ',') 
FROM Post
LEFT JOIN PostTag ON Post.PostURL = PostTag.PostURL
GROUP BY Post.title
ORDER BY Post.title;

-- Task 2

WITH TempTable AS (
    SELECT 
        Post.PostURL, 
        Post.title, 
        RANK () OVER (ORDER BY COUNT(Likes.PostURL) DESC) as rank
    FROM Post
    LEFT JOIN Likes ON Post.PostURL = Likes.PostURL
    LEFT JOIN PostTag ON Post.PostURL = PostTag.PostURL
    WHERE PostTag.Tag = '#leadership'
    GROUP BY Post.PostURL
    ORDER BY rank, Post.title
)
SELECT * 
From TempTable
WHERE rank <= 5;

-- Task 3

SELECT 
    Users.name, 
    COUNT(Likes.PostURL) >= 50 AS postLikes
From Users
LEFT JOIN Post ON Post.UserID = Users.UserID
LEFT JOIN Likes ON Post.PostURL = Likes.PostURL
WHERE DATE_PART('month', Post.Timestamp) = 3
GROUP BY Users.name
ORDER BY Users.name;

-- Task 4

SELECT 
    Users.name, 
    EVERY (Friend.UserID IS NOT NULL OR Friend.FriendID IS NOT NULL), 
    MIN(Subscription.DateOfPayment) AS RegistrationDate
FROM Users
LEFT JOIN Friend ON Users.UserID IN (Friend.UserID, Friend.FriendID) --Behöver inte ha någon vän
JOIN Subscription ON Users.UserID = Subscription.UserID
GROUP BY Users.name
HAVING DATE_PART('month', MIN(Subscription.DateOfPayment)) = 1
ORDER BY Users.name;

-- Task 5

WITH RECURSIVE friendchain AS (
    SELECT 
        Users.name, 
        Users.userID,
        Friend.FriendID,
        1 AS pos
    FROM Users
    LEFT JOIN Friend ON Users.UserID = Friend.UserID
    WHERE Users.UserID = 20
    UNION
    SELECT
        Users.name, 
        Users.userID, 
        Friend.FriendID,
        friendchain.pos + 1 AS pos

    From Users
    LEFT JOIN Friend ON Users.UserID = Friend.UserID
    INNER JOIN friendchain ON friendchain.FriendID = Users.UserID
)

SELECT         
    friendchain.name, 
    friendchain.userID, 
    friendchain.FriendID 
FROM friendchain
ORDER BY pos;

-- Task p+

WITH firstPayment AS (
    Select 
        Users.userID, 
        MIN(Subscription.DateOfPayment) AS firstPayment
    FROM Users
    LEFT JOIN Subscription ON Users.userID = Subscription.userID 
    GROUP BY Users.userID
)

SELECT 
    week, 
    (
        SELECT COUNT(firstPayment.userID) 
        FROM firstPayment
        WHERE DATE_PART('week', firstPayment.firstPayment) = week
    ) AS new_customers, 
    (
        SELECT COUNT(Subscription.userID)
        FROM Subscription
        LEFT JOIN firstPayment ON Subscription.userID = firstPayment.userID
        WHERE DATE_PART('week', Subscription.DateOfPayment) = week AND NOT Subscription.DateOfPayment = firstPayment.firstPayment
    ),
    (
        SELECT COUNT(Post.UserID) 
        FROM Post
        WHERE DATE_PART('week', Post.Timestamp) = week
    )

FROM generate_series(1, 30) as week;