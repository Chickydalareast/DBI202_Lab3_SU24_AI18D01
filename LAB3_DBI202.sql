﻿--DBI202_AI18D01_LAB3_SU24--

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

--14.Cho biết số lượng người phụ thuộc theo giới tính. 
--Thông tin yêu cầu: giới tính, số lượng người phụ thuộc
SELECT 
    depSex,
    COUNT(*) AS numOfDep
FROM 
    tblDependent
GROUP BY 
    depSex;
go
--15.Cho biết số lượng người phụ thuộc theo mối liên hệ với nhân viên. Thông tin yêu cầu: mối liên hệ, số lượng người phụ thuộc
SELECT 
    depRelationship, 
    COUNT(depName) AS numOfDep
FROM 
    tblDependent
GROUP BY 
    depRelationship; 
go
--16.Cho biết số lượng người phụ thuộc theo mỗi phòng ban. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng người phụ thuộc
SELECT 
    d.depNum,
    d.depName,
    COUNT(dep.depName) AS numOfDep
FROM 
    tblDepartment d
LEFT JOIN 
    tblEmployee e ON d.depNum = e.depNum
LEFT JOIN 
    tblDependent dep ON e.empSSN = dep.empSSN
GROUP BY 
    d.depNum, d.depName
ORDER BY 
    d.depNum;
go
--17.Cho biết phòng ban nào có số lượng người phụ thuộc là ít nhất. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng người phụ thuộc
--C1
SELECT TOP 1 WITH TIES
    d.depNum,
    d.depName,
    COUNT(dep.empSSN) AS numOfDependents
FROM 
    tblDepartment d
LEFT JOIN 
    tblEmployee e ON d.depNum = e.depNum
LEFT JOIN 
    tblDependent dep ON e.empSSN = dep.empSSN
GROUP BY 
    d.depNum, d.depName
ORDER BY 
    COUNT(dep.empSSN) ASC;
--
SELECT 
    d.depNum, 
    d.depName, 
    COUNT(dep.depName) AS numOfDep
FROM 
    tblDepartment d
LEFT JOIN 
    tblEmployee e ON d.depNum = e.depNum
LEFT JOIN 
    tblDependent dep ON e.empSSN = dep.empSSN
GROUP BY 
    d.depNum, d.depName
HAVING 
    COUNT(dep.depName) = (
        SELECT 
            MIN(dep_count)
        FROM (
            SELECT 
                COUNT(dep2.depName) AS dep_count
            FROM 
                tblDepartment d2
            LEFT JOIN 
                tblEmployee e2 ON d2.depNum = e2.depNum
            LEFT JOIN 
                tblDependent dep2 ON e2.empSSN = dep2.empSSN
            GROUP BY 
                d2.depNum, d2.depName
        ) AS Subquery
    )
ORDER BY 
    d.depNum;
go
--18.Cho biết phòng ban nào có số lượng người phụ thuộc là nhiều nhất.
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng người phụ thuộc
--C1
SELECT TOP 1 WITH TIES
    d.depNum,
    d.depName,
    COUNT(dep.empSSN) AS numOfDependents
FROM 
    tblDepartment d
LEFT JOIN 
    tblEmployee e ON d.depNum = e.depNum
LEFT JOIN 
    tblDependent dep ON e.empSSN = dep.empSSN
GROUP BY 
    d.depNum, d.depName
ORDER BY 
    COUNT(dep.empSSN) DESC;
--C2
SELECT 
    d.depNum,
    d.depName,
    COUNT(dep.depName) AS numOfDep
FROM 
    tblDepartment d
LEFT JOIN 
    tblEmployee e ON d.depNum = e.depNum
LEFT JOIN 
    tblDependent dep ON e.empSSN = dep.empSSN
GROUP BY 
    d.depNum, d.depName
HAVING 
    COUNT(dep.depName) = (
        SELECT 
            MAX(dependent_count)
        FROM (
            SELECT 
                COUNT(dep2.depName) AS dependent_count
            FROM 
                tblDepartment d2
            LEFT JOIN 
                tblEmployee e2 ON d2.depNum = e2.depNum
            LEFT JOIN 
                tblDependent dep2 ON e2.empSSN = dep2.empSSN
            GROUP BY 
                d2.depNum, d2.depName
        ) AS max_counts
	);
go
--19.Cho biết tổng số giờ tham gia dự án của mỗi nhân viên. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
SELECT 
    e.empSSN, 
    e.empName, 
    d.depName, 
    SUM(w.workHours) AS total_hours
FROM 
    tblEmployee e
JOIN 
    tblDepartment d ON e.depNum = d.depNum
JOIN 
    tblWorksOn w ON e.empSSN = w.empSSN
JOIN 
    tblProject p ON w.proNum = p.proNum
GROUP BY 
    e.empSSN, e.empName, d.depName;
go
--20.Cho biết tổng số giờ làm dự án của mỗi phòng ban. 
--Thông tin yêu cầu: mã phòng ban,  tên phòng ban, tổng số giờ
SELECT 
    d.depNum, 
    d.depName, 
    SUM(w.workHours) AS total_hours
FROM 
    tblDepartment d
JOIN 
    tblProject p ON d.depNum = p.depNum
JOIN 
    tblWorksOn w ON p.proNum = w.proNum
JOIN 
    tblEmployee e ON w.empSSN = e.empSSN
GROUP BY 
    d.depNum, d.depName;
go
--21.Cho biết nhân viên nào có số giờ tham gia dự án là ít nhất. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tổng số giờ tham gia dự án
SELECT TOP 1
    e.empSSN,
    e.empName,
    SUM(w.workHours) AS total_hours
FROM
    tblEmployee e
JOIN
    tblWorksOn w ON e.empSSN = w.empSSN
GROUP BY
    e.empSSN, e.empName
ORDER BY
    total_hours ASC;
go
--22.Cho biết nhân viên nào có số giờ tham gia dự án là nhiều nhất. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tổng số giờ tham gia dự án
SELECT TOP 1
    e.empSSN,
    e.empName,
    SUM(w.workHours) AS total_hours
FROM
    tblEmployee e
JOIN
    tblWorksOn w ON e.empSSN = w.empSSN
GROUP BY
    e.empSSN, e.empName
ORDER BY
    total_hours DESC;
go
--23.Cho biết những nhân viên nào lần đầu tiên tham gia dụ án. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
SELECT 
    e.empSSN,
    e.empName,
    d.depName
FROM 
    tblEmployee e
JOIN 
    tblDepartment d ON e.depNum = d.depNum
JOIN 
    tblWorksOn w ON e.empSSN = w.empSSN
GROUP BY 
    e.empSSN, e.empName, d.depName
HAVING 
    COUNT(w.proNum) = 1;
go
--24.Cho biết những nhân viên nào lần thứ hai tham gia dụ án. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
SELECT 
    e.empSSN,
    e.empName,
    d.depName
FROM 
    tblEmployee e
JOIN 
    tblDepartment d ON e.depNum = d.depNum
JOIN 
    tblWorksOn w ON e.empSSN = w.empSSN
GROUP BY 
    e.empSSN, e.empName, d.depName
HAVING 
    COUNT(DISTINCT w.proNum) = 2;
go
--25.Cho biết những nhân viên nào tham gia tối thiểu hai dụ án. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
SELECT 
    e.empSSN,
    e.empName,
    d.depName
FROM 
    tblEmployee e
JOIN 
    tblDepartment d ON e.depNum = d.depNum
JOIN 
    tblWorksOn w ON e.empSSN = w.empSSN
GROUP BY 
    e.empSSN, e.empName, d.depName
HAVING 
    COUNT(DISTINCT w.proNum) >= 2;
go
--26.Cho biết số lượng thành viên của mỗi dự án. 
--Thông tin yêu cầu: mã dự án, tên dự án, số lượng thành viên
SELECT 
    p.proNum,
    p.proName,
    COUNT(w.empSSN) AS numOfMem
FROM 
    tblProject p
LEFT JOIN 
    tblWorksOn w ON p.proNum = w.proNum
GROUP BY 
    p.proNum, p.proName;

--Gia Vinh--

--27.Cho biết tổng số giờ làm của mỗi dự án. Thông tin yêu cầu: mã dự án, tên dự án, tổng số giờ làm.
SELECT 
    p.proNum AS ProjectCode,
    p.proName AS ProjectName,
    SUM(CAST(w.workHours AS INT)) AS TotalWorkHours
FROM 
    tblWorksOn w
JOIN 
    tblProject p ON w.proNum = p.proNum
GROUP BY 
    p.proNum, p.proName;

--28.Cho biết dự án nào có số lượng thành viên là ít nhất. Thông tin yêu cầu: mã dự án, tên dự án, số lượng thành viên.
WITH ProjectMemberCounts AS (
    SELECT 
        p.proNum AS ProjectCode,
        p.proName AS ProjectName,
        COUNT(DISTINCT w.empSSN) AS MemberCount
    FROM 
        tblWorksOn w
    JOIN 
        tblProject p ON w.proNum = p.proNum
    GROUP BY 
        p.proNum, p.proName
)
SELECT 
    ProjectCode,
    ProjectName,
    MemberCount
FROM 
    ProjectMemberCounts
WHERE 
    MemberCount = (SELECT MIN(MemberCount) FROM ProjectMemberCounts);

--29..Cho biết dự án nào có số lượng thành viên là nhiều nhất. Thông tin yêu cầu: mã dự án, tên dự án, số lượng thành viên.
WITH ProjectMemberCounts AS (
    SELECT 
        p.proNum AS ProjectCode,
        p.proName AS ProjectName,
        COUNT(w.empSSN) AS MemberCount
    FROM 
        tblWorksOn w
    JOIN 
        tblProject p ON w.proNum = p.proNum
    GROUP BY 
        p.proNum, p.proName
)
SELECT 
    ProjectCode,
    ProjectName,
    MemberCount
FROM 
    ProjectMemberCounts
WHERE 
    MemberCount = (SELECT MAX(MemberCount) FROM ProjectMemberCounts);

--30.Cho biết dự án nào có tổng số giờ làm là ít nhất. Thông tin yêu cầu: mã dự án, tên dự án, tổng số giờ làm.
SELECT 
    w.proNum AS 'Mã số dự án', 
    p.proName AS 'Tên dự án', 
    SUM(w.workHours) AS 'Tổng số giờ làm'
FROM 
    dbo.tblWorksOn w
JOIN 
    dbo.tblProject p ON w.proNum = p.proNum
GROUP BY 
    w.proNum, p.proName
HAVING 
    SUM(w.workHours) = (
        SELECT MIN(totalHours)
        FROM (
            SELECT 
                SUM(workHours) AS totalHours
            FROM 
                dbo.tblWorksOn
            GROUP BY 
                proNum
        ) AS minHours
    );

--31..Cho biết dự án nào có tổng số giờ làm là nhiều nhất. Thông tin yêu cầu: mã dự án, tên dự án, tổng số giờ làm.
WITH ProjectWorkHours AS (
    SELECT 
        p.proNum AS ProjectCode,
        p.proName AS ProjectName,
        SUM(CAST(w.workHours AS INT)) AS TotalWorkHours
    FROM 
        tblWorksOn w
    JOIN 
        tblProject p ON w.proNum = p.proNum
    GROUP BY 
        p.proNum, p.proName
)
SELECT 
    ProjectCode,
    ProjectName,
    TotalWorkHours
FROM 
    ProjectWorkHours
WHERE 
    TotalWorkHours = (SELECT MAX(TotalWorkHours) FROM ProjectWorkHours);

--32..Cho biết số lượng phòng ban làm việc theo mỗi nơi làm việc. Thông tin yêu cầu: tên nơi làm việc, số lượng phòng ban.
SELECT
l.locName AS LocationName,
    COUNT(dl.depNum) AS DepartmentCount
FROM 
    tblDepLocation dl
JOIN 
    tblLocation l ON dl.locNum = l.locNum
GROUP BY 
    l.locName;

--33.Cho biết số lượng chỗ làm việc theo mỗi phòng ban. Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng chỗ làm việc.
SELECT 
    d.depNum AS DepartmentCode,
    d.depName AS DepartmentName,
    COUNT(dl.locNum) AS LocationCount
FROM 
    tblDepLocation dl
JOIN 
    tblDepartment d ON dl.depNum = d.depNum
GROUP BY 
    d.depNum, d.depName;

--34.Cho biết phòng ban nào có nhiều chỗ làm việc nhất. Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng chỗ làm việc.
WITH DepartmentLocationCounts AS (
    SELECT 
        d.depNum AS DepartmentCode,
        d.depName AS DepartmentName,
        COUNT(dl.locNum) AS LocationCount
    FROM 
        tblDepLocation dl
    JOIN 
        tblDepartment d ON dl.depNum = d.depNum
    GROUP BY 
        d.depNum, d.depName
)
SELECT 
    DepartmentCode,
    DepartmentName,
    LocationCount
FROM 
    DepartmentLocationCounts
WHERE 
    LocationCount = (SELECT MAX(LocationCount) FROM DepartmentLocationCounts);

--35.Cho biết phòng ban nào có ít chỗ làm việc nhất. Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng chỗ làm việc.
WITH DepartmentLocationCounts AS (
    SELECT 
        d.depNum AS DepartmentCode,
        d.depName AS DepartmentName,
        COUNT(dl.locNum) AS LocationCount
    FROM 
        tblDepLocation dl
    JOIN 
        tblDepartment d ON dl.depNum = d.depNum
    GROUP BY 
        d.depNum, d.depName
)
SELECT 
    DepartmentCode,
    DepartmentName,
    LocationCount
FROM 
    DepartmentLocationCounts
WHERE 
    LocationCount = (SELECT MIN(LocationCount) FROM DepartmentLocationCounts);

--36.Cho biết địa điểm nào có nhiều phòng ban làm việc nhất. Thông tin yêu cầu: tên nơi làm việc, số lượng phòng ban.
WITH LocationDepartmentCounts AS (
    SELECT 
        l.locName AS LocationName,
        COUNT(dl.depNum) AS DepartmentCount
    FROM 
        tblDepLocation dl
    JOIN 
        tblLocation l ON dl.locNum = l.locNum
    GROUP BY 
        l.locName
)
SELECT 
    LocationName,
    DepartmentCount
FROM 
    LocationDepartmentCounts
WHERE 
    DepartmentCount = (SELECT MAX(DepartmentCount) FROM LocationDepartmentCounts);

--37.Cho biết địa điểm nào có ít phòng ban làm việc nhất. Thông tin yêu cầu: tên nơi làm việc, số lượng phòng ban.
WITH LocationDepartmentCounts AS (
    SELECT 
        l.locName AS LocationName,
        COUNT(dl.depNum) AS DepartmentCount
    FROM 
        tblDepLocation dl
    JOIN 
        tblLocation l ON dl.locNum = l.locNum
    GROUP BY 
        l.locName
)
SELECT 
    LocationName,
    DepartmentCount
FROM 
    LocationDepartmentCounts
WHERE 
    DepartmentCount = (SELECT MIN(DepartmentCount) FROM LocationDepartmentCounts);
--38.Cho biết nhân viên nào có nhiều người phụ thuộc nhất. Thông tin yêu cầu: mã số, họ tên nhân viên, số lượng người phụ thuộc
WITH EmployeeDependentCounts AS (
    SELECT 
        e.empSSN AS EmployeeID,
        e.empName AS EmployeeName,
        COUNT(d.depName) AS DependentCount
    FROM 
        tblEmployee e
    LEFT JOIN 
        tblDependent d ON e.empSSN = d.empSSN
    GROUP BY 
        e.empSSN, e.empName
)
SELECT 
    EmployeeID,
    EmployeeName,
    DependentCount
FROM 
    EmployeeDependentCounts
WHERE 
    DependentCount = (SELECT MAX(DependentCount) FROM EmployeeDependentCounts);

--39.Cho biết nhân viên nào có ít người phụ thuộc nhất. Thông tin yêu cầu: mã số, họ tên nhân viên, số lượng người phụ thuộc.
WITH EmployeeDependentCounts AS (
    SELECT 
        e.empSSN AS EmployeeID,
        e.empName AS EmployeeName,
        COUNT(d.depName) AS DependentCount
    FROM 
        tblEmployee e
    LEFT JOIN 
        tblDependent d ON e.empSSN = d.empSSN
    GROUP BY 
        e.empSSN, e.empName
)
SELECT 
    EmployeeID,
    EmployeeName,
    DependentCount
FROM 
    EmployeeDependentCounts
WHERE 
    DependentCount = (SELECT MIN(DependentCount) FROM EmployeeDependentCounts);
 

--BaoTran--
--40.Cho biết nhân viên nào không có người phụ thuộc. 
--Thông tin yêu cầu: mã số nhân viên, họ tên nhân viên, tên phòng ban của nhân viên
SELECT 
    e.empSSN,
    e.empName,
    d.depName
FROM 
    tblEmployee e
JOIN 
    tblDepartment d ON e.depNum = d.depNum
LEFT JOIN 
    tblDependent dep ON e.empSSN = dep.empSSN
WHERE 
    dep.empSSN IS NULL;
--41.Cho biết phòng ban nào không có người phụ thuộc. 
--Thông tin yêu cầu: mã số phòng ban, tên phòng ban
SELECT
	d.depNum,
	d.depName
FROM
	tblDepartment d
LEFT JOIN
	tblEmployee e ON d.depNum = e.depNum
LEFT JOIN
	tblDependent dep ON e.empSSN = dep.empSSN
GROUP BY
	d.depNum, d.depName
HAVING
	COUNT(dep.empSSN) = 0;
--42.Cho biết những nhân viên nào chưa hề tham gia vào bất kỳ dự án nào. 
--Thông tin yêu cầu: mã số, tên nhân viên, tên phòng ban của nhân viên
SELECT
	e.empSSN,
	e.empName,
	d.depName
FROM
	tblEmployee e
JOIN
	tblDepartment d ON e.depNum = d.depNum
LEFT JOIN
	tblWorksOn w ON e.empSSN = w.empSSN
WHERE
	w.empSSN IS NULL;
--43.Cho biết phòng ban không có nhân viên nào tham gia (bất kỳ) dự án. 
--Thông tin yêu cầu: mã số phòng ban, tên phòng ban
SELECT
	d.depNum,
	d.depName
FROM
	tblDepartment d
LEFT JOIN
	tblEmployee e ON d.depNum = e.depNum
LEFT JOIN
	tblWorksOn w ON e.empSSN = w.empSSN
GROUP BY
	d.depNum, d.depName
HAVING
	COUNT(w.empSSN) = 0;
--44.Cho biết phòng ban không có nhân viên nào tham gia vào dự án có tên là ProjectA. 
--Thông tin yêu cầu: mã số phòng ban, tên phòng ban
SELECT 
	d.depNum, 
	d.depName
FROM 
	tblDepartment d
WHERE 
	d.depNum NOT IN (
    SELECT  
		e.depNum
    FROM 
		tblEmployee e
    JOIN 
		tblWorksOn w ON e.empSSN = w.empSSN
    JOIN 
		tblProject p ON w.proNum = p.proNum
    WHERE 
		p.proName = 'ProjectA'
);
--45.Cho biết số lượng dự án được quản lý theo mỗi phòng ban. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng dự án
SELECT
	d.depNum,
	d.depName,
	COUNT(p.proName) AS numOfPro
FROM
	tblDepartment d
LEFT JOIN
	tblProject p ON d.depNum = p.depNum
GROUP BY
	d.depNum, d.depName;
--46.Cho biết phòng ban nào quản lý it dự án nhất. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng dự án
--C1
SELECT TOP 1 WITH TIES
    d.depNum,
    d.depName,
    COUNT(p.proNum) AS numOfPro
FROM 
    tblDepartment d
LEFT JOIN 
    tblProject p ON d.depNum = p.depNum
GROUP BY 
    d.depNum, d.depName
ORDER BY 
    COUNT(p.proNum) ASC;
--C2
SELECT 
	d.depNum,
	d.depName,
    COUNT(p.proNum) AS numOfPro
FROM
	tblDepartment d
LEFT JOIN
	tblProject p ON d.depNum = p.depNum
GROUP BY
	d.depNum, d.depName
HAVING
	COUNT(p.proNum) = (
        SELECT 
            MIN(project_count)
        FROM (
            SELECT 
                COUNT(p2.proNum) AS project_count
            FROM 
                tblDepartment d2
            LEFT JOIN 
                tblProject p2 ON d2.depNum = p2.depNum
            GROUP BY 
                d2.depNum, d2.depName
        ) AS min_counts
    );
--47.Cho biết phòng ban nào quản lý nhiều dự án nhất. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng dự án
--C1
SELECT TOP 1 WITH TIES
    d.depNum,
    d.depName,
    COUNT(p.proNum) AS numOfPro
FROM 
    tblDepartment d
LEFT JOIN 
    tblProject p ON d.depNum = p.depNum
GROUP BY 
    d.depNum, d.depName
ORDER BY 
    COUNT(p.proNum) DESC;
--C2
SELECT 
	d.depNum,
	d.depName,
    COUNT(p.proNum) AS numOfPro
FROM
	tblDepartment d
LEFT JOIN
	tblProject p ON d.depNum = p.depNum
GROUP BY
	d.depNum, d.depName
HAVING
	COUNT(p.proNum) = (
        SELECT 
            MAX(project_count)
        FROM (
            SELECT 
                COUNT(p2.proNum) AS project_count
            FROM 
                tblDepartment d2
            LEFT JOIN 
                tblProject p2 ON d2.depNum = p2.depNum
            GROUP BY 
                d2.depNum, d2.depName
        ) AS max_counts
    );
--48.Cho biết những phòng ban nào có nhiểu hơn 5 nhân viên đang quản lý dự án gì. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng nhân viên của phòng ban, tên dự án quản lý
SELECT
	d.depNum,
	d.depName,
	COUNT(e.empSSN) AS numOfEmp,
	p.proName
FROM
	tblDepartment d
JOIN
	tblEmployee e ON d.depNum = e.depNum
JOIN
	tblWorksOn w ON e.empSSN = w.empSSN
JOIN
	tblProject p ON w.proNum = p.proNum
GROUP BY
	d.depNum, d.depName,p.proName
HAVING
	COUNT(e.empSSN) > 5;
--49.Cho biết những nhân viên thuộc phòng có tên là Phòng nghiên cứu, và không có người phụ thuộc. 
--Thông tin yêu cầu: mã nhân viên,họ tên nhân viên
SELECT
	e.empSSN,
	e.empName
FROM
	tblEmployee e
JOIN
	tblDepartment d ON e.depNum = d.depNum
LEFT JOIN
	tblDependent dep ON e.empSSN = dep.empSSN
WHERE
	d.depName Like  N'%Phòng Nghiên cứu%'
	AND dep.empSSN IS NULL;
--50.Cho biết tổng số giờ làm của các nhân viên, mà các nhân viên này không có người phụ thuộc. 
--Thông tin yêu cầu: mã nhân viên,họ tên nhân viên, tổng số giờ làm
SELECT
	e.empSSN,
	e.empName,
	w.workHours
FROM
	tblEmployee e
JOIN
	tblWorksOn w ON e.empSSN = w.empSSN
LEFT JOIN
	tblDependent dep ON e.empSSN = dep.empSSN
WHERE
	dep.empSSN IS NULL;
--51.Cho biết tổng số giờ làm của các nhân viên, mà các nhân viên này có nhiều hơn 3 người phụ thuộc. 
--Thông tin yêu cầu: mã nhân viên,họ tên nhân viên, số lượng người phụ thuộc, tổng số giờ làm
SELECT
	e.empSSN,
	e.empName,
	COUNT(dep.empSSN) AS numOfDep,
	SUM(w.workHours) AS sumOfWorkHours
FROM
	tblEmployee e
JOIN
	tblDependent dep ON e.empSSN = dep.empSSN
JOIN
	tblWorksOn w ON e.empSSN =w.empSSN
GROUP BY
	e.empSSN, e.empName
HAVING
	COUNT(dep.empSSN) > 3;
--52.Cho biết tổng số giờ làm việc của các nhân viên hiện đang dưới quyền giám sát (bị quản lý bởi) của nhân viên Mai Duy An. 
--Thông tin yêu cầu: mã nhân viên, họ tên nhân viên, tổng số giờ làm
SELECT
	e.empSSN,
	e.empName,
	SUM(w.workHours) AS sumOfWorkHours
FROM
	tblEmployee e
JOIN
	tblDepartment d ON d.depNum = e.depNum
JOIN
	tblWorksOn w ON e.empSSN = w.empSSN
WHERE
	e.supervisorSSN = (
	SELECT 
		empSSN
	FROM
		tblEmployee
	WHERE 
		empName = 'Mai Duy An'
)
GROUP BY
	e.empSSN, e.empName;
