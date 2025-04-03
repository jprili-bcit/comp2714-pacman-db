-- ISSUE[IssueID, UserID, timestamp, title]
CREATE TABLE issue (
    issue_id INT NOT NULL,
    user_id INT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,
    CONSTRAINT iss_pk PRIMARY KEY (issue_id),
    CONSTRAINT iss_fk FOREIGN KEY (user_id) REFERENCES `user`(user_id)
);
