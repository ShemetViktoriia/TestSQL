
CREATE DATABASE TEST_EMPLOYEES;
GO

use TEST_EMPLOYEES;
GO

/*
������� ������� EMPLOYEES
� ������
ID 
F_NAME (���)
L_NAME (�������)
FIX_PAYMENT (T - ������������� ������,  F - ��������� ������)
COUNT_DAYS (���-�� ������������ ���� �� �����)
COUNT_HOUR (���-�� ������������ ����� �� �����) 
RATE (����� ������ ���� FIX_PAYMENT = 'T' �� �� ����� ����� �� ���)
*/

CREATE TABLE Employees 
(
	ID INT PRIMARY KEY IDENTITY,
	F_NAME NVARCHAR(15) NOT NULL,
	L_NAME NVARCHAR(15) NOT NULL,
	FIX_PAYMENT VARCHAR(1) DEFAULT 'T',
		CONSTRAINT CK_Employee_Fix_Payment CHECK(FIX_PAYMENT='T' OR FIX_PAYMENT='F'),
	COUNT_DAYS TINYINT,
	COUNT_HOUR TINYINT DEFAULT 0,
	RATE DECIMAL(8,2) NOT NULL
);
GO

/*
������� ����� ��� ���������� ������� �������.
���� �� ������ ����������.
���� ��� ������ ��������� ���������� ������ ���-�� ������������ �����
������ �����������
*/
--STORED PROCEDURE AddOneEmployee
CREATE PROC sp_AddEmployee
	@f_name NVARCHAR(20),
	@l_name NVARCHAR(20),
	@fix_payment VARCHAR(1)='T',
	@count_days TINYINT,
	@count_hour TINYINT = 0,
	@rate DECIMAL(8,2)
AS
INSERT INTO Employees(F_NAME, L_NAME, FIX_PAYMENT, COUNT_DAYS, COUNT_HOUR, RATE) 
VALUES(@f_name, @l_name, @fix_payment, @count_days, @count_hour, @rate)
GO

--STORED PROCEDURE ShowAllEmployees
CREATE PROCEDURE sp_GetAllEmployees
AS
	SELECT * FROM Employees
GO	

-- ���� �� ������ ����������
-- 1-� ���������
EXEC sp_AddEmployee
	 @f_name ='Ivan',
	 @l_name = 'Ivanov',
	 @count_days = 20, 
	 @rate = 8000
-- 2-� ���������
EXEC sp_AddEmployee 'Anton', 'Sidorov', 'F', 15, 172, 53.5
-- 3-� ���������
EXEC sp_AddEmployee 'Stepan', 'Gavrilov',  'T', 25, 0, 10500
-- 4-� ���������
EXEC sp_AddEmployee 'Anna', 'Antonova',  'T', 20, 0, 9000
-- 5-� ���������
EXEC sp_AddEmployee 'Olga', 'Fedorova',  'F', 19, 188, 49.6
GO

-- ����������� ������� �����������
EXEC sp_GetAllEmployees
GO

/*
������� ����� ������ ���������� ����� �� ����� �� ���������� 
��������� �������� ������� � ���
���������� ����� �/�
���� ��������� FIX_PAYMENT = 'T' ��������� ���-�� ������� ���� � ������ ��� ���� � �����
(��������� �� ���������) ����� ����� ����� �������
���� FIX_PAYMENT = 'F' ������ �������� ���-�� ����� �� ������
*/

CREATE PROCEDURE sp_CalculateSalary
	@f_name NVARCHAR(15),
	@l_name NVARCHAR(15)
AS
	--������ ���-�� ���� � ������ ��� ������ � ����������� �� ������ ���
	DECLARE @work_days TINYINT, @start SMALLDATETIME, @end SMALLDATETIME
	SELECT @start = '20180201', @end = '20180228'
	SET @work_days =(SELECT DAY(DATEADD(Month, 1, @start) - DAY(DATEADD(Month, 1, @start))) -- ����� ���� � ���������� ��������� ���
			-  datediff (wk, @start - 7, @end - 6) -- ���-�� ������ � ���������� ���
				- datediff (wk, @start - 8, @end - 7) )-- ���-�� ����������� � ���������� ���
    -- ������ ������ ����� ���������� ����� ���������� � ����������� �� ����� ������
	DECLARE @fix_payment VARCHAR(1), @rate DECIMAL(8,2), @count_hour TINYINT
	SELECT @fix_payment = FIX_PAYMENT, @rate = RATE, @count_hour =COUNT_HOUR
    FROM Employees
    WHERE (F_NAME = @f_name AND L_NAME = @l_name)
IF @fix_payment = 'T'
	PRINT @l_name + ' ' + @f_name + ' - ' + CONVERT(NVARCHAR, @rate)  + ' ���. ������, � ������� �� ' + CONVERT(NVARCHAR, @work_days) + ' ������� ����'
ELSE 
	PRINT @l_name + ' ' + @f_name + ' - ' + CONVERT(NVARCHAR, @rate*@count_hour) + ' ���. ��������� �� �����'
GO

-- ������ ���������� ����� �� ����� �� ���� �����������
EXEC sp_CalculateSalary 'Ivan', 'Ivanov'
EXEC sp_CalculateSalary 'Anton', 'Sidorov'
EXEC sp_CalculateSalary 'Stepan', 'Gavrilov'
EXEC sp_CalculateSalary 'Anna', 'Antonova'
EXEC sp_CalculateSalary 'Olga', 'Fedorova'
GO


