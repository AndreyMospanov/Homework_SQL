USE master;
GO

IF DB_ID('Bookstore') IS NOT NULL
BEGIN
	DROP DATABASE [Bookstore]
END
GO

CREATE DATABASE Bookstore;
GO

USE Bookstore
GO

CREATE TABLE Countries
(
	id INT PRIMARY KEY IDENTITY (1,1),
	name NVARCHAR(50) NOT NULL CHECK( name != N''),
);

CREATE TABLE Themes
(
	id INT PRIMARY KEY IDENTITY (1,1),
	name NVARCHAR(100) NOT NULL CHECK( name != N''),
);

CREATE TABLE Authors
(
	id INT PRIMARY KEY IDENTITY (1,1),
	name NVARCHAR(MAX) NOT NULL CHECK( name != N''),
	surname NVARCHAR(MAX) NOT NULL CHECK( surname != N''),
	countryId INT REFERENCES Countries(id) ON DELETE NO ACTION
);

CREATE TABLE Books
(
	id INT PRIMARY KEY IDENTITY (1,1),
	name NVARCHAR(MAX) NOT NULL CHECK( name != N''),
	pages INT NOT NULL CHECK(Pages > 0),
	price MONEY NOT NULL CHECK(price >= 0),
	publishDate DATE NOT NULL CHECK(publishDate <= GETDATE()),
	authorId INT REFERENCES Authors(id) ON DELETE CASCADE,
	themeId INT REFERENCES Themes(id) ON DELETE SET NULL
);

CREATE TABLE Shops
(
	id INT PRIMARY KEY IDENTITY (1,1),
	name NVARCHAR(MAX) NOT NULL CHECK( name != N''),
	countryId INT REFERENCES Countries(id) ON DELETE NO ACTION
);

CREATE TABLE Sales
(
	id INT PRIMARY KEY IDENTITY (1,1),
	price MONEY NOT NULL CHECK(price >= 0),
	quantity INT NOT NULL CHECK(quantity > 0),
	saleDate DATE NOT NULL DEFAULT GETDATE() CHECK(saleDate <= GETDATE()),
	bookId INT REFERENCES Books(id) ON DELETE NO ACTION,
	shopId INT REFERENCES Shops(id) ON DELETE NO ACTION
);

--1. Показать все книги, количество страниц в которых больше 
--500, но меньше 650.

SELECT * FROM Books
WHERE pages BETWEEN 500 AND 650

--2. Показать все книги, в которых первая буква названия либо 
--«А», либо «З».

SELECT * FROM Books
WHERE name LIKE ('А%') OR name LIKE ('З%')

--3. Показать все книги жанра «Детектив», количество проданных книг более 30 экземпляров.

SELECT Books.name AS [Название книги], SUM(quantity) AS [sold]
FROM Books
JOIN Sales ON Books.id = Sales.bookId
JOIN Themes ON Books.themeId = Themes.id AND Themes.name = 'Детектив'
WHERE SUM(quantity) > 30
GROUP BY Books.name

--4. Показать все книги, в названии которых есть слово «Microsoft», но нет слова «Windows».

SELECT * FROM Books
WHERE name LIKE ('%Microsoft%')
EXCEPT 
SELECT * FROM Books
WHERE name LIKE ('%Windows%')

--5. Показать все книги (название, тематика, полное имя автора 
--в одной ячейке), цена одной страницы которых меньше 65 копеек.

SELECT b.name, t.name, a.name + ' ' + a.surname AS Author FROM Books AS b
JOIN Themes AS t ON b.themeId = t.id
JOIN Authors AS a ON b.authorId = a.id
WHERE price/b.pages > 0.65

--6. Показать все книги, название которых состоит из 4 слов.
GO
CREATE FUNCTION WORD_COUNT(@word NVARCHAR(MAX))
RETURNS INT
AS
BEGIN
DECLARE @temp INT
SET @temp = (SELECT COUNT (*) FROM STRING_SPLIT(@word, ' '))
RETURN @temp
END
GO

SELECT * FROM Books
WHERE dbo.WORD_COUNT(name) = 4


--7. Показать информацию о продажах в следующем виде:
--▷ Название книги, но, чтобы оно не содержало букву «А».
--▷ Тематика, но, чтобы не «Программирование».
--▷ Автор, но, чтобы не «Герберт Шилдт».
--▷ Цена, но, чтобы в диапазоне от 10 до 20 гривен.
--▷ Количество продаж, но не менее 8 книг.
--▷ Название магазина, который продал книгу, но он не 
--должен быть в Украине или России.

SELECT * FROM Sales
JOIN Books ON Books.id = Sales.bookId AND name NOT LIKE ('%А%')
JOIN Themes ON Books.themeId = Themes.id AND Themes.name NOT LIKE('Программирование')
JOIN Authors ON Books.authorId = Authors.id AND Authors.name + ' ' + surname NOT IN ('Герберт Шилдт')
JOIN Shops ON Sales.shopId = Shops.id
JOIN Countries ON Countries.id = Shops.countryId AND Countries.name NOT IN ('Россия') AND Countries.name NOT IN ('Украина')

--8. Показать следующую информацию в два столбца (числа 
--в правом столбце приведены в качестве примера):
--▷ Количество авторов: 14
--▷ Количество книг: 47
--▷ Средняя цена продажи: 85.43 грн.
--▷ Среднее количество страниц: 650.6.

SELECT 'Количество авторов' AS [Параметр], COUNT(Authors.id) AS [Значение] FROM Authors
UNION
SELECT 'Количество книг', COUNT(Books.id) FROM Books
UNION
SELECT 'Средняя цена продажи', AVG(Sales.price) FROM Sales
UNION
SELECT 'Среднее количество страниц', AVG(Books.pages) FROM Books

--9. Показать тематики книг и сумму страниц всех книг по 
--каждой из них.

SELECT Themes.name, SUM(pages) FROM Themes
JOIN Books ON Themes.id = themeId
GROUP BY Themes.name

--10. Показать количество всех книг и сумму страниц этих книг 
--по каждому из авторов.

SELECT Authors.name + ' ' + Authors.surname AS [Автор], SUM(pages) FROM Books
JOIN Authors ON Books.authorId = Authors.id
GROUP BY Authors.name

--11. Показать книгу тематики «Программирование» с наибольшим количеством страниц.

SELECT * FROM Books
JOIN Themes ON Themes.id = themeId AND Themes.name = 'Программирование'
WHERE pages = MAX(pages)

--12. Показать среднее количество страниц по каждой тематике, 
--которое не превышает 400.

SELECT Themes.Name, AVG(pages) FROM Themes
JOIN Books ON Themes.id = themeId
GROUP BY Themes.name
HAVING AVG(pages) <= 400

--13. Показать сумму страниц по каждой тематике, учитывая 
--только книги с количеством страниц более 400, и чтобы 
--тематики были «Программирование», «Администрирование» и «Дизайн».

SELECT Themes.Name, SUM(pages) FROM Themes
JOIN Books ON Themes.id = themeId AND Themes.name IN ('Программирование', 'Администрирование', 'Дизайн')
WHERE pages > 400
GROUP BY Themes.name

--14. Показать информацию о работе магазинов: что, где, кем, 
--когда и в каком количестве было продано.

SELECT Shops.name AS Shop, Countries.name AS Country, Books.Name AS Book, saleDate AS Date, quantity AS Quantity FROM Sales
JOIN Shops ON Sales.shopId = Shops.id
JOIN Countries ON Countries.id = countryId
JOIN Books ON Sales.bookId = Books.id

--15. Показать самый прибыльный магазин.

SELECT name FROM Shops
JOIN Sales ON Sales.shopId = Shops.Id
GROUP BY Shops.name
HAVING SUM(price * quantity) = MAX(SUM(price * quantity))
