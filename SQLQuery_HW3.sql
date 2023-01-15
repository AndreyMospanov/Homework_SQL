--Вывести таблицу кафедр, но расположить ее поля в обратном порядке.
SELECT Departments.Name, Departments.Financing, Departments.id FROM Departments

-- Вывести названия групп и их рейтинги с уточнением имен полей именем таблицы.
SELECT Name AS [GROUP NAME], Rating AS [GROUP RATING] FROM Groups
--Вывести для преподавателей их фамилию, процент ставки по отношению к надбавке и процент ставки по отношению к зарплате (сумма ставки и надбавки).
SELECT Surname, Salary/(Premium + Salary)*100 AS [Salary %], Premium/(Salary + Premium)*100 AS [Premium %] FROM Teachers
--Вывести таблицу факультетов в виде одного поля в следующем формате: “The dean of faculty [faculty] is [dean].”.
SELECT 'The dean of ' + Name + ' is ' + Dean FROM Faculties
--Вывести фамилии преподавателей, которые являются профессорами и ставка которых превышает 1050.
SELECT Surname FROM Teachers
WHERE isProfessor = 1 AND Salary > 1050
--Вывести названия кафедр, фонд финансирования которых меньше 11000 или больше 25000.
SELECT Name FROM Departments
WHERE Financing < 11000 OR Financing > 25000
--Вывести названия факультетов кроме факультета “Computer Science”.
SELECT Name FROM Departments
WHERE Name <> 'Computer Science Department'
--Вывести фамилии и должности преподавателей, которые не являются профессорами.
SELECT Surname, Position FROM Teachers
WHERE isProfessor = 0
-- Вывести фамилии, должности, ставки и надбавки ассистентов, у которых надбавка в диапазоне от 160 до 550.
SELECT Surname, Position, Salary, Premium FROM Teachers
WHERE isAssistant = 1 AND Premium BETWEEN 160 AND 550
--Вывести фамилии и ставки ассистентов.
SELECT Surname, Salary, Premium FROM Teachers
WHERE isAssistant = 1
--Вывести фамилии и должности преподавателей, которые были приняты на работу до 01.01.2000.
SELECT Surname, Position FROM Teachers
WHERE EmploymentDate < '2000-01-01'
--Вывести названия кафедр, которые в алфавитном порядке располагаются до кафедры “Software Development”. Выводимое поле должно иметь название “Name of Department”.
SELECT Name AS [Name of Department] FROM Departments
WHERE Name < 'Programming Department' ORDER BY Name 
--Вывести фамилии ассистентов, имеющих зарплату (сумма ставки и надбавки) не более 1200.
SELECT Surname FROM Teachers
WHERE isAssistant = 1 AND (Salary + Premium) <= 1200
--Вывести названия групп 5-го курса, имеющих рейтинг в диапазоне от 2 до 4.
SELECT Name FROM Groups
WHERE Year = 5 AND Rating BETWEEN 2 AND 4
--Вывести фамилии ассистентов со ставкой меньше 550 или надбавкой меньше 200
SELECT Surname FROM Teachers
WHERE isAssistant = 1 AND (Salary < 550 OR Premium < 200)