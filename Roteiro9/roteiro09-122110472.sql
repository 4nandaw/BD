-- QUESTÃO 1: criar views

CREATE VIEW vw_dptmgr AS 
    SELECT dnumber, fname FROM department, employee WHERE mgrssn = ssn;

CREATE VIEW vw_empl_houston AS 
    SELECT ssn, fname FROM employee WHERE address LIKE '%Houston%';

CREATE VIEW vw_deptstats AS
    SELECT dnumber, dname, COUNT (*) AS tot_emp FROM department, employee WHERE dno = dnumber GROUP BY dnumber, dname;

CREATE VIEW vw_projstats AS
    SELECT pno, COUNT (essn) AS tot_emp FROM works_on GROUP BY pno;



-- QUESTÃO 2: querys

-- Queries para checagem:
SELECT * FROM vw_dptmgr;

SELECT * FROM vw_empl_houston;

SELECT * FROM vw_deptstats;

SELECT * FROM vw_projstats;

-- Outras queries:
SELECT fname FROM vw_dptmgr;

SELECT ssn FROM vw_empl_houston;

SELECT dnumber, tot_emp FROM vw_deptstats;

SELECT pno, tot_emp FROM vw_projstats WHERE tot_emp < 5;



-- QUESTÃO 3: deletar views

DROP VIEW vw_dptmgr;

DROP VIEW vw_empl_houston;

DROP VIEW vw_deptstats;

DROP VIEW vw_projstats;



-- QUESTÃO 4: criar function

CREATE FUNCTION check_age (c_ssn CHAR(9))
RETURNS VARCHAR(7) AS $$
DECLARE age INTEGER;
BEGIN
    SELECT EXTRACT(YEAR FROM AGE(CURRENT_DATE, bdate)) INTO age FROM employee WHERE c_ssn = ssn;

    IF (age >= 50) THEN RETURN 'SENIOR';
    ELSIF (age < 0) THEN RETURN 'INVALID';
    ELSIF (age < 50) THEN RETURN 'YOUNG';
    ELSIF (age IS NULL) THEN RETURN 'UNKNOWN';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- TESTE SENIOR
SELECT check_age('666666609');

-- TESTE YOUNG
SELECT check_age('555555500');

-- TESTE INVALID
SELECT check_age('987987987');

-- TESTE UNKNOWN
SELECT check_age('x');
SELECT check_age(null);

-- TESTE EM CONSULTA
SELECT ssn FROM employee WHERE check_age(ssn) = 'SENIOR';



-- QUESTÃO 5: criar trigger procedure

CREATE OR REPLACE FUNCTION check_mgr() RETURNS trigger AS $$
DECLARE
    num_subordinados INTEGER;
    mgr_dpt INTEGER;
BEGIN
    SELECT COUNT(*) INTO num_subordinados FROM employee WHERE superssn = NEW.mgrssn;

    SELECT dno INTO mgr_dpt FROM employee WHERE ssn = NEW.mgrssn;

    IF mgr_dpt IS DISTINCT FROM NEW.dnumber OR mgr_dpt IS NULL 
        THEN RAISE EXCEPTION 'manager must be a department''s employee';
    ELSEIF num_subordinados = 0 
        THEN RAISE EXCEPTION 'manager must have supervisees';
    ELSEIF check_age(NEW.mgrssn) != 'SENIOR'
        THEN RAISE EXCEPTION 'manager must be a SENIOR employee';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- INSERTS
INSERT INTO department VALUES ('Test', 2, '999999999', now());

INSERT INTO employee VALUES ('Joao','A','Silva','999999999','10-OCT-1950','123 Peachtree, Atlanta, GA','M',85000,null,2);

-- employee subordinado ao anterior
INSERT INTO employee VALUES ('Jose','A','Santos','999999998','10-OCT-1950','123 Peachtree, Atlanta, GA','M',85000,'999999999',2);

-- ADD TRIGGER
CREATE TRIGGER check_mgr BEFORE INSERT OR UPDATE ON department
    FOR EACH ROW EXECUTE PROCEDURE check_mgr();

-- Update: funcionar normal
UPDATE department SET mgrssn = '999999999' WHERE dnumber=2;

-- ERROR:  manager must be a department's employee
UPDATE department SET mgrssn = null WHERE dnumber=2;

-- ERROR:  manager must be a department's employee
UPDATE department SET mgrssn = '999' WHERE dnumber=2;

-- ERROR:  manager must be a department's employee
UPDATE department SET mgrssn = '111111100' WHERE dnumber=2;

-- Update para não ser SENIOR
UPDATE employee SET bdate = '10-OCT-2000' WHERE ssn = '999999999';

-- ERROR:  manager must be a SENIOR employee
UPDATE department SET mgrssn = '999999999' WHERE dnumber=2;

-- Update para voltar a SENIOR
UPDATE employee SET bdate = '10-OCT-1950' WHERE ssn = '999999999';

UPDATE department SET mgrssn = '999999999' WHERE dnumber=2;

-- Remove subordinado
DELETE FROM employee WHERE superssn = '999999999';

-- ERROR:  manager must have supervisees
UPDATE department SET mgrssn = '999999999' WHERE dnumber=2;

DELETE FROM employee WHERE ssn = '999999999';

DELETE FROM department where dnumber=2;