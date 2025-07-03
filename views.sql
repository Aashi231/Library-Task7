--
-- File generated with SQLiteStudio v3.4.17 on Thu Jul 3 15:47:14 2025
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: AUTHORS
CREATE TABLE IF NOT EXISTS AUTHORS (
    AuthorID INTEGER PRIMARY KEY,
    Name     TEXT,
    Bio      TEXT
);

INSERT INTO AUTHORS (
                        AuthorID,
                        Name,
                        Bio
                    )
                    VALUES (
                        1,
                        'George Orwell',
                        'Author of 1984 and Animal Farm'
                    );

INSERT INTO AUTHORS (
                        AuthorID,
                        Name,
                        Bio
                    )
                    VALUES (
                        2,
                        'J.K. Rowling',
                        'British author best known for Harry Potter series'
                    );

INSERT INTO AUTHORS (
                        AuthorID,
                        Name,
                        Bio
                    )
                    VALUES (
                        3,
                        'Stephen Hawking',
                        'Theoretical physicist and author of A Brief History of Time'
                    );


-- Table: BookAuthors
CREATE TABLE IF NOT EXISTS BookAuthors (
    BookID   INTEGER,
    AuthorID INTEGER,
    PRIMARY KEY (
        BookID,
        AuthorID
    ),
    FOREIGN KEY (
        BookID
    )
    REFERENCES Books (BookID),
    FOREIGN KEY (
        AuthorID
    )
    REFERENCES Authors (AuthorID) 
);

INSERT INTO BookAuthors (
                            BookID,
                            AuthorID
                        )
                        VALUES (
                            1,
                            1
                        );

INSERT INTO BookAuthors (
                            BookID,
                            AuthorID
                        )
                        VALUES (
                            2,
                            3
                        );


-- Table: Books
CREATE TABLE IF NOT EXISTS Books (
    BookID     INTEGER PRIMARY KEY,
    Title      TEXT,
    ISBN       TEXT    UNIQUE,
    CategoryID INTEGER,
    FOREIGN KEY (
        CategoryID
    )
    REFERENCES Categories (CategoryID) 
);

INSERT INTO Books (
                      BookID,
                      Title,
                      ISBN,
                      CategoryID
                  )
                  VALUES (
                      1,
                      '1984',
                      '9780451524935',
                      1
                  );

INSERT INTO Books (
                      BookID,
                      Title,
                      ISBN,
                      CategoryID
                  )
                  VALUES (
                      2,
                      'A Brief History of Time',
                      '9780553380163',
                      2
                  );


-- Table: Categories
CREATE TABLE IF NOT EXISTS Categories (
    CategoryID   INTEGER PRIMARY KEY,
    CategoryName TEXT
);

INSERT INTO Categories (
                           CategoryID,
                           CategoryName
                       )
                       VALUES (
                           1,
                           'Fiction'
                       );

INSERT INTO Categories (
                           CategoryID,
                           CategoryName
                       )
                       VALUES (
                           2,
                           'Science'
                       );

INSERT INTO Categories (
                           CategoryID,
                           CategoryName
                       )
                       VALUES (
                           3,
                           'History'
                       );


-- Table: Loans
CREATE TABLE IF NOT EXISTS Loans (
    LoanID     INTEGER PRIMARY KEY,
    BookID     INTEGER,
    MemberID   INTEGER,
    LoanDate   TEXT,
    ReturnDate TEXT,
    FOREIGN KEY (
        BookID
    )
    REFERENCES Books (BookID),
    FOREIGN KEY (
        MemberID
    )
    REFERENCES Members (MemberID) 
);

INSERT INTO Loans (
                      LoanID,
                      BookID,
                      MemberID,
                      LoanDate,
                      ReturnDate
                  )
                  VALUES (
                      1,
                      1,
                      1,
                      '2025-06-01',
                      NULL
                  );

INSERT INTO Loans (
                      LoanID,
                      BookID,
                      MemberID,
                      LoanDate,
                      ReturnDate
                  )
                  VALUES (
                      2,
                      2,
                      2,
                      '2025-06-10',
                      '2025-06-20'
                  );


-- Table: Members
CREATE TABLE IF NOT EXISTS Members (
    MemberID INTEGER PRIMARY KEY,
    Name     TEXT,
    Email    TEXT    UNIQUE
);

INSERT INTO Members (
                        MemberID,
                        Name,
                        Email
                    )
                    VALUES (
                        1,
                        'Tina Doere',
                        'aashi@example.com'
                    );

INSERT INTO Members (
                        MemberID,
                        Name,
                        Email
                    )
                    VALUES (
                        2,
                        'John Martine',
                        'john.m@example.com'
                    );


-- View: AuthorBookCount
CREATE VIEW IF NOT EXISTS AuthorBookCount AS
    SELECT Authors.Name,
           COUNT(BookAuthors.BookID) AS NumberOfBooks
      FROM Authors
           LEFT JOIN
           BookAuthors ON Authors.AuthorID = BookAuthors.AuthorID
     GROUP BY Authors.AuthorID;


-- View: BookCategoryView
CREATE VIEW IF NOT EXISTS BookCategoryView AS
    SELECT Books.Ttitle,
           Books,
           ISBN,
           Categories.CategoryName
      FROM Books
           INNER JOIN
           Categories ON Books.CategoryID = Categories.CategoryID;


-- View: BookCategoryViews
CREATE VIEW IF NOT EXISTS BookCategoryViews AS
    SELECT Books.Title,
           Books.ISBN,
           Categories.CategoryName
      FROM Books
           INNER JOIN
           Categories ON Books.CategoryID = Categories.CategoryID;


-- View: CurrentlyBorrowedBooks
CREATE VIEW IF NOT EXISTS CurrentlyBorrowedBooks AS
    SELECT Loans.LoanID,
           Books.Title,
           Members.Name AS BorrowedBy,
           Loans.LoanDate
      FROM Loans
           INNER JOIN
           Books ON Loans.BookID = Books.BookID
           INNER JOIN
           Members ON Loans.MemberID = Members.MemberID
     WHERE Loans.ReturnDate IS NULL;


-- View: MemberLoanCount
CREATE VIEW IF NOT EXISTS MemberLoanCount AS
    SELECT Members.Name,
           Members.Email,
           COUNT(Loans.LoanID) AS TotalLoans
      FROM Members
           LEFT JOIN
           Loans ON Members.MemberID = Loans.MemberID
     GROUP BY Members.MemberID;


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
