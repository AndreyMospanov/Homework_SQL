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
	CONSTRAINT FK_AA FOREIGN KEY (ArtistId) REFERENCES Artist(Id)
);

CREATE TABLE Song
(
	Name NVARCHAR(50) PRIMARY KEY NOT NULL,
	AlbumId NVARCHAR(5) REFERENCES Album(Id),
	Length TIME(0) NOT NULL,	
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
('Rachels song', 'CNQ', '00:04:47', 'VNG'),
('Love theme', 'CNQ', '00:04:55', 'VNG'),
('End titles', 'CNQ', '00:04:39', 'VNG')
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
SELECT Artist.Name AS [Artist], Song.Name AS [Song], Album.Name AS [Album], Song.Length, Style.Name AS [Genre]  FROM  Artist, Album, Song, Style
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

--CREATE VIEW Most_Popular AS
--SELECT Artist.Name AS [Самый популярный артист] FROM Artist, Album
--WHERE COUNT(Album.Id) = MAX(COUNT(Album.Id)) AND ArtistId = Artist.Id
--GO

/*5. Представление отображает топ-3 самых популярных в коллекции исполнителей. Популярность определяется по количеству дисков в коллекции*/

CREATE VIEW Top_3_Popular AS
SELECT DISTINCT TOP 3 Album.ArtistId AS [Артист]
FROM Album
ORDER BY Album.ArtistId
GO

/*6. Представление отображает самый долгий по длительности музыкальный альбом.*/

--CREATE VIEW Most_Lengthy_Album AS
--SELECT Album.Name, SUM(Song.Length) AS Album_Length
--FROM Song, Album
--WHERE Song.AlbumId = Album.Id
--GO

SELECT * FROM ArtistsView
SELECT * FROM SongInfoView
SELECT * FROM BeatlesDiscography
SELECT * FROM Top_3_Popular

DROP Table Song
DROP Table Album
DROP Table Artist
DROP Table Lable
DROP Table Style

ALTER DATABASE Music_Collection
SET OFFLINE WITH ROLLBACK IMMEDIATE
ALTER DATABASE Music_Collection
SET ONLINE
GO
DROP DATABASE Music_Collection;

