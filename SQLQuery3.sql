-- Task 1

CREATE DATABASE Task

USE Task

CREATE TABLE ProjectList
( Task_ID INT PRIMARY KEY,
  Start_Date DATE,
  End_Date DATE
)

INSERT INTO ProjectList
VALUES(1 ,'2015-10-01','2015-10-02'),
      (2 ,'2015-10-02','2015-10-03'),
	  (3 ,'2015-10-03','2015-10-04'),
	  (4 ,'2015-10-13','2015-10-14'),
	  (5 ,'2015-10-14','2015-10-15'),
	  (6 ,'2015-10-28','2015-10-29'),
	  (7 ,'2015-10-30','2015-10-31');


-- Common Table Expression (CTE) is a temporary result set 
--that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement. 
--It is defined using the WITH keyword followed by a query.


--CTEs are useful for improving the readability and structure of 
--complex queries. They can be thought of as defining a temporary 
--table that only exists for the duration of a single query.

--PARTITION BY: Divides the result set into partitions to which the window function is applied.
--ORDER BY: Defines the logical order of rows within each partition.

--A window function performs a calculation across a set of table 
--to the current row. Unlike regular aggregate functions, 
--window functions do not cause rows to become grouped into a 
--single output row. Instead, the rows retain their separate identities.


--approach : 1)check start date of current task and end date of prv task => if they are same then they are in same project
--           2)add values set above =>tasks having same value are in same project
--		   3)calculate min and max date according to same project (value added in prev step)

WITH TaskGroups AS (      --TaskGroups:CTE
    SELECT 
        Task_ID,
        Start_Date,
        End_Date,
        CASE                          --check if current task is starting right after previous task end date to check if this task is part of previous task
            WHEN Start_Date = LAG(End_Date) OVER (ORDER BY Start_Date) 
			THEN 0                   --start date of current task =end date of prev task indicates same project
            ELSE 1                   --if task is of same proj then NewProject=0 otherwise 1
        END AS NewProject
    FROM 
        ProjectList
),

GroupedTasks AS (                    --temporary table
    SELECT 
        Task_ID,
        Start_Date,
        End_Date,
        SUM(NewProject) OVER (ORDER BY Start_Date) AS ProjectGroup  --SUM() as window function        --groups tasks according to value of newProject as tasks having same value(sum) of newProject ..they are in same project
    FROM 
        TaskGroups
),

ProjectBoundaries AS (                    --temporary table
    SELECT 
        ProjectGroup,
        MIN(Start_Date) AS ProjectStart,
        MAX(End_Date) AS ProjectEnd,
        DATEDIFF(day, MIN(Start_Date), MAX(End_Date)) AS ProjectDuration      --calculates project duration 
    FROM 
        GroupedTasks
    GROUP BY 
        ProjectGroup
)

SELECT 
    ProjectStart,
    ProjectEnd
FROM 
    ProjectBoundaries
ORDER BY 
    ProjectDuration ASC, 
    ProjectStart ASC;





--task 2

CREATE TABLE Friends
( ID INT PRIMARY KEY,
  Friend_ID INT
)

CREATE TABLE Students 
(
 ID INT PRIMARY KEY,
 Name VARCHAR(255),
 FOREIGN KEY (ID) REFERENCES Friends(ID)
)

CREATE TABLE Packages
(
  ID INT PRIMARY KEY,
  Salary FLOAT,
  FOREIGN KEY (ID) REFERENCES Friends(ID)
)

INSERT INTO Friends
VALUES(1,2),
      (2,3),
	  (3,4),
	  (4,1)

INSERT INTO Students
VALUES(1,'Ashley'),
      (2,'Samantha'),
	  (3,'Julia'),
	  (4,'Scarlet')

INSERT INTO Packages
VALUES(1,15.20),
      (2,10.06),
	  (3,11.55),
	  (4,12.12)

SELECT * FROM Friends
SELECT * FROM Students
SELECT * FROM Packages;


select s.ID,s.Name,f.Friend_ID,p1.Salary, p.Salary fSalary
from Students s, Friends f ,Packages p,Packages p1
where f.ID = s.ID
AND p.ID = f.Friend_ID
AND s.ID = p1.ID
AND p1.Salary<p.Salary



select s.Name
from Students s, Friends f ,Packages p,Packages p1
where f.ID = s.ID
AND p.ID = f.Friend_ID
AND s.ID = p1.ID
AND p1.Salary<p.Salary
order by p.Salary


--task 3

CREATE TABLE Functions 
(
 X INT,
 Y INT
)

INSERT INTO Functions
VALUES(20,20),
      (20,20),
      (20,21),
      (23,22),
      (22,23),
      (21,20)

SELECT * FROM Functions


SELECT distinct f1.X,f1.Y FROM Functions f1 
JOIN Functions f2
ON f1.X = f2.Y AND f1.Y = f2.X
where f1.X <= f1.Y
ORDER BY f1.X


--task 4
--question unclear

--task 5


CREATE TABLE Hackers
(
  hacker_id INT,
  name varchar(255)
)


CREATE TABLE Submissions
(
  submission_date DATE,
  submission_id INT,
  hacker_id INT,
  score INT
)

INSERT INTO Hackers
values (15758,'Rose'),
       (20703,'Angela'),
	   (36396,'Frank'),
	   (38289,'Patrick'),
	   (44065,'Lisa'),
	   (53473,'Kimberly'),
	   (62529,'Bonnie'),
	   (79722,'Michael')

INSERT INTO Submissions
values ('2016-03-01',8494,20703,0),
   ('2016-03-01',22403,53473,15),
   ('2016-03-01',23965,79722,60),
   ('2016-03-01',30173,36396,70),
   ('2016-03-02',34928,20703,0),
   ('2016-03-02',38740,15758,60),
   ('2016-03-02',42769,79722,25),
   ('2016-03-02',44364,79722,60),
   ('2016-03-03',45440,20703,0),
   ('2016-03-03',49050,36396,70),
   ('2016-03-03',50273,79722,5)
   

select max(count)
from(
select s.submission_date,s.hacker_id, count(submission_date) count from Submissions s 
group by s.submission_date, s.hacker_id
order by 1, 2 asc) 
as subquery;


select * from Submissions


truncate table Submissions;


--task 7 : incomplete question

--task 8
CREATE TABLE OCCUPATIONS
(
 Name varchar(255),
 Occupation varchar(255)
)

INSERT INTO OCCUPATIONS
VALUES('Samantha','Doctor'),
      ('Julia','Actor'),
      ('Maria','Actor'),
      ('Meera','Singer'),
      ('Ashley','Professor'),
      ('Ketty','Professor'),
      ('Christeen','Professor'),
      ('Jane','Actor'),
      ('Jenny','Doctor'),
      ('Priya','Singer')


SELECT 
CASE 
	WHEN occupation = 'Doctor' then name else null
END as doctor ,
CASE 
	WHEN occupation = 'Professor' then name else null
END as Professor ,
CASE 
	WHEN occupation = 'Actor' then name else null
END as Actor 
FROM OCCUPATIONS 
ORDER BY name

SELECT t1.name, t2.Name
FROM OCCUPATIONS t1, OCCUPATIONS t2
where t1.occupation = 'Doctor'
and t2.occupation = 'Actor'
and t1.rownum = t2.rownum


select * from OCCUPATIONS ORDER BY Occupation


select name from OCCUPATIONS 
where Occupation = 'Doctor'



SELECT 
    d.Name AS doctor,
	p.Name AS Professor,
    a.Name AS Actor
FROM
(SELECT 
        name, 
        ROW_NUMBER() OVER (ORDER BY name) AS RowNum
     FROM 
        Occupations 
     WHERE 
        occupation = 'doctor'
 )  d
 full join 
(SELECT 
        name, 
        ROW_NUMBER() OVER (ORDER BY name) AS RowNum1
     FROM 
        Occupations 
     WHERE 
        occupation = 'Professor'
) p
on d.RowNum = p.RowNum1
full join 
( SELECT 
        name, 
        ROW_NUMBER() OVER (ORDER BY name) AS RowNum2
     FROM 
        Occupations 
     WHERE 
        occupation = 'Actor'
) a
on coalesce(d.RowNum,p.RowNum1)= a.RowNum2
full join 
(
SELECT 
        name, 
        ROW_NUMBER() OVER (ORDER BY name) AS RowNum3
     FROM 
        Occupations
     WHERE 
        occupation = 'Singer'
) s
on coalesce(a.RowNum2,p.RowNum1)= s.RowNum3;

--task 9
create table BST
(
N INT,
P INT
)
insert into BST
values(1,2),
(3,2),
(6,8),
(9,8),
(2,5),
(8,5),
(5,null)

select N,
case
	WHEN P is null then 'Root'
	WHEN P is NOT NULL AND N IS NOT NULL AND P = (select N from BST where P is null) then 'Inner'
	else 'Leaf'
END
from BST order by N

--task 10

CREATE TABLE Company 
(
  company_code varchar(255),
  founder varchar(255)
)
CREATE TABLE Lead_Manager
(
   lead_manager_code varchar(255),
   company_code varchar(255)
)
CREATE TABLE Senior_Manager
(
   senior_manager_code varchar(255),
   lead_manager_code varchar(255),
   company_code varchar(255)
)
CREATE TABLE Manager
(
  manager_code varchar(255),
  senior_manager_code varchar(255),
  lead_manager_code varchar(255),
  company_code varchar(255)
)
CREATE TABLE Employee
(
  employee_code varchar(255),
  manager_code varchar(255),
  senior_manager_code varchar(255),
  lead_manager_code varchar(255),
  company_code varchar(255)
)
INSERT INTO Company
VALUES('C1','Monika'),
      ('C2','Samantha')

INSERT INTO Lead_Manager
VALUES('LM1','C1'),
      ('LM2','C2')
INSERT INTO Senior_Manager
VALUES('SM1','LM1','C1'),
      ('SM2','LM1','C1'),
	  ('SM3','LM2','C2')

INSERT INTO Manager
VALUES('M1','SM1','LM1','C1'),
      ('M2','SM3','LM2','C2'),
	  ('M3','SM3','LM2','C2')

INSERT INTO Employee
VALUES('E1','M1','SM1','LM1','C1'),
      ('E2','M1','SM1','LM1','C1'),
	  ('E3','M2','SM3','LM2','C2'),
	  ('E4','M3','SM3','LM2','C2')

SELECT * FROM Company
SELECT * FROM Lead_Manager
SELECT * FROM Senior_Manager
SELECT * FROM Manager
SELECT * FROM Employee;


select cd.company_code,
       cd.founder,
	   cd.count_lead_manager,
	   sd.count_seniorm,
	   sd.count_manager,
	   ed.count_emp
from 
 (  
  select c.company_code, c.founder,
  count(distinct l.lead_manager_code) count_lead_manager 
  from Company c 

  inner join 

  Lead_Manager l
  on c.company_code = l.company_code
  group by c.company_code,c.founder
  )cd

  inner join
  (
  select s.company_code, 
  count(distinct s.senior_manager_code) count_seniorm,
  count(distinct m.manager_code) count_manager 
  from Senior_Manager s 
  
  inner join 
  Manager m 
  on s.company_code = m.company_code
  group by s.company_code
  )sd
  on cd.company_code = sd.company_code
  
  inner join
  (
  select e.company_code,count(distinct e.employee_code) count_emp
  from Employee e
  group by e.company_code
  )ed
  on sd.company_code = ed.company_code
  
 
--task 11
--solution is same like task 2

--task 12 : 
--dataset not found


























