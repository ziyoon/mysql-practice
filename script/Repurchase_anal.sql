/** 
    Repurchase Analysis
                                from JY, 2022
**/

USE practice;

/** 
    create Data Mart 
        for repurchase analysis
    - use sub-query (sales)
    - 회원번호(mem_no), 최초 및 최근 구매일자, 구매 횟수(Frequency), 재구매 여부, 구매 간격, 구매 주기
**/
CREATE TABLE Repur_Cycle AS
SELECT *,
       CASE WHEN date_add(최초구매일자, INTERVAL + 1 DAY) <= 최근구매일자 THEN 'Y'
            ELSE 'N' END AS 재구매여부 ,
       DATEDIFF(최근구매일자, 최초구매일자) AS 구매간격,
       CASE WHEN 구매횟수 - 1 = 0 OR DATEDIFF(최근구매일자, 최초구매일자) = 0 THEN 0
            ELSE DATEDIFF(최근구매일자, 최초구매일자) / (구매횟수 - 1) END AS 구매주기
FROM (
    SELECT mem_no,
           MIN(order_date) AS 최초구매일자,
           MAX(order_date) AS 최근구매일자,
           COUNT(order_no) AS 구매횟수
    FROM sales
    WHERE mem_no <> '9999999' /** 비회원 제외 : not null 로 하면 안되나? **/
    GROUP BY mem_no
)AS A;

-- check Data Mart
SELECT * FROM Repur_Cycle;




/**
    Data Access
    - 재구매 회원수 비중(%)
    - 평균 구매주기 및 구매주기 구간별 회원수
**/

-- 재구매 회원수 비중(%)
SELECT count(DISTINCT mem_no) AS 구매회원수,
	   count(DISTINCT CASE WHEN 재구매여부 = 'Y' THEN mem_no END) AS 재구매회원수
	FROM Repur_Cycle;

-- 평균 구매주기 및 구매주기 구간별 회원수
SELECT AVG(구매주기)
	FROM Repur_Cycle
    WHERE 구매주기 > 0;

SELECT *,
	   CASE WHEN 구매주기 <= 7 THEN '7일 이내'
			WHEN 구매주기 <= 14 THEN '14일 이내'
            WHEN 구매주기 <= 21 THEN '21일 이내'
            WHEN 구매주기 <= 28 THEN '28일 이내'
            ELSE '29일 이후' END AS 구매주기_구간
	FROM Repur_Cycle
	WHERE 구매주기 > 0;

SELECT 구매주기_구간,
	   count(mem_no) AS 회원수
	FROM (
		SELECT *,
			   CASE WHEN 구매주기 <= 7 THEN '7일 이내'
			   WHEN 구매주기 <= 14 THEN '14일 이내'
               WHEN 구매주기 <= 21 THEN '21일 이내'
               WHEN 구매주기 <= 28 THEN '28일 이내'
               ELSE '29일 이후' END AS 구매주기_구간
		FROM Repur_Cycle
		WHERE 구매주기 > 0
		)AS A
	GROUP BY 구매주기_구간;



/**
	drop table
**/
DROP TABLE Repur_Cycle;


