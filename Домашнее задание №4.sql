
USE Academy;
/*DROP TABLE GroupsCurators
DROP TABLE GroupsLectures
DROP TABLE Groups
DROP TABLE Departments
DROP TABLE Lectures
DROP TABLE Curators
DROP TABLE Faculties
DROP TABLE Teachers
DROP TABLE Subjects*/


CREATE TABLE Curators
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,    
    [Name] NVARCHAR(MAX) NOT NULL CHECK ([Name] != ''),
    Surname NVARCHAR(MAX) NOT NULL,    
);

CREATE TABLE Faculties
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing > 0),
	[Name] NVARCHAR(100) NOT NULL CHECK ([Name] != '') UNIQUE
);

CREATE TABLE Departments
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing > 0),
	[Name] NVARCHAR(100) NOT NULL CHECK ([Name] != '') UNIQUE,
	FacultyId INT NOT NULL REFERENCES Faculties(Id)
);

CREATE TABLE Groups
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	[Name] NVARCHAR(10) NOT NULL CHECK ([Name] != '') UNIQUE,	
	DepartmentId INT NOT NULL REFERENCES Departments(Id),
	[Year] INT NOT NULL CHECK([Year] > 0 AND [Year] < 6)
);

CREATE TABLE Teachers
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] NVARCHAR(MAX) NOT NULL CHECK ([Name] != ''),
	Surname NVARCHAR(MAX) NOT NULL CHECK (Surname != ''),
	Salary MONEY NOT NULL CHECK(Salary >= 0),
);

CREATE TABLE Subjects
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] NVARCHAR(100) NOT NULL CHECK ([Name] != '') UNIQUE
);

CREATE TABLE Lectures
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	LectureRoom NVARCHAR(MAX) NOT NULL CHECK(LectureRoom != ''),
	SubjectId INT NOT NULL REFERENCES Subjects(Id),
	TeacherId INT NOT NULL REFERENCES Teachers(Id)
);

CREATE TABLE GroupsCurators
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	CuratorId INT NOT NULL REFERENCES Curators(Id),
	GroupId INT NOT NULL REFERENCES Groups(Id)	
);

CREATE TABLE GroupsLectures
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	GroupId INT NOT NULL REFERENCES Groups(Id),
	LectureId INT NOT NULL REFERENCES Lectures(Id)
);
	


INSERT INTO Faculties 
VALUES 
(500000, 'CS&IT'),
(100000, 'Geological')

INSERT INTO Departments
VALUES
(50000, 'Computer Science', 1),
(150000, 'Cryptography', 1),
(50000, 'Discreet Mathematics', 1),
(1000000, 'Programming', 1),
(10000, 'General Geology', 2),
(20000, 'Engeneer Geology', 2),
(20000, 'Geophysics', 2),
(150000, 'Oil Geology', 2)

INSERT INTO Curators
VALUES
('Arcady', 'Voloj'),
('Vagit', 'Alekperov')

INSERT INTO Teachers
VALUES
('John', 'Botan', 1000),
('Bob', 'Woo', 1200),
('Samantha', 'Adams', 500),
('Mary', 'Jane', 700),
('Alco', 'Holic', 900),
('Baker', 'Huges', 1200),
('Mike', 'Rutherford', 1000)

INSERT INTO Groups
VALUES
('P107', 1, 1),
('P212', 2, 2),
('P322', 3, 3),
('P434', 4, 4),
('P501', 1, 5),
('G111', 5, 1),
('G223', 6, 2),
('G431', 7, 4),
('G501', 8, 5)

INSERT INTO GroupsCurators
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9)

INSERT INTO Subjects
VALUES
('Computer Science'),
('Programming in C'),
('Object oriented proecting'),
('Cybersecurity'),
('ITE'),
('Mathematics'),
('Statistics'),
('DataBase Theory'),
('Essential geology'),
('Historical geology'),
('Geology of oil & gas'),
('Geophysics'),
('Geoecology')

INSERT INTO Lectures
VALUES
(101, 1, 1),
(102, 2, 1),
(103, 3, 2),
(104, 4, 2),
(201, 5, 3),
(202, 6, 3),
(203, 7, 4),
(204, 8, 4),
(301, 9, 5),
(302, 10, 5),
(402, 11, 6),
(404, 12, 7),
(403, 13, 6)

INSERT INTO GroupsLectures
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 4),
(4, 5),
(4, 6),
(5, 7),
(5, 8),
(6, 9),
(6, 10),
(7, 10),
(7, 9),
(8, 11),
(8, 12),
(9, 13),
(9, 12),
(9, 11)



--1. Вывести все возможные пары строк преподавателей и групп. + Название предмета

SELECT Teachers.Name + ' ' + Surname AS [Full Name], Groups.Name, Subjects.Name FROM Teachers, Groups, Lectures, GroupsLectures, Subjects
WHERE Teachers.Id = Lectures.TeacherId AND Groups.Id = GroupsLectures.GroupId AND GroupsLectures.LectureId = Lectures.Id AND Lectures.SubjectId = Subjects.Id

--2. Вывести названия факультетов, фонд финансирования кафедр которых превышает фонд финансирования факультета.

SELECT DISTINCT Faculties.Name FROM Faculties, Departments
WHERE Faculties.Financing < Departments.Financing AND Departments.FacultyId = FacultyId

--3. Вывести фамилии кураторов групп и названия групп, которые они курируют.

SELECT Curators.Name + ' ' + Curators.Surname AS Name, Groups.Name FROM Curators, Groups, GroupsCurators
WHERE CuratorId = Curators.Id AND GroupId = Groups.Id

--4. Вывести имена и фамилии преподавателей, которые читают лекции у группы “P107”.

SELECT Teachers.Name, Surname FROM Teachers, Groups, GroupsLectures, Lectures
WHERE Groups.Name = 'P107' AND GroupsLectures.GroupId = Groups.Id AND GroupsLectures.LectureId = Lectures.Id AND Lectures.TeacherId = Teachers.Id

--5. Вывести фамилии преподавателей и названия факультетов на которых они читают лекции.

SELECT DISTINCT Teachers.Name + ' ' + Surname AS Name, Faculties.Name AS Faculty FROM Teachers, Groups, GroupsLectures, Lectures, Faculties, Departments
WHERE Lectures.TeacherId = Teachers.Id AND GroupsLectures.LectureId = Lectures.Id AND GroupsLectures.GroupId = Groups.Id 
AND Groups.DepartmentId = Departments.Id AND Departments.FacultyId = Faculties.Id

--6. Вывести названия кафедр и названия групп, которые к ним относятся.

SELECT Departments.Name AS Department, Groups.Name AS [Group] FROM Departments, Groups
WHERE Groups.DepartmentId = Departments.Id

--7. Вывести названия дисциплин, которые читает преподаватель “Samantha Adams”.

SELECT Subjects.Name AS [Лекции Саманты Адамс] FROM Subjects, Lectures, Teachers
WHERE Teachers.Name = 'Samantha' AND Teachers.Surname = 'Adams' AND Teachers.Id = Lectures.TeacherId AND Lectures.SubjectId = Subjects.Id

--8. Вывести названия кафедр, на которых читается дисциплина “Database Theory”.

SELECT Departments.Name AS [DB Theory читают на]FROM Departments, Groups, GroupsLectures, Lectures, Subjects
WHERE Subjects.Name = 'DataBase Theory' AND Subjects.Id = Lectures.SubjectId AND Lectures.Id = GroupsLectures.LectureId AND GroupsLectures.GroupId = Groups.Id 
AND Groups.DepartmentId = Departments.Id

--9. Вывести названия групп, которые относятся к факультету “CS&IT”.

SELECT Groups.Name FROM Groups, Departments, Faculties
WHERE Faculties.Name = 'CS&IT' AND Faculties.Id = Departments.FacultyId AND Departments.Id = Groups.DepartmentId

--10. Вывести названия групп 5-го курса, а также название факультетов, к которым они относятся.

SELECT Groups.Name AS [5 курс], Faculties.Name AS [Факультет] FROM Groups, Departments, Faculties
WHERE Groups.Year = 5 AND Departments.Id = Groups.DepartmentId AND Departments.FacultyId = Faculties.Id

--11. Вывести полные имена преподавателей и лекции, которые они читают (названия дисциплин и групп), причем отобрать 
--только те лекции, которые читаются в аудитории “103”.

SELECT Teachers.Name + ' ' + Teachers.Surname AS [Полное имя], Subjects.Name AS [Предмет], Groups.Name AS [Группа]
FROM Teachers, Lectures, GroupsLectures AS GL, Groups, Subjects
WHERE Lectures.LectureRoom = '103' AND Lectures.TeacherId = Teachers.Id AND GL.LectureId = Lectures.Id 
AND Lectures.SubjectId = Subjects.Id AND GL.GroupId = Groups.Id

DROP TABLE GroupsCurators
DROP TABLE GroupsLectures
DROP TABLE Groups
DROP TABLE Departments
DROP TABLE Lectures
DROP TABLE Curators
DROP TABLE Faculties
DROP TABLE Teachers
DROP TABLE Subjects


