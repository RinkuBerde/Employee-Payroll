﻿-- Welcome to EmployeePayroll Problem
--     UC-01-CreateDatabase
create database Payroll 
use Payroll
-- UC-02 Create Employee_Payroll Table
create Table EmployeePayroll
(
id int identity primary key,
name varchar(200) not null,
salary money not null,
start_Date date not null
)
--UC-3 Insert values in Table
Insert into EmployeePayroll values
('Rinku',20000,'2023-01-12'),
('Swayam',25000,'2020-02-18'),
('Arya',10000,'2022-11-13'),
('Gitesh',30000,'2019-06-09')

--UC-4 Retrieve All data--
select * from EmployeePayroll

-- UC5 Retrieve salary for particular employee 
select salary from EmployeePayroll where name='Rinku'
-- Retrieve salary for particular employee who join in particular date using getdate()
select salary from  EmployeePayroll where start_Date between '2020-01-12' and getdate()

--UC6 Alter Table
alter table EmployeePayroll add gender char(1)
-- update row
update EmployeePayroll set gender='F' where name='Rinku' or name='Arya'
update EmployeePayroll set gender ='M' where id in (2,4)

--UC7 use aggregate functions
select gender, sum(salary) from EmployeePayroll  where gender = 'M' group by gender
select gender, avg(salary) from EmployeePayroll where gender = 'F' group by gender
select gender, sum(salary) from EmployeePayroll  group by gender
select gender, avg(salary) from EmployeePayroll  group by gender
select gender, count(salary) from EmployeePayroll  group by gender;
select max(salary) "Highest_Salary" from EmployeePayroll
select min(salary) "Lowest_Salary" from EmployeePayroll