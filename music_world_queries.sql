-- 1. senior most employee based on job title

	SELECT * FROM employee; -- to select everything from employee table

SELECT employee_id,
first_name, last_name
levels, title, birthdate FROM employee
WHERE(title, birthdate) IN
(SELECT title, MIN(birthdate)
FROM employee e1
GROUP BY title)
ORDER BY birthdate;

    ------------------------------------------------------------------------------------------------

-- 2. all countries with ordre by most invoices

	SELECT * FROM invoice; -- to select everything from invoice table

SELECT billing_country, COUNT(customer_id) AS count_1
FROM invoice
GROUP BY billing_country
ORDER BY count_1 DESC;

    ------------------------------------------------------------------------------------------------

-- 3. total invoice top-3 values

SELECT invoice_id, customer_id, billing_state, billing_country, total
FROM invoice
ORDER BY total DESC
LIMIT 3;

    ------------------------------------------------------------------------------------------------

-- 4. city with second and third highest invoice total

SELECT billing_city, SUM(total) AS total_invoice
FROM invoice
GROUP BY billing_city
ORDER BY total_invoice DESC
LIMIT 2 OFFSET 1;

    ------------------------------------------------------------------------------------------------

-- 5. customer who has spent the most money

SELECT c.first_name, c.last_name, c.customer_id, SUM(i.total) AS total_spending
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spending DESC
LIMIT 1;

    ------------------------------------------------------------------------------------------------

-- 6. rock music listeners ordered by email column
--    join customer and invoice table on customer id then join that with invoice_line table on invoice id
--    and match track id in track and genre table and join both the tables on genre id.

SELECT DISTINCT email, first_name, last_name
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
JOIN invoice_line i_l
ON i.invoice_id = i_l.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track t
	JOIN genre g ON g.genre_id = t.genre_id
	WHERE g.name LIKE 'Rock'
)
ORDER BY email;

    ------------------------------------------------------------------------------------------------

--  7. a query that returns the Artist name and total track count of the top 10 rock bands

	SELECT * FROM artist; -- artist id
	SELECT * FROM genre; --genre id
	SELECT * FROM track; -- track id, genre id, album id 
	SELECT * FROM album; --album id, artist id

SELECT art.name AS artist, COUNT(art.name) AS total_tracks
FROM track t
JOIN album alb
ON t.album_id = alb.album_id
JOIN artist art
ON alb.artist_id = art.artist_id
JOIN genre g
ON t.genre_id = g.genre_id
WHERE g.name LIKE 'Rock%'
GROUP BY art.artist_id
ORDER BY total_tracks DESC
LIMIT 10;

    ------------------------------------------------------------------------------------------------

-- return name and milliseconds of each track that has songhlength longer than avg. length

	SELECT * FROM track; -- to select everything from track table


SELECT name, milliseconds
FROM track
WHERE milliseconds > (
SELECT AVG(milliseconds) FROM track
);








