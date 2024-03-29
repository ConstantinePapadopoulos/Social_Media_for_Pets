CREATE DATABASE pet_database;

USE pet_database;

CREATE TABLE users (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nickname VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    business_name VARCHAR(255),
    phone VARCHAR(15),
    address VARCHAR(255),
    account_type VARCHAR(50)
);

CREATE TABLE posts (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    user_id INT(11),
    likes INT(11)
);

CREATE TABLE event (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT(11),
    user_name VARCHAR(255),
    description TEXT,
    time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR(255)
);

CREATE TABLE friendships (
    user1_id INT(11) NOT NULL,
    user2_id INT(11) NOT NULL,
    PRIMARY KEY (user1_id, user2_id)
);

CREATE TABLE requests (
    user1_id INT(11) NOT NULL,
    user2_id INT(11) NOT NULL,
    PRIMARY KEY (user1_id, user2_id)
);

CREATE TABLE comments (
    id INT(11) NOT NULL AUTO_INCREMENT,
    post_id INT(11) NOT NULL,
    username VARCHAR(255) NOT NULL,
    comment TEXT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

CREATE TABLE learn_about_me (
    user_id INT(11) NOT NULL PRIMARY KEY,
    image_path VARCHAR(255),
    description TEXT,
    links VARCHAR(255)
);

INSERT INTO users (id, email, nickname, password, business_name, phone, address, account_type)
VALUES
    (1, 'example@email.com', 'areti', 'pass2', 'adespoth_zwh', '1234567890', '123 Main St', 'business'),
    (3, 'kostas@email.com', 'Kostas', 'pass2', 'kostas', '695346', 'kostas', 'private'),
    (4, 'areti@email.com', 'toula', 'toula', NULL, NULL, NULL, 'private'),
    (5, 'touls.email.com', 'toula1', 'pass3', NULL, NULL, NULL, 'private'),
    (6, 'gohn@gmail.com', 'gohn', 'areti', NULL, NULL, NULL, 'business'),
    (7, 'kostaspap@mail.com', 'Kostandinos', 'pass2', NULL, NULL, NULL, 'private');



INSERT INTO posts (id, username, image_path, location, user_id, likes)
VALUES
    (1, 'Areti', 'assets/pet21.png', 'Chalkida', 1, 6),
    (2, 'Kostas', 'assets/pet26.png', 'Athens', 3, 5),
    (4, 'Areti', 'assets/pet26.png', 'Thessaloniki', 1, 4),
    (5, 'Kostas', 'assets/dog_cat.png', 'Patras', 3, 4);

INSERT INTO comments (id, post_id, username, comment)
VALUES
    (1, 1, 'Areti', 'Great post!'),
    (2, 1, 'Kostas', 'Excellent!'),
    (3, 2, 'Areti', 'Great post!'),
    (4, 2, 'Kostas', 'Excellent!'),
    (5, 5, 'Gohn', 'Τι γλυκό!'),
    (6, 5, 'Areti', 'αωωω!'),
    (7, 1, 'YourUsername', 'wow!'),
    (8, 2, 'areti', 'awesome!'),
    (9, 1, 'Kostandinos', 'τέλειο!'),
    (10, 4, 'areti', 'hihihi! so?');

INSERT INTO event (id, user_id, user_name, description, time, location)
VALUES
    (1, 1, 'areti', '4o event Peristeriou', '2024-01-14 22:34:19', 'peristeri'),
    (2, 6, 'gohn', 'Walking our Dogs', '2024-01-14 22:34:22', 'peristeri'),
    (3, 1, 'areti', 'lets play!', '2024-01-23 17:05:00', 'chalkida'),
    (4, 1, 'areti', '4o pet adoption day', '2024-01-31 14:00:00', 'Zografou');


INSERT INTO friendships (user1_id, user2_id)
VALUES
    (1, 5),
    (1, 6),
    (1, 7),
    (5, 3);


INSERT INTO learn_about_me (user_id, image_path, description, links)
VALUES
    (1, 'assets/dog_cat.png', 'hope you have fun on my page!', 'https://www.akc.org/dog-breeds/german-shepherd-dog/'),
    (3, 'assets/dog_cat.png', 'Its so nice to meet you!', 'https://www.akc.org/dog-breeds/german-shepherd-dog/');


CREATE TABLE user_event (
    id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11),
    event_id BIGINT(20) UNSIGNED,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (event_id) REFERENCES event(id)
);

CREATE TABLE user_likes (
    id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11),
    post_id INT(11),
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

INSERT INTO user_likes (user_id, post_id) VALUES
(3, 1),
(4, 1),
(7, 1),
(1, 5),
(1, 2),
(1, 1),
(1, 6);

INSERT INTO user_event (user_id, event_id) VALUES
(1, 1),
(1, 3);

