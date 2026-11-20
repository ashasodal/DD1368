


------


-- 1. 

SELECT
    title,
    STRING_AGG(tag, ', ') AS tags
FROM Post
LEFT JOIN PostTag
    ON Post.PostURL = PostTag.PostURL
GROUP BY Post.postURL
ORDER BY title ASC;

-------


-- 2.


-- Rank the top 5 posts of all time with the tag #leadership.
-- Rank them based on how many likes each post has received.
-- Posts with the same number of likes get the same rank.
-- Include all posts ranked 1 to 5, even if we get more than 5 posts.


WITH ranked_posts AS (
    SELECT
        Post.PostURL,
        Post.title,
        RANK() OVER (
            ORDER BY COUNT(Likes.UserID) DESC
        ) AS rank
    FROM Post
    JOIN PostTag
        ON Post.PostURL = PostTag.PostURL
    LEFT JOIN Likes
        ON Post.PostURL = Likes.PostURL
    WHERE PostTag.Tag = '#leadership'
    GROUP BY Post.PostURL
)
SELECT *
FROM ranked_posts
WHERE rank <= 5
ORDER BY rank ASC, title ASC;

-----

-- 3.

-- Show all users who made at least one post in March.
-- Show their name and true if their posts from March got at least 50 likes in total, otherwise false.

SELECT
    Users.Name,
    COUNT(Likes.userid) >= 50 AS received_likes
FROM Users
JOIN Post
    ON Users.UserID = Post.UserID
LEFT JOIN Likes
    ON Post.PostURL = Likes.PostURL
WHERE DATE_PART('month', Post.Timestamp) = 3
GROUP BY Users.UserID
ORDER BY Users.Name;

---
-- 4.

-- Show users whose first subscription payment was in January.
-- Show their name, if they have at least one friend (true/false),and their registration date.

SELECT
    Users.Name,
    NOT EVERY(Friend.UserID IS NULL) AS has_friend,
    MIN(Subscription.DateOfPayment) AS registration_date
FROM Users
-- don't include users that does NOT have a subscription
JOIN Subscription
    ON Users.UserID = Subscription.UserID
LEFT JOIN Friend
    ON Users.UserID = Friend.UserID
    OR Users.UserID = Friend.FriendID
GROUP BY Users.UserID
-- First, we want to find when each user subscribed for the first time.
-- Then we check if that date was in January, as the task asks.
HAVING DATE_PART('month', MIN(Subscription.DateOfPayment)) = 1
ORDER BY Users.Name ASC;

------------

-- 5.

WITH RECURSIVE friend_chain AS (

-- anchor query 
    SELECT
        Users.Name,
        Users.UserID,
        Friend.FriendID,
        1 AS pos
    FROM Users
    LEFT JOIN Friend
        ON Users.UserID = Friend.UserID
    WHERE Users.UserID = 20

    UNION 
-- recursive query
    SELECT
        Users.Name,
        Users.UserID,
        Friend.FriendID,
        friend_chain.pos + 1 AS pos
    FROM friend_chain
    JOIN Users
        ON friend_chain.FriendID = Users.UserID
    LEFT JOIN Friend
        ON Users.UserID = Friend.UserID
)
SELECT 
Name, 
UserID AS user_id, 
FriendID AS friend_id
FROM friend_chain
ORDER BY pos ASC;

-------

-- Show a weekly report from week 1 to 30.
-- Show how many users subscribed for the first time each week.
-- Count all later subscription payments as renewals.
-- Show the activity (number of posts created each week).


 -- P+ 

WITH firstPayment AS (
    Select 
        Users.userID, 
        MIN(Subscription.DateOfPayment) AS firstPayment
    FROM Users
    JOIN Subscription ON Users.userID = Subscription.userID 
    GROUP BY Users.userID
)

SELECT 
    week, 
    (
        SELECT COUNT(*) 
        FROM firstPayment
        WHERE DATE_PART('week', firstPayment.firstPayment) = week
    ) AS new_customers, 
    (
        SELECT COUNT(*)
        FROM Subscription
        JOIN firstPayment 
        ON Subscription.userID = firstPayment.userID
        WHERE DATE_PART('week', Subscription.DateOfPayment) = week AND NOT Subscription.DateOfPayment = firstPayment.firstPayment
    ) AS kept_customers,
    (
        SELECT COUNT(*) 
        FROM Post
        WHERE DATE_PART('week', Post.Timestamp) = week
    ) AS activity

FROM generate_series(1, 30) as week
ORDER BY week ASC;





