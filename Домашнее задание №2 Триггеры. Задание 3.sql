USE master;
GO

IF DB_ID('Sales') IS NOT NULL
BEGIN 
DROP DATABASE[Sales]
END
GO

CREATE DATABASE Sales;
GO

USE Sales;
GO

CREATE TABLE Sellers
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	FIO NVARCHAR(MAX) NOT NULL,
	Email NCHAR(20),
	Phone NCHAR(20)
);

CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	FIO NVARCHAR(MAX) NOT NULL,
	Email NCHAR(20),
	Phone NCHAR(20),
	History NVARCHAR(MAX)
);

CREATE TABLE DoubleClients
(
	Id INT,
	FIO NVARCHAR(MAX),
	Email NCHAR(20),
	Phone NCHAR(20),
	History NVARCHAR(MAX)
);

CREATE TABLE ClientHistory
(
	ClientId INT REFERENCES Clients(Id) ON DELETE NO ACTION,
	History NVARCHAR(MAX)
);

CREATE TABLE Sales
(
	SalerId INT NOT NULL REFERENCES Sellers(Id) ON DELETE NO ACTION,
	BuyerId INT NOT NULL REFERENCES Clients(Id) ON DELETE NO ACTION,
	Product NVARCHAR(MAX) NOT NULL,
	Price MONEY NOT NULL CHECK(Price > 0),
	SalesDate DATE NOT NULL DEFAULT GETDATE()
);


--������� 3. � ���� ������ �������� �� ������������� 
--������� ������ ������� � ��������� � ��������������� � 
--MS SQL Server� �������� ��������� ��������:

--1. ��� ���������� ������ ���������� ������� ��������� 
--������� ����������� � ����� �� ��������. ��� ���������� ���������� ������� ���������� �� ���� ���������� � ����������� �������
GO
CREATE TRIGGER DoubleClientsTrigger
ON Clients
FOR INSERT
AS
BEGIN
IF((SELECT inserted.FIO FROM inserted) IN (SELECT FIO FROM Clients))
	BEGIN
	INSERT INTO DoubleClients
	SELECT * FROM inserted
	PRINT('DoubleClientsTrigger activated')
	END
END
GO


--2. ��� �������� ���������� � ���������� ������� ��������� 
--��� ������� ������� � ������� �������� �������

GO
CREATE TRIGGER ClientHistoryTrigger
ON Clients
AFTER DELETE
AS
BEGIN
INSERT INTO ClientHistory
SELECT id, History FROM deleted
PRINT('ClientHistoryTrigger activated')
END


--3. ��� ���������� �������� ������� ��������� ���� �� �� � 
--������� �����������, ���� ������ ���������� ���������� ������ �������� ����������
GO
CREATE TRIGGER ClientCantBeSeller
ON Sellers
AFTER INSERT
AS
BEGIN
IF((SELECT inserted.FIO FROM inserted) IN (SELECT FIO FROM Sellers))
	BEGIN
	RAISERROR('���������� �� ����� ����� ���������',0,1)
	ROLLBACK TRANSACTION
	END
END


--4. ��� ���������� ���������� ������� ��������� ���� �� �� 
--� ������� ���������, ���� ������ ���������� ���������� ������ ���������� ����������

GO
CREATE TRIGGER SellerCantBeClient
ON Clients
AFTER INSERT
AS
BEGIN
IF((SELECT inserted.FIO FROM inserted) IN (SELECT FIO FROM Clients))
	BEGIN
	RAISERROR('�������� �� ����� ���� �����������',0,1)
	ROLLBACK TRANSACTION
	END
END


--5. ������� �� ��������� ��������� ���������� � ������� 
--����� �������: ������, �����, �����, �����

GO
CREATE TRIGGER FruitsIsNotInLaw
ON Sales
FOR INSERT
AS
BEGIN
IF((SELECT inserted.Product FROM inserted) IN (SELECT '������', '�����', '�����', '�����'))
	BEGIN
	RAISERROR('����� �������� ��������� � �������',0,1)
	ROLLBACK TRANSACTION
	END
END
