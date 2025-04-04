-- ISSUE[IssueID, UserID, timestamp, title]
CREATE TABLE issue (
    issue_id INT NOT NULL,
    user_id INT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,
    `status` ENUM('new', 'opened', 'assigned', 'closed', 'abandoned') NOT NULL,
    CONSTRAINT iss_pk PRIMARY KEY (issue_id),
    CONSTRAINT iss_fk FOREIGN KEY (user_id) REFERENCES `user`(user_id)
);

-- FEATURE_REQUEST[IssueID]
CREATE TABLE feature_request (
    issue_id INT NOT NULL,
    CONSTRAINT fr_pk PRIMARY KEY (issue_id),
    CONSTRAINT fr_fk FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);

-- BUG_REPORT[IssueID, stackTrace]
CREATE TABLE bug_report (
    issue_id INT NOT NULL,
    stack_trace LONGTEXT NOT NULL,
    CONSTRAINT br_pk PRIMARY KEY (issue_id),
    CONSTRAINT br_fk FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);

-- REPLIES_TO[ReplyID, UserID, IssueID, content, timestamp]

CREATE TABLE replies_to (
    reply_id INT NOT NULL,
    user_id INT NOT NULL,
    issue_id INT NOT NULL,
    `content` LONGTEXT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,
    CONSTRAINT rt_pk PRIMARY KEY (reply_id),
    CONSTRAINT rt_u_id_fk FOREIGN KEY (user_id) REFERENCES `user`(user_id),
    CONSTRAINT rt_i_id_fk FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);