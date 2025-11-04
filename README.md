# SQL Case Study: World's Famous Paintings<br><br>

## I. Table of Contents
  [SQL Case Study: World's Famous Paintings](#sql-case-study-worlds-famous-paintings)
- [SQL Case Study: World's Famous Paintings](#sql-case-study-worlds-famous-paintings)
  - [I. Table of Contents](#i-table-of-contents)
  - [II. Overview](#ii-overview)
  - [III. Dataset](#iii-dataset)
  - [IV. Objectives](#iv-objectives)
  - [V. Key Analyses](#v-key-analyses)
    - [A. Quantitative Analysis](#a-quantitative-analysis)
    - [B. Categorical Analysis](#b-categorical-analysis)
    - [C. Spatial Analysis](#c-spatial-analysis)
  - [VI. Folder Structure](#vi-folder-structure)
  - [VII. Tools Used](#vii-tools-used)
  - [VIII. Future Enhancements](#viii-future-enhancements)
  - [IX. Author](#ix-author)
  - [X. Acknowledgment](#x-acknowledgment)


## <br>II. Overview
This project explores the World Famous Paintings dataset using SQL to uncover insights about artists, artworks, subjects, and styles in the dataset.

## <br>III. Dataset
Source: [Kaggle – World Famous Paintings Dataset by Maxwell]([https://](https://www.kaggle.com/datasets/mexwell/famous-paintings))

The dataset contains information about thousands of famous paintings, including:
- **work**: Details of each artwork (title, artist, style, genre, date, dimensions)
- **artist**: Information about artists (name, nationality, birth/death year)
- **subject**: Art subjects (e.g., portrait, landscape, religious, etc.)
- **museum**: Museum data (name, city, country)
- **product_size**: Product specifications (e.g. sales price, regular price)
- **museum_hours**: Museum open/close time
- **image_link**: Links to the paintings’ images


## <br>IV. Objectives
The main objectives of this study are:
- Explore the dataset using SQL queries.
- Analyze relationships between artists, styles, and subjects.
- Generate insights on arts, productivity, and museum distributions.


## <br>V. Key Analyses
### A. Quantitative Analysis
1. Total no of Paintings
   ```sql
   SELECT COUNT(DISTINCT work_id)
   FROM work;
   ```
   *Insight*: There are 14716 paintings in the dataset.

2. Total no. of Unique Artists
   ```sql
   SELECT COUNT(DISTINCT artist_id)
   FROM artist;
   ```
   *Insight*: There are 421 artists in the dataset

3. Total no. of Museums
   ```sql
   SELECT COUNT(DISTINCT museum_id)
   FROM museum;
   ```
   *Insight*: There are 57 museums in the dataset

4. No. of Paintings per Artist
   ```sql
   SELECT 
        art.full_name AS artists, 
        COUNT(wo.work_id) AS total_no_of_paintings
   FROM work wo
   LEFT JOIN artist art
   USING (artist_id)
   GROUP BY art.artist_id, art.full_name
   ORDER BY total_no_of_paintings DESC;
   ```
   *Insight*: Shows artists with their total no. of paintings in the dataset.

5. Average Lifespan of Artists
   ```sql
    WITH artist_lifespan AS (
        SELECT
            artist_id,
            full_name,
            death - birth AS lifespan
        FROM artist
        WHERE death IS NOT NULL 
            AND birth IS NOT NULL
    )
    
    SELECT AVG(lifespan)::integer AS avg_lifespan_of_artists
    FROM artist_lifespan;
   ```
   *Insight*: The average lifespan of an artist in the dataset is 66 years.

6. Top 10 Longest Lived Artists
   ```sql
    WITH artist_lifespan AS (
        SELECT
            full_name AS artist,
            death::integer - birth::integer AS lifespan,
            DENSE_RANK() OVER(ORDER BY death::integer - birth::integer DESC) as ranking
        FROM artist
        WHERE death IS NOT NULL 
            AND birth IS NOT NULL
    )
    SELECT *
    FROM artist_lifespan
    WHERE ranking <= 10
    ORDER BY ranking ASC;
    ```
    *Insight*: 
    - Sir George Clausen, Titian, and Kees Van Dongen were the *Top 3 Longest Lived Artists*
7. Cummulative Mortality Rate by Age Threshold
   ```sql
    WITH artist_lifespan AS (
        SELECT
            full_name AS artist,
            death::integer - birth::integer AS lifespan
        FROM artist
        WHERE death IS NOT NULL 
            AND birth IS NOT NULL
    )

    SELECT 
        ROUND(
            100 * SUM(CASE WHEN lifespan < 50 THEN 1  ELSE  0 END)::numeric/COUNT(*),
            2
        ) AS pct_died_before_50,
        ROUND(
            100 * SUM(CASE WHEN lifespan < 70 THEN 1 ELSE  0 END)::numeric/COUNT(*),
            2
        ) AS pct_died_before_70,
        ROUND(
            100 * SUM(CASE WHEN lifespan < 80 THEN 1  ELSE  0 END)::numeric/COUNT(*),
            2
        ) AS pct_died_before_80,
        ROUND(
            100 * SUM(CASE WHEN lifespan < 90 THEN 1  ELSE  0 END)::numeric/COUNT(*),
            2
        ) AS pct_died_before_90,
        ROUND(
            100 * SUM(CASE WHEN lifespan < 100 THEN 1  ELSE  0 END)::numeric/COUNT(*),
            2
        ) AS pct_died_before_100,
        COUNT(*) AS total_artist
    FROM artist_lifespan;
   ```
    *Insight*:
    - Over half of the artists (55.6%) died before reaching 70.
    - Nearly 80% did not live past 80, suggesting that most artists in the dataset lived between 50–80 years.
    - Only 1% reached 90 years old, and none surpassed 100.
### <br>B. Categorical Analysis
1. Most Common Styles of Paintings
    ```sql
    SELECT 
        style,
        COUNT(DISTINCT work_id) AS total_paintings,
        DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT work_id) DESC) AS ranking
    FROM work
    WHERE style IS NOT NULL
    GROUP BY style
    ORDER BY total_paintings DESC;
    ```
    *Insight*
    - **Impressionism** is the most popular style in the dataset, followed by Realism.
    - **Japanese Art** is the least common style represented in the dataset.
  
2. Artists who explored two or more genres
   ```sql
    SELECT 
        art.full_name AS artist,
        STRING_AGG(DISTINCT wo.style, ',') AS styles,
        COUNT(DISTINCT wo.style) AS total_styles
    FROM work wo
    INNER JOIN artist art
    USING (artist_id)
    WHERE wo.style IS NOT NULL
    GROUP BY art.artist_id, art.full_name
    HAVING COUNT(DISTINCT wo.style) > 1
    ORDER BY total_styles DESC;
   ```
   *Insight*: **Inness** (American Landscape, Rococo) and **Pascin** (Expressionism, Impressionism) were **the only artists** in the dataset who explored two or more genres.

3. Styles with Most Contributing Artists
   ```sql
    SELECT 
        wo.style,
        COUNT(DISTINCT wo.work_id) AS total_paintings,
        STRING_AGG(DISTINCT art.full_name, ', ') AS artists,
        COUNT(DISTINCT art.artist_id) AS total_artists,
        DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT art.artist_id) DESC) AS ranking
    FROM work wo
    INNER JOIN artist art
    USING (artist_id)
    WHERE wo.style IS NOT NULL
    GROUP BY wo.style 
    ORDER BY total_artists DESC;
   ```
   *Insights:*
   - Baroque and Impressionism had the most contributing artists, indicating these styles were widely practiced and influential across different painters.
   - Japanese Art, Surrealism, and Art Nouveau had the fewest contributing artists, showing these styles were less commonly explored.

4. Styles Associated with Nationalities
   ```sql
    WITH artist_count AS (
        SELECT 
            wo.style,
            art.nationality,
            COUNT(DISTINCT art.artist_id) AS total_artists
        FROM work wo
        INNER JOIN artist art 
        USING (artist_id)
        WHERE wo.style IS NOT NULL
        GROUP BY wo.style, art.nationality
    )
    SELECT 
        COALESCE(style, 'Grand Total') AS style,
        COALESCE(nationality, 'Subtotal') AS nationality,
        SUM(total_artists) AS total_artists
    FROM artist_count
    GROUP BY ROLLUP(style, nationality)
    ORDER BY style, total_artists ASC; 
   ```
   *Insights*
   - American Art and Realism were primarily practiced by American artists.
   - Baroque was mostly represented by Dutch artists.
   - Expressionism was dominated by German artists.
   - Impressionism and Neo-Classicism were led by French artists.
   - Renaissance was driven by Italian artists.
   - Japanese Art was exclusively produced by Japanese artists in the dataset.

5. Most Common Subjects in Artworks
   ```sql
    SELECT 
        subject,
        COUNT(DISTINCT work_id) AS total_paintings
    FROM work wo
    INNER JOIN subject sub
    USING (work_id)
    GROUP BY subject
    ORDER BY total_paintings DESC;
   ```
   *Insight*: Portraits, Nude, and Landscape art are the most common subjects in the dataset, highlighting artists’ focus on human form, nature, and personal expression.

6. Most Common Subjects in Artworks by Artist
   ```sql
    WITH subject_work AS (
        SELECT 
            wo.artist_id,
            sub.subject,
            COUNT(DISTINCT wo.work_id) AS total_paintings
        FROM work wo
        INNER JOIN subject sub
        USING (work_id)
        GROUP BY wo.artist_id, sub.subject
    ), subject_rank AS (
            SELECT 
                art.full_name,
                subj.subject,
                total_paintings,
                RANK() OVER(PARTITION BY artist_id ORDER BY total_paintings DESC) AS rank
            FROM subject_work subj
            INNER JOIN artist art
            USING (artist_id)
    )
    SELECT 
        full_name,
        subject AS most_common_subject,
        total_paintings
    FROM subject_rank WHERE rank = 1
    ORDER BY full_name ASC;
   ```
   *Insights*:
   - Vincent van Gogh primarily painted portraits, making it his most common subject.
   - Gilbert Stuart mostly focus on portrait paintings.
   - Pierre-Auguste Renoir frequently created nude artworks.

### <br>C. Spatial Analysis
1. Countries with Largest Collection of Paintings
   ```sql
    SELECT 
        mu.country, 
        COUNT(DISTINCT wo.work_id) AS total_paintings,
        DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT wo.work_id) DESC) as ranking
    FROM work wo
    INNER JOIN museum mu
    ON wo.museum_id = mu.museum_id
    GROUP BY mu.country
    ORDER BY total_paintings DESC;
   ```
   *Insights*
   - The United States holds the largest collection of paintings in the dataset, with over 2,672 artworks.

2. Museums with Most Artworks
   ```sql
    SELECT
        mu.name,
        mu.country, 
        COUNT(DISTINCT wo.work_id) AS total_paintings
    FROM museum mu
    INNER JOIN work wo
    ON mu.museum_id = wo.museum_id
    GROUP BY mu.museum_id, mu.name, mu.country
    ORDER BY total_paintings DESC;
   ```
   *Insight:* Metropolitan Museum of Art, USA had the largest collection of artworks in the dataset

3. Museums with Most Variety of Artists
   ```sql
    SELECT 
        mu.name AS museum,
        mu.country,
        COUNT(DISTINCT artist_id) AS total_artists
    FROM museum mu
    INNER JOIN work wo
    USING (museum_id)
    GROUP BY mu.museum_id, mu.name, mu.country
    ORDER BY total_artists DESC;
   ```
   *Insight:* The Metropolitan Museum of Art in the United States showcased the greatest diversity of artists in the dataset.

4. Artists with Most Paintings Spread across Museums
   ```sql
    WITH artist_work AS (
        SELECT 
            art.artist_id,
            art.nationality,
            art.full_name,
            wo.museum_id,
            wo.work_id
        FROM artist art
        INNER JOIN work wo
        USING (artist_id)
    )
    SELECT 
        art.full_name AS artist,
        art.nationality,
        COUNT(DISTINCT art.work_id) AS total_paintings,
        STRING_AGG(DISTINCT mu.name, ', ') AS museums,
        COUNT(DISTINCT mu.museum_id) AS total_no_of_museums
    FROM artist_work art
    INNER JOIN museum mu
    USING (museum_id)
    GROUP BY art.artist_id, art.full_name, art.nationality
    ORDER BY total_no_of_museums DESC;
   ```
   *Insights:*
   - Claude Monet’s paintings were exhibited in 27 different museums.
   - Vincent van Gogh’s works were displayed in 22 different museums.
  
## <br>VI. Folder Structure
```graphql
main/
│
├── dataset/                                # Original dataset files
├── query/
│   ├── setup/                              # Python preprocessing & SQL schema creation
│   │   ├── create_schema.py                # SQL schema setup 
│   │   ├── preprocess_in_python.ipynb      # Preprocess dataset and load data to database
│   └── eda/                                # SQL exploratory data analysis
│       ├── quantitative/        
│       ├── categorical/         
│       ├── spatial/             
│       └── temporal/           
└── readme.md                               # Project overview
```

## <br>VII. Tools Used
- SQL (MySQL / PostgreSQL) — for querying and analysis
- Kaggle — for dataset exploration
- VS Code / Jupyter Notebook — for SQL and markdown documentation

## <br>VIII. Future Enhancements
- Visualize insights using Power BI or Python
- Integrate queries into a dashboard

## <br>IX. Author
Gelo (Ryan Dela Cruz)

Data Analyst skilled in **SQL, Python, and Excel**, passionate about uncovering insights through data and building impactful analytical projects.

## <br>X. Acknowledgment
Dataset by [Mexwell](https://www.kaggle.com/datasets/mexwell/famous-paintings/data) on Kaggle.

Thanks to the open-source data community for making this analysis possible!
