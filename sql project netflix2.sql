-- NETFLIX Project--
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id       VARCHAR(6),
    type          VARCHAR(10), 
    title         VARCHAR(150),
    director      VARCHAR(208),
    casts         VARCHAR(1000),
    country       VARCHAR(150),
    date_added    VARCHAR(50),
    release_year  INT,
    rating        VARCHAR(10),
    duration      VARCHAR(15),
    listed_in     VARCHAR(100),
    description   VARCHAR(250)
);

SELECT * FROM netflix;


SELECT 
	COUNT(*) as total_content
FROM netflix;

SELECT
	DISTINCT type
FROM netflix;

--15 business problem--

-- 1. count the number of movies vs TV show--

SELECT
	TYPE,
	COUNT(*) as total_content
FROM netflix
GROUP BY TYPE

--2. find the most common rating for movies and TV shows

SELECT
	TYPE,
	rating
FROM
(
SELECT
	TYPE,
	rating,
	COUNT(*),
	--MAX(rating)
	RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1,2
) as t1
WHERE
	ranking = 1
--ORDER BY 1,3 DESC


-- 3. list all movies realised in a specific year in 2020
--filter 2020
--movies

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020

	
--4. NAME THE TOP 5 COUNTRIES WITH THE MOST CONTENT ON NETFLIX--

-- Query 1: Count shows per country
SELECT
    UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country;


SELECT
    UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;

-- identity the longest movie--

SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration)FROM netflix)
	

6. --find content added in the last 5 years

SELECT
	*
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'

7.-- FIND ALL THE MOVIES/TV SHOWS BY DIRECTOR 'RAJIV CHILAKA'--

SELECT * FROM netflix
WHERE director ILIKE '%rajiv chilaka%';


8.--LIST ALL THE TV SHOWS WITH MORE THAN 5 SEASON--


SELECT 
    *,
    CAST(SPLIT_PART(duration, ' ', 1) AS INT) AS seasons
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;


9.--COUNT THE NUMBERS OF CONTENTS ITEMS IN EACH GENRE--

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

10.-- find each year and the average numbers of content release by india on netflix 
return top 5 year with highest average content release.--

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS total_content,
    COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100 AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY year
ORDER BY year;

-- 11. list all the movies with documentries--

SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';


--12. find all the content without director--

SELECT * FROM netflix
WHERE
	director is NULL

-- 13. FIND HOW MANY MOVIES ACTOR 'SALMAN KHAN' APPEARED IN LAST 10 YEARS--

SELECT * 
FROM netflix
WHERE casts ILIKE '%salman khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


--14. FIND THE TOP 10 ACTOR WHO HAS APPEARED IN THE  HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA.--
SELECT
-- show__id,
-- casts,
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--15. categorize the content based on the presence of the keyboards
'kill' and 'voilence' in the description field.
label content conatining these keywords as 'bed'
and all other content as a 'good'. count how many items
fall into each category--

WITH new_table
AS
(
SELECT
*,
	CASE
	WHEN
		description ILIKE '%kill%' OR
		description ILIKE '%voilence%' THEN 'Bad_content'
		ELSE 'Good Content'
	END category
FROM netflix	
)
SELECT
	category,
	COUNT(*) as totaal_content
FROM new_table
GROUP BY 1

WHERE
	description ILIKE '%KILL%'
	OR
	description ILIKE '%voilence%'








