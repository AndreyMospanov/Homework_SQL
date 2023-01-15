/*Задание 1. Создайте базу данных «Телефонный справочник». Эта база данных должна содержать одну таблицу 
«Люди». В таблице нужно хранить: ФИО человека, дату 
рождения, пол, телефон, город проживания, страна проживания, домашний адрес. Для создания базы данных 
используйте запрос CREATE DATABASE. */

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

--Задание 2. 
--Создайте базу данных «Продажи». База данных 
--должна содержать информацию о продавцах, покупателях, 
--продажах. Необходимо хранить следующую информацию:
--1. О продавцах: ФИО, email, контактный телефон
--2. О покупателях: ФИО, email, контактный телефон
--3. О продажах: покупатель, продавец, название товара, цена 
--продажи, дата сделки
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

/*Задание 3. Создайте базу данных «Музыкальная коллекция». База данных должна содержать информацию о музыкальных дисках, исполнителях, стилях. Необходимо хранить 
следующую информацию:
1. О музыкальном диске: название диска, исполнитель, дата 
выпуска, стиль, издатель
2. О стилях: названия стилей
3. Об исполнителях: название
4. Об издателях: название, страна
5. О песнях: название песни, название диска, длительность 
песни, музыкальный стиль песни, исполнитель.*/

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

/*Задание 4. Все задания необходимо выполнить по отношению к базе данных из третьего задания:
1. Добавьте к уже существующей таблице с информацией 
о музыкальном диске столбец с краткой рецензией на него
2. Добавьте к уже существующей таблице с информацией об 
издателе столбец с юридическим адресом главного офиса
3. Измените в уже существующей таблице с информацией 
о песнях размер поля, хранящий название песни
4. Удалите из уже существующей таблицы с информацией 
об издателе столбец с юридическим адресом главного 
офиса
5. Удалите связь между таблицами «музыкальных дисков» 
и «исполнителей»
6. Добавьте связь между таблицами «музыкальных дисков» 
и «исполнителей»*/

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

/*Задание 5. Создайте следующие представления. В качестве 
базы данных используйте базу данных из третьего задания:
1. Представление отображает названия всех стилей
2. Представление отображает названия всех издателей
3. Представление отображает полную информацию о диске: 
название диска, исполнитель, дата выпуска, стиль, издатель*/
GO
CREATE VIEW StylesView AS
SELECT Style.Name AS [Отображение всех стилей] 
FROM Style
GO


CREATE VIEW LableView AS
SELECT Lable.Name AS [Отображение всех издателей] 
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

