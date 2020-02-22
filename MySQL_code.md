```mysql
# where
select *
from country

where population between 70000000 and 100000000

where continent = "Asia"
or continent = "africa"

where continent not in ("Asia", "Africa")

where Region like "%Europe"
where Region like "Europe%"


# order by
select CountryCode, name, population
from city

-- where population between 70000000 and 100000000
order by CountryCode ASC, name Desc


# limit
# 인구가 가장 많은 국가 5개 출력
select code, name, population
from country

order by population desc
-- limit 5

# 5개를 skip하고 그 밑에 3개를 출력
limit 5, 3


# 함수 사용법: 90% 이상 사용되는 언어 출력
# percentage가 없을때만 language 중복제거 적용
select distinct(language), percentage
from countrylanguage

where percentage < 90
order by language

# 99% 이상 사용되는 언어의 갯수 출력
# 앨리어스 as
select count(distinct(language)) as count
from countrylanguage

where percentage >= 99
order by language


# select
select 10 as number, 10/5 as div_number
from dual

# 국가 데이터에서 인구당 GNP 순위를 내림차순으로 출력
select code, name, population, GNP, (GNP/population)*100 as gpp
from country

order by gpp desc


# group by: count, max, min, avg, var_samp(분산), stddev(표준편차)
# city 테이블에서 국가별 도시의 갯수 출력
select countrycode, count(countrycode)
from city

# 중복 데이터 합치면서 다른 데이터까지 처리
group by countrycode

# 대륙별 평균 인구수와 GNP 최소값 조회
select continent, avg(population) as avg_population, min(GNP) as min_gnp
from country

# 조건 1
where GNP > 0

# 실행되지 않음 (select 문이 마지막에 실행되기 때문에 min_gnp를 읽지 못함)
-- where GNP > 0 and min_gnp > 100

group by continent

# 조건 2
having min_gnp > 100

order by min_gnp desc
limit 1


# 고객과 스태프별 매출과 고객별 매출 총합
use sakila;
select customer_id, staff_id, sum(amount)
from payment

group by customer_id, staff_id

# customer_id별 staff_id 합 출력
with rollup
```

```mysql
# 191209 quiz
# 1. country 테이블에서 중복을 제거한 Continent 조회
use world;
select distinct(continent) as continent_count
from country

# 2. Sakila DB에서 국가가 인도인 고객의 수 출력
use sakila;
select country, count(country) as count
from customer_list

where country = "India"

# 3. 한국 도시 중 인구가 100만이 넘는 도시를 조회해 인구순으로 내림차순
select name, population
from city

where countrycode = "KOR" and population > 1000000

# 4. city 테이블에서 population이 800~1000만 사이인 도시 데이터를 인구순으로 내림차순
select name, countrycode, population
from city

where population between 8000000 and 10000000
order by population desc
```

```mysql
# DDL: CREATE, USE, DROP, ALTER, SHOW
# DB 생성
CREATE DATABASE test;
SHOW databases;
USE test;
SELECT database();

# table 생성 1: 제약조건이 없는 table 생성
CREATE TABLE user1(
	user_id INT
    , name VARCHAR(20)
    , email VARCHAR(30)
    , age INT
    , rdate DATE
);
DESC user1;

# table 생성 2: 제약조건이 있는 table 생성
CREATE TABLE user2(
	user_id INT PRIMARY KEY AUTO_INCREMENT
    , name VARCHAR(20) NOT NULL
    , email VARCHAR(30) UNIQUE NOT NULL
    , age INT DEFAULT '30'
    , rdate TIMESTAMP
);

# ALTER: 수정
# DB 인코딩 수정
use world;
SHOW VARIABLES LIKE "character_set_database"
ALTER DATABASE world CHARACTER SET = ascii

# table 변경
# ADD: 컬럼 추가
USE test;
DESC user2;
ALTER TABLE user2 ADD tmp TEXT;

# MODIFY: 컬럼 수정
ALTER TABLE user2 MODIFY COLUMN tmp INT;

# DROP: 컬럼 삭제
ALTER TABLE user2 DROP tmp;

# DROP: 삭제
# DB 삭제
SHOW databases;
DROP DATABASE wps;

# table 삭제
USE test;
DROP TABLE wps;

# quiz 2-2
# 국가 코드별 도시의 갯수 출력
use world;
select CountryCode, count(CountryCode) as count
from city
group by CountryCode
order by count desc
limit 5;

# quiz 2-3
# 대륙별 몇개의 나라가 있는지 대륙별 나라의 갯수 내림차순 출력
use world;
select Continent, count(continent) as count
from country
group by continent
order by count desc;

# 컬럼 추가
use world;
select Continent, count(continent) as count, sum(gnp) as total_gnp, avg(gnp) as total_gnp, sum(population) as total_popu, sum(gnp) / sum(population) as gpp
from country
group by continent
order by count desc;

# INSERT: 데이터 추가
USE test;
DESC user1;
select now();
INSERT INTO user1 (user_id, name, email, age, rdate)
VALUES (1, "jin", "jin@gmail.com", 30, now())
, (3, "peter", "peter@daum.net", 40, now());
select *
from user1;

# 제약조건 설정
DESC user2;
INSERT INTO user1(name, email)
VALUES ("andy", "andy@naver.com");
select *
from user2;

# SELECT 문으로 출력된 결과 INSERT
USE world;

# 인구가 8천만 이상인 국가 출력(컬럼: 국가 코드, 국가 이름, 인구)
select code, name, population
from country
where population >= 80000000;

# table 생성
create table country2 (
	code CHAR(3)
    , name VARCHAR(50)
    , population INT
);
desc country2;

INSERT INTO country2
select code, name, population
from country
where population >= 80000000;

select *
from country2;

# UPDATE SET
USE test;
select *
from user1;
UPDATE user1
SET name="john"
where age > 32
limit 50;

select *
from user1
where age > 32
limit 50;

# DELETE DROP TRUNCATE

# DELETE(DML): 데이터 삭제
use world;
select *
from city;

use test;
select *
from user1;


DELETE FROM user1
where age > 32;

select *
from user1;

# TRUNCATE(DLL): 데이터(테이블) 삭제
TRUNCATE user1;

# DROP(DLL): 테이블 모두 삭제
DROP TABLE user1;
```

```mysql
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
select code, name, gnp
from country 
where countrycode in (
	select countrycode
	from city
	where population >= 8000000
)
```

```mysql
# view
# 가상 테이블 - 실제 데이터는 저장되지 않음
# 복잡한 쿼리문을 간단하게 만들어주는 효과
# 수정이 불가능하며 인덱스 설정이 불가

CREATE VIEW code_name AS

select code, name
from country
join code_name

select *
from city
join code_name

# Index
# 테이블에서 데이터 검색으로 빠르게 해줄수 있는 기능
# 장점: 검색속도가 빨라짐
# 단점: 저장공간을 추가로 차지, CUD 할 때 속도가 느려짐

use employees
```

```mysql
# 쿼리가 인덱스를 사용하는지 확인하려면 실행 계획을 확인
explain
select *
from salaries
where to_date < "1986-01-01";

# 인덱스 생성
create index fdate
on salaries (from_date);

# 인덱스 삭제
drop index fdate
on salaries;

explain
select *
from salaries
where from_date < "1986-01-01" and to_date < "1986-01-01";

# 두 개의 컬럼을 갖는 인덱스 생성
create index ftdate
on salaries (from_date, to_date);

drop index ftdate
on salaries;
```

```mysql
# quiz 3
use world;

select
	"population" as "category",
    sum(sub.KOR) as KOR,
    sum(sub.USA) as USA
from(select 
	if(code="KOR", population, 0) as KOR,
    if(code="USA", population, 0) as USA,
    1 as flag
from country
) as sub
group by flag;

select code, population
from country;

# quiz 6
select sub.countrycode, sub.name as city_name, sub.population, country.name, sub.language_count, sub.languages
from (
	select city.countrycode, city.name, city.population, cl.language_count, cl.languages
	from(
		select countrycode, GROUP_CONCAT(language) as languages, count(language) as language_count
		from countrylanguage
		group by countrycode
		having language_count <= 3
	) as cl
	JOIN (
		select countrycode, name, population
		from city
		where population > 3000000
	) as city
	ON cl.countrycode = city.countrycode
) as sub
JOIN country
on country.code = sub.countrycode
order by population desc;

select countrycode, GROUP_CONCAT(Language) as languages, count(language) as launguage_count
from countrylanguage
group by countrycode
having launguage_count <= 3;

select *
from countrylanguage
where countrycode = "KOR";

select countrycode, name, population
from city
where population > 3000000
```

