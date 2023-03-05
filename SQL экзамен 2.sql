USE master;
GO

IF DB_ID('Showbusiness') IS NOT NULL
BEGIN
	DROP DATABASE [Showbusiness]
END
GO

CREATE DATABASE Showbusiness;
GO

USE Showbusiness
GO

CREATE TABLE Countries
(
id INT PRIMARY KEY IDENTITY (1,1),
country_name NVARCHAR(30) NOT NULL CHECK(country_name != N'')
);

CREATE TABLE Cities
(
id INT PRIMARY KEY IDENTITY (1,1),
city_name NVARCHAR(30) NOT NULL CHECK(city_name != N''),
country_id INT REFERENCES Countries(id) ON DELETE NO ACTION
);

CREATE TABLE Venues
(
id INT PRIMARY KEY IDENTITY (1,1),
venue_name NVARCHAR(30) NOT NULL CHECK(venue_name != N''),
city_id INT REFERENCES Cities(id) ON DELETE NO ACTION
);

CREATE TABLE Categories
(
id INT PRIMARY KEY IDENTITY (1,1),
category_name NVARCHAR(30) NOT NULL CHECK(category_name != N'')
);

CREATE TABLE Shows
(
id INT PRIMARY KEY IDENTITY (1,1),
show_name NVARCHAR(200) NOT NULL CHECK(show_name != N''),
show_date DATE NOT NULL CHECK(show_date > GETDATE()),
venue_id INT REFERENCES Venues(id) ON DELETE NO ACTION,
show_time TIME NOT NULL,
category_id INT REFERENCES Categories(id) ON DELETE NO ACTION,
description_show NVARCHAR(MAX),
restrictions INT NOT NULL,
image_show IMAGE,
max_tickets INT NOT NULL,
tickets_bought INT DEFAULT 0
);

CREATE TABLE Clients
(
id INT PRIMARY KEY IDENTITY (1,1),
full_name NVARCHAR(100) NOT NULL CHECK(full_name != N''),
email VARCHAR(50) UNIQUE NOT NULL CHECK(email != ''),
birthdate DATE NOT NULL
);

CREATE TABLE Sales
(
id INT PRIMARY KEY IDENTITY (1,1),
client_id INT NOT NULL REFERENCES Clients(id) ON DELETE NO ACTION,
show_id INT REFERENCES Shows(id) ON DELETE NO ACTION,
price MONEY NOT NULL,
sale_date DATE DEFAULT GETDATE()
);

CREATE TABLE Archive
(
id INT ,
show_name NVARCHAR(20),
show_date DATE,
venue_id INT,
show_time TIME,
category_id INT,
description_show NVARCHAR(MAX),
restrictions INT,
image_show IMAGE,
max_tickets INT,
tickets_bought INT
);

GO
CREATE VIEW Show_info AS
SELECT show_name, show_date, category_name, venue_name, city_name, country_name FROM Shows
JOIN Venues ON venue_id = Venues.id
JOIN Cities ON Venues.city_id = Cities.id
JOIN Countries ON Countries.id = Cities.country_id
JOIN Categories ON Categories.id = category_id

GO
CREATE VIEW Show_info_all AS
SELECT show_name, show_date, category_name, venue_name, city_name, country_name FROM Shows
JOIN Venues ON venue_id = Venues.id
JOIN Cities ON Venues.city_id = Cities.id
JOIN Countries ON Countries.id = Cities.country_id
JOIN Categories ON Categories.id = category_id
UNION
SELECT show_name, show_date, category_name, venue_name, city_name, country_name FROM Archive
JOIN Venues ON venue_id = Venues.id
JOIN Cities ON Venues.city_id = Cities.id
JOIN Countries ON Countries.id = Cities.country_id
JOIN Categories ON Categories.id = category_id

--При проектировании базы данных обязательно используйте индексы
GO
CREATE CLUSTERED INDEX archive_idx ON Archive(id);
CREATE NONCLUSTERED INDEX archive_big_idx ON Archive(id)
INCLUDE (show_name, venue_id);

CREATE NONCLUSTERED INDEX show_idx ON Shows(id)
INCLUDE (show_name, venue_id);

CREATE NONCLUSTERED INDEX client_idx ON Clients(id, full_name);

CREATE NONCLUSTERED INDEX sales_idx ON Sales(client_id, show_id);

--Продумайте систему безопасности. Обязательные требования к ней: 
--■ Пользователь с полным доступом ко всей информации
--GO
--CREATE USER _admin WITH Password = 'admin';

--EXEC sp_addsrvrolemember @loginame = '_admin', @rolename =
--'sysadmin'

----■ Пользователь с правом только на чтение данных
--GO
--CREATE USER Client;

----■ Пользователь с правом резервного копирования и восстановления данных

--CREATE USER backup_admin WITH Password = 'backup_admin';
--GRANT BACKUP DATABASE TO backup_admin;

--■ Пользователь с правом создания и удаления пользователей.

--■ Отобразите все актуальные события на конкретную дату. 
--  Дата указывается в качестве параметра
GO
CREATE FUNCTION SHOWS_A_THE_DATE(@date DATE)
RETURNS TABLE
AS
RETURN (SELECT * FROM Show_info WHERE show_date = @date);

--■ Отобразите все актуальные события из конкретной категории. Категория указывается в качестве параметра

GO
CREATE FUNCTION SHOWS_AT_THE_CATEGORY(@category NVARCHAR(30))
RETURNS TABLE
AS
RETURN (SELECT * FROM Show_info WHERE category_name = @category);

--■ Отобразите все актуальные события со стопроцентной 
--продажей билетов

GO
CREATE PROCEDURE sp_sold_out_shows
AS
SELECT Show_info.* FROM Show_info
JOIN Shows ON Show_info.show_name = Shows.show_name
WHERE Shows.show_date > GETDATE() AND tickets_bought = max_tickets

--■ Отобразите топ-3 самых популярных актуальных событий (по количеству приобретенных билетов)
GO
CREATE PROCEDURE sp_top3_popular_actual
AS
SELECT TOP(3) tickets_bought, Show_info.* FROM Shows, Show_info
WHERE Shows.show_name = Show_info.show_name AND Shows.show_date >= GETDATE();

--■ Отобразите топ-3 самых популярных категорий событий 
--(по количеству всех приобретенных билетов). Архив событий учитывается

GO
CREATE PROCEDURE sp_top3_popular_ever
AS
SELECT TOP 3 tickets_bought, show_name FROM 
(
SELECT TOP(3) tickets_bought, show_name FROM Shows
UNION
SELECT TOP(3) tickets_bought, show_name FROM Archive
) AS SubQ;

--■ Отобразите самое популярное событие в конкретном городе. Город указывается в качестве параметра

GO
CREATE FUNCTION MOST_POPULAR_IN_THE_CITY(@city NVARCHAR(30))
RETURNS TABLE
AS
RETURN (SELECT Show_info.* FROM Show_info 
JOIN Shows ON Shows.show_name = Show_info.show_name
WHERE city_name = @city);


--■ Покажите информацию о самом активном клиенте (по 
--количеству купленных билетов)

GO
CREATE PROCEDURE sp_best_client
AS
SELECT TOP 1 SUM(price), Clients.full_name FROM Clients
JOIN Sales ON Sales.client_id = Clients.id
GROUP BY Clients.full_name

--■ Покажите информацию о самой непопулярной категории 
--(по количеству событий). Архив событий учитывается.

GO
CREATE PROCEDURE sp_unpopular_category
AS
SELECT category_name FROM Show_info_all
GROUP BY Show_info_all.category_name
HAVING COUNT(Show_info_all.show_name) = MIN(COUNT(Show_info_all.show_name))

--■ Отобразите топ-3 набирающих популярность событий 
--(по количеству проданных билетов за 5 дней) 
GO
CREATE PROCEDURE sp_top3_pop
AS
SELECT TOP 3 (Sales.show_id), Sales.show_id FROM Sales
JOIN Shows ON Shows.id = Sales.show_id
GROUP BY Sales.show_id

--■ Покажите все события, которые пройдут сегодня в указанное время. Время передаётся в качестве параметра 

GO
CREATE FUNCTION TODAYS_SHOW(@time_start TIME)
RETURNS TABLE
AS 
RETURN (SELECT show_name FROM Shows
WHERE show_date = GETDATE() AND show_time = @time_start);

--■ Покажите название городов, в которых сегодня пройдут 
--события 

GO
CREATE PROCEDURE sp_today_shows_cities
AS
SELECT city_name AS [Today's shows city] FROM Shows
JOIN Venues ON Shows.venue_id = Venues.id
JOIN Cities ON Venues.city_id = Cities.id

--■ При вставке нового клиента нужно проверять, нет ли его 
--уже в базе данных. Если такой клиент есть, генерировать 
--ошибку с описанием возникшей проблемы

GO
CREATE TRIGGER ClientChecker
ON Clients 
AFTER INSERT
AS
BEGIN
DECLARE @new_mail VARCHAR(30);
SET @new_mail = (SELECT email FROM inserted);
IF(@new_mail = (SELECT email FROM Clients))
	BEGIN 
	RAISERROR('Такой клиент уже есть', 0, 1)
	ROLLBACK TRANSACTION
	END
END

--■ При вставке нового события нужно проверять, нет ли его 
--уже в базе данных. Если такое событие есть, генерировать 
--ошибку с описанием возникшей проблемы

GO
CREATE TRIGGER ShowChecker
ON Shows 
AFTER INSERT
AS
BEGIN
DECLARE @new_show VARCHAR(30);
SET @new_show = (SELECT show_name FROM inserted);
IF(@new_show = (SELECT show_name FROM Shows))
	BEGIN
	RAISERROR('Событие с таким названием уже есть', 0,1)
	ROLLBACK TRANSACTION
	END
END

--■ При удалении прошедших событий необходимо их переносить в архив событий

GO
CREATE TRIGGER ShowArchivator
ON Shows
FOR DELETE
AS
BEGIN
INSERT INTO Archive
SELECT * FROM deleted
END

--■ При попытке покупки билета проверять не достигнуто ли 
--уже максимальное количество билетов. Если максимальное количество достигнуто, генерировать ошибку с информацией о возникшей проблеме

GO
CREATE TRIGGER TicketsAviabilityChecker
ON Sales
AFTER INSERT
AS
BEGIN
DECLARE @show_id INT
SET @show_id = (SELECT show_id FROM inserted)
IF((SELECT tickets_bought FROM Shows WHERE id = @show_id) = (SELECT max_tickets FROM Shows WHERE id = @show_id))
	BEGIN 
	RAISERROR('Sold Out! Все билеты раскуплены!', 0, 1)
	ROLLBACK TRANSACTION
	END
ELSE
UPDATE Shows
SET tickets_bought +=1 WHERE id = @show_id
END

--■ При попытке покупки билета проверять возрастные ограничения. Если возрастное ограничение нарушено, генерировать ошибку с информацией о возникшей проблеме

GO
CREATE TRIGGER AgeChecker
ON Sales
AFTER INSERT
AS
BEGIN
DECLARE @client_id INT
SET @client_id = (SELECT client_id FROM inserted)
IF((SELECT DATEDIFF(YEAR, birthdate, GETDATE()) FROM Clients WHERE Clients.id = @client_id) < (SELECT restrictions FROM Shows, inserted WHERE Shows.id = inserted.show_id))
	BEGIN
	RAISERROR('Ограничение по возрасту, продажа невозможна!',0,1)
	ROLLBACK TRANSACTION
	END
END

--■ Настроить создание резервных копий с периодичностью 
--раз в день.
GO
CREATE PROCEDURE sp_backup_db
AS
DECLARE @pathName NVARCHAR(512) 
SET @pathName = 'C:\Backup\dbbackups\db_backup_' + Convert(varchar(8), GETDATE(), 112) + '.bak' 
BACKUP DATABASE [Showbusiness] TO  DISK = @pathName WITH NOFORMAT, NOINIT,  NAME = N'db_backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
