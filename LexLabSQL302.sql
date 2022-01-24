USE sakila;

-- Q1 How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.title, COUNT(f.title)
FROM sakila.film f
JOIN sakila.inventory i
ON f.film_id = i.film_id
GROUP BY f.title
HAVING f.title = 'Hunchback Impossible';

-- Q2 List all films whose length is longer than the average of all the films.

SELECT * FROM sakila.film
WHERE length > (
  SELECT avg(length)
  FROM sakila.film
);

-- Q3 Use subqueries to display all actors who appear in the film Alone Trip.

SELECT a.first_name, a.last_name
FROM sakila.actor a
WHERE actor_id IN(
		SELECT a.actor_id 
        FROM sakila.film_actor a
		JOIN sakila.film f 
        USING (film_id)
		WHERE f.title='Alone Trip');

-- Q4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title
FROM sakila.film f
WHERE film_id IN(
		SELECT fc.film_id 
        FROM sakila.film_category fc
		JOIN sakila.category c 
        USING (category_id)
		WHERE c.name='Family');

SELECT * FROM category;

-- Q5 Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- Using subqueries
SELECT last_name, email
FROM sakila.customer
WHERE address_id IN(
	SELECT address_id
	FROM address
	WHERE city_id IN(
		(SELECT city_id
		FROM sakila.city
		WHERE country_id IN (
			SELECT country_id
			FROM sakila.country
			WHERE country = 'Canada'))));

-- Using joins
SELECT cu.last_name, cu.email
FROM sakila.customer cu
JOIN sakila.address a
USING (address_id)
JOIN sakila.city ci
USING (city_id)
JOIN sakila.country
USING (country_id)
WHERE country='Canada';

-- Q6 Which are films starred by the most prolific actor? 
SELECT f.title 
FROM sakila.film f
WHERE f.film_id IN(
SELECT fa.film_id
FROM sakila.film_actor fa
WHERE fa.actor_id =(
	SELECT actor_id FROM(
		SELECT actor_id, COUNT(actor_id) AS count_movies
		FROM sakila.film_actor
		GROUP BY actor_id
		ORDER BY count_movies DESC
		LIMIT 1)sub1));

-- Q7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments	

SELECT f.title 
FROM sakila.film f
WHERE f.film_id IN(
	SELECT i.film_id 
	FROM sakila.inventory i
	WHERE inventory_id IN(
		SELECT r.rental_id
		FROM sakila.rental r
		WHERE r.customer_id =(
			SELECT customer_id FROM(
				SELECT customer_id, SUM(amount) AS total_amount
				FROM sakila.payment
				GROUP BY customer_id
				ORDER BY total_amount DESC
				LIMIT 1)
				sub1)));
                
-- Q8 Customers who spent more than the average payments.

SELECT last_name 
FROM sakila.customer
WHERE customer_id IN(
	SELECT customer_id
    FROM sakila.payment
    WHERE amount >(
		SELECT AVG(amount)
        FROM sakila.payment));

