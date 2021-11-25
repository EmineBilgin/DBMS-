Use master

Create Database University

Use University

CREATE TABLE Region
(
RegionID INT IDENTITY(1, 1),
RegionName VARCHAR(25) CHECK (RegionName IN ('England', 'Scotland', 'Wales', 'Northern Ireland')) NOT NULL,
PRIMARY KEY (RegionID)
);

INSERT Region (RegionName)
VALUES('England'),
('Scotland'),
('Wales'),
('Northern Ireland');

CREATE TABLE Staff
(
StaffID INT IDENTITY(10, 1),
FirstName nVARCHAR(50) NOT NULL,
LastName nVARCHAR(50) NOT NULL,
RegionID INT NOT NULL,
PRIMARY KEY (StaffID),
FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

INSERT Staff (FirstName, LastName,  RegionID)
VALUES('Kellie', 'Pear',  1),
('Harry', 'Smith', 1),
('Margeret', 'Nolan', 1),
('Neil', 'Mango', 2),
('Ross', 'Island', 2),
('October', 'Lime', 3),
('Tom', 'Garden', 4),
('Victor', 'Fig', 3),
('Yavette', 'Berry', 4)


CREATE TABLE Student
(
StudentID INT IDENTITY(20, 1),
FirstName nVARCHAR(50) NOT NULL,
LastName nVARCHAR(50) NOT NULL,
Register_date Date NOT NULL DEFAULT '2020-05-12',
RegionID INT NOT NULL,
StaffID INT NOT NULL,
PRIMARY KEY (StudentID),
FOREIGN KEY (StaffID) REFERENCES Staff (StaffID),
FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);


INSERT INTO Student (FirstName, LastName, StaffID, RegionID)
VALUES('Zorro', 'Apple', 10, 1),
('Debbie', 'Orange', 17, 3),
('Charlie','Apricot', 11, 1),
('Ursula', 'Douglas', 13, 2),
('Bronwin', 'Blueberry', 14, 2),
('Alec', 'Hunter', 15, 3);

CREATE TABLE Course
(
CourseID INT IDENTITY(30, 1),
Title VARCHAR(50) NOT NULL,
Credit INT CHECK (Credit in (15,30)) NOT NULL,
PRIMARY KEY (CourseID)
);


INSERT Course (Title, Credit)
VALUES('French', 30),
('Physics', 30),
('Psychology', 30),
('History', 30),
('Biology', 15),
('Fine Arts', 15),
('German', 15),
('Music', 30),
('Chemistry', 30);

CREATE TABLE Enrollment
(
StudentID INT  NOT NULL, 
CourseID INT NOT NULL, 
PRIMARY KEY (StudentID, CourseID),
FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

INSERT Enrollment
VALUES (22, 35),
(23, 35),
(24, 35),
(25, 35),
(22, 36),
(23, 36),
(24, 36),
(25, 36);


CREATE TABLE StaffCourse
(
StaffID INT NOT NULL,
CourseID INT NOT NULL, 
PRIMARY KEY (StaffID, CourseID),
FOREIGN KEY (StaffID) REFERENCES Staff(StaffID), 
FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);


INSERT INTO StaffCourse (StaffID, CourseID)
VALUES(10, 30),
(12, 30),
(10, 31),
(11, 31),
(12, 38),
(13, 35),
(11, 36),
(18, 34)



Create FUNCTION dbo.check_credit()
RETURNS INT
AS
BEGIN
	DECLARE @REJECT int

	IF EXISTS (
				SELECT 1
				FROM	(
						SELECT	B.StudentID, sum(Credit) sum_credit
						FROM	Course A 
						INNER JOIN Enrollment B 
						ON		A.CourseID = B.CourseID
						GROUP BY B.StudentID
						) A
				WHERE sum_credit > 180
			) 
		SET @REJECT = 1 
	ELSE
		SET @REJECT = 0

RETURN @REJECT
END;

ALTER TABLE Enrollment
ADD CONSTRAINT CK_check_credit CHECK(dbo.check_credit() = 0);

ALTER TABLE COURSE
ADD CONSTRAINT CK_check_credit2 CHECK(dbo.check_credit() = 0);

CREATE FUNCTION check_region2()
RETURNS INT
AS
BEGIN
	DECLARE @REJECT int
		IF EXISTS(
					SELECT 1
					FROM Student A INNER JOIN Staff B ON A.StaffID = B.StaffID 
					WHERE A.RegionID != B.RegionID
				)
			SET @REJECT =1
		ELSE 
			SET @REJECT = 0

RETURN @REJECT
END;

ALTER TABLE Student
ADD CONSTRAINT CK_check_region2 CHECK(dbo.check_region2() = 0);


--1. Test the credit limit constraint.

INSERT INTO Enrollment (StudentID, CourseID)
VALUES (21, 30),
(21, 31),
(21, 32),
(21, 33),
(21, 35),
(21, 36),
(21, 37)

select * from COURSE



--2. Test that you have correctly defined the constraint for the student counsel's region.

INSERT INTO Student (FirstName, LastName, StaffID, RegionID)
VALUES
('Fred', 'Udress', 16, 4),
('Irene', 'Roland', 15, 3),
('Jack', 'Quince', 15, 3);

--3. Try to set the credits of the History course to 20. (You should get an error.)

UPDATE Course
SET Credit = 20
WHERE CourseID = 33


--4. Try to set the credits of the Fine Arts course to 30.(You should get an error.)


UPDATE Course
SET Credit = 30
WHERE CourseID = 35



SELECT  * FROM Course

--5. Debbie Orange wants to enroll in Chemistry instead of German. (You should get an error.)

UPDATE Enrollment
SET CourseID = 38
WHERE StudentID = 21
AND CourseID = 36



SELECT * FROM Course

--6. Try to set Tom Garden as counsel of Alec Hunter (You should get an error.)

UPDATE Student
SET StaffID = 16
WHERE StudentID = 25;




--7. Swap counselors of Ursula Douglas and Bronwin Blueberry.


SELECT * FROM Student

/*UPDATE Student
SET StaffID = (SELECT StaffID FROM Student WHERE StudentID=24) 
WHERE StudentID = 23;


UPDATE Student
SET StaffID = (SELECT StaffID FROM Student WHERE StudentID=23)   --değişiklik yapmadı.
WHERE StudentID = 24 */


DECLARE @FIRST_STAFF INT;
DECLARE @SECOND_STAFF INT;

SET @FIRST_STAFF = (SELECT StaffID FROM Student WHERE StudentID=23);
SET @SECOND_STAFF = (SELECT StaffID FROM Student WHERE StudentID=24);


UPDATE Student
SET StaffID = @FIRST_STAFF -- eski deðer 14
WHERE StudentID = 24;


UPDATE Student
SET StaffID = @SECOND_STAFF -- eski deðer 13
WHERE StudentID = 23


--8. Remove a staff member from the staff table.
--	 If you get an error, read the error and update the reference rules for the relevant foreign key.


SELECT * FROM Staff



DELETE FROM Staff 
WHERE StaffID = 15  
  
