-- ISSUE[IssueID, UserID, timestamp, title]
CREATE TABLE issue (
    issue_id INT NOT NULL,
    user_id INT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,
    issue_type ENUM( 'bug_report', 'feature_request' ) NOT NULL,
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