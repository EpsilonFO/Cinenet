# Cinenet - Movie Social Network Database

## Project Overview
Cinenet is a comprehensive database system designed for a movie-oriented social network. The project implements a relational database that allows users to interact with movies, share recommendations, follow other users, and discover new films based on community engagement.

## Features
- User account management and profile customization
- Movie database with detailed information (genre, director, actors, etc.)
- Rating and review system for films
- Social networking capabilities (following users, sharing content)
- Recommendation engine based on user preferences and network activity
- Analytics on trending films and popular content

## Database Schema
The database is structured around the following core entities:

### Main Tables
- **Users**: Stores user account information and preferences
- **Movies**: Contains film details including metadata and classification
- **Ratings**: Records user ratings and reviews for movies
- **Follows**: Manages social connections between users
- **Recommendations**: Tracks movie recommendations between users
- **Genres**: Categorizes films by type
- **Actors/Directors**: Contains information about film professionals

### Relationships
- Users can follow multiple other users
- Users can rate and review multiple movies
- Users can recommend movies to other users
- Movies are associated with multiple genres, actors, and directors

## Implementation
The project is implemented using:
- SQL for database definition and queries
- SQL scripts for database initialization
- Database management system (MySQL/PostgreSQL)
- Sample data for testing and demonstration

## SQL Components

### Database Creation
```sql
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    date_joined DATE NOT NULL,
    biography TEXT,
    profile_picture VARCHAR(255)
);

CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    release_year INT,
    description TEXT,
    poster_url VARCHAR(255),
    avg_rating DECIMAL(3,1)
);

-- Additional tables and relationships...
```

### Key Queries
The database supports various operations through SQL queries, including:

1. **User Recommendations**:
```sql
SELECT m.title, m.release_year, COUNT(*) as rec_count
FROM Recommendations r
JOIN Movies m ON r.movie_id = m.movie_id
WHERE r.recipient_id = [user_id]
GROUP BY m.movie_id
ORDER BY rec_count DESC;
```

2. **Movie Discovery Based on Network**:
```sql
SELECT m.title, m.release_year, m.avg_rating
FROM Ratings r
JOIN Movies m ON r.movie_id = m.movie_id
JOIN Follows f ON r.user_id = f.followed_id
WHERE f.follower_id = [user_id] AND r.rating >= 4
ORDER BY r.rating_date DESC;
```

3. **Trending Movies Analysis**:
```sql
SELECT m.title, m.release_year, COUNT(*) as review_count, AVG(r.rating) as avg_recent_rating
FROM Ratings r
JOIN Movies m ON r.movie_id = m.movie_id
WHERE r.rating_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY m.movie_id
HAVING review_count > 10
ORDER BY avg_recent_rating DESC;
```

## Installation and Usage

### Prerequisites
- MySQL/PostgreSQL database server
- SQL client (MySQL Workbench, pgAdmin, etc.)

### Setup Instructions
1. Clone the repository:
```bash
git clone https://github.com/EpsilonOF/Cinenet.git
```

2. Initialize the database:
```bash
mysql -u username -p database_name < schema.sql
```

3. Load sample data (optional):
```bash
mysql -u username -p database_name < sample_data.sql
```

4. Test with example queries:
```bash
mysql -u username -p database_name < example_queries.sql
```

## Database Design Choices

### Normalization
The database follows third normal form (3NF) to minimize redundancy while maintaining data integrity. This approach:
- Separates movie metadata (genres, actors, directors) into dedicated tables
- Creates junction tables for many-to-many relationships
- Ensures efficient updates and reduces anomalies

### Indexing Strategy
Strategic indexes are implemented on:
- Foreign keys to optimize joins
- Frequently queried columns like movie titles and usernames
- Timestamp fields for chronological sorting

### Constraints
Data integrity is maintained through:
- Primary and foreign key constraints
- Unique constraints on usernames and emails
- Check constraints for valid ratings (1-5 scale)
- Default values for creation timestamps

## Future Enhancements
- Integration with external movie APIs for automated data population
- Advanced recommendation algorithms using collaborative filtering
- Performance optimization for large-scale deployment
- Data analytics dashboard for trends and user engagement metrics
