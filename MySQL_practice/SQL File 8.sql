# function 1
# CEIL, ROUND, TRUNCATE
select CEIL(12.345);
select ROUND(12.645, 2);
select TRUNCATE(12.645, 2);

use world;
select name, round(gnp/population, 4) as gpp
from country;

# DATE_FORMAT: 날짜데이터에 대한 포맷을 설정
USE sakila;
select DATE_FORMAT(payment_date, "%Y-%m") as monthly, sum(amount) as total_amount
from payment
group by monthly;

select DATE_FORMAT(payment_date, "%H") as monthly, sum(amount) as total_amount
from payment
group by monthly;

# function 2: IF, IFNULL, CASE
# IF: world 도시 인구가 100만 넘으면 "big city", 아니면 "small city"로 결과 출력
# IF(조건, True, False)
USE world;
select name, population, IF(population >= 1000000, "big city", "small city") as city_scale
from city;

# IFNULL: NULL 데이터를 판단해서 결과 출력
# IFNULL(True, False)
select name, GNPOld, IFNULL(GNPOld, 0)
from country;

# CASE: 여러 개의 조건을 사용하는 방법
# 나라별로 인구가 10억 이상, 1억 이상, 1억 이하 출력하는 컬럼
SELECT name, population,
	CASE
		WHEN population >= 1000000000 THEN "upper 1 billion"
        WHEN population >= 100000000 THEN "upper 100 million"
        ELSE "below 100 million"
	END AS result
FROM country;

# JOIN: 여러 개의 테이블 데이터를 모아서 보여줄 때 사용
# MySQL에서 사용되는 JOIN의 종류: INNER, OUTER, LEFT, RIGHT
use test;
CREATE TABLE user (
	user_id int(11) unsigned NOT NULL AUTO_INCREMENT,
	name varchar(30) DEFAULT NULL,
	PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE addr (
  	id int(11) unsigned NOT NULL AUTO_INCREMENT,
  	addr varchar(30) DEFAULT NULL,
	user_id int(11) DEFAULT NULL,
  	PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO user(name)
VALUES ("jin"),
              ("po"),
              ("alice"),
              ("petter");
INSERT INTO addr(addr, user_id)
VALUES ("seoul", 1),
              ("pusan", 2),
              ("deajeon", 3),
              ("deagu", 5),
              ("seoul", 6); 
              
# INNER JOIN: table 간 공통된 값이 없는 data는 출력하지 x
SELECT *
FROM user
JOIN addr
ON user.user_id = addr.user_id;

SELECT user.user_id, user.name, addr.addr
FROM user, addr
ON user.user_id = addr.user_id;

# LEFT JOIN
SELECT user.user_id, user.name, addr.addr
FROM user
LEFT JOIN addr
ON user.user_id = addr.user_id;

# RIGHT JOIN
SELECT user.user_id, user.name, addr.addr
FROM user
RIGHT JOIN addr
ON user.user_id = addr.user_id;

# world: 도시인구가 100만 넘는 도시 이름, 국가 이름, 도시 인구, 국가 인구 출력
USE world;
SELECT city.name, country.name, city.population, country.population, city.population/country.population as avg
from city
join country
on city.countrycode = country.countrycode
where population >= 8000000

select *
from country

# OUTER JOIN
# UNION: 데이터를 합치고 중복 데이터를 제거
use test;
SELECT name
FROM user
UNION
SELECT addr
FROM addr;

SELECT name
FROM user
UNION ALL
SELECT addr
FROM addr;

# OUTER JOIN
SELECT id, user.name, addr.addr
FROM user
LEFT JOIN addr
ON user.user_id = addr.user_id
UNION
SELECT id, user.name, addr.addr
FROM user
RIGHT JOIN addr
ON user.user_id = addr.user_id;

# Sub Query: 쿼리 안에 쿼리
# SELECT, FROM, WHERE 절에서 사용
# 전체 도시수 컬럼, 전체 나라수 컬럼, 전체 언어수 컬럼
use world;
SELECT
(select count(name) from city) as city,
(select count(name) from country) as country,
(select count(distinct(language)) from countrylanguage) as countrylanguage
FROM DUAL

# 도시 인구가 800만 이상인 도시의 도시 이름, 도시 인구, 국가 이름 출력
select *
from (
	select countrycode, name, population
	from city
	where population >= 8000000
) as sub1
JOIN (
	select code, name
	from country
) as sub2
on sub1.countrycode = sub2.code

# WHERE 절 sub query
# 800만 이상 도시의 국가 코드, 국가 이름, GNP 출력
use world;
select code, name, gnp
from country 
where countrycode in (
	select countrycode
	from city
	where population >= 8000000
);


