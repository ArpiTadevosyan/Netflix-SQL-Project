USE NetflixDB;

--1. Total counts of movies and TV shows
SELECT type, COUNT(*) AS total_count
FROM netflix_titles
GROUP BY type;

--2. TOP 10 release years with most content
SELECT TOP 10 release_year, COUNT(*) AS content_count
FROM netflix_titles
GROUP BY release_year
ORDER BY content_count DESC;

--3. TOP 5 directors with most movies
SELECT TOP 5 director, COUNT(*) AS total_movies
FROM netflix_titles
WHERE director <> 'Unknown' AND type = 'Movie'
GROUP BY director
ORDER BY total_movies DESC;

--4. TOP 10 most active actors
SELECT TOP 10 
    c.actor_name, 
    COUNT(*) AS total_projects
FROM netflix_titles t
JOIN netflix_cast c ON t.show_id = c.show_id
GROUP BY c.actor_name
ORDER BY total_projects DESC;


--5. TOP 10 countries with most content
SELECT TOP 10 country, COUNT(*) AS content_count
FROM netflix_titles
WHERE country <> 'Unknown'
GROUP BY country
ORDER BY content_count DESC;

--6. Titles and their genres
SELECT TOP 20 t.title, t.type, g.genre_name
FROM netflix_titles t
JOIN netflix_genres g ON t.show_id = g.show_id;

--7. Ranking genres by popularity 
WITH genre_counts AS (
    SELECT 
        genre_name,
        COUNT(*) AS total_shows
    FROM netflix_genres
    GROUP BY genre_name
)
SELECT 
    genre_name,
    total_shows,
    DENSE_RANK() OVER (ORDER BY total_shows DESC) AS popularity_rank
FROM genre_counts;

--8. TOP 10 oldest movies and TV shows
SELECT TOP 10 
    title, 
    type, 
    release_year, 
    country
FROM netflix_titles
ORDER BY release_year ASC;

--9. Count of movies and TV shows by each genre
SELECT 
    g.genre_name,
    COUNT(CASE WHEN t.type = 'Movie' THEN 1 END) AS movie_count,
    COUNT(CASE WHEN t.type = 'TV Show' THEN 1 END) AS tv_show_count
FROM netflix_titles t
JOIN netflix_genres g ON t.show_id = g.show_id
GROUP BY g.genre_name
ORDER BY movie_count DESC;

--10. TOP 3 actors for each genre
WITH actor_genre_count AS (
    SELECT 
        g.genre_name,
        c.actor_name,
        COUNT(*) AS movie_count,
        DENSE_RANK() OVER (PARTITION BY g.genre_name ORDER BY COUNT(*) DESC) AS actor_rank
    FROM netflix_titles t
    JOIN netflix_cast c ON t.show_id = c.show_id
    JOIN netflix_genres g ON t.show_id = g.show_id
    GROUP BY g.genre_name, c.actor_name
)
SELECT 
    genre_name,
    actor_name,
    movie_count
FROM actor_genre_count
WHERE actor_rank <= 3
ORDER BY genre_name, actor_rank;

--11. Most frequent actor duos
SELECT 
    a.actor_name AS Actor_1, 
    b.actor_name AS Actor_2, 
    COUNT(*) AS movies_together
FROM netflix_cast a
JOIN netflix_cast b ON a.show_id = b.show_id AND a.actor_name < b.actor_name
GROUP BY a.actor_name, b.actor_name
HAVING COUNT(*) > 1
ORDER BY movies_together DESC;

--12. Duration of movies
WITH movie_durations AS (
    SELECT 
        show_id,
        title,
        release_year,
        CAST(REPLACE(duration, ' min', '') AS INT) AS duration_minutes
    FROM netflix_titles
    WHERE type = 'Movie' AND duration LIKE '%min%'
)
SELECT
    CASE
        WHEN duration_minutes < 60 THEN 'Short (< 1 hour)'
        WHEN duration_minutes BETWEEN 60 AND 120 THEN 'Medium (1 - 2 hours)'
        ELSE 'Long ( > 2 hours)'
    END AS duration_category,
    COUNT(*) AS Total_Movies,
    MIN(duration_minutes) AS Min_Minutes,
    MAX(duration_minutes) AS Max_Minutes,
    AVG(duration_minutes) AS Avg_Minutes
FROM movie_durations
GROUP BY
    CASE
        WHEN duration_minutes < 60 THEN 'Short (< 1 hour)'
        WHEN duration_minutes BETWEEN 60 AND 120 THEN 'Medium (1 - 2 hours)'
        ELSE 'Long ( > 2 hours)'
    END
ORDER BY Total_Movies DESC;

--Indexes
CREATE INDEX idx_netflix_cast_show_id ON netflix_cast(show_id);
CREATE INDEX idx_netflix_genres_show_id ON netflix_genres(show_id);




