USE master;
GO

IF DB_ID('Music_Collection') IS NOT NULL
	BEGIN
	DROP DATABASE [Music_Collection]
	END
GO

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
	ArtistId NVARCHAR(3),
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
('VNG', 'Vangelis'),
('HNZ', 'Hans Zimmer')

INSERT INTO Style
VALUES
('RNR', 'Rock''n''Roll'),
('ALT', 'Alternative'),
('SPR', 'Space Rock'),
('GRU', 'Grunge'),
('GLA', 'Glam Rock'),
('ELE', 'Electronic'),
('DPP', 'Dark Power Pop')

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

--Задание 2. Для базы данных «Музыкальная коллекция» из 
--практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие хранимые 
--процедуры:
--1. Хранимая процедура показывает полную информацию о музыкальных дисках

GO
CREATE PROCEDURE sp_disc_info
AS
SELECT al.Name, Year, ar.Name AS Artist, Style.Name AS Genre, Lable.Name AS Publlisher   
FROM Album AS al, Artist AS ar, Lable, Style
WHERE al.ArtistId = ar.Id AND al.StyleId = Style.Id AND al.LabelId = Lable.Id
ORDER BY Year

GO 
EXECUTE sp_disc_info


--2. Хранимая процедура показывает полную информацию 
--обо всех музыкальных дисках конкретного издателя. Название издателя передаётся в качестве параметра

GO 
CREATE PROCEDURE sp_label_discs
@label NVARCHAR(50)
AS
SELECT al.Name, Year, ar.Name AS Artist, Style.Name AS Genre, Lable.Name AS Publlisher  
FROM Album AS al, Artist AS ar, Lable, Style
WHERE al.ArtistId = ar.Id AND al.StyleId = Style.Id AND al.LabelId = Lable.Id AND Lable.Name LIKE @label
ORDER BY Year 

GO 
EXECUTE sp_label_discs 'Universal'

--3. Хранимая процедура показывает название самого популярного стиля
--4. Популярность стиля определяется по количеству дисков 
--в коллекции

GO 
CREATE PROCEDURE sp_most_popular_genre
AS
BEGIN
WITH DiscOfGenreCount
AS
(SELECT Album.StyleId, COUNT(StyleId) AS count FROM Album GROUP BY StyleId)

SELECT DISTINCT Style.Name AS [Most popular genre] FROM Album, Style, DiscOfGenreCount
WHERE Album.StyleId = Style.Id AND DiscOfGenreCount.StyleId = Style.Id AND 
DiscOfGenreCount.count = (SELECT MAX(count) FROM DiscOfGenreCount)
END

GO
EXECUTE sp_most_popular_genre

--5. Хранимая процедура отображает информацию о диске конкретного стиля с наибольшим количеством песен. Название 
--стиля передаётся в качестве параметра, если передано слово all, анализ идёт по всем стилям

GO
CREATE PROCEDURE sp_largest_songs_catalogue_in_album
@Genre NVARCHAR(30)
AS
WITH SongCount
AS
(SELECT StyleId, COUNT(Song.AlbumId) AS count FROM Song, Album GROUP BY AlbumId, StyleId)
SELECT  TOP 1 s.Name AS [Largest catalogue genre], sc.count  FROM SongCount AS sc, Style AS s
WHERE sc.StyleId = s.Id AND s.Name = @Genre

GO 
EXECUTE sp_largest_songs_catalogue_in_album 'Electronic'

--6. Хранимая процедура удаляет все диски заданного стиля. 
--Название стиля передаётся в качестве параметра. Процедура 
--возвращает количество удаленных альбомов

GO
CREATE PROCEDURE sp_delete_genre
@Genre NVARCHAR(30),
@count INT output
AS
DECLARE @GenreId NVARCHAR(3)
SET @GenreId = (SELECT Style.Id FROM Style WHERE Style.Name = @Genre)
SET @count = 0
SET @count = (SELECT COUNT(Id) FROM Album WHERE StyleId LIKE @GenreId GROUP BY StyleId)
DELETE FROM Album
WHERE StyleId LIKE @GenreId

GO 
DECLARE @countdeleted INT
EXECUTE sp_delete_genre 'Space Rock', @countdeleted output
SELECT 'Удалено ' + CAST(@countdeleted AS NVARCHAR(10)) + ' альбомов' AS [После процедуры удаления по жанру]
SELECT * FROM Album

--7. Хранимая процедура отображает информацию о самом 
--«старом» альбом и самом «молодом». Старость и молодость определяются по дате выпуска

GO
CREATE PROCEDURE sp_oldest_and_newest_albums
AS
SELECT 'Oldest' AS Status, * FROM Album WHERE Year = (SELECT MIN(Year) FROM Album)
UNION
SELECT 'Newest' AS Status, * FROM Album WHERE Year = (SELECT MAX(Year) FROM Album)

GO
EXECUTE sp_oldest_and_newest_albums

--8. Хранимая процедура удаляет все диски в названии которых есть заданное слово. Слово передаётся в качестве 
--параметра. Процедура возвращает количество удаленных альбомов

GO
CREATE PROCEDURE sp_delete_with_word
@word NVARCHAR(20),
@count INT OUTPUT
AS
SET @count = (SELECT COUNT(*) FROM Album WHERE Name LIKE ('%' + @word +'%'))
DELETE FROM Album
WHERE Name LIKE ('%' + @word +'%')

GO 
DECLARE @count_deleted INT
EXECUTE sp_delete_with_word 'please', @count_deleted OUTPUT
SELECT 'Удалено ' + CAST(@count_deleted AS NVARCHAR(10)) + ' альбомов' AS [После процедуры удаления по слову]
SELECT * FROM Album ORDER BY Year