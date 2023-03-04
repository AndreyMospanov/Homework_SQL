use [master];
go

if db_id('Academy') is not null
begin
	drop database [Academy];
end
go

CREATE DATABASE [Academy];
GO

USE Academy;


CREATE TABLE Curators
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,    
    [Name] NVARCHAR(MAX) NOT NULL CHECK ([Name] != N''),
    Surname NVARCHAR(MAX) NOT NULL,    
);

CREATE TABLE Faculties
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing > 0),
	[Name] NVARCHAR(100) NOT NULL CHECK ([Name] != N'') UNIQUE
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
	[Name] NVARCHAR(10) NOT NULL CHECK ([Name] != N'') UNIQUE,	
	DepartmentId INT NOT NULL REFERENCES Departments(Id),
	[Year] INT NOT NULL CHECK([Year] > 0 AND [Year] < 6),
	Size INT DEFAULT 0 CHECK(Size > 0)
);

CREATE TABLE Teachers
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] NVARCHAR(MAX) NOT NULL CHECK ([Name] != N''),
	Surname NVARCHAR(MAX) NOT NULL CHECK (Surname != N''),
	Salary MONEY NOT NULL CHECK(Salary >= 0),
);

CREATE TABLE Subjects
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] NVARCHAR(100) NOT NULL CHECK ([Name] != N'') UNIQUE
);

CREATE TABLE Lectures
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	LectureRoom NVARCHAR(MAX) NOT NULL CHECK(LectureRoom != N''),
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
(1000000, 'Software Development', 1),
(10000, 'General Geology', 2),
(200000, 'Engeneer Geology', 2),
(20000, 'Geophysics', 2),
(150000, 'Oil Geology', 2)

INSERT INTO Curators
VALUES
('Arcady', 'Voloj'),
('Vagit', 'Alekperov')

INSERT INTO Teachers
VALUES
('Dave', 'McQueen', 1000),
('Jack', 'Underhill', 1200),
('Samantha', 'Adams', 1000),
('Mary', 'Jane', 800),
('Alco', 'Holic', 900),
('Baker', 'Huges', 1200),
('Mike', 'Rutherford', 1000)

INSERT INTO Groups
VALUES
('P107', 1, 1, 38),
('P212', 2, 2, 31),
('P322', 3, 3, 27),
('P434', 4, 4, 25),
('P501', 1, 5, 22),
('G111', 5, 1, 35),
('G223', 6, 2, 30),
('G431', 7, 4, 24),
('G501', 8, 5, 21)

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
('Software Development'),
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
(101, 2, 1),
(103, 3, 1),
(104, 4, 2),
(202, 5, 3),
(202, 6, 3),
(202, 7, 4),
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
GO

--Домашнее задание №5
--Тема: Функции агрегирования.
--Запросы
--1. Вывести количество преподавателей кафедры “Software Development”.

SELECT COUNT(*) AS [Количество преподавателей кафедры “Software Development”] FROM Teachers, Lectures, GroupsLectures, Groups, Departments
WHERE Teachers.Id = Lectures.TeacherId AND Lectures.Id = GroupsLectures.LectureId AND GroupsLectures.GroupId = Groups.Id AND
Groups.DepartmentId = Departments.Id AND Departments.Name = 'Software Development'

--2. Вывести количество лекций, которые читает преподаватель “Dave McQueen”.

SELECT COUNT(*) AS [Количество лекций, которые читает преподаватель “Dave McQueen”] FROM Lectures, Teachers
WHERE Lectures.TeacherId = Teachers.Id AND Teachers.Name = 'Dave' AND Teachers.Surname = 'McQueen'

--3. Вывести количество занятий, проводимых в аудитории “201”.

SELECT COUNT (*) AS [Количество занятий, проводимых в аудитории “201”] FROM Subjects, Lectures
WHERE Subjects.Id = Lectures.SubjectId AND Lectures.LectureRoom = '201'

--4. Вывести названия аудиторий и количество лекций, проводимых в них.

SELECT Lectures.LectureRoom AS [Аудитория], COUNT(SubjectId) AS [Количество лекций] FROM Lectures
GROUP BY LectureRoom

--5. Вывести количество групп (у нас нет таблицы со студентами), посещающих лекции преподавателя “Jack Underhill”.

SELECT COUNT(*) AS [Количество групп, посещающих лекции преподавателя “Jack Underhill”] FROM Groups, GroupsLectures, Lectures, Teachers
WHERE Groups.Id = GroupsLectures.GroupId AND GroupsLectures.LectureId = Lectures.Id AND Lectures.TeacherId = Teachers.Id
AND Teachers.Name = 'Jack' AND Teachers.Surname = 'Underhill'

--6. Вывести среднюю ставку преподавателей факультета “CS&IT”.

SELECT AVG(R.Salary) AS [Средняя ставка преподавателей CS&IT] FROM
(SELECT DISTINCT T.Id AS Id, T.Salary
FROM Teachers AS T, Lectures AS L, GroupsLectures AS GL, Groups AS G, Departments AS D, Faculties AS F
WHERE T.Id = L.TeacherId AND GL.LectureId = L.Id AND GL.GroupId = G.Id AND G.DepartmentId = D.Id 
AND D.FacultyId = F.Id AND F.Name = 'CS&IT') AS R

--7. Вывести минимальное и максимальное количество студентов среди всех групп.

SELECT MAX(Groups.Size) AS [Максимальное количество студентов] FROM Groups

SELECT MIN(Groups.Size) AS [Минимальное количество студентов] FROM Groups

--8. Вывести средний фонд финансирования кафедр.

SELECT AVG(Financing) AS [Средний фонд финансирования кафедр] FROM Departments

--9. Вывести полные имена преподавателей и количество читаемых ими дисциплин.
SELECT DISTINCT T.Id, T.Name+ ' ' + T.Surname AS [Полное имя], TS.SbjCount FROM Teachers AS T,
(SELECT Teachers.Id, COUNT(SubjectId) AS [SbjCount] FROM Teachers, Lectures
WHERE Lectures.TeacherId = Teachers.Id
GROUP BY Teachers.Id) AS TS
WHERE T.Id = TS.Id

--10. Вывести количество лекций в каждый день недели.

--Расписания в БД нет

--11. Вывести номера аудиторий и количество кафедр, чьи лекции в них читаются.

SELECT RoomDep.Room, COUNT(RoomDep.DepId) AS [Количество кафедр, чьи лекции в них читаются]
FROM (SELECT L.LectureRoom AS [Room], D.Id AS [DepId] FROM Lectures AS L, GroupsLectures AS GL, Groups AS G, Departments AS D
WHERE L.Id = GL.LectureId AND GL.GroupId = G.Id AND G.DepartmentId = D.Id) AS RoomDep
GROUP BY Room

--12.Вывести названия факультетов и количество дисциплин, которые на них читаются

SELECT FcltySbj.Name AS [Факультет], COUNT(FcltySbj.SubjectId) AS [Количество дисциплин]
FROM (SELECT DISTINCT L.SubjectId, F.Name FROM  Lectures AS L, GroupsLectures AS GL, Groups AS G, Departments AS D, Faculties as F
WHERE L.Id = GL.LectureId AND GL.GroupId = G.Id AND G.DepartmentId = D.Id AND D.FacultyId = F.Id) AS FcltySbj
GROUP BY FcltySbj.Name





--DROP TABLE GroupsCurators
--DROP TABLE GroupsLectures
--DROP TABLE Groups
--DROP TABLE Departments
--DROP TABLE Lectures
--DROP TABLE Curators
--DROP TABLE Faculties
--DROP TABLE Teachers
--DROP TABLE Subjects


