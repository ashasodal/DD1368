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
    EVERY (Friend.UserID IS NOT NULL)
FROM Users
LEFT JOIN Friend ON USERS.UserID = Friend.UserID
GROUP BY Users.name
ORDER BY Users.name;