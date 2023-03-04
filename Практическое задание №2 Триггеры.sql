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
salerId INT NOT NULL REFERENCES Employees(employee_id),
clientId INT NOT NULL REFERENCES Clients(client_id)
);

CREATE TABLE History  
(
sale_idH INT,
good_idH INT,
priceH MONEY,
sale_dateH DATETIME,
quantityH INT,
salerIdH INT,
clientIdH INT
);

CREATE TABLE Archive
(
good_idA INT,
good_nameA NVARCHAR(30),
good_typeA NVARCHAR(30),
quantityA INT,
boughtA MONEY,
priceA MONEY,
manufacturerA NVARCHAR(30)
);

CREATE TABLE LastGood
(
good_idL INT,
good_nameL NVARCHAR(30)
)

GO

INSERT INTO Goods VALUES--���, ���, ����������, ����������, ����, �������������
('���������� ������', '������', 10, 1500, 4599, '������'),
('�������', '������', 5, 500, 1999, '���������� ��������'),
('�������', '�����', 12, 100, 799, '������ ������������ �����'),
('����', '�����', 4, 350, 2000, '������ ������������ �����'),
('���������', '��������������', 5, 5000, 19999, '�����������'),
('����', '��������������', 6, 1000, 4899, '���������������� ������ �����')

INSERT INTO Employees VALUES --���, ���������, �������, ���, ��
('���� �����', '��������-�����������', '20210911', '�������', 19000),
('�������� ����������', '������� ��������-�����������', '20141001', '�������', 25000),
('������ ������', '������', '20221225', '����������', 12000)

INSERT INTO Clients VALUES --���, ����, ���, ������, ��������
('��������������������',NULL, NULL, 0, 0, 0),
('������ ������','best@mail.ru', '123-456', 12, 1, 45000),
('���� ������',NULL, NULL, 2, 0, 3000),
('���� ������',NULL, NULL, 5, 1, 2699),
('������� �������','beatch@ya.ru', '937-555-77', 50, 0, 100000)

SELECT * FROM Clients
SELECT * FROM Employees
SELECT * FROM Goods



--������� 2. ��� ���� ������ �� ������� ������� �������� 
--��������, ������� ����� ������ ������ ����:

--1. ��� ������� ������, �������� ���������� � ������� � 
--������� ���������. ������� ��������� ������������ ��� 
--������� ���������� � ���� ��������
GO
CREATE TRIGGER HistoryAdd
ON Sales
AFTER INSERT
AS
INSERT INTO History(sale_idH, good_idH, priceH, sale_dateH, quantityH, salerIdH, clientIdH)
SELECT sale_id, good_id, price_of_sale, sale_date, quantity_saled, salerId, clientId
FROM INSERTED
	BEGIN
			print('historyAdd trigger enabled')
	END
GO

INSERT INTO Sales VALUES --id, price, date, Q, saler, client
(1, 4599, GETDATE(), 1, 3, 1)

SELECT * FROM History

--2. ���� ����� ������� ������ �� �������� �� ����� ������� ������� ������, ���������� ��������� ���������� 
--� ��������� ��������� ������ � ������� ������

GO
CREATE TRIGGER DeleteSaledGoods
ON Sales
FOR INSERT
AS
BEGIN
--�������� ���������� ������ �� ������ ����� �������
UPDATE Goods
SET quantity_stored -= quantity_saled FROM inserted,Goods
WHERE Goods.good_id = inserted.good_id

DECLARE @quantity_updated INT
SELECT @quantity_updated = quantity_stored FROM Goods, inserted WHERE Goods.good_id = inserted.good_id

DECLARE @message NVARCHAR(50)
SELECT @message = 'Update quantity stored. New value = ' + CONVERT(CHAR(3), @quantity_updated)
Print(@message)

--���������, �� ����� �� ���������� ����
DECLARE @id INT
SELECT @id = good_id FROM inserted

IF((SELECT quantity_stored FROM Goods, inserted WHERE Goods.good_id = inserted.good_id) = 0) 
	BEGIN
		DELETE FROM Goods
		WHERE Goods.good_id = @id
		print('Delete Saled Goods trigger enabled')		
	END
END
GO


CREATE TRIGGER ArchiveAdd
ON Goods
FOR DELETE
AS
BEGIN
INSERT INTO Archive
SELECT * FROM deleted
Print('Archive data added with trigger ArchiveAdd')
END
GO


INSERT INTO Sales VALUES --id, price, date, Q, saler, client
(1, 40000, GETDATE(), 10, 2, 2)
SELECT '����� ��������� �������� ���������:'
SELECT * FROM History
SELECT * FROM Goods
SELECT * FROM Archive

--3. �� ��������� �������������� ��� ������������� �������. ��� ������� ��������� ������� ������� �� ��� 
--� email
GO
CREATE TRIGGER DoubleCustomer
ON Clients
FOR INSERT
AS
BEGIN
DECLARE @newCustomer NVARCHAR(50)
DECLARE @newCustomerMail NVARCHAR(50)
SELECT @newCustomer = inserted.client_name FROM inserted
SELECT @newCustomerMail = inserted.email FROM inserted
IF(@newCustomer IN (SELECT client_name FROM Clients))
	BEGIN
		RAISERROR('������ � ����� ������ ��� ����. �������� ��������', 0, 1)		
		ROLLBACK TRANSACTION
	END
IF(@newCustomerMail IN (SELECT email FROM Clients) AND @newCustomerMail IS NOT NULL)
	BEGIN
		RAISERROR('������ � ����� ������������ ������ ��� ����. �������� ��������', 0, 1)		
		ROLLBACK TRANSACTION
	END
END
GO

--������ �������� ��������������� ������.
INSERT INTO Clients
VALUES('���� ������',NULL, NULL, 2, 0, 3000)
GO

--4. ��������� �������� ������������ ��������

CREATE TRIGGER NoDeteteForClients
ON Clients
FOR DELETE
AS
BEGIN
	RAISERROR('������ ������� ������������ ��������', 0, 1)
	ROLLBACK TRANSACTION	
END
GO

-- �������� ��������������� ������
DELETE FROM Clients
WHERE client_id = 5
GO

--5. ��������� �������� �����������, �������� �� ������ �� 2015 ����

CREATE TRIGGER NoDeteteForOldEmployees
ON Employees
FOR DELETE
AS
BEGIN
DECLARE @employeedYear INT
SELECT @employeedYear = YEAR(deleted.employeed) FROM DELETED
IF(@employeedYear < 2015)
	BEGIN
		RAISERROR('������ ������� �����������-���������!', 0, 1)
		ROLLBACK TRANSACTION	
	END
END
GO

-- �������� �������������� ������:
DELETE FROM Employees 
WHERE YEAR(employeed) < 2015
GO

--6. ��� ����� ������� ������ ����� ��������� ����� ����� ������� �������. ���� ����� ��������� 50000 ���, 
--���������� ���������� ������� ������ � 15%

CREATE TRIGGER SetDiscont
ON Sales
FOR INSERT
AS
BEGIN
DECLARE @sum_bought MONEY
DECLARE @this_sale_sum MONEY
DECLARE @client_id_var INT
DECLARE @this_sale_id INT
SELECT @this_sale_sum = inserted.price_of_sale FROM inserted
SELECT @client_id_var = inserted.clientId FROM inserted, Clients
SELECT @sum_bought = Clients.sum_bought + @this_sale_sum FROM Clients, inserted 
WHERE Clients.client_id = @client_id_var
SELECT @this_sale_id = sale_id FROM inserted

--��������� ������ � ������ � ��������
UPDATE Clients
SET Clients.sum_bought = @sum_bought
WHERE Clients.client_id =  @client_id_var

IF(@sum_bought > 50000 AND (SELECT Clients.discont  FROM Clients WHERE client_id = @client_id_var) <= 15)
	BEGIN 
		UPDATE Clients
		SET Clients.discont = 15
		WHERE client_id = @client_id_var
		
		UPDATE Sales
		SET Sales.price_of_sale *= 0.85  FROM Sales
		WHERE Sales.sale_id = @this_sale_id		
	END
END
GO

INSERT INTO Sales VALUES --id, price, date, Q, saler, client
(5, 59997, GETDATE(), 3, 1, 3)

SELECT * FROM Clients
SELECT * FROM Sales
GO

--7. ��������� ��������� ����� ���������� �����. ��������, 
--����� ����� ������, ������ � ������

CREATE TRIGGER ForbidProducer
ON Goods
FOR INSERT
AS
BEGIN
IF((SELECT inserted.manufacturer FROM inserted) LIKE '�����, ������ � ������')
	BEGIN
		RAISERROR('���� ������������� �������� � �������', 0,1)
		ROLLBACK TRANSACTION
	END
END
GO

INSERT INTO Goods VALUES--���, ���, ����������, ����������, ����, �������������
('����', '���������� ���������', 2, 1500, 3699, '�����, ������ � ������')
GO

--8. ��� ������� ��������� ���������� ������ � �������. ���� 
--�������� ���� ������� ������, ���������� ������ ���������� �� ���� ������ � ������� ���������� �������

CREATE TRIGGER LastGoodCheck
ON Sales
FOR INSERT
AS
BEGIN
IF((SELECT Goods.quantity_stored FROM inserted, Goods WHERE Goods.good_id = inserted.good_id) = 1)
	BEGIN
		INSERT INTO LastGood
		SELECT inserted.good_id, good_name FROM inserted, Goods WHERE Goods.good_id = inserted.good_id
	END
END

GO

INSERT INTO Sales VALUES --id, price, date, Q, saler, client
(5, 19999, GETDATE(), 1, 3, 4)

SELECT * FROM Sales
SELECT * FROM LastGood