-- Welcome to EmployeePayroll Problem
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

--UC8 Add column department,PhoneNumber and Address
alter table EmployeePayroll add
EmployeePhone varchar(15), 
Address varchar(200) not null default 'India',
Department varchar(200)  
Update EmployeePayroll set EmployeePhone='1234567891',Department='IT' where name='Rinku'
Update EmployeePayroll set EmployeePhone='9876543215',Department='CS' where name='Swayam'
Update EmployeePayroll set EmployeePhone='5678943214',Department='CS' where name='Arya'
Update EmployeePayroll set EmployeePhone='1643897651',Department='Mech' where name='Gitesh'
select * from EmployeePayroll

--UC9 Rename Salary to Basic Pay and Add Deduction,Taxable pay, Income Pay , Netpay
Sp_rename 'EmployeePayroll.Department', 'Basic_Pay'
alter table EmployeePayroll add department varchar(50) not null default 'IT' 
Update EmployeePayroll set Basic_pay=null  where name in ('Rinku','Swayam','Arya')
Alter table EmployeePayroll add 
Deduction money,
Taxable_Pay money,
Income_Tax money,
Net_Pay money
Update EmployeePayroll  set Deduction=1000 where Gender='F'
Update EmployeePayroll  set Deduction=2000 where Gender='M'
Update EmployeePayroll  set Net_Pay=(Basic_Pay - Deduction)
Update EmployeePayroll  set Taxable_Pay=0,Income_Tax=0
select * from EmployeePayroll 

-- UC10 Adding duplicate names
insert into  EmployeePayroll values('Rinku',20000,'2023-01-12','F','1234567891','India',null,'EXTC',10000,0,0,null)

------- UC 11: Implement the ER Diagram into Payroll Service DB -------
        --Create Table for Company---
create table Company
(
CompanyID int identity(1,1) primary key,
CompanyName varchar(100)

   --Insert Values in Company table
Insert into Company values 
('Softech'),
('Infotech')
Select * from Company

--Create Employee Table
drop table EmployeePayroll
create table Employee
(
EmployeeID int identity(1,1) primary key,
CompanyIdentity int,
EmployeeName varchar(200),
EmployeePhoneNumber bigInt,
EmployeeAddress varchar(200),
StartDate date,
Gender char,
Foreign key (CompanyIdentity) references Company(CompanyID)
)

--Insert Values in Employee
insert into Employee values
(1,'Rinku Berde',964325436,'5298 Wild Indigo, Georgia,340002','2018-03-28','F'),
(2,'Yukta Mane',6742905468,'Constitution Ave Fairfield, California(CA), 94533','2017-04-22','F'),
(1,'Ketan Kumar',7878655050,'Bernard Shaw, Georgia,132001 ','2015-08-22','M'),
(2,'Swayam Rane',7812905000,'Bernard Shaw, PB Marg Bareilly','2016-08-29','M')
Select * from Employee

    --Create Payroll Table--
create table PayrollCalculate
(
BasicPay float,
Deductions float,
TaxablePay float,
IncomeTax float,
NetPay float,
EmployeeIdentity int,
Foreign key (EmployeeIdentity) references Employee(EmployeeID)
)

     --Insert Values in Payroll Table
insert into PayrollCalculate(BasicPay,Deductions,IncomeTax,EmployeeIdentity) values 
(4000000,1000000,20000,1),
(4500000,200000,4000,2),
(6000000,10000,5000,3),
(9000000,399994,6784,4)

select * from PayrollCalculate

     --Update Derived attribute values 
update PayrollCalculate set TaxablePay=BasicPay-Deductions

update PayrollCalculate set NetPay=TaxablePay-IncomeTax
select * from PayrollCalculate

   --Create Department Table
create table Department
(
DepartmentId int identity(1,1) primary key,
DepartName varchar(100)
)
    --Insert Values in Department Table
insert into Department values
('Marketing'),
('Sales'),
('IT')
select * from Department

   --Create table EmployeeDepartment
create table EmployeeDepartment
(
DepartmentIdentity int ,
EmployeeIdentity int,
Foreign key (EmployeeIdentity) references Employee(EmployeeID),
Foreign key (DepartmentIdentity) references Department(DepartmentID)
)

   --Insert Values in EmployeeDepartment
insert into EmployeeDepartment values
(3,1),
(2,2),
(1,3),
(3,4)

select * from EmployeeDepartment

------- UC 12: Ensure all retrieve queries done especially in UC 4, UC 5 and UC 7 are working with new table structure -------
     --UC 4: Retrieve all Data---
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,EmployeeAddress,EmployeePhoneNumber,StartDate,Gender,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,DepartName
FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID
INNER JOIN EmployeeDepartment on Employee.EmployeeID=EmployeeDepartment.EmployeeIdentity
INNER JOIN Department on Department.DepartmentId=EmployeeDepartment.DepartmentIdentity

  --UC 5: Select Query using GetDate()--
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay
FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity and StartDate BETWEEN Cast('2016-01-23' as Date) and GetDate()
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID

--Retrieve query based on Name
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay
FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity and Employee.EmployeeName='Rinku Berde'
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID

   --UC 7: Use Aggregate Functions and Group by Gender--
select Sum(BasicPay) as "TotalSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender

select Avg(BasicPay) as "AverageSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender

select Min(BasicPay) as "MinimumSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender

select Max(BasicPay)  as "MaximumSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender

select Count(BasicPay) as "CountSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender
