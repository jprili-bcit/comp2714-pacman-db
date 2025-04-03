CREATE TABLE Proprietary (
    PackageID INT PRIMARY KEY,
    License VARCHAR(50) NOT NULL,
    Price int NOT NULL,
    FOREIGN KEY (PackageID) REFERENCES Package(ID)
);