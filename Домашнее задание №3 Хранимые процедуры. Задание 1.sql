USE [master];
GO

IF db_id('Sportstore') is not null
begin
	DROP DATABASE [Sportstore];
end
GO

CREATE DATABASE Sportstore;
GO
USE Sportstore;
GO
CREATE TABLE Goods
(
good_id INT PRIMARY KEY IDENTITY(1,1),
good_name NVARCHAR(30) NOT NULL CHECK (good_name != N''),
good_type NVARCHAR(30) NOT NULL CHECK (good_type != N''),
quantity_stored INT DEFAULT 0 CHECK(quantity_stored >=0),
bought MONEY DEFAULT 0 CHECK(bought >=0),
price_for_sale MONEY NOT NULL,
manufacturer NVARCHAR(30),
total_sold MONEY DEFAULT 0
);

CREATE TABLE Employees
(
employee_id INT PRIMARY KEY IDENTITY (1,1),
employee_name NVARCHAR(50) NOT NULL CHECK(employee_name != N''),
position NVARCHAR(50) NOT NULL CHECK(position != N''),
employeed DATETIME NOT NULL,
sex NVARCHAR(10) NOT NULL,
salary MONEY NOT NULL CHECK ([salary] >= 12000),
sold MONEY DEFAULT 0
);

CREATE TABLE Clients
(
client_id INT PRIMARY KEY IDENTITY (1,1),
client_name NVARCHAR(50) NOT NULL CHECK(client_name != N''),
email VARCHAR(MAX),
phone VARCHAR(10),
discont INT NOT NULL CHECK([discont] >= 0),
subscribed BIT NOT NULL DEFAULT 0, 
sum_bought MONEY DEFAULT 0,
registered DATETIME
);

CREATE TABLE Sales
(
sale_id INT PRIMARY KEY IDENTITY(1,1),
good_id INT NOT NULL REFERENCES Goods(good_id) ON DELETE NO ACTION,
price_of_sale MONEY NOT NULL,
sale_date DATETIME NOT NULL DEFAULT GETDATE(),
quantity_saled INT DEFAULT 1,
salerId INT NOT NULL REFERENCES Employees(employee_id) ON DELETE NO ACTION,
clientId INT NOT NULL REFERENCES Clients(client_id) ON DELETE NO ACTION
);

GO

INSERT INTO Goods VALUES--имя, тип, количество, закупочная, цена, производитель
('Спортивный костюм', 'Одежда', 10, 1500, 4599, 'Абибас', 45000),
('Треники', 'Одежда', 5, 500, 1999, 'Ивановский трикотаж', 99999),
('Шлёпанцы', 'Обувь', 12, 100, 799, 'Подвал вьетнамского рынка', 500000),
('Кеды', 'Обувь', 4, 350, 2000, 'Подвал вьетнамского рынка', 34999),
('Велосипед', 'Спортинвентарь', 5, 5000, 19999, 'АлиЭкспресс', 0),
('Лыжи', 'Спортинвентарь', 6, 1000, 4899, 'Верхнепыжминский лыжный завод', 489900)

INSERT INTO Employees VALUES --имя, должность, устроен, пол, зп
('Иван Таран', 'продавец-консультант', '20210911', 'мужской', 19000, 259876),
('Светлана Звездунова', 'старший продавец-консультант', '20141001', 'женский', 25000, 1500999),
('Эдуард Эдисон', 'стажер', '20221225', 'небинарный', 12000, 45678)

INSERT INTO Clients VALUES --имя, мейл, тел, скидка, подписка
('Незарегестрированный',NULL, NULL, 0, 0, 0, '31-12-2009'),
('Лучший клиент','best@mail.ru', '123-456', 12, 1, 45000, '20101030'),
('Вася Иванов', NULL, NULL, 2, 0, 3000, '2020-10-10'),
('Петя Петров', NULL, NULL, 5, 1, 2699, '2022-12-01'),
('Подруга хозяина','beatch@ya.ru', '937-555-77', 50, 0, 100000, '19-11-2018')

--Задание 1. Для базы данных «Спортивный магазин» из 
--практического задания модуля «Триггеры, хранимые процедуры и пользовательские функции» создайте следующие 
--хранимые процедуры:
--1. Хранимая процедура отображает полную информацию 
--о всех товарах
GO
CREATE PROCEDURE sp_good_info
AS
BEGIN
SELECT * FROM Goods
END

GO 
EXECUTE sp_good_info

--2. Хранимая процедура показывает полную информацию 
--о товаре конкретного вида. Вид товара передаётся в качестве параметра. Например, если в качестве параметра 
--указана обувь, нужно показать всю обувь, которая есть в наличии

GO
CREATE PROCEDURE sp_type_of_good_info
@good_type NVARCHAR(30)
AS
SELECT * FROM Goods WHERE good_type LIKE @good_type

GO
EXECUTE sp_type_of_good_info 'Обувь'

--3. Хранимая процедура показывает топ-3 самых старых клиентов. Топ-3 определяется по дате регистрации

GO
CREATE PROCEDURE sp_oldest_clients
AS
SELECT TOP 3 * FROM Clients
ORDER BY registered

GO
EXECUTE sp_oldest_clients

--4. Хранимая процедура показывает информацию о самом 
--успешном продавце. Успешность определяется по общей сумме продаж за всё время

GO
CREATE PROCEDURE sp_best_employee
AS
SELECT * FROM Employees 
WHERE sold = (SELECT MAX(sold) FROM Employees)

GO 
EXECUTE sp_best_employee

--5. Хранимая процедура проверяет есть ли хоть один товар 
--указанного производителя в наличии. Название производителя передаётся в качестве параметра. По итогам работы 
--хранимая процедура должна вернуть yes в том случае, если товар есть, и no, если товара нет

GO 
CREATE PROCEDURE sp_is_it_any_good_in_store
@manufacturer NVARCHAR(30),
@answer NVARCHAR(3) output
AS
BEGIN
IF((SELECT TOP 1 quantity_stored FROM Goods WHERE manufacturer LIKE @manufacturer) > 0)
	BEGIN
	SET @answer = 'yes'
	END
ELSE
	BEGIN
	SET @answer = 'no'
	END
END

GO
DECLARE @inStore NVARCHAR(3)
EXECUTE sp_is_it_any_good_in_store 'Верхнепыжминский лыжный завод', @inStore output
SELECT @inStore AS [Наличие Верхнепыжминских лыж на складе]
EXECUTE sp_is_it_any_good_in_store 'Нижнетагильский танковый завод', @inStore output
SELECT @inStore AS [Наличие Нижнетагильских наборов для танкового биатлона на складе]

--6. Хранимая процедура отображает информацию о самом популярном производителе среди покупателей. Популярность 
--среди покупателей определяется по общей сумме продаж
GO

GO
CREATE PROCEDURE sp_most_popular_manufacturer
AS
BEGIN
WITH FactorySold
AS
(SELECT manufacturer, SUM(total_sold) AS summand FROM Goods GROUP BY manufacturer)

SELECT manufacturer AS [Самый популярный производитель], summand AS [Продано] FROM FactorySold
WHERE summand = (SELECT MAX(summand) FROM FactorySold)
END

GO 
EXECUTE sp_most_popular_manufacturer

--7. Хранимая процедура удаляет всех клиентов, зарегистрированных после указанной даты. Дата передаётся в качестве 
--параметра. Процедура возвращает количество удаленных 
--записей.
GO
CREATE PROCEDURE sp_delete_clients_after_date
@date DATETIME
AS
BEGIN
DELETE FROM Clients WHERE registered > @date
END

GO
EXECUTE sp_delete_clients_after_date '20150101'
SELECT * FROM Clients
