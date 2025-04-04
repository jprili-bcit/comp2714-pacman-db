CREATE TABLE UserRepliesToIssue (
    UserID INT,
    IssueID INT,
    PRIMARY KEY (UserID, IssueID, ReplyDate),
    FOREIGN KEY (UserID) REFERENCES User(ID),
    FOREIGN KEY (IssueID) REFERENCES Issue(ID)
);