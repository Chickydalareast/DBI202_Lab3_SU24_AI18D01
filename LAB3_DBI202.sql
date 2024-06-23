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


