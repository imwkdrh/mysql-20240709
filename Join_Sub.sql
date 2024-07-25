use practice_sql;

CREATE TABLE employee (
	employee_num INT PRIMARY KEY auto_increment,
    name VARCHAR(20),
    age INT,
    department_code VARCHAR(2)
);
ALTER TABLE employee 
 ADD CONsTRAINT department_code_fk 
 FOREIGN KEY (department_code) 
 REFERENCES department(department_code);
 
 ALTER TABLE employee
  DROP CONSTRAINT department_code_fk;
  
CREATE TABLE department (
	department_code VARCHAR(2) PRIMARY KEY,
    name VARCHAR(15),
    tel VARCHAR(15)
);
INSERT INTO department VALUES ('A','영업부', '123456');
INSERT INTO department VALUES ('B','재무부', '123457');
INSERT INTO department VALUES ('C','행정부', '123458');


INSERT INTO employee (name,age,department_code) VALUES ('홍길동', 23,'A');
INSERT INTO employee (name,age,department_code) VALUES ('이영희', 15,'A');
INSERT INTO employee (name,age,department_code) VALUES ('고길동', 34,'C');
INSERT INTO employee (name,age,department_code) VALUES ('김희동', 20,'D');
INSERT INTO employee (name,age,department_code) VALUES ('이도', 17,'D');


-- Alias : 쿼리문에서 사용되는 별칭
-- 컬럼 및 테이블에서 사용가능
-- 사용하는 이름을 변경하고 싶을 때 적용

-- AS 키워드 생략 가능
SELECT 
	dpt.department_code  '부서코드',
    dpt.name  '부서명',
    dpt.tel  '부서 전화번호'
FROM department  dpt;

-- JOIN  : 두 개 이상의 테이블을 특정 조건에 따라 조합하여 결과를 조회하고자 할 때 사용하는 명령어

-- INNER JOIN : 두 테이블에서 조건이 일치하는 레코드만 반환
-- SELECT column, ... FROM 기준테이블명 INNER JOIN 조합할 테이블명 ON 조인조건
SELECT 
	E.employee_num '사원번호',
	E.name '사원이름',
    E.age '사원나이',
	D.department_code  '부서코드',
    D.name  '부서명',
    D.tel  '부서 전화번호'
	FROM employee E
	INNER JOIN department D
    ON E.department_code = D.department_code;
-- LEFT OUTER JOINE (LEFT JOIN) : 기준 테이블의 모든 레코드와 조합할 테이블 중 조건에 일치하는 레코드만 반환
-- 만약에 조합할 테이블의 조건에 일치하는 레코드가 존재하지 않으면 NULL로 표현

SELECT 
	E.employee_num '사원번호',
	E.name '사원이름',
    E.age '사원나이',
	D.department_code  '부서코드',
    D.name  '부서명',
    D.tel '부서 전화번호'
	FROM employee E
	LEFT JOIN department D
    ON E.department_code = D.department_code;
    
-- RIGHT OUTER JOIN (RIGHT JOIN) : 조합할 테이블의 모든 레코드와 기준 테이블 중 조건에 일치하는 레코드만 반환
-- 만약 기준 테이블의 조건에 일치하는 레코드가 존재하지 않으면 NULL로 반환
SELECT 
	E.employee_num '사원번호',
	E.name '사원이름',
    E.age '사원나이',
	D.department_code  '부서코드',
    D.name  '부서명',
    D.tel '부서 전화번호'
	FROM employee E
	RIGHT JOIN department D
    ON E.department_code = D.department_code;
    
-- FULL OUTER JOIN (FULL JOIN) : 두 테이블의 모든 레코드와 조합할 테이블의 모든 레코드를 반환
-- 만약 기준 테이블 혹은 조합할 테이블에 조건에 일치하는 레코드가 존재하지 않으면 NULL 반환
-- MySQL에서는 FULL OUTER JOIN을 문법상 제공하지 않음
-- FULL JOIN = LEFT JOIN + RIGHT JOIN
-- FULL JOIN은 LEFT JOIN과 RIGHT JOIN의 합집합이므로 UNION을 이용하여 표현가능하다
SELECT 
	E.employee_num '사원번호',
	E.name '사원이름',
    E.age '사원나이',
	D.department_code  '부서코드',
    D.name  '부서명',
    D.tel '부서 전화번호'
	FROM employee E
	LEFT JOIN department D
    ON E.department_code = D.department_code
    
UNION 

SELECT 
	E.employee_num '사원번호',
	E.name '사원이름',
    E.age '사원나이',
	D.department_code  '부서코드',
    D.name  '부서명',
    D.tel '부서 전화번호'
	FROM employee E
	RIGHT JOIN department D
    ON E.department_code = D.department_code;
    
-- CROSS JOIN : 기준 테이블의 각 레코드를 조합할 테이블의 모든 레코드에 조합하여 반환
-- CROSS JOIN 결과 레코드 수 = 기준 테이블 레코드 수 * 조합할 테이블 레코드 수
SELECT * FROM employee E CROSS JOIN department D;
-- MySQL에서 기본 조인이 CROSS JOIN 형태임
SELECT * FROM employee E JOIN department D;
SELECT * FROM employee E, department D;

-- 부서코드가 A인 사원에 대해 사번, 이름, 부서명을 조회하시오
SELECT E.employee_num '사번', E.name '이름', D.name '부서명'
	FROM employee E INNER JOIN department D
    ON E.department_code = D.department_code
    WHERE D.department_code = 'A';
    
-- 부서명이 '영업부'인 사원에 대해 사번, 이름, 나이를 조회하시오
SELECT E.employee_num '사번', E.name '이름', E.age '나이'
	FROM employee E INNER JOIN department D
    ON E.department_code = D.department_code
    WHERE D.name = '영업부';


-- 서브쿼리 : 쿼리 내부에 존재하는 또 다른 쿼리, 쿼리 결과를 조건이나 테이블로 사용할 수 있도록 함
-- WHERE 절 서브쿼리 : 조회 결과를 조건으로 사용하여 조건을 동적으로 지정할 수 있도록 함
-- WHERE 절에서 비교 연산등으로 사용할 때에는 조회하는 컬럼의 갯수 및 레로드의 갯수를 주의
SELECT employee_num '사번', name '이름', age '나이'
	FROM employee WHERE department_code =(SELECT department_code FROM department WHERE name = '영업부');
    
SELECT employee_num '사번', name '이름', age '나이'
	FROM employee WHERE department_code =(SELECT * FROM department WHERE name = '영업부');
    
    SELECT employee_num '사번', name '이름', age '나이'
	FROM employee WHERE department_code =(SELECT department_code FROM department WHERE name = '영업부');
		














