SELECT * FROM new_db.`youtube.csv`;

SELECT * FROM new_db.`youtube.csv` LIMIT 15;

SHOW DATABASES;

DESCRIBE new_db.`youtube.csv`;

SELECT *
FROM new_db.`youtube.csv`
LIMIT 5;

USE new_db;

SELECT 
    video_id,
    title,
    category_id,
    views,
    likes,
    dislikes
FROM `youtube.csv`
LIMIT 10;

SELECT video_id FROM `youtube.csv` LIMIT 5;

SELECT title, views FROM `youtube.csv` LIMIT 5;

SELECT title, views
FROM `youtube.csv`
ORDER BY views DESC
LIMIT 10;

SELECT category_id, SUM(views) AS total_views
FROM `youtube.csv`
GROUP BY category_id
ORDER BY total_views DESC;

SELECT 
    title,
    views,
    likes,
    dislikes,
    (likes - dislikes) AS engagement_score
FROM `youtube.csv`
ORDER BY engagement_score DESC
LIMIT 10;

SELECT title, views
FROM `youtube.csv`
WHERE comments_disabled = 'True';

SELECT *
FROM (
    SELECT 
        category_id,
        title,
        views,
        RANK() OVER (PARTITION BY category_id ORDER BY views DESC) AS category_rank
    FROM `youtube.csv`
) ranked_videos
WHERE category_rank <= 3;

WITH engagement AS (
    SELECT 
        title,
        views,
        likes,
        dislikes,
        comment_count,
        (likes + comment_count) - dislikes AS engagement_score
    FROM `youtube.csv`
)
SELECT *
FROM engagement
ORDER BY engagement_score DESC
LIMIT 10;

SELECT 
    title,
    views
FROM `youtube.csv`
WHERE views > (
    SELECT AVG(views) + 3 * STDDEV(views)
    FROM `youtube.csv`
)
ORDER BY views DESC;

SELECT 
    published_day_of_week,
    COUNT(*) AS video_count,
    AVG(views) AS avg_views
FROM `youtube.csv`
GROUP BY published_day_of_week
ORDER BY avg_views DESC;

WITH category_avg AS (
    SELECT 
        category_id,
        AVG(views) AS avg_category_views
    FROM `youtube.csv`
    GROUP BY category_id
),
video_perf AS (
    SELECT 
        y.video_id,
        y.title,
        y.category_id,
        y.views,
        c.avg_category_views,
        ROUND(y.views / c.avg_category_views, 2) AS performance_index
    FROM `youtube.csv` y
    JOIN category_avg c
        ON y.category_id = c.category_id
)
SELECT *
FROM video_perf
WHERE performance_index >= 3
ORDER BY performance_index DESC
LIMIT 10;

