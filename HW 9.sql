USE sakila;

-- 1a
SELECT first_name, last_name FROM actor;

-- 1b
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name' FROM actor;

-- 2a
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'Joe';

-- 2b
SELECT * FROM actor
WHERE last_name LIKE('%GEN%');

-- 2c
SELECT * FROM actor
WHERE last_name LIKE('%LI%')
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD COLUMN description BLOB DEFAULT NULL;

-- 3b
ALTER TABLE actor
DROP COLUMN description;

-- 4a
SELECT last_name, COUNT(last_name) AS 'Number of Actors with this Last Name' FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) AS 'Number of Actors with this Last Name' FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT staff.first_name, staff.last_name, address.address FROM staff
JOIN address
ON staff.address_id = address.address_id;

-- 6b
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS 'Total Amount Rung Up' FROM staff
JOIN payment
ON staff.staff_id = payment.staff_id
WHERE payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY staff.first_name;

-- 6c
SELECT film.title, COUNT(film_actor.actor_id) AS 'Number of Actors' FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.title;

-- 6d
SELECT film.title, COUNT(inventory.inventory_id) AS 'Number of Copies' FROM inventory
JOIN film
ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible'
GROUP BY film.title;

-- 6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) as 'Total Paid' FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

-- 7a
SELECT title FROM film
WHERE title LIKE('K%')
OR  title LIKE('Q%')
AND language_id IN (
SELECT language_id FROM language
WHERE name = 'English');

-- 7b
SELECT first_name, last_name FROM actor
WHERE actor_id IN (
SELECT actor_id FROM film_actor
WHERE film_id IN (
SELECT film_id FROM film
WHERE title = 'Alone Trip')
);

-- 7c
SELECT customer.first_name, customer.last_name, customer.email FROM customer
JOIN address
ON customer.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id
WHERE country = 'Canada';

-- 7d
SELECT title FROM film
WHERE film_id IN (
SELECT film_id FROM film_category
WHERE category_id IN (
SELECT category_id FROM category
WHERE name = 'Family')
);

-- 7e
SELECT film.title, COUNT(rental.rental_id) AS 'Number of Times Rented' FROM film
JOIN inventory
ON film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY COUNT(rental.rental_id) DESC;

-- 7f
SELECT store.store_id, SUM(payment.amount) FROM store
JOIN staff
ON store.store_id = staff.store_id
JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY store.store_id;

-- 7g
SELECT store.store_id, city.city, country.country FROM store
JOIN address
ON store.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id;

-- 7h
SELECT category.name, SUM(payment.amount) AS 'Gross Revenue' FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8a
CREATE VIEW top_five_genres AS SELECT category.name, SUM(payment.amount) AS gross_revenue FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8b
SELECT * FROM top_five_genres;

-- 8c
DROP VIEW top_five_genres;
