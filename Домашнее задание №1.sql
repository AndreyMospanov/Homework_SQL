--Домашнее задание №1

CREATE DATABASE Music_Collection;
GO

USE Music_Collection;
GO

CREATE TABLE Artist
(
	Id NVARCHAR(3) PRIMARY KEY NOT NULL,
	Name NVARCHAR(50) NOT NULL 
);

CREATE TABLE Lable
(
	Id NVARCHAR(3) PRIMARY KEY NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	Country NVARCHAR(MAX)
);

CREATE TABLE Style
(
	Id NVARCHAR(3) PRIMARY KEY NOT NULL,
	Name NVARCHAR(MAX) NOT NULL
);

CREATE TABLE Album
(
	Id NVARCHAR(5) PRIMARY KEY NOT NULL,
	Name NVARCHAR(50)  NOT NULL,
	Year INT,
	ArtistId NVARCHAR(3),-- REFERENCES Artist(Id),
	StyleId NVARCHAR(3) REFERENCES Style(Id),
	LabelId NVARCHAR(3) REFERENCES Lable(Id),
	CONSTRAINT FK_AA FOREIGN KEY (ArtistId) REFERENCES Artist(Id) ON DELETE CASCADE
);

CREATE TABLE Song
(
	Name NVARCHAR(50) PRIMARY KEY NOT NULL,
	AlbumId NVARCHAR(5) REFERENCES Album(Id) ON DELETE CASCADE,
	Duration TIME(0) NOT NULL,	
	ArtistId NVARCHAR(3) REFERENCES Artist(Id)
);

INSERT INTO Artist 
VALUES
('BEA', 'The Beatles'),
('MUS', 'Muse'),
('NRV', 'Nirvana'),
('QUE', 'Queen'),
('VNG', 'Vangelis')

INSERT INTO Style
VALUES
('RNR', 'Rock''n''Roll'),
('ALT', 'Alternative'),
('SPR', 'Space Rock'),
('GRU', 'Grunge'),
('GLA', 'Glam Rock'),
('ELE', 'Electronic')

INSERT INTO Lable
VALUES
('PAR', 'Parlophone', 'UK'),
('APP', 'Apple', 'US'),
('MUS', 'Mushroom Records', 'UK'),
('GEF', 'Geffen', 'US'),
('EMI', 'EMI Records', 'UK'),
('UNI', 'Universal', 'US')

INSERT INTO Album--id, name, art, sty, lab
VALUES
('PPM', 'Pease please me', 1963, 'BEA', 'RNR', 'PAR'),
('SGT', 'Sgt. Pepper’s Lonely Heart’s Club Band', 1967, 'BEA', 'RNR', 'APP'),
('ABR', 'Abbey Road', 1969, 'BEA', 'RNR', 'APP'),
('SHB', 'Showbiz', 1999, 'MUS', 'SPR', 'MUS'),
('NVM', 'Nevermind', 1991, 'NRV', 'GRU', 'GEF'),
('NOW', 'News of the world', 1977, 'QUE', 'GLA', 'EMI'),
('MIH', 'Made in Heaven', 1992, 'QUE', 'GLA', 'EMI'),
('MIR', 'The Miracle', 1989, 'QUE', 'GLA', 'EMI'),
('CNQ', 'Conquest of Paradise', 1992, 'VNG', 'ELE', 'UNI'),
('BRN', 'Blade Runner', 1984, 'VNG', 'ELE', 'UNI')

INSERT INTO Song--name, alb, len, art
VALUES
('I saw her standing there', 'PPM', '00:02:53', 'BEA'),
('Misery', 'PPM', '00:01:48', 'BEA'),
('Anna', 'PPM', '00:02:57', 'BEA'),
('Chains', 'PPM', '00:02:25', 'BEA'),
('Ask me why', 'PPM', '00:02:26', 'BEA'),
('Sgt. Pepper’s Lonely Heart’s Club Band', 'SGT', '00:02:02', 'BEA'),
('With a little help from my friends', 'SGT', '00:02:44', 'BEA'),
('Lucy in the sky with diamonds', 'SGT', '00:03:28', 'BEA'),
('Come together', 'ABR', '00:04:19', 'BEA'),
('Something', 'ABR', '00:04:19', 'BEA'),
('I want you', 'ABR', '00:07:47', 'BEA'),
('Mean mr. Mustard', 'ABR', '00:01:06', 'BEA'),
('The end', 'ABR', '00:02:21', 'BEA'),
('Muscle museum', 'SHB', '00:04:22', 'MUS'),
('Cave', 'SHB', '00:04:46', 'MUS'),
('Uno', 'SHB', '00:03:38', 'MUS'),
('Smells like teen spirit', 'NVM', '00:05:01', 'NRV'),
('In bloom', 'NVM', '00:04:15', 'NRV'),
('Breed', 'NVM', '00:03:04', 'NRV'),
('Lithium', 'NVM', '00:04:17', 'NRV'),
('We will rock you', 'NOW', '00:02:20', 'QUE'),
('We are the champions', 'NOW', '00:03:30', 'QUE'),
('Made in heaven', 'MIH', '00:05:25', 'QUE'),
('Mother love', 'MIH', '00:04:47', 'QUE'),
('Too much love will kill you', 'MIH', '00:04:19', 'QUE'),
('A winters tale', 'MIH', '00:03:48', 'QUE'),
('The miracle', 'MIR', '00:04:54', 'QUE'),
('I want it all', 'MIR', '00:04:40', 'QUE'),
('Breakthru', 'MIR', '00:04:09', 'QUE'),
('Scandal', 'MIR', '00:04:42', 'QUE'),
('Conques of paradise', 'CNQ', '00:04:38', 'VNG'),
('Moxica the horse', 'CNQ', '00:07:06', 'VNG'),
('Twenty eigth parallel', 'CNQ', '00:05:14', 'VNG'),
('Pinta, nina, santa maria', 'CNQ', '00:13:20', 'VNG'),
('Rachels song', 'BRN', '00:04:47', 'VNG'),
('Love theme', 'BRN', '00:04:55', 'VNG'),
('End titles', 'BRN', '00:04:39', 'VNG')

/*Задание 1. Все задания необходимо выполнить по отношению к базе данных «Музыкальная коллекция», описанной 
в практическом задании для этого модуля. Создайте следующие представления:
1. Представление отображает названия всех исполнителей*/
GO
CREATE VIEW ArtistsView AS
SELECT Artist.Name AS [Artist Name] FROM Artist
GO

/*2. Представление отображает полную информацию о всех песнях: название песни, название диска, длительность песни, 
музыкальный стиль песни, исполнитель*/

CREATE VIEW SongInfoView AS
SELECT Artist.Name AS [Artist], Song.Name AS [Song], Album.Name AS [Album], Song.Duration, Style.Name AS [Genre]  FROM  Artist, Album, Song, Style
WHERE AlbumId = Album.Id AND Album.StyleId = Style.Id AND Song.ArtistId = Artist.Id
GO
/*3. Представление отображает информацию о музыкальных 
дисках конкретной группы. Например, The Beatles*/

CREATE VIEW BeatlesDiscography AS
SELECT * FROM Album 
WHERE ArtistId = 'BEA'
GO

/*4. Представление отображает название самого популярного 
в коллекции исполнителя. Популярность определяется по количеству дисков в коллекции*/

CREATE VIEW Most_Popular AS
SELECT TOP 3 Artist.Name AS [Самый популярный артист] FROM 
(SELECT TOP 3 COUNT(ArtistId) AS AlCount, Album.ArtistId AS ArtistId FROM Album GROUP BY ArtistId ORDER BY AlCount DESC) AS AlbumCount, Artist
WHERE AlbumCount.ArtistId = Artist.Id
GO

/*5. Представление отображает топ-3 самых популярных в коллекции исполнителей. Популярность определяется по количеству дисков в коллекции*/

CREATE VIEW Top_3_Popular AS
SELECT TOP 3 Artist.Name AS [Топ 3 артистов], AlCount AS [Количество альбомов] FROM 
(SELECT TOP 3 COUNT(ArtistId) AS AlCount, Album.ArtistId AS ArtistId FROM Album GROUP BY ArtistId ORDER BY AlCount DESC) AS AlbumCount, Artist
WHERE AlbumCount.ArtistId = Artist.Id
GO

/*6. Представление отображает самый долгий по длительности музыкальный альбом.*/

CREATE VIEW Most_Lengthy_Album AS
SELECT TOP 1 Album.Name FROM
(SELECT AlbumId AS Album, Total = SUM(DATEDIFF(SECOND,'00:00:00', Duration)) FROM Song GROUP BY AlbumId) AS Duration, Album
WHERE Duration.Album = Album.Id
GO

/*Задание 2. Все задания необходимо выполнить по отношению к базе данных «Музыкальная коллекция», описанной 
в практическом задании для этого модуля:
1. Создайте обновляемое представление, которое позволит вставлять новые стили*/

CREATE VIEW GenreView AS
SELECT * FROM Style
GO

--2. Создайте обновляемое представление, которое позволит вставлять новые песни

CREATE VIEW InsertSong AS
SELECT * FROM Song
GO

--3. Создайте обновляемое представление, которое позволит обновлять информацию об издателе

CREATE VIEW LableInfo AS
SELECT * FROM Lable
GO

--4. Создайте обновляемое представление, которое позволит удалять исполнителей

CREATE VIEW ArtistDelete AS
SELECT Artist.Name FROM Artist
GO
/*5. Создайте обновляемое представление, которое позволит 
обновлять информацию о конкретном исполнителе. Например, Muse.*/

CREATE VIEW MuseUpdate AS
SELECT * 
FROM Artist
WHERE Artist.Name = 'Muse'
GO

SELECT * FROM ArtistsView
SELECT * FROM SongInfoView
ORDER BY Artist, Album
SELECT * FROM BeatlesDiscography
ORDER BY Year
SELECT * FROM Most_Popular
SELECT * FROM Top_3_Popular

INSERT INTO GenreView VALUES
('ROB', 'Rockabilly')
SELECT * FROM GenreView

DELETE FROM ArtistDelete
WHERE ArtistDelete.Name = 'Nirvana'
SELECT * FROM ArtistDelete

SELECT *  FROM MuseUpdate





DROP Table Song
DROP Table Album
DROP Table Artist
DROP Table Lable
DROP Table Style
GO
ALTER DATABASE Music_Collection
SET OFFLINE WITH ROLLBACK IMMEDIATE
ALTER DATABASE Music_Collection
SET ONLINE
GO
DROP DATABASE Music_Collection;


/*Задание 3. Все задания необходимо выполнить по отношению к базе данных «Продажи», описанной в практическом 
задании для этого модуля*/



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
	SalesDate DATE DEFAULT GETDATE()
);

--1. Создайте обновляемое представление, которое отображает информацию о всех продавцах
GO
CREATE VIEW SalersInfo AS
SELECT * FROM Salers
GO

--2. Создайте обновляемое представление, которое отображает информацию о всех покупателях

CREATE VIEW BuyersInfo AS
SELECT * FROM Buyers
GO

--3. Создайте обновляемое представление, которое отображает информацию о всех продажах конкретного товара. Например, яблок

CREATE VIEW AppleSales AS
SELECT * FROM Sales 
WHERE Product = 'Apple'
GO

--4. Создайте представление, отображающее все осуществленные сделки

CREATE VIEW AllDeals AS
SELECT * FROM Sales
WITH CHECK OPTION
GO

--5. Создайте представление, отображающее информацию о самом активном продавце. Определяем самого активного продавца по максимальной общей сумме продаж

CREATE VIEW SalerOfTheMonth AS
SELECT Salers.FIO AS [Работник месяца] FROM Salers,
(SELECT TOP 1 SUM(Sales.Price) AS TopSum, SalerId FROM Sales GROUP BY SalerId ORDER BY TopSum DESC) AS TS
WHERE TS.SalerId = Salers.Id
GO

/*6. Создайте представление, отображающее информацию о самом активном покупателе. Определяем самого активного 
покупателя по максимальной общей сумме покупок.
Используйте опции CHECK OPTION, SCHEMABINDING, 
ENCRYPTION там, где это необходимо или полезно*/

CREATE VIEW BestBuyer AS
SELECT Buyers.FIO AS [Лучший клиент] FROM Buyers,
(SELECT TOP 1 SUM(Sales.Price) AS TopSum, BuyerId FROM Sales GROUP BY BuyerId ORDER BY TopSum DESC) AS TS
WHERE TS.BuyerId = Buyers.Id
GO

-------------
INSERT INTO Salers VALUES
('Продавец №1', 'mail1@mail.ru', '555-555'),
('Продавец №2', 'mail2@mail.ru', '555-555')

INSERT INTO Buyers VALUES
('Покупатель №1', 'mail1@ya.ru', '123-456'),
('Покупатель №2', 'mail2@ya.ru', '123-457')

INSERT INTO Sales VALUES
(1, 1, 'Товар №1', 1000, GETDATE()),
(2, 1, 'Товар №2', 1000, GETDATE()),
(1, 2, 'Товар №3', 1000, GETDATE()),
(2, 2, 'Товар №4', 1000, GETDATE()),
(1, 2, 'Товар №5', 1000, GETDATE())

SELECT * FROM SalerOfTheMonth
SELECT * FROM BestBuyer



DROP TABLE Sales
DROP TABLE Buyers
DROP TABLE Salers

ALTER DATABASE Sales
SET OFFLINE WITH ROLLBACK IMMEDIATE
ALTER DATABASE Sales
SET ONLINE
DROP DATABASE Sales;