USE sakila;
/* Email Campaigns for customers of Store 2
First, Last name and Email address of customers from Store 2*/
SELECT first_name, last_name, email FROM customer WHERE store_id=2;

/* movie with rental rate of 0.99$*/
SELECT * FROM film WHERE rental_rate = 0.99;
SELECT COUNT(*) FROM film WHERE rental_rate = 0.99;

/* we want to see rental rate and how many movies are in each rental rate categories*/
SELECT rental_rate, COUNT(title) AS numberOfFilms FROM film GROUP BY rental_rate;

/*Which rating do we have the most films in?*/
SELECT rating, COUNT(*) AS numberOfFilms FROM film GROUP BY rating ORDER BY numberOfFilms DESC LIMIT 1;

/*Which rating is most prevalant in each store?*/
SELECT store.store_id, film.rating, COUNT(inventory.film_id) AS Movies 
FROM inventory 
JOIN store 
JOIN film ON inventory.store_id = store.store_id AND inventory.film_id = film.film_id 
GROUP BY store_id, rating 
ORDER BY store_id, Movies;

/*We want to mail the customers about the upcoming promotion*/
SELECT customer.first_name, customer.last_name, address.address 
FROM customer 
JOIN address ON customer.address_id = address.address_id;

/* List of films by Film Name, Category, Language*/
SELECT * FROM category;
SELECT * FROM film;

SELECT film.title, category.name, language.name 
FROM film 
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id 
JOIN language ON film.language_id = language.language_id;

/* How many times each movie has been rented out? */
SELECT film.title, COUNT(rental.rental_id) AS rentalCount
FROM film 
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY rentalCount DESC;

/*Revenue per Movie */
SELECT film.title, film.film_id, film.rental_rate*COUNT(rental.rental_id) AS revenue
FROM film 
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film_id
ORDER BY revenue DESC;

/* Most Spending Customer so that we can send him/her rewards or debate points*/
SELECT customer.customer_id AS id, SUM(payment.amount) AS totalSpend
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY id
ORDER BY totalSpend DESC;

/* What Store has historically brought the most revenue */
SELECT store.store_id, SUM(payment.amount) AS Revenue
FROM store 
JOIN inventory ON store.store_id = inventory.store_id
JOIN rental ON  inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY store.store_id
ORDER BY Revenue DESC;


/*How many rentals we have for each month*/
SELECT left(rental_date,7) AS month, COUNT(*) AS rentals
FROM rental
GROUP BY month;

/* Rentals per Month (such Jan => How much, etc)*/
SELECT date_format(rental_date,"%M") AS "month", COUNT(*) AS rentals
FROM rental
GROUP BY month
ORDER BY rentals DESC;

/* Which date first movie was rented out ? */
SELECT rental_date
FROM rental
ORDER BY rental_date
LIMIT 1;
/* Which date last movie was rented out ? */
SELECT MAX(rental_date)
FROM rental;

/* For each movie, when was the first time and last time it was rented out? */
SELECT film.title AS title, MIN(rental.rental_date) AS first_time, MAX(rental.rental_date) AS last_time
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY title;

/* How many distint Renters per month*/
SELECT LEFT(rental_date,7) AS month, 
	COUNT(DISTINCT(customer_id)) AS distint_Renters,
    COUNT(DISTINCT(rental_id)) / COUNT(DISTINCT(customer_id)) AS average_rent_per_renter
FROM rental
GROUP BY month;