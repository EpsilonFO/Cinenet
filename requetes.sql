-- Requête sur au moins trois tables :
SELECT u.username, e.name, p.content
FROM users u
JOIN participation pa ON u.user_id = pa.user_id
JOIN evenement e ON pa.event_id = e.event_id
JOIN publication p ON p.event_id = e.event_id
WHERE u.role = 'user';
-- Obtenir les noms d'utilisateur, les noms d'événements et les noms de lieux pour les utilisateurs ayant le rôle 'user'.
-- Tables impliquées : users (u), participation (pa), event (e), place (p)

-- Auto-jointure :
SELECT f1.user_id, f1.friend_id, f2.user_id AS mutual_friend
FROM friends f1
JOIN friends f2 ON f1.friend_id = f2.user_id
WHERE f1.user_id <> f2.friend_id;
-- Trouver les amis communs entre les utilisateurs en joignant deux copies de la table friends. 

-- Sous-requête corrélée :
SELECT u.username, u.birth_year
FROM users u
WHERE u.birth_year > (
    SELECT AVG(u2.birth_year)
    FROM users u2
    WHERE u2.role = u.role
);
-- Sélectionner les utilisateurs dont l'année de naissance est supérieure à la moyenne des années de naissance des utilisateurs ayant le même rôle

-- Sous-requête dans le FROM :
SELECT u.username, event_participation.event_count
FROM users u
JOIN (
    SELECT pa.user_id, COUNT(pa.event_id) AS event_count
    FROM participation pa
    GROUP BY pa.user_id
) AS event_participation ON u.user_id = event_participation.user_id;
-- Obtenir les noms d'utilisateur et le nombre d'événements auxquels chaque utilisateur a participé.

-- Sous-requête dans le WHERE :
SELECT e.event_id, e.name
FROM evenement e
WHERE e.event_id NOT IN (
    SELECT pa.event_id
    FROM participation pa
    WHERE pa.user_id = 1
);
-- Obtenir les événements auxquels l'utilisateur avec user_id = 1 n'a pas encore participé.

-- GROUP BY et HAVING :
SELECT u.username, COUNT(pa.event_id) AS event_count
FROM users u
JOIN participation pa ON u.user_id = pa.user_id
GROUP BY u.username
HAVING COUNT(pa.event_id) > 1;
-- Obtenir les noms d'utilisateur et le nombre d'événements auxquels chaque utilisateur a participé, pour les utilisateurs ayant participé à plus de 1 événement.

-- GROUP BY et HAVING (2) :
SELECT d.name, COUNT(c.content_id) AS content_count
FROM director d
JOIN content c ON d.director_id = c.director_id
GROUP BY d.name
HAVING COUNT(c.content_id) > 5;
-- Obtenir les noms de réalisateurs et le nombre de contenus qu'ils ont réalisés, pour les réalisateurs ayant réalisé plus de 5 contenus.

-- Calcul de 2 agrégats :
SELECT AVG(max_price) AS avg_max_price
FROM (
    SELECT e.place_id, MAX(e.price) AS max_price
    FROM evenement e
    GROUP BY e.place_id
) max_prices;
-- Calculer la moyenne des prix maximums des événements par lieu

-- Jointure externe (LEFT JOIN) :
SELECT u.username, p.content
FROM users u
LEFT JOIN publication p ON u.user_id = p.user_id;
-- Récupérer tous les noms d'utilisateurs et le contenu de leurs publications, incluant les utilisateurs sans publications (LEFT JOIN).

-- Condition de totalité avec sous-requête corrélée
SELECT h.name
FROM hashtag h
WHERE NOT EXISTS (
    SELECT p.publication_id
    FROM publication p
    WHERE p.user_id = 1 AND NOT EXISTS (
        SELECT 1
        FROM publication p2
        WHERE p2.hashtag_id = h.hashtag_id AND p2.publication_id = p.publication_id
    )
);
-- Obtenir les noms de hashtags qui ont été utilisés dans toutes les publications faites par l'utilisateur 1

-- Condition de totalité avec agrégation
SELECT u.username
FROM users u
JOIN participation p ON u.user_id = p.user_id
GROUP BY u.username
HAVING COUNT(DISTINCT p.event_id) < (SELECT COUNT(event_id) FROM evenement);
--  Sélectionner les noms des utilisateurs qui n'ont pas participé à tous les événements


SELECT e.event_id, COUNT(p.user_id) AS participant_count
FROM evenement e
LEFT JOIN participation p ON e.event_id = p.event_id
GROUP BY e.event_id;
-- Récupérer les événements et compter le nombre de participants pour chaque événement, incluant les événements sans participants (LEFT JOIN).
-- Les événements sans participants auront un participant_count de 0.

--Requête avec résultats différents dûs à des NULLs (2) :
SELECT e.event_id, COUNT(p.user_id) AS participant_count
FROM evenement e
JOIN participation p ON e.event_id = p.event_id
GROUP BY e.event_id;
-- Récupérer les événements et compte le nombre de participants pour chaque événement, n'incluant que les événements avec au moins un participant (INNER JOIN).
-- Les événements sans participants ne seront pas inclus.

-- Requête récursive
WITH RECURSIVE next_event_day AS (
    SELECT CURRENT_DATE::timestamp AS event_day
    UNION ALL
    SELECT event_day + INTERVAL '1 day'
    FROM next_event_day
    WHERE NOT EXISTS (
        SELECT 1
        FROM evenement e
        WHERE e.date = (event_day + INTERVAL '1 day')::date
    )
)
SELECT event_day::date
FROM next_event_day
WHERE NOT EXISTS (
    SELECT 1
    FROM evenement e
    WHERE e.date = event_day::date
)
LIMIT 1;
-- Trouver la prochaine date sans événement

-- Requête utilisant le fenêtrage
WITH user_participations AS (
    SELECT u.user_id, u.username, COUNT(pa.event_id) AS total_participations
    FROM users u
    JOIN participation pa ON u.user_id = pa.user_id
    GROUP BY u.user_id, u.username
)
SELECT user_id, username, total_participations, RANK() OVER (ORDER BY total_participations DESC) AS participation_rank
FROM user_participations
ORDER BY participation_rank;
-- les utilisateurs avec le nombre total de leurs participations à des événements et leur classement basé sur ce nombre



-- Liste des utilisateurs et leurs participations
SELECT u.user_id, u.username, p.event_id, e.name AS event_name, p.status
FROM users u
JOIN participation p ON u.user_id = p.user_id
JOIN evenement e ON p.event_id = e.event_id
ORDER BY u.username, e.date;


-- Nombre total de participations par utilisateur
SELECT u.user_id, u.username, COUNT(p.event_id) AS total_participations
FROM users u
LEFT JOIN participation p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username
ORDER BY total_participations DESC;


-- Lister les utilisateurs qui suivent plus de 1 follower
SELECT u.username, COUNT(f.follow_id) as follows_count
FROM users u
JOIN follows f ON u.user_id = f.user_id
GROUP BY u.username
HAVING COUNT(f.follow_id) > 1;

-- Trouver les publications qui mentionnent le hashtag "shake"
SELECT p.publication_id, p.content, h.name as hashtag
FROM publication p
JOIN hashtag h ON p.hashtag_id = h.hashtag_id
WHERE h.name = 'shake';


--Trouver les acteurs qui ont joué dans le plus de contenus
SELECT a.name, COUNT(c.casting_id) AS content_count
FROM actor a
JOIN casting c ON a.actor_id = c.actor_id
GROUP BY a.name
ORDER BY content_count DESC
LIMIT 5;



--------------------------------------- ALGORITHME DE RECOMMANDATION ---------------------------------------

SELECT e.event_id, e.name, COUNT(p.user_id) AS participant_count
FROM evenement e
JOIN participation p ON e.event_id = p.event_id
JOIN friends f ON p.user_id = f.friend_id
WHERE f.user_id = 4
GROUP BY e.event_id, e.name
ORDER BY participant_count DESC
LIMIT 5;
-- Recommander les événements les plus populaires parmi les amis de l'utilisateur 4

SELECT p.publication_id, p.content, COUNT(r.user_id) AS like_count
FROM publication p
JOIN reaction r ON p.publication_id = r.publication_id
JOIN friends f ON r.user_id = f.friend_id
WHERE f.user_id = 3 AND r.react = 'like'
GROUP BY p.publication_id, p.content
ORDER BY like_count DESC
LIMIT 5;
-- Recommander les publications les plus aimées parmi les amis de l'utilisateur 3

SELECT e.event_id, e.name, 
    (0.5 * COUNT(DISTINCT p.user_id) + 
     0.3 * COUNT(DISTINCT f.friend_id) + 
     0.2 * COUNT(DISTINCT r.user_id)) AS recommendation_score
FROM evenement e
LEFT JOIN participation p ON e.event_id = p.event_id
LEFT JOIN friends f ON p.user_id = f.friend_id AND f.user_id = 1
LEFT JOIN reaction r ON r.publication_id IN (
    SELECT publication_id 
    FROM publication 
    WHERE event_id = e.event_id) AND r.react = 'like'
GROUP BY e.event_id, e.name
ORDER BY recommendation_score DESC
LIMIT 5;
-- Recommander les événements les plus pertinents pour l'utilisateur 1 en utilisant un score de recommandation basé sur 
-- le nombre de participations, d'amis participants et de réactions 'like' sur les publications associées aux événements.