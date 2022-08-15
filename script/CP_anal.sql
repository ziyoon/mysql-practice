/** 
    Customer Profiles Analysis
                                from JY, 2022
**/

USE practice;

/** 
    create Data Mart 
        for customer profiles analysis
    - JOIN TABLES (customer, salse)
    - customer columns + 가입년원, 나이, 연령대, 구매여부
**/
CREATE TABLE Customer_Profile AS 
SELECT A.*,
       DATE_FORMAT(JOIN_DATE, '%Y-%m') AS 가입년월,
       2022 - YEAR(birthday) + 1 AS 나이,
       CASE WHEN 2022 - YEAR(birthday) + 1 < 10 THEN '0대'
            WHEN 2022 - YEAR(birthday) + 1 < 20 THEN '10대'
            WHEN 2022 - YEAR(birthday) + 1 < 30 THEN '20대'
            WHEN 2022 - YEAR(birthday) + 1 < 40 THEN '30대'
            WHEN 2022 - YEAR(birthday) + 1 < 50 THEN '40대'
            ELSE '50대 이상' END AS 연령대
       ,
       CASE WHEN B.mem_no IS NOT NULL THEN '구매'
            ELSE '비구매' END AS 구매여부
FROM customer AS A 
LEFT JOIN (
           SELECT DISTINCT mem_no
           FROM sales
           )AS B 
ON A.mem_no = B.mem_no;

-- check Data Mart
SELECT * FROM Customer_Profile;



/**
    Data Access
    - 가입년월별 회원 수
    - 성별 평균 연령, 성별 및 연령대별 회원 수
    - 성별 및 연령대별 회원 수, 구매 여부
    - 지역별 회원 수
    - 지역별 및 성별 회원수, 구매여부
**/

-- 가입년월별 회원 수
SELECT 가입년월,
       COUNT(mem_no) AS 회원수
FROM Customer_Profile
GROUP BY 가입년월;

-- 성별 평균 연령, 성별 및 연령대별 회원수
SELECT gender AS 성별,
       AVG(나이) AS 평균나이
FROM Customer_Profile
GROUP BY gender;

SELECT gender AS 성별,
       연령대,
       COUNT(mem_no) AS 회원수
FROM Customer_Profile
GROUP BY gender,
         연령대
ORDER BY gender,
         연령대;

-- 성별 및 연령대별 회원수 + 구매여부
SELECT gender AS 성별,
       연령대,
       구매여부,
       COUNT(mem_no) AS 회원수
FROM Customer_Profile
GROUP BY gender,
         연령대,
         구매여부
ORDER BY 구매여부,
         gender,
         연령대;

-- 지역별 회원수
SELECT addr AS 지역,
       COUNT(addr) AS 회원수
FROM Customer_Profile
GROUP BY addr
ORDER BY 회원수 DESC;

-- 지역별 및 성별 회원수, 구매여부
SELECT addr AS 지역,
       gender AS 성별,
       구매여부,
       COUNT(mem_no) AS 회원수
FROM Customer_Profile
GROUP BY addr,
         gender,
         구매여부
ORDER BY 구매여부,
         addr,
         gender;

/**
	drop table
**/
DROP TABLE Customer_Profile;
