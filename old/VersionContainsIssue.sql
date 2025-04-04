CREATE TABLE VersionContainsIssue (
    VersionNo VARCHAR(20),
    IssueID INT,
    PRIMARY KEY (VersionNo, IssueID),
    FOREIGN KEY (VersionNo) REFERENCES Version(number)
    FOREIGN KEY (IssueID) REFERENCES Issue(IssueID)
);