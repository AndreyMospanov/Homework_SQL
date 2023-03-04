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

CREATE TABLE Teachers
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] NVARCHAR(MAX) NOT NULL CHECK ([Name] != N''),
	Surname NVARCHAR(MAX) NOT NULL CHECK (Surname != N'')	
);

CREATE TABLE Assistants
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TeacherId INT NOT NULL REFERENCES Teachers(Id)
);

CREATE TABLE Curators
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,    
    TeacherId INT NOT NULL REFERENCES Teachers(Id)
);

CREATE TABLE Deans
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TeacherId INT NOT NULL REFERENCES Teachers(Id)
);

CREATE TABLE Heads
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TeacherId INT NOT NULL REFERENCES Teachers(Id)
);

CREATE TABLE Faculties
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
	[Name] NVARCHAR(100) NOT NULL CHECK ([Name] != N'') UNIQUE,
	DeanId INT NOT NULL REFERENCES Deans(Id)
);

CREATE TABLE Departments
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
	[Name] NVARCHAR(100) NOT NULL CHECK ([Name] != N'') UNIQUE,
	FacultyId INT NOT NULL REFERENCES Faculties(Id),
	HeadId INT NOT NULL REFERENCES Heads(Id)
);

CREATE TABLE Groups
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	[Name] NVARCHAR(10) NOT NULL CHECK ([Name] != N'') UNIQUE,
	[Year] INT NOT NULL CHECK([Year] > 0 AND [Year] < 6),
	DepartmentId INT NOT NULL REFERENCES Departments(Id)
);

CREATE TABLE LectureRooms
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
	[Name] NVARCHAR(10) NOT NULL CHECK ([Name] != N'') UNIQUE,
);

CREATE TABLE Subjects
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] NVARCHAR(100) NOT NULL CHECK ([Name] != N'') UNIQUE
);

CREATE TABLE Lectures
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	SubjectId INT NOT NULL REFERENCES Subjects(Id),
	TeacherId INT NOT NULL REFERENCES Teachers(Id)
);

CREATE TABLE Schedules
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,	
	Class INT NOT NULL CHECK(Class BETWEEN 1 AND 8),
	[DayOfWeek] INT NOT NULL CHECK([DayOfWeek] BETWEEN 1 AND 7),
	[Week] INT NOT NULL CHECK([Week] BETWEEN 1 AND 52),
	LectureId INT NOT NULL REFERENCES Lectures(Id),
	LectureRoomId INT NOT NULL REFERENCES LectureRooms(Id)
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
	
GO



INSERT INTO Teachers
VALUES
('Dave', 'McQueen'),
('Jack', 'Underhill'),
('Samantha', 'Adams'),
('Edward', 'Hopper'),
('Alex', 'Carmack'),
('Baker', 'Huges'),
('Mike', 'Rutherford')

INSERT INTO Deans
VALUES
(1),
(6)

INSERT INTO Heads
VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7)

INSERT INTO Curators
VALUES
(2),
(4),
(5),
(7)

INSERT INTO Assistants
VALUES
(3),
(7)

INSERT INTO Faculties 
VALUES 
(3, 'CS&IT', 1),
(1, 'Geological', 2)

INSERT INTO Departments
VALUES
(3, 'Computer Science', 1, 1),
(4, 'Cryptography', 1, 2),
(5, 'Discreet Mathematics', 1, 3),
(5, 'Software Development', 1, 4),
(1, 'General Geology', 2, 5),
(1, 'Engeneer Geology', 2, 5),
(2, 'Geophysics', 2, 6),
(2, 'Oil Geology', 2, 7)

INSERT INTO Groups
VALUES
('P107', 1, 1),
('P212', 2, 2),
('P322', 3, 3),
('P434', 4, 4),
('P501', 5, 1),
('G111', 1, 5),
('G223', 2, 6),
('G431', 4, 7),
('G501', 5, 8)

INSERT INTO GroupsCurators
VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(2, 5),
(3, 6),
(3, 7),
(4, 8),
(3, 9)

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
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
(9, 5),
(10, 5),
(11, 6),
(12, 7),
(13, 6)

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
(9, 10),
(9, 13),
(9, 12),
(9, 9)

INSERT INTO LectureRooms
VALUES
(1, '101'),
(1, '102'),
(2, '201'),
(2, '202'),
(3, '301'),
(4, '404'),
(5, '505'),
(5, '520')

INSERT INTO Schedules
VALUES
(1, 1, 1, 9, 1),
(2, 4, 1, 10, 2),
(1, 2, 3, 11, 3),
(1, 2, 4, 12, 4),
(3, 3, 2, 13, 4),
(4, 6, 52, 13, 4),
(1, 1, 1, 1, 5),
(2, 1, 1, 2, 6),
(2, 2, 1, 3, 7),
(3, 2, 2, 4, 5),
(4, 7, 52, 5, 6),
(7, 5, 45, 6, 7),
(8, 5, 45, 7, 8),
(3, 6, 48, 8, 7)

GO


--ƒомашнее задание є7
--«апросы
--1. ¬ывести названи€ аудиторий, в которых читает лекции преподаватель УEdward HopperФ.

SELECT LectureRooms.Name AS [јудитории, в которых читает лекции преподаватель УEdward HopperФ] 
FROM LectureRooms, Schedules, Lectures, Teachers
WHERE Schedules.LectureRoomId = LectureRooms.Id AND Lectures.Id = Schedules.LectureId 
AND Lectures.TeacherId = Teachers.Id AND Teachers.Name = 'Edward' AND Teachers.Surname = 'Hopper'

--2. ¬ывести фамилии ассистентов, читающих лекции в группе УG501Ф.

SELECT Teachers.Surname AS [‘амилии ассистентов, читающих лекции в группе УG501Ф] 
FROM Assistants, Teachers, Lectures, GroupsLectures AS GL, Groups
WHERE Teachers.Id = Assistants.TeacherId AND Lectures.TeacherId = Teachers.Id AND GL.LectureId = Lectures.Id 
AND Groups.Id = GL.GroupId AND Groups.Name = 'G501'

--3. ¬ывести дисциплины, которые читает преподаватель УAlex CarmackФ дл€ групп 5-го курса.

SELECT Subjects.Name AS [Dисциплины, которые читает преподаватель УAlex CarmackФ дл€ групп 5-го курса] 
FROM Subjects, Lectures, Teachers, GroupsLectures AS GL, Groups
WHERE Lectures.SubjectId = Subjects.Id AND Lectures.TeacherId = Teachers.Id AND  Teachers.Name = 'Alex' AND Teachers.Surname = 'Carmack'
AND GL.LectureId = Lectures.Id AND GL.GroupId = Groups.Id AND Groups.Year = 5

--4. ¬ывести фамилии преподавателей, которые не читают лекции по понедельникам.

SELECT DISTINCT T.Surname AS [ѕреподаватели, которые не читают лекции по понедельникам] 
FROM Teachers AS T
EXCEPT
SELECT T.Surname 
FROM Teachers AS T, Lectures AS L, Schedules AS S
WHERE T.Id = L.TeacherId AND S.LectureId = L.Id AND S.DayOfWeek = 1

--5. ¬ывести названи€ аудиторий, с указанием их корпусов, в которых нет лекций в среду второй недели на третьей паре. /k.202/

SELECT LR.Name, LR.Building FROM LectureRooms AS LR
EXCEPT
SELECT LR.Name, LR.Building
FROM LectureRooms AS LR, Schedules AS S
WHERE LR.Id = S.LectureRoomId AND S.DayOfWeek = 3 AND S.Class = 3 AND S.Week = 2

--6. ¬ывести полные имена преподавателей факультета УCS&ITФ, которые не курируют группы кафедры УSoftware DevelopmentФ./группа 434 Edward Hoppper/

--ƒл€ удобства навигации создадим два вида с иерархи€ми кураторов и преподавателей
GO
CREATE VIEW CuratorsHierarhy AS 
SELECT Teachers.Id AS Id, Teachers.Name + ' ' + Teachers.Surname AS Teacher, Curators.TeacherId AS Curator, Groups.Name AS [Group], Departments.Name AS Department, Faculties.Name AS Faculty 
FROM Teachers, Curators, GroupsCurators, Groups, Departments, Faculties
WHERE Teachers.Id = Curators.TeacherId AND Curators.Id = GroupsCurators.CuratorId AND Groups.Id = GroupsCurators.GroupId 
AND Departments.Id = Groups.DepartmentId AND Departments.FacultyId = Faculties.Id 
GO

CREATE VIEW TeachersHierarhy AS 
SELECT Teachers.Id AS Id, Teachers.Name + ' ' + Teachers.Surname AS [Teacher], Heads.TeacherId AS Head, Departments.Name AS Department, 
Faculties.Name AS Faculty, Deans.TeacherId AS Dean
FROM Teachers, Heads, Departments, Faculties, Deans
WHERE Teachers.Id = Heads.TeacherId AND Departments.HeadId = Heads.Id AND Departments.FacultyId = Faculties.Id AND Faculties.DeanId = Deans.Id
GO

SELECT Teacher AS [Ќе курируют группы кафедры "Software Development"] FROM TeachersHierarhy
WHERE Faculty = 'CS&IT'
EXCEPT
SELECT [Teacher] FROM CuratorsHierarhy
WHERE Department = 'Software Development'

--7. ¬ывести список номеров всех корпусов, которые имеютс€ в таблицах факультетов, кафедр и аудиторий.

SELECT DISTINCT LR.Building, LR.Name, Faculties.Name, Departments.Name/*LR.Building AS [Ќомера корпусов]*/ FROM LectureRooms AS LR, Schedules, Lectures, GroupsLectures AS GL, Groups, Departments, Faculties
WHERE LR.Id = Schedules.LectureRoomId AND Schedules.LectureId = Lectures.Id AND Lectures.Id = GL.LectureId AND GL.GroupId = Groups.Id
AND Groups.DepartmentId = Departments.Id AND Departments.FacultyId = Faculties.Id
ORDER BY LR.Building

--8. ¬ывести полные имена преподавателей в следующем пор€дке: деканы факультетов, заведующие кафедрами, преподаватели, кураторы, ассистенты.

SELECT 'ƒекан ' + TH.Teacher AS [ѕолное им€ преподавател€] FROM TeachersHierarhy AS TH
WHERE Id = Dean
UNION ALL
SELECT '«ав. кафедрой ' +TH.Teacher FROM TeachersHierarhy AS TH
WHERE Id = Head 
UNION ALL
SELECT DISTINCT 'ѕреподаватель ' + TH.Teacher  FROM TeachersHierarhy AS TH
UNION ALL
SELECT ' уратор ' + CH.Teacher  FROM CuratorsHierarhy AS CH
WHERE ID = Curator
UNION ALL
SELECT 'јссистент ' + Teachers.Name + ' ' + Teachers.Surname  FROM Teachers, Assistants
WHERE Teachers.Id IN (Assistants.TeacherId)

--9. ¬ывести дни недели (без повторений), в которые имеютс€ зан€ти€ в аудитори€х У101Ф и У102Ф корпуса 1.

SELECT DISTINCT DayOfWeek AS [дни недели (без повторений), в которые имеютс€ зан€ти€ в аудитори€х У101Ф и У102Ф корпуса 1.] FROM Schedules AS S JOIN LectureRooms AS LR
ON S.LectureRoomId = LR.Id AND LR.Building = 1 AND LR.Name IN ('101', '102')

