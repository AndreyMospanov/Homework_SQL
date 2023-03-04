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
	Name NVARCHAR(50) NOT NULL
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
--практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» выполните действия:
--1. Создайте набор clustered (кластеризованных) индексов для тех таблиц, где это необходимо

GO
DECLARE @msg NVARCHAR(MAX)
SET @msg = 'Аналогично первому заданию, считаю что дополнительных кластеризованных индексов не требуется, чтобы не терялась логика связывания таблиц по id'
PRINT(@msg)

--2. Создайте набор nonclustered (некластеризованных) индексов 
--для тех таблиц, где это необходимо

CREATE NONCLUSTERED INDEX song_idx ON Song(name);
CREATE NONCLUSTERED INDEX genre_idx ON Style(Name);

--3. Решите нужны ли вам composite (композитные) индексы 
--с учетом структуры базы данных и запросов. Если да, создайте индексы

CREATE NONCLUSTERED INDEX album_idx ON Album(name, ArtistId, StyleId, Year)
CREATE NONCLUSTERED INDEX song_composite_idx ON Song(name, AlbumId, ArtistId)

--4. Решите нужны ли вам indexes with included columns (индексы с включенными столбцами). Учитывайте структуру 
--базы данных и запросов. Если необходимость есть, создайте индексы

CREATE NONCLUSTERED INDEX song_timing_idx ON Song(name)
INCLUDE(AlbumId, Duration)

--5. Решите нужны ли вам filtered indexes (отфильтрованные 
--индексы). Учитывайте структуру базы данных и запросов. 
--Если необходимость есть, создайте индексы

CREATE NONCLUSTERED INDEX electronic_music_idx ON Album(name)
WHERE StyleId = 'ELE'

--6. Проверьте execution plans (планы выполнения) для наиболее 
--важных запросов с точки зрения частоты их использования. 
--Если найдено слабое место по производительности, попробуйте решить возникшую проблему с помощью создания 
--новых индексов.

GO
SET SHOWPLAN_ALL ON
GO

SELECT * FROM Album WHERE StyleId = 'ELE'
SELECT art.Name, al.Name, al.Year, s.Name FROM Artist AS art, Album AS al, Song AS s
WHERE al.ArtistId = art.Id AND s.AlbumId = al.Id