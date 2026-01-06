--create table netflix

CREATE TABLE netflix (
    show_id VARCHAR2(10),
    type VARCHAR2(10),
    title VARCHAR2(300),
    director VARCHAR2(200),
    country VARCHAR2(100),
    date_added DATE,
    release_year NUMBER(4),
    rating VARCHAR2(15),
    duration VARCHAR2(20),
    listed_in VARCHAR2(300)
);
select * from netflix;


----check total records
SELECT COUNT(*) AS total_records
FROM netflix;

----Check NULL values
SELECT
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS null_director,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_rating
FROM netflix;


----Remove duplicates (if any)
SELECT show_id, COUNT(*)
FROM netflix
GROUP BY show_id
HAVING COUNT(*) > 1;

desc netflix;

--------------------------------------------------------------
---------------------------------------------------------------

--1.movies vs tv shows distribution
select type, count(*) as total from netflix group by type;
--This query calculates the total number of Movies and 
--TV Shows available on Netflix. It helps understand how Netflix’s
--content library is divided between movies and television shows.
---------------------------------------------------------------

--2.content added over the years
SELECT
    EXTRACT(YEAR FROM date_added_dt) AS year_added,
    COUNT(*) AS total_content
FROM netflix
WHERE date_added_dt IS NOT NULL
GROUP BY EXTRACT(YEAR FROM date_added_dt)
ORDER BY year_added;
--This query analyzes how Netflix content has grown over time by 
--counting the number of titles added each year. 
--It highlights Netflix’s expansion trend across different years.
---------------------------------------------------------------

--3 top 10 countries with most content
SELECT *
FROM (
    SELECT country, COUNT(*) AS total
    FROM netflix
    GROUP BY country
    ORDER BY total DESC
)
WHERE ROWNUM <= 10;
--This query identifies the top 10 countries that have 
--contributed the highest number of titles to Netflix. 
--It helps understand which countries are the largest content producers on the platform.
-----------------------------------------------------------------

--4 rating distribution
SELECT rating, COUNT(*) AS total
FROM netflix
GROUP BY rating
ORDER BY total DESC;
--This query shows the distribution of Netflix titles based on 
--content ratings such as TV-MA, TV-14, PG-13, etc. It provides insight
--into the type of audience Netflix content is mainly targeted toward.
-----------------------------------------------------------------

-- 5: Monthly Content Release Trend

SELECT
    TO_CHAR(date_added_dt, 'Month') AS month_name,
    EXTRACT(MONTH FROM date_added_dt) AS month_num,
    COUNT(*) AS total
FROM netflix
WHERE date_added_dt IS NOT NULL
GROUP BY
    TO_CHAR(date_added_dt, 'Month'),
    EXTRACT(MONTH FROM date_added_dt)
ORDER BY month_num;
--This query analyzes the number of Netflix titles added
--in each month. It helps identify seasonal patterns and months when Netflix releases more content.
-----------------------------------------------------------------

-- 6: Top 10 Genres
SELECT *
FROM (
    SELECT listed_in, COUNT(*) AS total
    FROM netflix
    GROUP BY listed_in
    ORDER BY total DESC
)
WHERE ROWNUM <= 10;
--This query identifies the top 10 most common genres
--(or genre combinations) available on Netflix based on the listed categories. 
--It highlights the most popular content genres on the platform.
---------------------------------------------------------------

--7: Top 10 Directors
SELECT *
FROM (
    SELECT director, COUNT(*) AS total_titles
    FROM netflix
    WHERE director IS NOT NULL
    AND director <> 'Unknown'
    GROUP BY director
    ORDER BY total_titles DESC
)
WHERE ROWNUM <= 10;
--This query finds the top 10 directors with the highest
--number of titles on Netflix. It helps identify 
--directors who have contributed the most content to the platform.
-----------------------------------------------------------------

--8.Movies released after 2015
SELECT COUNT(*)
FROM netflix
WHERE type = 'Movie'
AND release_year > 2015;
--This query counts the number of movies on Netflix that were
--released after the year 2015. It 
--helps analyze Netflix’s focus on newer movie content in recent years.
--------------------------------------------------------------------

--9..Oldest content on Netflix
SELECT *
FROM (
    SELECT title, release_year
    FROM netflix
    ORDER BY release_year
)
WHERE ROWNUM = 1;

--This query identifies the oldest title available on Netflix based on
--the release year.It provides insight into how far back Netflix’s content library goes.
--------------------------------------------------------------------

--10 Content by India
SELECT type, COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY type;
--This query analyzes Netflix content originating from India by
--counting the number of Movies and TV Shows.
--It helps understand India’s contribution to Netflix’s content library.
--------------------------------------------------------------------
