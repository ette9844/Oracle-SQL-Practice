--변환 함수
SELECT TO_NUMBER(TO_CHAR(123456))
FROM DUAL;

--에러: 소숫점은 쓸 수 X
SELECT TO_CHAR(123456789,'999999.999') + 1 AS RESULT
FROM DUAL;

SELECT TO_CHAR(123456789) + 1 AS RESULT
FROM DUAL;

SELECT TO_CHAR(123456789,'$999999999') 
FROM DUAL;

SELECT TO_CHAR(123456789,'999,999,999') 
FROM DUAL;

--L = WON 마크가 되어서 출력 됨
SELECT TO_CHAR(123456789,'L999,999,999') 
FROM DUAL;

SELECT TO_DATE('05292019','MM-DD-YYYY')
FROM DUAL;

SELECT TO_DATE('20190529','YYYY-MM-DD')
FROM DUAL;

SELECT TO_CHAR(SYSDATE)
FROM DUAL;

--NULL 관련 함수
SELECT ENAME, MGR
FROM EMP
WHERE MGR IS NOT NULL;

SELECT ENAME, NVL(MGR, 1111) + 1
FROM EMP;

SELECT ENAME, NVL(COMM, 100)
FROM EMP ;

--모든 사원들에게 커미션을 200씩 추가하여 출력하시오.
SELECT ENAME, NVL(COMM,0) + 200
FROM EMP;

--JOB이 MANAGER가 아닌 사원의 모든 정보를 출력하시오. 
--!=, <>, ^= 모두 되지만 !=를 많이 씀
SELECT * 
FROM EMP
WHERE JOB <> 'MANAGER';

--급여가 800이상인 사원의 이름, 급여, 부서번호
SELECT ENAME, SAL, DEPTNO
FROM EMP
WHERE SAL >= 800;

--직책이 SALESMAN, ANALYST인 사람의 모든 정보를 출력하시오
SELECT *
FROM EMP
WHERE JOB LIKE 'SALESMAN'
OR JOB = 'ANALYST';

--ORACLE에서는 이렇게 풀수도 있다 (IN, SOME, ANY)
SELECT *
FROM EMP
WHERE JOB IN ('SALESMAN', 'ANALYST');
/*
= WHERE JOB ANY ('SALESMAN', 'ANALYST');  둘 중 아무거나
= WHERE JOB SOME ('SALESMAN', 'ANALYST'); 둘 중 하나라도
*/

--부서번호가 30번인 사원들 중 사원번호, 이름, 입사일을 출력하는데 사원번호를 오름출력으로 정렬
SELECT EMPNO, ENAME, HIREDATE
FROM EMP
WHERE DEPTNO = 30
ORDER BY EMPNO;

--사원들 중에 1981년에 입사한 사원의 이름과 사원번호를 사원번호 내림차순으로 정렬하시오.
SELECT ENAME, EMPNO, HIREDATE
FROM EMP
WHERE TO_CHAR(HIREDATE, 'YYYY') = '1981'
ORDER BY EMPNO DESC;

--DECODE문(IF-ELSE문과 같음)
SELECT EMPNO, ENAME, SAL, 
    DECODE(JOB, 
    'SALESMAN', SAL*1.1,
    'CLERK', SAL*1.3,
    'MANAGER', SAL*1.5, SAL) AS IN_SAL
FROM EMP;

--사장님만 급여를 두배로
SELECT EMPNO, ENAME, SAL, 
    DECODE(MGR, NULL, SAL*2, SAL) AS IN_SAL
FROM EMP;

/*학생들 중에 기계과 학생들은 등록금 10000원,
--전기전자 학생들은 8000원, 컴퓨터 정보 학생들은 6000원이라고 할때
--학번 이름, 전공, 등록금을 출력하시오. 단 2013년 학번만*/
SELECT STU_NO AS 학번, STU_NAME AS 이름, STU_DEPT AS 전공,
    DECODE(STU_DEPT, 
        '기계', 10000,
        '전기전자', 8000,
        '컴퓨터정보', 6000, 0) AS 등록금
FROM STUDENT
WHERE SUBSTR(STU_NO, 1, 4) = '2013';

--LIKE를 사용한 풀이법
--WHERE STU_NO LIKE '2013%'

--CASE 문
SELECT STU_NO AS 학번, STU_NAME AS 이름, STU_DEPT AS 전공,
    CASE STU_DEPT 
        WHEN '기계' THEN 10000
        WHEN '전기전자'THEN 8000
        WHEN '컴퓨터정보' THEN 6000
        ELSE 0
        END AS 등록금
FROM STUDENT
WHERE STU_NO LIKE '2013%';

--집계 함수
SELECT COUNT(*)
FROM STUDENT;

SELECT COUNT(STU_HEIGHT)
FROM STUDENT;

--표준편차
SELECT STDDEV(STU_HEIGHT)
FROM STUDENT;

--분산
SELECT VARIANCE(STU_HEIGHT)
FROM STUDENT;

--기계과 학생들의 가장 큰 신장, 가장 작은 신장, 평균 신장을 출력
SELECT MAX(STU_HEIGHT) AS MAX, 
    MIN(STU_HEIGHT) AS MIN, 
    ROUND(AVG(STU_HEIGHT), 2) AS AVG
FROM STUDENT
WHERE STU_DEPT = '기계';

--TO_CHAR(AVG(STU_HEIGHT), '999.99')

--1981년 입사자들의 평균 임금을 출력
SELECT AVG(SAL) AS AVG
FROM EMP
WHERE TO_CHAR(HIREDATE, 'YYYY') = 1981;

--사원번호, 사원이름, 총 급여(SAL+COMM)를 출력
SELECT EMPNO, ENAME, NVL(COMM, 0) + SAL AS TOTAL_SAL
FROM EMP;

--사원번호, 사원이름, 직책(사장, 사원)을 출력
SELECT EMPNO, ENAME, CASE JOB
    WHEN 'PRESIDENT' THEN '사장'
    ELSE '사원'
    END AS 직책
FROM EMP;

--DISTINCT (중복제외)
SELECT DISTINCT STU_DEPT
FROM STUDENT;

--GROUP BY 
SELECT STU_DEPT, STU_HEIGHT      --오류남 DEPT는 3개 HEIGHT는 10개
FROM STUDENT
GROUP BY STU_DEPT;

--↑ 그룹함수는 사용가능
SELECT STU_CLASS, MAX(STU_HEIGHT)
FROM STUDENT
GROUP BY STU_CLASS
ORDER BY STU_CLASS;

--SALESMAN의 커미션 평균을 출력
SELECT JOB, AVG(NVL(COMM, 0)) AS 커미션_평균
FROM EMP
WHERE JOB = 'SALESMAN'
GROUP BY JOB;

--부서명, 부서별 사원들의 인원수를 출력
SELECT DNAME, COUNT(*)
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
GROUP BY DNAME;

--직책명, 직책별 사원들의 인원수 출력(단, 사원수 4이상)
--각각의 경우에 조건 -> WHERE, 그룹으로 묶인 값에 대한 조건 -> HAVING
SELECT JOB, COUNT(*)
FROM EMP
GROUP BY JOB
HAVING COUNT(*) >= 4;

--JOB중에 가장 적게 수입(COMM+SAL)을 가지는 직무의 평균 월급을 출력하시오 
--(잘못 낸 문제 서브쿼리를 써야 해결 가능)
SELECT JOB, AVG(SAL)
FROM EMP
GROUP BY JOB
HAVING SUM(NVL(COMM,0)+SAL) = MIN(SUM(NVL(COMM,0)+SAL)); 
--함수가 너무 깊어서 FAIL

--사원수가 5명이상인 부서의 부서번호와 사원수를 출력하시오
SELECT DEPTNO, COUNT(EMPNO) AS 사원수   --COUNT(*)는 EMPNO = NULL인것까지 COUNT
FROM EMP
GROUP BY DEPTNO
HAVING COUNT(EMPNO) >= 5;

