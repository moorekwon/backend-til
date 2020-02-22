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

