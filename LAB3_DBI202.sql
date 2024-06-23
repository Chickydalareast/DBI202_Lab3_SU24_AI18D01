--DBI202_AI18D01_LAB3_SU24--

USE [FUH_COMPANY]
GO

--Trunghieu--

 --1. Cho biết ai đang quản lý phòng ban có tên: Phòng Nghiên cứu và phát triển. --
 SELECT e.empSSN, e.empName, d.depNum, d.depName
FROM tblEmployee e
JOIN tblDepartment d ON e.empSSN = d.mgrSSN
WHERE d.depName = N'Phòng Nghiên cứu và phát triển';
 --2. Cho phòng ban có tên: Phòng Nghiên cứu và phát triển hiện đang quản lý dự án nào.--
 SELECT  p.proNum, p.proName, d.depName
FROM  tblProject p
JOIN  tblDepartment d ON p.depNum = d.depNum
WHERE  d.depName = N'Phòng Nghiên cứu và phát triển';
 --3.	Cho biết dự án có tên ProjectB hiện đang được quản lý bởi phòng ban nào. --
 SELECT  p.proNum, p.proName, d.depName
FROM  tblProject p
JOIN tblDepartment d ON p.depNum = d.depNum
WHERE  p.proName = 'ProjectB';
 --4. Cho biết những nhân viên nào đang bị giám sát bởi nhân viên có tên Mai Duy An.--
 SELECT e1.empSSN, e1.empName
FROM tblEmployee e1
JOIN  tblEmployee e2 ON e1.supervisorSSN = e2.empSSN
WHERE e2.empName = N'Mai Duy An';
 --5. Cho biết ai hiện đang giám sát những nhân viên có tên Mai Duy An.--
 SELECT e2.empSSN, e2.empName
FROM tblEmployee e1
JOIN  tblEmployee e2 ON e1.supervisorSSN = e2.empSSN
WHERE e1.empName = N'Mai Duy An';
 --6.	Cho biết dự án có tên ProjectA hiện đang làm việc ở đâu--
 SELECT p.proNum,  l.locName
FROM tblProject p
JOIN  tblLocation l ON p.locNum = l.locNum
WHERE  p.proName = 'ProjectA';
 --7.	Cho biết vị trí làm việc có tên Tp. HCM hiện đang là chỗ làm việc của những dự án nào. --
 SELECT p.proNum, p.proName
FROM  tblProject p
JOIN tblLocation l ON p.locNum = l.locNum
WHERE  l.locName = N'TP Hồ Chí Minh';
 --8.	Cho biết những người phụ thuộc trên 18 tuổi --
 SELECT  d.depName, d.depBirthdate, e.empName
FROM tblDependent d
JOIN tblEmployee e ON d.empSSN = e.empSSN
WHERE DATEDIFF(YEAR, d.depBirthdate, GETDATE()) > 18;
 --9.	Cho biết những người phụ thuộc  là nam giới. --
 SELECT d.depName,d.depBirthdate, e.empName
FROM  tblDependent d
JOIN  tblEmployee e ON d.empSSN = e.empSSN
WHERE d.depSex = 'M';
 --10.	Cho biết những nơi làm việc của phòng ban có tên : Phòng Nghiên cứu và phát triển.--
 SELECT d.depNum, d.depName, l.locName
FROM  tblDepLocation dl
JOIN tblDepartment d ON dl.depNum = d.depNum
JOIN tblLocation l ON dl.locNum = l.locNum
WHERE d.depName = N'Phòng Nghiên cứu và phát triển';
 --11.	Cho biết các dự án làm việc tại Tp. HCM. --
 SELECT  p.proNum, p.proName, d.depName
FROM tblProject p
JOIN tblLocation l ON p.locNum = l.locNum
JOIN tblDepartment d ON p.depNum = d.depNum
WHERE l.locName = N'TP Hồ Chí Minh';
 --12.	Cho biết những người phụ thuộc là nữ giới, của nhân viên thuộc phòng ban có tên: Phòng Nghiên cứu và phát triển .--
 SELECT e.empName,d.depName, d.depRelationship
FROM tblDependent d
JOIN  tblEmployee e ON d.empSSN = e.empSSN
JOIN tblDepartment dep ON e.depNum = dep.depNum
WHERE d.depSex = N'F' AND dep.depName = N'Phòng Nghiên cứu và phát triển';
 --13.	Cho biết những người phụ thuộc trên 18 tuổi, của nhân viên thuộc phòng ban có tên: Phòng Nghiên cứu và phát triển.--
 SELECT e.empName,d.depName,d.depRelationship
FROM tblDependent d
JOIN tblEmployee e ON d.empSSN = e.empSSN
JOIN tblDepartment dep ON e.depNum = dep.depNum
WHERE DATEDIFF(YEAR, d.depBirthdate, GETDATE()) > 18 AND dep.depName = N'Phòng Nghiên cứu và phát triển';


--LanNhi--



--Gia Vinh--


 

--BaoTran--


