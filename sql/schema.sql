USE NetflixDB;

CREATE TABLE netflix_titles (
    show_id VARCHAR(50) PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    title NVARCHAR(255) NOT NULL,
    director NVARCHAR(255),
    country VARCHAR(255),
    date_added DATE,
    release_year INT,
    rating VARCHAR(50),
    duration VARCHAR(50),
    description NVARCHAR(MAX) 
);

CREATE TABLE  netflix_cast (
    cast_id INT IDENTITY(1,1) PRIMARY KEY, 
    show_id VARCHAR(50) FOREIGN KEY REFERENCES netflix_titles(show_id) ON DELETE CASCADE,
    actor_name NVARCHAR(255) NOT NULL
);

CREATE TABLE netflix_genres (
    genre_id INT IDENTITY(1,1) PRIMARY KEY,
    show_id VARCHAR(50) FOREIGN KEY REFERENCES netflix_titles(show_id) ON DELETE CASCADE,
    genre_name VARCHAR(255) NOT NULL
);

