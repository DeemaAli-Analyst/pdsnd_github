/*QUERY 1 Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. 
Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.*/

SELECT DATE_PART('month', re.rental_date) AS Rental_month , DATE_PART('year',re.rental_date) AS Rental_year , I.store_id , COUNT(*) AS Count_rentals 
FROM rental re
JOIN Inventory I 
ON I.inventory_id = re.inventory_id
GROUP BY 1 , 2 ,3
ORDER BY 4 DESC ;

/*QUERY2 Can you write a query to capture the customer name,
month and year of payment, 
and total payment amount for each month by these top 10 paying customers?*/

SELECT DATE_TRUNC('month',p.payment_date) AS pay_month,
       c.first_name||' '||c.last_name AS full_name,
       COUNT(*) AS pay_countpermonth,
       SUM(p.amount) AS pay_amount
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
WHERE p.payment_date BETWEEN '2007-01-01' AND '2007-12-31'
GROUP BY 1,2
ORDER BY 4 DESC
LIMIT 10;

/*QUERY3 We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, 
Comedy, Family and Music.Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.*/


SELECT
c.name category_name ,
  f.title film_title,
  SUM(r.rental_id) AS Rental_count
FROM film f 
JOIN film_category fc
  ON f.film_id = fc.film_id
JOIN category c
  ON c.category_id = fc.category_id
JOIN rental r 
  ON r.rental_id = f.film_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

/* QUERY4 Finally, provide a table with the family-friendly film category, each of the quartiles, 
and the corresponding count of movies within each combination of film category for each corresponding rental duration category.*/


SELECT category_name,standard_quartiles,
  COUNT(category_name) AS  Counts 
FROM (SELECT ca.name category_name,
  NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartiles
FROM film f
JOIN film_category fc
  ON f.film_id = fc.film_id
JOIN category ca
  ON ca.category_id = fc.category_id
WHERE ca.name IN ( 'Music', 'Children', 'Classics', 'Comedy', 'Family','Animation' )) Table1
GROUP BY 1, 2
ORDER BY 1, 2;