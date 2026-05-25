# Netflix Data Ingestion and Analytics Pipeline Project

## Project Overview
This project implements a basic data pipeline (ETL) using Python, Pandas, and SQLAlchemy to take a real-world Netflix dataset from Kaggle and load it into Microsoft SQL Server. After loading the data, SQL is used to analyze it, applying JOINs, GROUP BY, and Window Functions to extract meaningful insights.

---

## Dataset Source
* **Platform:** Kaggle
* **Dataset Link:** https://www.kaggle.com/datasets/shivamb/netflix-shows/data
* **Data Size:** 8,807 rows containing information about show IDs, titles, directors, cast, countries, dates added, release years, ratings, duration, and descriptions.

---

## Pipeline Description
The pipeline is organized into separate Python modules to handle the ETL process:

1. **Extract (`app/extract.py`):** Reads the raw `data/netflix_titless.csv` file using Pandas to ensure all characters are read correctly.
2. **Transform (`app/transform.py`):** Cleans the raw data by:
   * Filling empty values with placeholders like 'Unknown', 'No Cast', and 'NR' to prevent issues in the SQL database.
   * Fixing dates and converting them into a standard format (`YYYY-MM-DD`).
   * Removing duplicate records based on the `show_id`.
3. **Load (`app/load.py`):** Connects to MS SQL Server using SQLAlchemy and loads the cleaned data into the database.
4. **Main (`app/main.py`):** Connects all steps together and runs the full pipeline from start to finish.

---

## Database Schema Explanation
To avoid data duplication and follow basic normalization rules, the data is split into 3 related tables in SQL Server:


| Table Name | Description | Key Fields Included |
| :--- | :--- | :--- |
| **netflix_titles** | Main table storing the core details for each movie and TV show | `show_id` (PK), `type`, `title`, `director`, `country`, `date_added`, `release_year`, `rating`, `duration`, `description` |
| **netflix_cast** | Actors table storing actor names split into separate rows via `STRING_SPLIT` | `cast_id` (PK/Identity), `show_id` (FK), `actor_name` |
| **netflix_genres** | Genres table storing content categories split into separate rows for easier analysis | `genre_id` (PK/Identity), `show_id` (FK), `genre_name` |

### Indexes
To optimize the performance of queries and make `JOIN` operations faster, two non-clustered indexes are added on the foreign key columns:
* `idx_netflix_cast_show_id` on `netflix_cast(show_id)`
* `idx_netflix_genres_show_id` on `netflix_genres(show_id)`

---

## How to Install & Run Locally
Follow these steps to spin this project up on your own local machine.

### Prerequisites
* **Anaconda** installed.
* **Git** installed.
* **MS SQL Server** running locally with a database named `NetflixDB`.

### Step 1: Ingest the Dataset
Download the raw database file from the official platform page:
https://www.kaggle.com/datasets/shivamb/netflix-shows/data

Place the unzipped file into your project folder directory path: `data/netflix_titless.csv`

### Step 2: Configure Your Database Settings
Before running the pipeline, the database server name must be updated to match your local MS SQL Server instance. 

Open the `app/main.py` file, find the `SQL_SERVER_NAME` variable, and replace the placeholder string with your own local server configuration name:

```python
# Replace with your actual local MS SQL Server name
SQL_SERVER_NAME = "YOUR_LOCAL_SERVER_NAME\\SQLEXPRESS"
```

### Step 3: Install Dependencies & Build Schema
Open your Anaconda Prompt and install the required libraries into your active environment:
```bash
pip install -r requirements.txt
```

Next, open your SQL client environment, connect to your server, and execute the `sql/schema.sql` file to create the database tables, constraints, and relational schemas.

### Step 4: Run the ETL Pipeline
Inside your Anaconda Prompt, fire off the main orchestrator script. This will automatically extract the raw CSV file, clear out data anomalies, and stream the clean dataset rows directly into your MS SQL database:
```bash
python app/main.py
```

### Step 5: Run the Analytics
Once the terminal reads `"ETL PIPELINE FINISHED"`, navigate to `sql/queries.sql`. You can execute the queries to view the answers to all 12 analytical questions!

---

### Summary of Analytical Results
Using advanced SQL features like Window Functions (`DENSE_RANK`), Conditional Aggregations (`CASE WHEN`), CTEs, and multi-table Joins, we built a `queries.sql` file that answers these core business questions:

1. **Movies vs TV Shows Count:** Finds the total number of movies compared to TV shows to see which type is more common on Netflix.
2. **Top Content Years:** Shows the top 10 years when Netflix added the most movies and TV shows to see peak production trends.
3. **Top Movie Directors:** Filters out empty rows to rank the top 5 directors with the most movies on the platform.
4. **Most Active Actors:** Joins the tables to find the top 10 busiest actors based on the total number of projects they have worked in.
5. **Top Producing Countries:** Displays the top 10 countries that have created the most content for Netflix.
6. **Titles and Genres List:** Performs a simple query using JOIN to display Netflix titles along with their specific genre categories.
7. **Genre Popularity Rank:** Groups all genres together and uses the `DENSE_RANK` window function to rank them from most popular to least popular.
8. **Oldest Netflix Content:** Searches the release years to list the top 10 oldest classic movies and TV shows available.
9. **Movies and TV Shows per Genre:** Uses conditional counting (`CASE WHEN`) to see exactly how many movies and how many TV shows belong to each genre.
10. **Top Actors per Genre:** Uses an advanced window function (`PARTITION BY`) to find the top 3 most popular actors for every single genre.
11. **Most Frequent Actor Duos:** Uses an analytical Self-JOIN to find actor pairs who work together. 
12. **Movie Duration Categories:** Uses `CASE WHEN` to group movies into Short, Medium, and Long buckets. 

---

## Technologies Used

* **Language:** Python
* **Libraries:** Pandas, SQLAlchemy, PyODBC
* **Database Engine:** Microsoft SQL Server (MS SQL)
* **Query Language:** SQL (T-SQL)
* **Environment Manager:** Anaconda
* **Version Control:** Git & GitHub

---

## Project Structure

```text
project/
├── app/
│   ├── extract.py
│   ├── transform.py
│   ├── load.py
│   └── main.py
├── data/
│   └── netflix_titless.csv
├── sql/
│   ├── schema.sql
│   └── queries.sql
├── README.md
└── requirements.txt
```
