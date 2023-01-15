--������� ������� ������, �� ����������� �� ���� � �������� �������.
SELECT Departments.Name, Departments.Financing, Departments.id FROM Departments

-- ������� �������� ����� � �� �������� � ���������� ���� ����� ������ �������.
SELECT Name AS [GROUP NAME], Rating AS [GROUP RATING] FROM Groups
--������� ��� �������������� �� �������, ������� ������ �� ��������� � �������� � ������� ������ �� ��������� � �������� (����� ������ � ��������).
SELECT Surname, Salary/(Premium + Salary)*100 AS [Salary %], Premium/(Salary + Premium)*100 AS [Premium %] FROM Teachers
--������� ������� ����������� � ���� ������ ���� � ��������� �������: �The dean of faculty [faculty] is [dean].�.
SELECT 'The dean of ' + Name + ' is ' + Dean FROM Faculties
--������� ������� ��������������, ������� �������� ������������ � ������ ������� ��������� 1050.
SELECT Surname FROM Teachers
WHERE isProfessor = 1 AND Salary > 1050
--������� �������� ������, ���� �������������� ������� ������ 11000 ��� ������ 25000.
SELECT Name FROM Departments
WHERE Financing < 11000 OR Financing > 25000
--������� �������� ����������� ����� ���������� �Computer Science�.
SELECT Name FROM Departments
WHERE Name <> 'Computer Science Department'
--������� ������� � ��������� ��������������, ������� �� �������� ������������.
SELECT Surname, Position FROM Teachers
WHERE isProfessor = 0
-- ������� �������, ���������, ������ � �������� �����������, � ������� �������� � ��������� �� 160 �� 550.
SELECT Surname, Position, Salary, Premium FROM Teachers
WHERE isAssistant = 1 AND Premium BETWEEN 160 AND 550
--������� ������� � ������ �����������.
SELECT Surname, Salary, Premium FROM Teachers
WHERE isAssistant = 1
--������� ������� � ��������� ��������������, ������� ���� ������� �� ������ �� 01.01.2000.
SELECT Surname, Position FROM Teachers
WHERE EmploymentDate < '2000-01-01'
--������� �������� ������, ������� � ���������� ������� ������������� �� ������� �Software Development�. ��������� ���� ������ ����� �������� �Name of Department�.
SELECT Name AS [Name of Department] FROM Departments
WHERE Name < 'Programming Department' ORDER BY Name 
--������� ������� �����������, ������� �������� (����� ������ � ��������) �� ����� 1200.
SELECT Surname FROM Teachers
WHERE isAssistant = 1 AND (Salary + Premium) <= 1200
--������� �������� ����� 5-�� �����, ������� ������� � ��������� �� 2 �� 4.
SELECT Name FROM Groups
WHERE Year = 5 AND Rating BETWEEN 2 AND 4
--������� ������� ����������� �� ������� ������ 550 ��� ��������� ������ 200
SELECT Surname FROM Teachers
WHERE isAssistant = 1 AND (Salary < 550 OR Premium < 200)