# SQL Music World
SQL Project on Music World database containing more than 10 tables. Solved complex problems using basic to advanced SQL queries involving joins, subqueries, and window functions. This project helped deepen my understanding of SQL and relational database concepts through hands-on data analysis.

> Learning Credits: Rishabh Mishra (https://github.com/rishabhnmishra)

## Database and Tools
- PostgreSQL

- PgAdmin4

## Description
In this project, I worked on a comprehensive SQL-based exploration of the "Music World" database, which consists of over 10 interconnected tables representing artists, albums, tracks, customers, purchases, playlists, and more. I performed a range of basic to advanced SQL queries to solve complex analytical problems and extract meaningful insights.

Key techniques used include:

- ✅ Joins to combine data across tables

- ✅ Subqueries for conditional filtering and nested analysis

- ✅ Window functions to perform advanced analytical computations such as customer ranking, track popularity, and sales trends

This hands-on project significantly enhanced my understanding of SQL, database relationships, and real-world data handling, reinforcing both foundational concepts and advanced querying techniques.

### Sample Query
Q. Find the customers who have spent the most amount for each country

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
