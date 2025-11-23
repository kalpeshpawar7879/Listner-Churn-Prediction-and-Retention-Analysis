create database Music_Business;

-- 1. Select all users from the users table.
SELECT 
    *
FROM
    users;
    
-- 2. Select user_id and country from users.
SELECT 
    user_id, country
FROM
    users;
    
-- 3. List all songs with title and artist.
SELECT 
    title, artist
FROM
    songs;
    
-- 4. Show all subscriptions and their payment method.
SELECT 
    subscription_id, payment_method
FROM
    subscriptions;
    
-- 5. Select listening_history, user_id for user_id = 1.
SELECT 
    history_id, user_id
FROM
    listening_history
WHERE
    user_id = 1;
    
-- 6. List users from USA or UK. 
SELECT 
    *
FROM
    users
WHERE
    country IN ('USA' , 'UK');
    
-- 7. Find subscriptions with auto_renew = TRUE. 
SELECT 
    *
FROM
    subscriptions
WHERE
    auto_renew = 'TRUE';
    
-- 8. List songs longer than 300 seconds. 
SELECT 
    *
FROM
    songs
WHERE
    duration > 300;
    
-- 9. Find listening_history with duration_played < 50. 
SELECT 
    *
FROM
    listening_history
WHERE
    duration_played < 50;
    
-- 10. Count number of users per country.
SELECT 
    country, COUNT(*) AS user_count
FROM
    users
GROUP BY country;

-- 11. Average duration of songs per genre. 
SELECT 
    genre, AVG(duration) AS avg_duration
FROM
    songs
GROUP BY genre;

-- 12. Total listening time per user. 
SELECT 
    user_id, SUM(duration_played) AS total_listening
FROM
    listening_history
GROUP BY user_id;

-- 13. Count of subscriptions per payment_method.
SELECT 
    payment_method, COUNT(*) AS total_count
FROM
    subscriptions
GROUP BY payment_method;

-- 14. Max duration_played per user.
SELECT 
    user_id, SUM(duration_played) AS max_played
FROM
    listening_history
GROUP BY user_id;

-- 15 Min song duration per artist.
SELECT 
    artist, MIN(duration) AS min_played
FROM
    songs
GROUP BY artist;

-- 16. Number of skipped songs per user. 
SELECT 
    user_id, COUNT(*) AS skipped_songs
FROM
    listening_history
WHERE
    skipped = 'true'
GROUP BY user_id;

-- 17. Average duration_played of skipped songs.
SELECT 
    AVG(duration_played) AS avg_skipped_duration
FROM
    listening_history
WHERE
    skipped = 'true';
    
-- 18. Count of users per subscription_type 
SELECT 
    subscription_type, COUNT(*) AS total_user
FROM
    users
GROUP BY subscription_type;

-- 19. User with exactly 10 listening sessions. 
SELECT 
    user_id, COUNT(*) AS total_sessions
FROM
    listening_history
GROUP BY user_id
HAVING COUNT(*) = 10;

-- 20.List users by signup_date descending. 
SELECT 
    *
FROM
    users
ORDER BY signup_date DESC;

-- 21. Songs by duration ascending.
SELECT 
    *
FROM
    songs
ORDER BY duration;

-- 22. Top 5 users by total listening time.
SELECT 
    user_id, SUM(duration_played) AS total_listening
FROM
    listening_history
GROUP BY user_id
ORDER BY SUM(duration_played) DESC
LIMIT 5;

-- 23. Artist with most songs, descending. 
SELECT 
    artist, COUNT(*) AS total_songs
FROM
    songs
GROUP BY artist
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 24. Listening sessions sorted by timestamp descending.
SELECT 
    *
FROM
    listening_history
ORDER BY timestamp DESC;

-- 25. Find songs where title starts with 'S'. 
SELECT 
    *
FROM
    songs
WHERE
    title LIKE 'S%';
    
-- 26. Find users from countries ending with 'a'. 
SELECT 
    *
FROM
    users
WHERE
    country LIKE '%a';
    
-- 27. Uppercase all artist names in query. 
SELECT 
    UPPER(artist)
FROM
    songs;
    
-- 28. Length of song title.
SELECT 
    title AS song_title, LENGTH(title) AS total_length
FROM
    songs;
    
-- 29. Concatenate artist and song title.
SELECT 
    CONCAT(artist, '-', title) AS full_title
FROM
    songs;
    
-- 30. Users who signed up in the last 30 days.
SELECT 
    *
FROM
    users
WHERE
    signup_date >= CURRENT_DATE() - INTERVAL 30 DAY;

-- 31. Listening sessions in January 2023. 
SELECT 
    *
FROM
    listening_history
WHERE
    timestamp BETWEEN '2023-01-01' AND '2023-01-31';

-- 32. Month of subscription start. 
SELECT 
    user_id, MONTH(start_date) AS subscription_month
FROM
    subscriptions;
    
-- 33. Days since last listening session per user. 
SELECT 
    user_id,
    DATEDIFF(CURRENT_DATE(), MAX(timestamp)) AS days_inactive
FROM
    listening_history
GROUP BY user_id;

-- 34. Number of listening sessions per week.
SELECT 
    YEAR(timestamp) year_,
    WEEK(timestamp) AS week_,
    COUNT(*) AS sessions
FROM
    listening_history
GROUP BY year_ , week_;

-- 35. List all users with their subscription info (INNER JOIN). 
SELECT 
    u.user_id,
    u.subscription_type,
    s.subscription_id,
    s.payment_method,
    s.auto_renew
FROM
    users u
        INNER JOIN
    subscriptions s ON u.user_id = s.user_id;
    
-- 36. List all listening history with song titles (INNER JOIN).
SELECT 
    l.user_id, l.song_id, l.duration_played, s.title
FROM
    listening_history l
        INNER JOIN
    songs s ON l.song_id = s.song_id;
    
-- 37. Songs without any listening history (LEFT JOIN)
SELECT 
    s.song_id, s.title
FROM
    songs s
        LEFT JOIN
    listening_history lh ON s.song_id = lh.song_id
WHERE
    lh.song_id IS NULL;

-- 38. Count of listening sessions per song (INNER JOIN).
SELECT 
    s.title, COUNT(*) AS total_session
FROM
    songs s
        INNER JOIN
    listening_history lh ON s.song_id = lh.song_id
GROUP BY s.title;

-- 39.  Users and their total skipped songs (LEFT JOIN). 
SELECT 
    u.user_id, COUNT(lh.user_id) AS skipped_songs
FROM
    users u
        LEFT JOIN
    listening_history lh ON u.user_id = lh.user_id
        AND lh.skipped = TRUE
GROUP BY u.user_id;

-- 40.Total listening time per user using SUM() OVER().
SELECT 
    user_id, 
    SUM(duration_played) OVER (PARTITION BY user_id) AS total_listening;
    
-- 41.Row number of listening sessions per user.
SELECT 
    user_id,
    history_id,
    ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY `timestamp`
    ) AS session_order
FROM listening_history;

-- 42. Rank users by total listening time.
SELECT 
    user_id,
    SUM(duration_played) AS total_listening,
    RANK() OVER (
        ORDER BY SUM(duration_played) DESC
    ) AS listening_rank
FROM listening_history
GROUP BY user_id;

-- 43. Average listening duration per user using window function.
SELECT
    user_id,
    duration_played,
    AVG(duration_played) OVER (
        PARTITION BY user_id
    ) AS avg_listening_duration
FROM listening_history;

-- 44.Cumulative listening duration per user.
SELECT 
    user_id,
    `timestamp`,
    SUM(duration_played) OVER (
        PARTITION BY user_id
        ORDER BY `timestamp`
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_duration
FROM listening_history;

-- 45. Average listening duration over last 5 sessions per user.
SELECT
    user_id,
    duration_played,
    AVG(duration_played) OVER (
        PARTITION BY user_id
        ORDER BY `timestamp`
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS avg_last_5
FROM listening_history;

-- 46. Users from USA or Premium subscribers (UNION).
SELECT 
    user_id, 
    country
FROM users 
WHERE country = 'USA'

UNION

SELECT 
    user_id, 
    country
FROM users 
WHERE subscription_type = 'Premium';

-- 47. All songs from Pop or Rock genres (UNION ALL).
SELECT 
    title, 
    genre 
FROM songs 
WHERE genre = 'Pop'

UNION ALL

SELECT 
    title, 
    genre 
FROM songs 
WHERE genre = 'Rock';

-- 48. Users who did not skip songs INTERSECT with Premium users.
SELECT 
    user_id
FROM listening_history
WHERE skipped = FALSE
  AND user_id IN (
        SELECT user_id
        FROM users
        WHERE subscription_type = 'Premium'
    );

-- 49. Users in India but not Premium (EXCEPT / MINUS).
SELECT 
    user_id
FROM users
WHERE country = 'India'
  AND user_id NOT IN (
        SELECT user_id
        FROM users
        WHERE subscription_type = 'Premium'
    );

-- 50. Users active in last 30 days OR premium users (UNION). 
SELECT 
    user_id
FROM users
WHERE is_active = TRUE

UNION

SELECT 
    user_id
FROM users
WHERE subscription_type = 'Premium';







