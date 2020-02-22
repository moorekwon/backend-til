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