CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    birth_year INT
);

CREATE TABLE place (
    place_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE keyword (
    keyword_id INT PRIMARY KEY,
    word VARCHAR(255) NOT NULL
);

CREATE TABLE evenement (
    event_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    description TEXT,
    place_id INT REFERENCES place(place_id),
    capacity INT,
    price INT NOT NULL
);

CREATE TABLE keywordevent (
    event_id INT REFERENCES evenement(event_id),
    keyword_id INT REFERENCES keyword(keyword_id),
    PRIMARY KEY (event_id, keyword_id)
);

CREATE TABLE participation (
    user_id INT REFERENCES users(user_id),
    event_id INT REFERENCES evenement(event_id),
    status VARCHAR(50) CHECK (status IN ('interested', 'participating')),
    PRIMARY KEY (user_id, event_id)
);

CREATE TABLE genre (
    genre_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    parent_id INT REFERENCES genre(genre_id)
);

CREATE TABLE director (
    director_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE actor (
    actor_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);


CREATE TABLE content (
    content_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_date DATE,
    director_id INT REFERENCES director(director_id),
    genre_id INT REFERENCES genre(genre_id),
    content_type VARCHAR(50),
    seasons INT
);
CREATE TABLE keywordcontent (
    content_id INT REFERENCES content(content_id),
    keyword_id INT REFERENCES keyword(keyword_id),
    PRIMARY KEY (content_id, keyword_id)
);

CREATE TABLE casting (
    casting_id INT PRIMARY KEY,
    content_id INT REFERENCES content(content_id),
    actor_id INT REFERENCES actor(actor_id)
);

CREATE TABLE hashtag (
    hashtag_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE friends (
    user_id INT REFERENCES users(user_id),
    friend_id INT REFERENCES users(user_id),
    PRIMARY KEY (user_id, friend_id),
    CHECK (user_id < friend_id)
);

CREATE TABLE follows (
    user_id INT REFERENCES users(user_id),
    follow_id INT REFERENCES users(user_id),
    PRIMARY KEY (user_id, follow_id)
);

CREATE TABLE publication (
    publication_id INT PRIMARY KEY,
    content TEXT,
    date DATE,
    user_id INT REFERENCES users(user_id),
    content_id INT REFERENCES content(content_id),
    hashtag_id INT REFERENCES hashtag(hashtag_id),
    event_id INT REFERENCES evenement(event_id),
    parent_id INT REFERENCES publication(publication_id)
);


CREATE TABLE reaction (
    reaction_id INT PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    publication_id INT NOT NULL REFERENCES publication(publication_id),
    react TEXT
);

CREATE TABLE history (
    publication_id INT REFERENCES publication(publication_id),
    reaction_id INT REFERENCES reaction(reaction_id),
    PRIMARY KEY (publication_id, reaction_id)
<<<<<<< HEAD
);

CREATE TABLE emoji (
    emoji_id INT PRIMARY KEY,
    emoji VARCHAR(5)
);
=======
);

CREATE TABLE emoji (
    emoji_id INT PRIMARY KEY,
    emoji VARCHAR(5)
);

\copy users(user_id, username, password, role, birth_year) FROM 'CSV/USER.csv' DELIMITER ',' CSV HEADER;

\copy place(place_id, name) FROM 'CSV/PLACE.csv' DELIMITER ',' CSV HEADER;

\copy keyword(keyword_id, word) FROM 'CSV/KEYWORD.csv' DELIMITER ',' CSV HEADER;

\copy evenement(event_id, name, date, description, place_id, capacity, price) FROM 'CSV/EVENEMENT.csv' DELIMITER ',' CSV HEADER;

\copy genre(genre_id, name, parent_id) FROM 'CSV/GENRE.csv' DELIMITER ',' CSV HEADER;

\copy director(director_id, name) FROM 'CSV/DIRECTOR.csv' DELIMITER ',' CSV HEADER;

\copy actor(actor_id, name) FROM 'CSV/ACTOR.csv' DELIMITER ',' CSV HEADER;

\copy content(content_id, title, release_date, director_id, genre_id, content_type, seasons) FROM 'CSV/CONTENT.csv' DELIMITER ',' CSV HEADER;

\copy casting(casting_id, content_id, actor_id) FROM 'CSV/CASTING.csv' DELIMITER ',' CSV HEADER;

\copy keywordevent(event_id, keyword_id) FROM 'CSV/KEYWORDEVENT.csv' DELIMITER ',' CSV HEADER;

\copy participation(user_id, event_id, status) FROM 'CSV/PARTICIPATION.csv' DELIMITER ',' CSV HEADER;

\copy hashtag(hashtag_id, name) FROM 'CSV/HASHTAG.csv' DELIMITER ',' CSV HEADER;

\copy publication(publication_id, content, date, user_id, content_id, hashtag_id, event_id, parent_id) FROM 'CSV/PUBLICATION.csv' DELIMITER ',' CSV HEADER;

\copy keywordcontent(content_id, keyword_id) FROM 'CSV/KEYWORDCONTENT.csv' DELIMITER ',' CSV HEADER;

\copy friends(user_id, friend_id) FROM 'CSV/FRIENDS.csv' DELIMITER ',' CSV HEADER;

\copy follows(user_id, follow_id) FROM 'CSV/FOLLOWS.csv' DELIMITER ',' CSV HEADER;

\copy reaction(reaction_id, user_id, publication_id, react) FROM 'CSV/REACTION.csv' DELIMITER ',' CSV HEADER;

\copy history(publication_id, reaction_id) FROM 'CSV/HISTORY.csv' DELIMITER ',' CSV HEADER;

\copy emoji(emoji_id, emoji) FROM 'CSV/EMOJI.csv' DELIMITER ',' CSV HEADER;
>>>>>>> cfa796326856993f831ade7d2339532819b00735
