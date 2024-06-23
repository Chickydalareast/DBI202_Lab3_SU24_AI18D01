--DBI202_AI18D01_LAB3_SU24--

USE [FUH_COMPANY]
GO

--Trunghieu--



--LanNhi--



--Gia Vinh--


 

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
