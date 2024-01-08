SELECT * FROM netflix_originals.genre_details;
use netflix_originals;
select * from genre_details;
select * from netflix_originals;

Select * from netflix_originals N, genre_details G 
WHERE N.GenreID = G.GenreID;

#counting the no of rows
select COUNT(*) AS NOOFROWS
FROM netflix_originals;

#counting the no of rows
select count(*) AS NOOFROWS
FROM genre_details;

#setting the date in a format that sql understands
alter table netflix_originals
add column new_date date;

select Premiere_Date, str_to_date(left(premiere_date,10), "%d-%m-%Y")
from netflix_originals;

set sql_safe_updates=0;
Update netflix_originals
set new_date=str_to_date(left(premiere_date,10), "%d-%m-%Y");

#Count of distinct language
select distinct Language
from netflix_originals;

#languages in which the films were released
select language, count(language)
from netflix_originals
group by language;

#comparison of most popular language used
select language, count(language) as Preferred_langugage, round(AVG(Runtime),2) as Avgtime, round(avg(IMDBScore),2) as Avgscore
from netflix_originals
group by language
having count(language)>=1
order by AVG(IMDBScore) DESC, AVG(RUNTIME) DESC;

#imdb score range
select max(IMDBScore) as MaxScore, min(IMDBScore) as MinScore, round(Avg(IMDBScore),2) as Avgscore
from netflix_originals;


SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
#Comparison of popular genres
select N.GenreID, G.Genre, count(genre) as popular_genre
from netflix_originals N INNER join genre_details G
ON N.genreID = G.genreID
group by Genre
Having Count(Genre)>=1
order by popular_genre desc;

select G.Genre, N.IMDBScore
FROM netflix_originals N, Genre_Details G
WHERE N.GenreID = G.GenreID
Group by Genre
order by IMDBScore DESC;

select Title, GenreID, IMDBScore, dense_rank()
over (order by IMDBScore DESC) AS DRnk
from netflix_originals;

#best rated movie for the period 2015-21
select * 
from (select Title, GenreID, IMDBScore,
dense_Rank() over (order by IMDBScore DESC) as DRnk
from netflix_originals) as derivedtable
where DRnk=1;

#comparison of films release year
select year(new_date), count(year(new_date)) as Noofmovies
from netflix_originals
group by Year(new_date)
having count(year(new_date))>=1
order by year(new_date) desc;

#