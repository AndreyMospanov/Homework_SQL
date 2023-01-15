/*������� 1. �������� ���� ������ ����������� ����������. ��� ���� ������ ������ ��������� ���� ������� 
�����. � ������� ����� �������: ��� ��������, ���� 
��������, ���, �������, ����� ����������, ������ ����������, �������� �����. ��� �������� ���� ������ 
����������� ������ CREATE DATABASE. */

CREATE DATABASE Phonebook;
GO

ALTER DATABASE Phonebook
SET MULTI_USER

USE Phonebook;
GO
CREATE TABLE People
(
	FIO NVARCHAR(MAX) NOT NULL,
	Birthdate DATE NOT NULL,
	Sex BIT NOT NULL,
	Phone NCHAR(20) NOT NULL,
	City NVARCHAR(20),
	Country NVARCHAR(20),
	[Address] NVARCHAR(MAX)
);

SELECT * FROM People
GO
DROP TABLE People

ALTER DATABASE Phonebook
SET OFFLINE WITH ROLLBACK IMMEDIATE
ALTER DATABASE Phonebook
SET ONLINE

DROP DATABASE Phonebook;

--������� 2. 
--�������� ���� ������ ��������. ���� ������ 
--������ ��������� ���������� � ���������, �����������, 
--��������. ���������� ������� ��������� ����������:
--1. � ���������: ���, email, ���������� �������
--2. � �����������: ���, email, ���������� �������
--3. � ��������: ����������, ��������, �������� ������, ���� 
--�������, ���� ������
CREATE DATABASE Sales;
GO

USE Sales;
GO

CREATE TABLE Salers
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	FIO NVARCHAR(MAX) NOT NULL,
	Email NCHAR(20),
	Phone NCHAR(20)
);

CREATE TABLE Buyers
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	FIO NVARCHAR(MAX) NOT NULL,
	Email NCHAR(20),
	Phone NCHAR(20)
);

CREATE TABLE Sales
(
	SalerId INT NOT NULL REFERENCES Salers(Id),
	BuyerId INT NOT NULL REFERENCES Buyers(Id),
	Product NVARCHAR(MAX) NOT NULL,
	Price MONEY NOT NULL CHECK(Price > 0),
	SalesDate DATE NOT NULL DEFAULT GETDATE()
);

SELECT * FROM Salers, Buyers, Sales

DROP TABLE Sales
DROP TABLE Buyers
DROP TABLE Salers

ALTER DATABASE Sales
SET OFFLINE WITH ROLLBACK IMMEDIATE
ALTER DATABASE Sales
SET ONLINE
DROP DATABASE Sales;

/*������� 3. �������� ���� ������ ������������ ����������. ���� ������ ������ ��������� ���������� � ����������� ������, ������������, ������. ���������� ������� 
��������� ����������:
1. � ����������� �����: �������� �����, �����������, ���� 
�������, �����, ��������
2. � ������: �������� ������
3. �� ������������: ��������
4. �� ���������: ��������, ������
5. � ������: �������� �����, �������� �����, ������������ 
�����, ����������� ����� �����, �����������.*/

CREATE DATABASE Music_Collection;
GO

USE Music_Collection;
GO

CREATE TABLE Artist
(
Name NVARCHAR(50) PRIMARY KEY NOT NULL 
);

CREATE TABLE Lable
(
	Name NVARCHAR(50) PRIMARY KEY NOT NULL,
	Country NVARCHAR(MAX)
);

CREATE TABLE Style
(
	Name NVARCHAR(50) PRIMARY KEY NOT NULL
);

CREATE TABLE Album
(
	Name NVARCHAR(50) PRIMARY KEY NOT NULL,
	ArtistId NVARCHAR(50) NOT NULL,
	StyleId NVARCHAR(50) REFERENCES Style(Name),
	LabelId NVARCHAR(50) REFERENCES Lable(Name),
	CONSTRAINT FK_AA FOREIGN KEY (ArtistId) REFERENCES Artist(Name)
);

CREATE TABLE Song
(
	Name NVARCHAR(50) PRIMARY KEY NOT NULL,
	AlbumId NVARCHAR(50) REFERENCES Album(Name),
	Length TIME NOT NULL,
	StyleId NVARCHAR(50) REFERENCES Style(Name),
	ArtistId NVARCHAR(50) REFERENCES Artist(Name)
);

SELECT * FROM Album, Song, Artist, Lable, Style

/*������� 4. ��� ������� ���������� ��������� �� ��������� � ���� ������ �� �������� �������:
1. �������� � ��� ������������ ������� � ����������� 
� ����������� ����� ������� � ������� ��������� �� ����
2. �������� � ��� ������������ ������� � ����������� �� 
�������� ������� � ����������� ������� �������� �����
3. �������� � ��� ������������ ������� � ����������� 
� ������ ������ ����, �������� �������� �����
4. ������� �� ��� ������������ ������� � ����������� 
�� �������� ������� � ����������� ������� �������� 
�����
5. ������� ����� ����� ��������� ������������ ������ 
� �������������
6. �������� ����� ����� ��������� ������������ ������ 
� �������������*/

ALTER TABLE Album
ADD Review NVARCHAR(MAX); 

ALTER TABLE Lable
ADD [Address] NVARCHAR(MAX);

ALTER TABLE Song
ALTER COLUMN Name NVARCHAR(100) NOT NULL;

ALTER TABLE Lable
DROP COLUMN [Address];

ALTER TABLE Album
DROP FK_AA;

ALTER TABLE Album
ADD CONSTRAINT FK_AA2 FOREIGN KEY (ArtistId) REFERENCES Artist(Name);

/*������� 5. �������� ��������� �������������. � �������� 
���� ������ ����������� ���� ������ �� �������� �������:
1. ������������� ���������� �������� ���� ������
2. ������������� ���������� �������� ���� ���������
3. ������������� ���������� ������ ���������� � �����: 
�������� �����, �����������, ���� �������, �����, ��������*/
GO
CREATE VIEW StylesView AS
SELECT Style.Name AS [����������� ���� ������] 
FROM Style
GO


CREATE VIEW LableView AS
SELECT Lable.Name AS [����������� ���� ���������] 
FROM Lable
GO 

CREATE VIEW AlbumView AS
SELECT * FROM Album
GO

SELECT * FROM StylesView
SELECT * FROM LableView
SELECT * FROM AlbumView
GO

DROP Table Song
DROP Table Album
DROP Table Artist
DROP Table Lable
DROP Table Style

ALTER DATABASE Music_Collection
SET OFFLINE WITH ROLLBACK IMMEDIATE
ALTER DATABASE Music_Collection
SET ONLINE
DROP DATABASE Music_Collection;

