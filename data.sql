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
