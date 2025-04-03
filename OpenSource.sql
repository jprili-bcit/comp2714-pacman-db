CREATE TABLE OpenSource (
    PackageID INT PRIMARY KEY,
    License VARCHAR(50) NOT NULL,
    FOREIGN KEY (PackageID) REFERENCES Package(ID)
);