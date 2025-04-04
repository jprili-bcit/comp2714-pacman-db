CREATE TABLE UserWritesReview (
    UserID INT,
    ReviewID INT,
    PRIMARY KEY (UserID, ReviewID),
    FOREIGN KEY (UserID) REFERENCES User(ID),
    FOREIGN KEY (ReviewID) REFERENCES Review(ID)
);