/* An analyst must start by addressing how complete is the information they're working with. This first query is meant to test if each country has provided enough 
information for the analyst to gain trustworthy insights, by determining if the Dataset actually represents each country's population. By running the query, the
Dataset has passed the test and has proved it contains representative information about most countries. */

SELECT 
   country.Name AS country,
   SUM(percentage) AS total_percentage
FROM country
INNER JOIN countrylanguage AS lang
	ON country.code = lang.CountryCode
GROUP BY country
ORDER BY total_percentage DESC;

/* The country table contains the estimated population size of each country. However, population density is oftentimes more useful to better understand how a population
is distributed or how the resources must be considered to better assess a population needs. The population density also is a powerful tool to make fair comparations.
High population density locations may be overlooked at smaller countries, where the surface area may not be enough for the population to rank among the highest general
populations. */

SELECT 
   name AS country,
   surfacearea AS Surface_Area, 
   Population, 
   ROUND(population / surfacearea * 100, 2) AS Pop_Density
FROM country
WHERE capital IN
   (SELECT id
    FROM city
    WHERE population > 1000000
    AND surfacearea IS NOT NULL)
ORDER BY Pop_Density DESC
LIMIT 10;

/* No matter how well versed an analyst may be on geography and foreign cities, it is always best to keep an eye open for naming coincidences between cities and 
countries, this will ensure that each registry is handled in the category where it belongs. */

SELECT name
FROM city
INTERSECT
SELECT name
FROM country;

/* Oftentimes, cities that share their name with their country tend to be major ones, even capitals. This next query will return other major cities, using their
demographic importance as filtering criteria */

SELECT name
FROM city
WHERE population > 5000000
EXCEPT
SELECT name
FROM country;

/* Using a prestablished value such as 5 million is not the best way to establish the demographic importance of a city, and will fail to ilustrate the size of these
populations, a comparison against whole countries will demonstrate the demographic importance of such cities and could help an analyst showcase how big the populations
are even without visualization tools */

SELECT district, population
FROM city
UNION
SELECT NAME, population
FROM country
ORDER BY population DESC;

/* Linguistic representation may be crucial in polyglot cultures, it is important to dedicate a query to understand how prevalent are non-official languages in such
countries. An analyst with such understanding may be able to better grasp some details on foreign cultures. */

SELECT 
   country.Name AS country,
   language AS languages,
   isofficial AS is_official,
   percentage
FROM country
INNER JOIN countrylanguage AS lang
	ON country.code = lang.countrycode
ORDER BY country ASC, is_official ASC;


/* Then, these next two queries will showcase the prevalence of official languages, when matched against non-official ones, for each country. 
E.g., 84.5% of Afghanistan's population speaks an official language, for example, while 11.6% speaks a non-official one.
The percentage of official languages speakers: */

SELECT 
   country.name AS country,
   SUM(percentage) AS official_percentage
FROM country
INNER JOIN countrylanguage AS lang
	ON country.code = lang.CountryCode
WHERE isofficial = 'T'
GROUP BY country

ORDER BY official_percentage DESC;

-- The percentage of non-offical languages speakers:

SELECT 
	country.name, 
	SUM(percentage) AS non_official_percentage
FROM country
INNER JOIN countrylanguage AS lang
	ON country.code = lang.countrycode
WHERE isofficial = 'F' 
GROUP BY country.name
ORDER BY non_official_percentage DESC;

/* It is also important for an analyst to understand how spread across countries a language is. This understanding will be most important for determinating if it's
convenient acording to the scope of the project to make translations available or if the current languages are enough to achieve targets and team efforts may be better
focused elsewhere */

SELECT 
	language AS Language,
	COUNT(language) AS Countries_Spoken
FROM country
INNER JOIN countrylanguage AS lang
	ON country.code = lang.countrycode
GROUP BY LANGUAGE
ORDER BY Countries_Spoken DESC;

/* However important each insight is, an analyst must also recognize it's limitations and recognize when no correlation can be fairly established, e.g. there is
no correlation between life expectancy and how many languages are spoken in each country. The reason behind this may be the historical and economical variety of 
contexts (which surely are more related to the life expectancy) behind the languages that propagated in each territory */

SELECT 
   country.Name AS country,
   lifeexpectancy AS life_expectancy,
   COUNT(language) AS languages_per_country
FROM country
INNER JOIN countrylanguage AS lang
	ON country.code = lang.countrycode
GROUP BY country
ORDER BY life_expectancy DESC;

/* This next query will show the 10 most populated capitals in the world by descending order. */

SELECT 
	city.name AS Capital,
	country.name AS Country,
	Continent,
	city.population AS Capitals_Pop
FROM country
INNER JOIN city
	ON country.capital = city.id
ORDER BY capitals_pop DESC
LIMIT 10;

-- India and Pakistan have a lot of shared history, this next querie shows if that reflects on any shared languages.

SELECT 
	country.Name AS country,
	language
FROM country
CROSS JOIN countrylanguage AS lang
	ON country.Code = lang.CountryCode
WHERE country.Name IN ('Pakistan', 'India')
ORDER BY language
