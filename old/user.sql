use pacman_db;

-- USER[UserID, name, email]

CREATE TABLE `user` (
    `user_id` INT NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    CONSTRAINT usr_pk PRIMARY KEY (user_id),
);
