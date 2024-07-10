import pandas as pd
import random
from faker import Faker

fake = Faker()

# Number of records for each table
n_users = 100
n_places = 20
n_keywords = 50
n_events = 30
n_genres = 10
n_directors = 30
n_actors = 50
n_contents = 100
n_hashtags = 50
n_publications = 200
n_reactions = 300
n_emojis = 10

# Generate data for USER table
users = [{
    'user_ID': i,
    'username': fake.user_name(),
    'password': fake.password(),
    'role': random.choice(['admin', 'user']),
    'birth_year': random.randint(1950, 2005)
} for i in range(1, n_users + 1)]

# Generate data for PLACE table
places = [{
    'place_ID': i,
    'name': fake.city()
} for i in range(1, n_places + 1)]

# Generate data for KEYWORD table
keywords = [{
    'keyword_ID': i,
    'word': fake.word()
} for i in range(1, n_keywords + 1)]

# Generate data for GENRE table
genres = []
for i in range(1, n_genres + 1):
    parent_id = random.choice([g['genre_ID'] for g in genres]) if genres else None
    if parent_id is not None and random.randint(1, 3) == 2:
        parent_id = None
    if parent_id is None:
        genre = {
            'genre_ID': i,
            'name': fake.word(),
            'parent_ID': None
        }
    else:
        genre = {
            'genre_ID': i,
            'name': fake.word(),
            'parent_ID': int(parent_id)
        }
    genres.append(genre)

# Generate data for DIRECTOR table
directors = [{
    'director_ID': i,
    'name': fake.name()
} for i in range(1, n_directors + 1)]

# Generate data for ACTOR table
actors = [{
    'actor_ID': i,
    'name': fake.name()
} for i in range(1, n_actors + 1)]

# Generate data for CONTENT table
contents = [{
    'content_ID': i,
    'title': fake.sentence(nb_words=3),
    'release_date': fake.date_between(start_date='-30y', end_date='today'),
    'director_ID': random.choice([d['director_ID'] for d in directors]),
    'genre_ID': random.choice([g['genre_ID'] for g in genres]),
    'content_type': random.choice(['films', 'serie']),
    'seasons': random.randint(1, 8)
} for i in range(1, n_contents + 1)]
for content in contents:
    if content['content_type'] == 'films':
        content['seasons'] = 0

# Generate data for EVENT table
events = [{
    'event_ID': i,
    'name': fake.sentence(nb_words=3),
    'date': fake.date(),
    'description': fake.text(),
    'place_ID': random.choice([p['place_ID'] for p in places]),
    'capacity': random.randint(50, 500),
    'price': random.randint(10, 100)
} for i in range(1, n_events + 1)]

# Generate data for HASHTAG table
hashtags = [{
    'hashtag_ID': i,
    'name': fake.word()
} for i in range(1, n_hashtags + 1)]

# Generate data for PUBLICATION table
publications = []
for i in range(1, n_publications + 1):
    publication = {
        'publication_ID': i,
        'content': fake.text(),
        'date': fake.date(),
        'user_ID': random.randint(1, n_users),
        'content_ID': random.randint(1, n_contents),
        'hashtag_ID': random.randint(1, n_hashtags),
        'event_ID': random.randint(1, n_events),
        'parent_ID': random.choice([p['publication_ID'] for p in publications]) if publications else 0
    }
    publications.append(publication)

# Generate data for REACTION table
reactions = [{
    'reaction_ID': i,
    'user_ID': random.choice([u['user_ID'] for u in users]),
    'publication_ID': random.choice([p['publication_ID'] for p in publications]),
    'react': random.choice(['like', 'love', 'haha', 'wow', 'sad', 'angry'])
} for i in range(1, n_reactions + 1)]

# Generate data for EMOJI table
emojis = [{
    'emoji_ID': i,
    'emoji': random.choice(['😀', '😂', '😍', '😢', '😡', '👍', '👎', '💔', '👏', '🙌'])
} for i in range(1, n_emojis + 1)]

# Generate data for FRIENDS table
friends = []
for _ in range(50):
    user_id = random.choice([u['user_ID'] for u in users])
    friend_id = random.choice([u['user_ID'] for u in users])
    if user_id != friend_id and (friend_id, user_id) not in friends:
        friends.append({
            'user_ID': min(user_id, friend_id),
            'friend_ID': max(user_id, friend_id)
        })
friends = [dict(t) for t in {tuple(d.items()) for d in friends}]

# Generate data for FOLLOWS table
follows = []
for _ in range(50):
    user_id = random.choice([u['user_ID'] for u in users])
    follow_id = random.choice([u['user_ID'] for u in users])
    if user_id != follow_id:
        follows.append({
            'user_ID': user_id,
            'follow_ID': follow_id
        })
follows = [dict(t) for t in {tuple(d.items()) for d in follows}]

# Generate data for HISTORY table
history = []
for _ in range(50):
    publication_id = random.randint(1,n_publications)
    reaction_id = random.randint(1,n_reactions)
    history.append({
        'publication_ID': publication_id,
        'reaction_ID': reaction_id
    })
history = [dict(t) for t in {tuple(d.items()) for d in history}]

# Generate data for KEYWORDEVENT table
keyword_event = []
for _ in range(50):
    event_id = random.choice([e['event_ID'] for e in events])
    keyword_id = random.choice([k['keyword_ID'] for k in keywords])
    keyword_event.append({
        'event_ID': event_id,
        'keyword_ID': keyword_id
    })
keyword_event = [dict(t) for t in {tuple(d.items()) for d in keyword_event}]

# Generate data for PARTICIPATION table
participation = []
for _ in range(50):
    user_id = random.choice([u['user_ID'] for u in users])
    event_id = random.choice([e['event_ID'] for e in events])
    if (user_id, event_id, 'interested') not in participation and (user_id, event_id, 'participating') not in participation:
        participation.append({
            'user_ID': user_id,
            'event_ID': event_id,
            'status': random.choice(['interested', 'participating'])
        })
participation = [dict(t) for t in {tuple(d.items()) for d in participation}]

# Generate data for KEYWORDCONTENT table
keyword_content = []
for _ in range(50):
    content_id = random.choice([c['content_ID'] for c in contents])
    keyword_id = random.choice([k['keyword_ID'] for k in keywords])
    keyword_content.append({
        'content_ID': content_id,
        'keyword_ID': keyword_id
    })
keyword_content = [dict(t) for t in {tuple(d.items()) for d in keyword_content}]

# Generate data for CASTING table
casting = [{
    'casting_ID': i,
    'content_ID': random.choice([c['content_ID'] for c in contents]),
    'actor_ID': random.choice([a['actor_ID'] for a in actors])
} for i in range(1, n_contents + 1)]

# Save to CSV
def save_to_csv(data, filename):
    df = pd.DataFrame(data)
    df.to_csv(filename, index=False)

# save_to_csv(users, 'CSV/USER.csv')
# save_to_csv(places, 'CSV/PLACE.csv')
# save_to_csv(keywords, 'CSV/KEYWORD.csv')
save_to_csv(events, 'CSV/EVENEMENT.csv')
# save_to_csv(genres, 'CSV/GENRE.csv')
# save_to_csv(directors, 'CSV/DIRECTOR.csv')
# save_to_csv(actors, 'CSV/ACTOR.csv')
# save_to_csv(contents, 'CSV/CONTENT.csv')
# save_to_csv(hashtags, 'CSV/HASHTAG.csv')
save_to_csv(publications, 'CSV/PUBLICATION.csv')
# save_to_csv(reactions, 'CSV/REACTION.csv')
# save_to_csv(emojis, 'CSV/EMOJI.csv')
# save_to_csv(friends, 'CSV/FRIENDS.csv')
# save_to_csv(follows, 'CSV/FOLLOWS.csv')
# save_to_csv(history, 'CSV/HISTORY.csv')
# save_to_csv(keyword_event, 'CSV/KEYWORDEVENT.csv')
# save_to_csv(participation, 'CSV/PARTICIPATION.csv')
# save_to_csv(keyword_content, 'CSV/KEYWORDCONTENT.csv')
# save_to_csv(casting, 'CSV/CASTING.csv')
for p in publications:
    print(p['event_ID'])