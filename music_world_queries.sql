
------------------ M U S I C    W O R L D ------------------ 


-- 1. senior most employee based on job title

	SELECT * FROM employee; -- to select everything from employee table

SELECT employee_id,
first_name, last_name
levels, title, birthdate FROM employee
WHERE(title, birthdate) IN (
SELECT title, MIN(birthdate)
FROM employee e1
GROUP BY title
)
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


-- 8. return name and milliseconds of each track that has songhlength longer than avg. length

	SELECT * FROM track; -- to select everything from track table


SELECT name, milliseconds/60000 AS track_length_mins
FROM track
WHERE milliseconds > (
SELECT AVG(milliseconds) FROM track
)
ORDER BY milliseconds DESC;

    ------------------------------------------------------------------------------------------------


-- 9. find how much each customer spent on artists and return customer name, artist name and total spent

	SELECT * FROM customer; -- first_name, last_name, customer_id
	SELECT * FROM artist; -- artist_id, name
	SELECT * FROM invoice; -- invoice_id, customer_id, total
	SELECT * FROM album; -- album_id, artist_id
	SELECT * FROM track; -- track_id, album_id
	SELECT * FROM invoice_line; -- invoice_id, track_id, unit_price, quantity


SELECT c.first_name, c.last_name, art.name AS artist_name,
SUM((il.unit_price)*(il.quantity)) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i. customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album alb ON t.album_id = alb.album_id
JOIN artist art ON alb.artist_id = art.artist_id
GROUP BY c.customer_id, art.artist_id
ORDER BY total_spent DESC;

    ------------------------------------------------------------------------------------------------


-- 10. find the genre with highest purchase of each country

	SELECT * FROM invoice; -- invoice_id, customer_id, total, billing_country
	SELECT * FROM invoice_line; -- invoice_id, track_id, unit_price, quantity
	SELECT * FROM genre; -- genre_id, name
	SELECT * FROM track; -- track_id, album_id, genre_id

WITH purchase AS(
	SELECT i.billing_country, g.name,
	SUM(il.unit_price*il.quantity) AS total_spent,
	ROW_NUMBER() OVER(PARTITION BY i.billing_country ORDER BY SUM((il.unit_price)*(il.quantity)) DESC) AS row_num
	FROM invoice i
	JOIN invoice_line il ON i.invoice_id = il.invoice_id
	JOIN track t ON il.track_id = t.track_id
	JOIN genre g ON t.genre_id = g.genre_id
	GROUP BY i.billing_country, g.name
	ORDER BY i.billing_country ASC, total_spent DESC
)
SELECT billing_country, name, total_spent
FROM purchase pur WHERE row_num = 1
ORDER BY total_spent DESC;

    ------------------------------------------------------------------------------------------------


-- 11. find the customer who have spent most amount for each country

WITH purchase AS(
	SELECT c.first_name, c.last_name, c.customer_id, c.country,
	SUM(il.unit_price*il.quantity) AS total_spent,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY SUM((il.unit_price)*(il.quantity)) DESC) AS row_num
	FROM invoice_line il
	JOIN invoice i ON i.invoice_id = il.invoice_id
	JOIN customer c ON i.customer_id = c.customer_id
	GROUP BY c.country, c.customer_id
	ORDER BY c.country ASC, total_spent DESC
)
SELECT first_name, last_name, country, total_spent
FROM purchase pur WHERE row_num = 1
ORDER BY country;

