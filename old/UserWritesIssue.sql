CREATE TABLE UserWritesIssue (
    UserID INT,
    IssueID INT,
    PRIMARY KEY (UserID, IssueID),
    FOREIGN KEY (UserID) REFERENCES User(ID),
    FOREIGN KEY (IssueID) REFERENCES Issue(ID)
);