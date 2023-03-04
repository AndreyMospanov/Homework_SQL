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
('���� ������', NULL, NULL, 2, 0, 3000),
('���� ������', NULL, NULL, 5, 1, 2699),
('������� �������','beatch@ya.ru', '937-555-77', 50, 0, 100000)

--������� 1. � ���� ������ ����������� ������� �� ������������� ������� � ����� ������ �������� ��������� ��������:
--1. ��� ���������� ������ ������ ������� ��������� ��� ������� �� ������, ���� ����� ����� ���� � ����� ������ � 
--������ ��������� � ��� ������������� �������, ������ ���������� ���������� ���������� ���������� � ���������� ������
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
VALUES('����', '��������������', 150, 1000, 4899, '���������������� ������ �����')

SELECT * FROM Goods

--2. ��� ���������� ���������� ������� ��������� ���������� 
--�� ��������� ���������� � ������� ������ �����������
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
WHERE employee_name LIKE '%������%'
SELECT * FROM EmployeesArchive

--3. ������� ��������� ��������� ������ ��������, ���� ���������� ������������ ��������� ������ 3.
GO
CREATE TRIGGER EmployeesLimiter
ON Employees
FOR INSERT
AS
BEGIN
IF((SELECT COUNT(*) FROM Employees) > 3)
	BEGIN
	RAISERROR('��������� ������ ���������� �����������', 0, 1)
	ROLLBACK TRANSACTION
	END
END

GO

INSERT INTO Employees VALUES --���, ���������, �������, ���, ��
('��������', '��������-�����������', '20230222', '�������', 24000)
GO
INSERT INTO Employees VALUES --���, ���������, �������, ���, ��
('�����', '����� ��������-�����������', '20230222', '�������', 12000)
GO 
SELECT * FROM Employees