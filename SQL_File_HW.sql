-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

-- 1b.  Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, ' ',  last_name)) AS "Actor Name" FROM actor;

-- 2a. Find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

-- 2b.Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE  "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. Order the rows by last name and first name, in that order:

SELECT first_name, last_name FROM actor WHERE last_name LIKE  "%LI%" ORDER BY last_name ASC, first_name ASC;


-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
--  so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research 
-- the type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor ADD description blob;
 
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the `description` column.

ALTER TABLE actor DROP description;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, count(last_name) as no_of_actors_having_current_lastname FROM actor GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that
-- are shared by at least two actors

SELECT last_name, COUNT(last_name) AS count_of_lastname FROM actor GROUP BY last_name HAVING count_of_lastname > 1;

-- 4c. HARPO WILLIAMS was accidentally entered  as GROUCHO WILLIAMS, fix the record.

UPDATE actor SET first_name = "HARPO" WHERE first_name = "GROUCHO" and last_name ="WILLIAMS";


-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name 
-- after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

UPDATE actor SET first_name = "GROUCHO" WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables 
-- staff and address:

SELECT st.first_name, st.last_name, ad.address FROM staff AS st LEFT JOIN address AS ad ON st.address_id = ad.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 

SELECT * from payment;


SELECT * from staff;

SELECT st.staff_id,  st.first_name, st.last_name, SUM(py.amount) as total_sales
FROM payment AS py INNER JOIN staff AS st ON py.staff_id = st.staff_id
WHERE payment_date >=  "20050801" AND payment_date <  "20050901"
GROUP BY st.staff_id;

--  6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT f.title , count(a.actor_id) as count_of_actor FROM film AS f
INNER JOIN film_actor AS a ON f.film_id = a.film_id
GROUP BY f.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT f.title, COUNT(f.title) AS num FROM film AS f INNER JOIN inventory AS i ON f.film_id = i.film_id
WHERE f.title = "Hunchback Impossible"
GROUP BY f.title;

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name:

SELECT cust.first_name, cust.last_name, sum(py.amount) AS total_paid_by_cust FROM payment AS py
INNER JOIN customer AS cust
ON py.customer_id = cust.customer_id
GROUP BY cust.first_name, cust.last_name
ORDER BY cust.last_name, cust.first_name;

-- 7a.films starting with the letters K and Q have soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title FROM film
WHERE title LIKE "Q%" OR title LIKE "K%"
	AND language_id = ( 
		SELECT language_id FROM language
        WHERE name = "English");

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT first_name, last_name FROM actor
WHERE actor_id IN (
	SELECT actor_id FROM film_actor 
    WHERE film_id = (
		SELECT film_id FROM film 
        WHERE title = "Alone Trip"));
	
	
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
-- of all Canadian customers. Use joins to retrieve this information.
SELECT cust.first_name, cust.last_name, cust.email
FROM customer AS cust INNER JOIN address AS ad
    ON cust.address_id = ad.address_id INNER JOIN city AS ct
    ON ad.city_id = ct.city_id INNER JOIN country AS co    
    ON ct.country_id = co.country_id WHERE co.country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as _family_ films.
SELECT title
FROM film
WHERE film_id IN (SELECT film_id
				  FROM film_category
                  WHERE category_id = (SELECT category_id FROM category WHERE name = "Family")
                 );

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(f.title) AS rent_count
FROM rental AS r INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id INNER JOIN film AS f
    ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rent_count DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT ad.address, ct.city, co.country, SUM(py.amount) AS total_revenue_in_dollars
FROM store AS st INNER JOIN address AS ad 
    ON st.address_id = ad.address_id INNER JOIN customer AS cust
    ON st.store_id=cust.store_id INNER JOIN payment AS py
    ON py.customer_id = cust.customer_id INNER JOIN city AS ct
    ON ct.city_id = ad.city_id INNER JOIN country AS co
    ON co.country_id = ct.country_id
GROUP BY ad.address, ct.city, co.country;


-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT st.store_id, ad.address, ct.city, co.country
FROM store AS st INNER JOIN address AS ad
    ON st.address_id = ad.address_id INNER JOIN city AS ct
    ON ct.city_id = ad.city_id INNER JOIN country AS co
    ON co.country_id = ct.country_id;


-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following 
-- tables: category, film_category, inventory, payment, and rental.)

SELECT c.name, SUM(p.amount) AS gross_revenue
FROM category AS c INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id INNER JOIN inventory AS i
    ON fc.film_id = i.film_id INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id INNER JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross 
-- revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute 
-- another query to create a view.
CREATE VIEW top_5_genre_based_gross_revenue AS
SELECT c.name, SUM(p.amount) AS gross_revenue
FROM category AS c INNER JOIN film_category AS fc 
    ON c.category_id = fc.category_id INNER JOIN inventory AS i
    ON fc.film_id = i.film_id INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id INNER JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_5_genre_based_gross_revenue;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW IF EXISTS top_5_genre_based_gross_revenue;