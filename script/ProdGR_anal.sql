/** 
    Product Growth Analysis
                                from JY, 2022
**/

USE practice;

/** 
    create Data Mart 
        for product growth analysis
    - 회원번호(mem_no), 최초 및 최근 구매일자, 구매 횟수(Frequency), 재구매 여부, 구매 간격, 구매 주기
**/
CREATE TABLE Product_Growth AS
	SELECT A.mem_no,
		   B.category,
           B.brand,
           A.sales_qty * B.price AS 구매금액,
           CASE WHEN date_format(order_date, '%Y-%m') BETWEEN '2020-01' AND '2020-03' THEN '2020_1분기'
				WHEN date_format(order_date, '%Y-%m') BETWEEN '2020-04' AND '2020-06' THEN '2020_2분기'
				END AS 분기
	FROM sales AS A
    LEFT JOIN product as B
    ON a.product_code = B.product_code
    WHERE date_format(order_date, '%Y-%m')
		BETWEEN '2020-01' AND '2020-06';

-- check Data Mart
SELECT * FROM Product_Growth;



/**
    Data Access
    - 카테고리별 구매금액 성장률(2020년 1분기 -> 2020년 2분기)
    - 뷰티 카테고리 중, 브랜드별 구매지표
**/

-- 카테고리별 구매금액 성장률(2020년 1분기 -> 2020년 2분기)
SELECT *,
	   2020_2분기_구매금액 / 2020_1분기_구매금액 - 1 AS 성장률
	FROM (
		SELECT category,
			   sum(CASE WHEN 분기 = '2020_1분기' THEN 구매금액 END) AS 2020_1분기_구매금액,
               sum(CASE WHEN 분기 = '2020_2분기' THEN 구매금액 END) AS 2020_2분기_구매금액
			FROM Product_Growth
            GROUP BY category
		  ) AS A
	ORDER BY 4 DESC;


-- 뷰티 카테고리 중, 브랜드별 구매지표

SELECT brand,
	   count(DISTINCT mem_no) AS 구매자수,
	   sum(구매금액) AS 구매금액_합계,
       sum(구매금액) / count(DISTINCT mem_no) AS 인당_구매금액
	FROM Product_Growth
    WHERE category = 'beauty'
    GROUP BY brand
    ORDER BY 4 DESC;


/**
	drop table
**/
DROP TABLE Product_Growth;


