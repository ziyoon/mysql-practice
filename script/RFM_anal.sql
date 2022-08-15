/** 
    RFM Analysis (2020)
                                from JY, 2022
**/

USE practice;

/** 
    create Data Mart 
        for RFM analysis
    - JOIN TABLES (customer, sales, product)
    - customer columns + 구매 금액(Monetary), 구매 횟수(Frequency) (주문일자=2020년; Recency)
**/
CREATE TABLE RFM AS 
SELECT A.*,
       B.구매금액,
       B.구매횟수
FROM customer AS A 
LEFT JOIN (
        SELECT A.mem_no,
                SUM(A.sales_qty * B.price) AS 구매금액,
                COUNT(A.order_no) AS 구매횟수
        FROM sales AS A 
        LEFT JOIN product AS B 
        ON A.product_code = B.product_code
        WHERE YEAR(A.order_date) = '2020'
        GROUP BY A.mem_no
        )AS B 
ON A.mem_no = B.mem_no;

-- 확인
SELECT * FROM RFM;


/**
    Data Access
    - 각 회원 RFM 세분화
    - RFM 세분화별 회원수
    - RFM 세분화별 매출액
    - RFM 세분화별 인당 구매금액
**/

-- 각 회원 RFM 세분화
SELECT *,
       CASE WHEN 구매금액 > 5000000 THEN 'VIP'
            WHEN 구매금액 > 1000000 OR 구매횟수 > 3 THEN '우수회원'
            WHEN 구매금액 > 0 THEN '일반회원'
            ELSE '잠재회원' END AS 회원세분화
FROM RFM;

-- RFM 세분화별 회원수
SELECT 회원세분화,
       COUNT(mem_no) AS 회원수
FROM (
      SELECT *,
             CASE WHEN 구매금액 > 5000000 THEN 'VIP'
                  WHEN 구매금액 > 1000000 OR 구매횟수 > 3 THEN '우수회원'
                  WHEN 구매금액 > 0 THEN '일반회원'
                  ELSE '잠재회원' END AS 회원세분화
      FROM RFM
     )AS A
GROUP BY 회원세분화
ORDER BY 회원수 ASC;

-- RFM 세분화별 매출액
SELECT 회원세분화,
       SUM(구매금액) AS 구매금액
FROM (
      SELECT *,
             CASE WHEN 구매금액 > 5000000 THEN 'VIP'
                  WHEN 구매금액 > 1000000 OR 구매횟수 > 3 THEN '우수회원'
                  WHEN 구매금액 > 0 THEN '일반회원'
                  ELSE '잠재회원' END AS 회원세분화
      FROM RFM
     )AS A
GROUP BY 회원세분화
ORDER BY 구매금액 DESC;

-- RFM 세분화별 인당 구매금액
SELECT 회원세분화,
       SUM(구매금액) / COUNT(mem_no) AS 인당_구매금액
FROM (
      SELECT *,
             CASE WHEN 구매금액 > 5000000 THEN 'VIP'
                  WHEN 구매금액 > 1000000 OR 구매횟수 > 3 THEN '우수회원'
                  WHEN 구매금액 > 0 THEN '일반회원'
                  ELSE '잠재회원' END AS 회원세분화
      FROM RFM
     )AS A
GROUP BY 회원세분화
ORDER BY 인당_구매금액 DESC; 
-- ? 강의에서는 ORDER BY 구매금액 DESC; ...


/**
	drop table
**/
DROP TABLE RFM;
