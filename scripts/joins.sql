
-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

select film_title, release_year, worldwide_gross
from specs 
inner join revenue 
	using(movie_id)
order by worldwide_gross

Ans: 430 record

-- 2. What year has the highest average imdb rating?
Select release_year, avg(imdb_rating) as Avg_rating
from rating
left join specs
using(movie_id)
	group by release_year
order by Avg_rating desc;

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

select max(worldwide_gross) from revenue where movie_id in (select movie_id from specs where mpaa_rating like ('G'))
	
select company_name from distributors where distributor_id in
(select domestic_distributor_id from specs where movie_Id in (select movie_id from revenue where worldwide_gross in (select max(worldwide_gross) from revenue
	where movie_id in (select movie_id from specs where mpaa_rating like 'G') )))
	
	
	Alternately
	
select s.domestic_distributor_id, company_name, s.film_title, s.mpaa_rating, r.worldwide_gross
from specs as s
inner join revenue as r
on s.movie_id = r.movie_id
inner join distributors as d
on d.distributor_id = s.domestic_distributor_id
where s.mpaa_rating ilike 'G'
order by r.worldwide_gross desc
limit 1;

---Ans:
86124	"Walt Disney "	"Toy Story 4"	"G"	1073394593

	
-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
select  d.company_name, count(s.film_title) as Number_of_movies
from distributors as d
left join specs as s
on d.distributor_id = s.domestic_distributor_id
group by d.company_name;


-- 5. Write a query that returns the five distributors with the highest average movie budget.
select domestic_distributor_id, avg(film_budget) as avg_budget
from specs
inner join revenue
using(movie_id)
group by domestic_distributor_id
order by avg_budget desc
limit 5;

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT count(*) from distributors as d
left join specs as s 
on d.distributor_id = s.domestic_distributor_id
where d.headquarters not in ('California')

Ans: 421

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
select  avg(select case when length_in_min > 120 then r.imdb_rating) else end as Over_2hr, 
	avg(select case when length_in_min <= 120 then r.imdb_rating) else end as under_2hr
from specs as s
join rating as r
on s.movie_id=r.movie_id;
