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



