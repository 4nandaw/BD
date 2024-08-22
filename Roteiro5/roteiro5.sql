-- 1. 
SELECT COUNT(*) FROM employee WHERE sex = 'F';

-- 2.
SELECT AVG(salary) FROM employee WHERE address LIKE '%TX%' AND sex = 'M';

-- 3.
SELECT superssn AS ssn_supervisor, COUNT(ssn) AS qtd_supervisionados FROM employee GROUP BY superssn ORDER BY qtd_supervisionados;

-- 4.
SELECT s.fname AS nome_supervisor, COUNT(e.superssn) AS qtd_supervisionados FROM employee e INNER JOIN employee s ON e.superssn = s.ssn GROUP BY s.fname ORDER BY qtd_supervisionados ASC;

-- 5.
SELECT s.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM employee e LEFT JOIN employee s ON e.superssn = s.ssn GROUP BY s.fname;

-- 6. 
SELECT MIN(qtd) AS qtd FROM (SELECT pno, COUNT(*) AS qtd FROM works_on GROUP BY pno ORDER BY COUNT(*)) AS WORKS;

-- 7.
SELECT pno AS num_proj, qtd AS qtd_func FROM (SELECT pno, COUNT(*) AS qtd FROM works_on GROUP BY pno ORDER BY COUNT(*)) AS WORKS GROUP BY pno, qtd HAVING qtd = (SELECT MIN(qtd) FROM (SELECT pno, COUNT(*) AS qtd FROM works_on GROUP BY pno) AS CONT);

-- 8.
SELECT pno AS num_proj, AVG(salary) AS media_sal FROM employee, works_on WHERE essn = ssn GROUP BY pno;

-- 9.
SELECT pnumber AS proj_num, pname AS proj_nome, AVG(salary) AS media_sal FROM employee, works_on, project WHERE essn = ssn AND pnumber = pno GROUP BY pnumber, pname;

-- 10.
SELECT DISTINCT fname, salary FROM employee, works_on WHERE NOT essn = ssn AND pno = 92 AND salary > (SELECT MAX(salary) FROM employee, works_on WHERE essn = ssn AND pno = 92 GROUP BY pno);

-- 11.
SELECT ssn, COUNT(pno) AS qtd_proj FROM employee LEFT JOIN works_on ON ssn = essn GROUP BY ssn ORDER BY qtd_proj ASC;

-- 12.
SELECT pno AS num_proj, COUNT(ssn) AS qtd_func FROM (employee LEFT OUTER JOIN works_on ON ssn = essn) GROUP BY pno HAVING COUNT(ssn) < 5 ORDER BY COUNT(ssn);

-- 13.
SELECT DISTINCT fname FROM employee, dependent WHERE ssn = essn AND ssn IN (SELECT essn FROM works_on, PROJECT WHERE pno = pnumber AND plocation = 'Sugarland');

-- 14.
SELECT dname FROM department WHERE NOT dname = ANY (SELECT DISTINCT dname FROM department, project WHERE dnum = dnumber);

-- 15.
SELECT DISTINCT fname, lname FROM employee WHERE NOT EXISTS ((SELECT pno FROM works_on WHERE essn = '123456789') EXCEPT (SELECT pno FROM works_on WHERE ssn = essn)) AND ssn <> '123456789';