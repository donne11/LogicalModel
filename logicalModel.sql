-- Part 2
DROP SCHEMA IF EXISTS hw3_DonnellWeldon;
CREATE SCHEMA IF NOT EXISTS hw3_DonnellWeldon;
USE hw3_DonnellWeldon;
-- have to drop database // easier to run each query once // drop then use it 
DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS Tweets;
DROP TABLE IF EXISTS Followers;
DROP TABLE IF EXISTS Twitter_User;
DROP TABLE IF EXISTS Tweets_With_Hashtag;
DROP TABLE IF EXISTS Hashtag;



-- a table to represent a Twitter_User
CREATE TABLE Twitter_User (
    Twitter_User_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Twitter_Handle VARCHAR(75) UNIQUE NOT NULL,
    Profile_Picture BLOB,
    Email_Address VARCHAR(100) UNIQUE NOT NULL,
    Twitter_User_Password VARCHAR(50) NOT NULL,
    Short_Bio VARCHAR(255),
    Private BOOLEAN -- account private or not 
);

-- a table to represent a Tweets 
CREATE TABLE Tweets (
    Tweets_ID INT AUTO_INCREMENT PRIMARY KEY,
    Twitter_User_ID INT,
    Post_Type VARCHAR(160), -- this can be a one of : "Tweets" , image, video
    Content BLOB, 
    Time_Of_Post DATETIME,
	FOREIGN KEY (Twitter_User_ID) REFERENCES Twitter_User(Twitter_User_ID)
);

-- a table to represent a hastag
CREATE TABLE Hashtag (
    Hashtag_ID INT AUTO_INCREMENT PRIMARY KEY,
    Tag VARCHAR(255) UNIQUE NOT NULL
);

-- a table to represent a Tweets with a hastag
CREATE TABLE IF NOT EXISTS Tweets_With_Hashtag (
	Tweets_With_Hashtag_ID INT AUTO_INCREMENT PRIMARY KEY,
    Tweets_ID INT,
    Hashtag_ID INT,
    FOREIGN KEY (Tweets_ID) REFERENCES Tweets(Tweets_ID),
    FOREIGN KEY (Hashtag_ID) REFERENCES Hashtag(Hashtag_ID)
);

-- a table to represent likes 
CREATE TABLE IF NOT EXISTS Likes (
    Like_ID INT AUTO_INCREMENT PRIMARY KEY,
    Twitter_User_ID INT,
    Tweets_ID INT,
    FOREIGN KEY (Twitter_User_ID) REFERENCES Twitter_User(Twitter_User_ID),
    FOREIGN KEY (Tweets_ID) REFERENCES Tweets(Tweets_ID)
);

-- a table to represent followers
CREATE TABLE IF NOT EXISTS Followers (
    Follower_ID INT AUTO_INCREMENT PRIMARY KEY,
    Follower_Twitter_User_ID INT,
    Followed_Twitter_User_ID INT,
    FOREIGN KEY (Follower_Twitter_User_ID) REFERENCES Twitter_User(Twitter_User_ID),
    FOREIGN KEY (Followed_Twitter_User_ID) REFERENCES Twitter_User(Twitter_User_ID)
);

-- data for Twitter_Users 
INSERT INTO  Twitter_User (First_Name, Last_Name, Twitter_Handle, Profile_Picture, Email_Address, Twitter_User_Password, Short_Bio, Private)
VALUES
    ("Donnell", "Weldon", "donne11", NULL, "weldon.do@northeastern.edu", "canttellyou", "hello twitter", 1),
    ("Prof", "Doe", "J_Racch1", NULL, "Pro.rachlin@aol.com", "easy123", "welcome to CS3200", 0),
    ("Olivia", "Litle-Jon", "OlivEUh", NULL, "olivia@gmail.com", "Twitter_User_Password321", "Class of 2026", 1),
    ("Mahima", "Ramesh", "mram", NULL, "mRamesh@gmail.com", "slay123", "#NEU", 0);

-- data for Tweetss
INSERT INTO Tweets (Twitter_User_ID, Post_Type, Content, Time_Of_Post)
VALUES
    (1, "Tweets", "Hope you're getting paid well for grading this", "2023-10-24 04:11:32"),
    (2, "Tweets", "Just tryna make it to the weekend", "2020-08-20 07:07:07"),
    (3, "Tweets", "let's skip over my mistake ;)", NOW()),
    (4, "Tweets", "this homework keeps playing w/ me but #NEU hashtag!", NOW());
    
-- data for hashtags
INSERT INTO Hashtag (Tag)
VALUES ("#WhyAmIACSMajor"), ("#IceSpice"), ("#Munch"), ("Slay"), ("#NEU");

-- data for tweets with hashtags
INSERT INTO Tweets_With_Hashtag (Tweets_ID, Hashtag_ID)
VALUES
    (4, 1);

-- data for likes 
INSERT INTO Likes (Twitter_User_ID, Tweets_ID)
VALUES (1, 1), (2, 2), (3, 3), (4, 1), (4, 2), (4, 4);

-- data for followers
INSERT INTO Followers (Follower_Twitter_User_ID, Followed_Twitter_User_ID)
VALUES (2, 1), (3, 1), (3, 2),(4, 1), (4, 2);


-- PART 3  
-- ISSUES WITH B AND F

-- A
SELECT Followed_Twitter_User_ID, COUNT(*) AS Most_Followers
FROM Followers
GROUP BY Followed_Twitter_User_ID
ORDER BY Most_Followers DESC
LIMIT 1;


-- B
SELECT T.Tweets_ID, T.Twitter_User_ID, T.Post_Type, T.Content, T.Time_Of_Post
FROM Tweets T
WHERE T.Twitter_User_ID = 1
  AND T.Post_Type = "Tweets"
  AND T.Content LIKE "%#NEU%" 
ORDER BY T.Time_Of_Post DESC
LIMIT 5;

-- C
SELECT Hashtag_ID, COUNT(*) AS Number_of_Uses
FROM Tweets_With_Hashtag
GROUP BY Hashtag_ID
ORDER BY Number_of_Uses DESC;

-- D
SELECT Tweets_ID, COUNT(*) AS Number_Of_Hashtag
FROM Tweets
WHERE Content LIKE "%#%"
GROUP BY Tweets_ID;

-- E
SELECT Tweets.Tweets_ID, Tweets.Content, Tweets.Time_Of_Post, (
    SELECT COUNT(*)
    FROM Likes
    WHERE Likes.Tweets_ID = Tweets.Tweets_ID) AS Number_Of_Likes
FROM Tweets
ORDER BY Number_Of_Likes DESC
LIMIT 1;

-- F
SELECT T.Tweets_ID, T.Twitter_User_ID, T.Post_Type, T.Content, T.Time_Of_Post
FROM Tweets T
WHERE T.Twitter_User_ID IN (
    SELECT Followed_Twitter_User_ID
    FROM Followers
    WHERE Follower_Twitter_User_ID = 1) -- replaced w/ user ID user ID
ORDER BY T.Time_Of_Post DESC;

