create database video_game_sales;

select count(*) as total_rows
from vgchartz_2024;

-- ============================================================
-- TASK: Data Quality Check
-- PURPOSE: Check for nulls and anomalies before analysing
-- DIFFICULTY: Beginner
-- ============================================================
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_titles,
    SUM(CASE WHEN total_sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN genre IS NULL THEN 1 ELSE 0 END) AS null_genre,
    SUM(CASE WHEN critic_score IS NULL THEN 1 ELSE 0 END) AS null_scores,
    MIN(total_sales) AS min_sales,
    MAX(total_sales) AS max_sales
FROM vgchartz_2024;

-- ============================================================
-- TASK 2: Top 10 Best Selling Games Worldwide
-- PURPOSE: Identify which titles drove the most revenue globally
-- DIFFICULTY: Beginner
-- ============================================================
SELECT 
    title,
    console,
    genre,
    ROUND(total_sales, 2) AS total_sales_millions
FROM vgchartz_2024
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- TASK 3: Best Year for Sales
-- PURPOSE: Identify peak years and whether industry is growing
-- DIFFICULTY: Beginner
-- ============================================================

SELECT 
    LEFT(release_date, 4) AS release_year,
    COUNT(*) AS total_games,
    ROUND(SUM(total_sales), 2) AS total_sales_millions
FROM vgchartz_2024
WHERE release_date IS NOT NULL
GROUP BY LEFT(release_date, 4)
ORDER BY total_sales_millions DESC
LIMIT 10;
-- ============================================================
-- TASK 4: Top Genre Per Console
-- PURPOSE: Understand if consoles specialise in particular genres
-- DIFFICULTY: Intermediate
-- ============================================================
SELECT 
    console,
    genre,
    COUNT(*) AS game_count,
    ROUND(SUM(total_sales), 2) AS total_sales
FROM vgchartz_2024
GROUP BY console, genre
ORDER BY console, total_sales DESC;

-- ============================================================
-- TASK: Investigate blank console records
-- PURPOSE: Understand how many records have missing console
--          data and decide how to handle them
-- DIFFICULTY: Beginner
-- ============================================================
SELECT 
    console,
    COUNT(*) AS game_count
FROM vgchartz_2024
WHERE console IS NULL OR console = ''
GROUP BY console;

-- ============================================================
-- TASK 4: Top Genre Per Console (Fixed)
-- PURPOSE: Understand if consoles specialise in particular 
--          genres — excluding records with missing console data
-- DIFFICULTY: Intermediate
-- ============================================================
SELECT 
    console,
    genre,
    COUNT(*) AS game_count,
    ROUND(SUM(total_sales), 2) AS total_sales
FROM vgchartz_2024
WHERE console IS NOT NULL AND console != ''
GROUP BY console, genre
ORDER BY console, total_sales DESC;

-- ============================================================
-- TASK: Replace blank console with Unknown
-- PURPOSE: Clean data without losing records — best practice
--          is to label missing data rather than delete it
-- DIFFICULTY: Beginner
-- ============================================================
UPDATE vgchartz_2024
SET console = 'Unknown'
WHERE console IS NULL OR console = '';



-- ============================================================
-- TASK 5: Regional Hits vs Flops
-- PURPOSE: Find games popular in one region but not another
-- DIFFICULTY: Intermediate
-- ============================================================
SELECT 
    title,
    console,
    ROUND(na_sales, 2) AS na_sales,
    ROUND(jp_sales, 2) AS jp_sales,
    ROUND(pal_sales, 2) AS pal_sales,
    ROUND(total_sales, 2) AS total_sales
FROM vgchartz_2024
WHERE na_sales > 3 AND jp_sales < 0.5
ORDER BY na_sales DESC
LIMIT 10;

-- ============================================================
-- TASK 6: Top Publishers by Total Sales
-- PURPOSE: Identify which publishers dominate the market
-- DIFFICULTY: Beginner
-- ============================================================
SELECT 
    publisher,
    COUNT(*) AS total_games,
    ROUND(SUM(total_sales), 2) AS total_sales_millions
FROM vgchartz_2024
GROUP BY publisher
ORDER BY total_sales_millions DESC
LIMIT 10;

-- ============================================================
-- TASK 7: Average Critic Score by Genre
-- PURPOSE: See which genres are rated highest by critics
-- DIFFICULTY: Beginner
-- ============================================================
SELECT 
    genre,
    COUNT(*) AS total_games,
    ROUND(AVG(critic_score), 2) AS avg_critic_score,
    ROUND(SUM(total_sales), 2) AS total_sales
FROM vgchartz_2024
WHERE critic_score IS NOT NULL
GROUP BY genre
ORDER BY avg_critic_score DESC;

-- ============================================================
-- TASK: Fix total_sales column — replace non-numeric values
-- PURPOSE: Clean sales data so Power BI can read it as numbers
-- DIFFICULTY: Beginner
-- ============================================================
UPDATE vgchartz_2024
SET total_sales = NULL
WHERE total_sales NOT REGEXP '^[0-9]+\.?[0-9]*$';

-- ============================================================
-- TASK: Fix all sales columns
-- PURPOSE: Remove non-numeric values from all sales columns
--          so Power BI can read them as decimal numbers
-- DIFFICULTY: Beginner
-- ============================================================
UPDATE vgchartz_2024 SET na_sales = NULL 
WHERE na_sales NOT REGEXP '^[0-9]+\.?[0-9]*$';

UPDATE vgchartz_2024 SET jp_sales = NULL 
WHERE jp_sales NOT REGEXP '^[0-9]+\.?[0-9]*$';

UPDATE vgchartz_2024 SET pal_sales = NULL 
WHERE pal_sales NOT REGEXP '^[0-9]+\.?[0-9]*$';

UPDATE vgchartz_2024 SET other_sales = NULL 
WHERE other_sales NOT REGEXP '^[0-9]+\.?[0-9]*$';


-- ============================================================
-- TASK: Replace blank genre with Unknown
-- PURPOSE: Clean genre data so slicers show no blank entries
-- DIFFICULTY: Beginner
-- ============================================================
UPDATE vgchartz_2024
SET genre = 'Unknown'
WHERE genre IS NULL OR genre = '';
