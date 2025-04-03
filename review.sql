-- REVIEW[ReviewID, PackageID, UserID, rating, description, timestamp]
CREATE TABLE review (
    review_id INT NOT NULL,
    package_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    `description` LONGTEXT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,
    CONSTRAINT re_pk PRIMARY KEY (reply_id),
    CONSTRAINT re_p_id_fk FOREIGN KEY (package_id) REFERENCES `package` (package_id),
    CONSTRAINT re_u_id_fk FOREIGN KEY (user_id) REFERENCES `user` (user_id)
);
