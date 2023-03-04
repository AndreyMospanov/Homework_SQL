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
manufacturer NVARCHAR(30)
);

CREATE TABLE Employees
(
employee_id INT PRIMARY KEY IDENTITY (1,1),
employee_name NVARCHAR(50) NOT NULL CHECK(employee_name != N''),
position NVARCHAR(50) NOT NULL CHECK(position != N''),
employeed DATETIME NOT NULL,
sex NVARCHAR(10) NOT NULL,
salary MONEY NOT NULL CHECK ([salary] >= 12000)
);

CREATE TABLE Clients
(
client_id INT PRIMARY KEY IDENTITY (1,1),
client_name NVARCHAR(50) NOT NULL CHECK(client_name != N''),
email VARCHAR(MAX),
phone VARCHAR(10),
discont INT NOT NULL CHECK([discont] >= 0),
subscribed BIT NOT NULL DEFAULT 0, 
sum_bought MONEY DEFAULT 0
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

CREATE TABLE EmployeesArchive
(
employee_id INT, 
employee_name NVARCHAR(50),
position NVARCHAR(50),
employeed DATETIME,
sex NVARCHAR(10),
salary MONEY
);

GO

INSERT INTO Goods VALUES--имя, тип, количество, закупочная, цена, производитель
('Спортивный костюм', 'Одежда', 10, 1500, 4599, 'Абибас'),
('Треники', 'Одежда', 5, 500, 1999, 'Ивановский трикотаж'),
('Шлёпанцы', 'Обувь', 12, 100, 799, 'Подвал вьетнамского рынка'),
('Кеды', 'Обувь', 4, 350, 2000, 'Подвал вьетнамского рынка'),
('Велосипед', 'Спортинвентарь', 5, 5000, 19999, 'АлиЭкспресс'),
('Лыжи', 'Спортинвентарь', 6, 1000, 4899, 'Верхнепыжминский лыжный завод')

INSERT INTO Employees VALUES --имя, должность, устроен, пол, зп
('Иван Таран', 'продавец-консультант', '20210911', 'мужской', 19000),
('Светлана Звездунова', 'старший продавец-консультант', '20141001', 'женский', 25000),
('Эдуард Эдисон', 'стажер', '20221225', 'небинарный', 12000)

INSERT INTO Clients VALUES --имя, мейл, тел, скидка, подписка
('Незарегестрированный',NULL, NULL, 0, 0, 0),
('Лучший клиент','best@mail.ru', '123-456', 12, 1, 45000),
('Вася Иванов', NULL, NULL, 2, 0, 3000),
('Петя Петров', NULL, NULL, 5, 1, 2699),
('Подруга хозяина','beatch@ya.ru', '937-555-77', 50, 0, 100000)

--Задание 1. К базе данных «Спортивный магазин» из практического задания к этому модулю создайте следующие триггеры:
--1. При добавлении нового товара триггер проверяет его наличие на складе, если такой товар есть и новые данные о 
--товаре совпадают с уже существующими данными, вместо добавления происходит обновление информации о количестве товара
GO
CREATE TRIGGER DoubleGoodsPreventer
ON Goods
AFTER INSERT 
AS
BEGIN
DECLARE @good_id INT
	IF(SELECT good_name FROM inserted) IN (SELECT good_name FROM Goods)
	BEGIN	
	SET @good_id = (SELECT MIN(G.good_id) FROM Goods AS G, inserted AS I WHERE G.good_name = i.good_name)
	PRINT(@good_id)
	IF(SELECT good_type FROM Goods WHERE good_id = @good_id) = (SELECT good_type FROM inserted)
		BEGIN		
		IF(SELECT manufacturer FROM Goods WHERE good_id = @good_id) = (SELECT manufacturer FROM inserted)
			BEGIN			
			UPDATE Goods
			SET Goods.quantity_stored += inserted.quantity_stored FROM inserted 
			WHERE Goods.good_id = @good_id
			PRINT('Quantity updated')
			DELETE FROM Goods
			WHERE good_id = (SELECT Goods.good_id FROM Goods, inserted WHERE Goods.good_id = inserted.good_id)
			END
		END
	END	
END
GO

INSERT INTO Goods
VALUES('Лыжи', 'Спортинвентарь', 150, 1000, 4899, 'Верхнепыжминский лыжный завод')

SELECT * FROM Goods

--2. При увольнении сотрудника триггер переносит информацию 
--об уволенном сотруднике в таблицу «Архив сотрудников»
GO
CREATE TRIGGER EmployeesArchiveTrigger
ON Employees
AFTER DELETE
AS
BEGIN
INSERT INTO EmployeesArchive
SELECT * FROM deleted
END

GO
DELETE FROM Employees
WHERE employee_name LIKE '%Эдуард%'
SELECT * FROM EmployeesArchive

--3. Триггер запрещает добавлять нового продавца, если количество существующих продавцов больше 3.
GO
CREATE TRIGGER EmployeesLimiter
ON Employees
FOR INSERT
AS
BEGIN
IF((SELECT COUNT(*) FROM Employees) > 3)
	BEGIN
	RAISERROR('Достигнут предел количества сотрудников', 0, 1)
	ROLLBACK TRANSACTION
	END
END

GO

INSERT INTO Employees VALUES --имя, должность, устроен, пол, зп
('Петрович', 'продавец-консультант', '20230222', 'мужской', 24000)
GO
INSERT INTO Employees VALUES --имя, должность, устроен, пол, зп
('Серёжа', 'стажёр продавец-консультант', '20230222', 'мужской', 12000)
GO 
SELECT * FROM Employees