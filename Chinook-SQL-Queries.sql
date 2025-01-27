/* Question 1: Who is the top customer? */
SELECT (Customer.FirstName || " " || Customer.LastName) AS customer_name,
       ROUND(SUM(Invoice.Total), 2) AS total_spending
FROM Customer
JOIN Invoice 
  ON Customer.CustomerId = Invoice.CustomerId
GROUP BY customer_name
ORDER BY total_spending DESC
LIMIT 5;

/* Question 2: Who is the best-selling artist? */
SELECT Artist.ArtistId, Artist.Name AS artist_name, 
       ROUND(SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity), 2) AS total_sales
FROM InvoiceLine
JOIN Track 
  ON Track.TrackId = InvoiceLine.TrackId
JOIN Album 
  ON Album.AlbumId = Track.AlbumId
JOIN Artist 
  ON Artist.ArtistId = Album.ArtistId
GROUP BY Artist.ArtistId
ORDER BY total_sales DESC
LIMIT 5;

/* Question 3: What is the most frequent genre? */
SELECT Genre.Name AS genre_name, 
       COUNT(Track.GenreId) AS total_count
FROM Genre
JOIN Track 
  ON Genre.GenreId = Track.GenreId
GROUP BY Genre.Name
ORDER BY total_count DESC
LIMIT 5;

/* Question 4: Who is the top rock artist? */
SELECT Artist.ArtistId, Artist.Name AS artist_name, 
       COUNT(Track.TrackId) AS rock_song_count
FROM Artist
JOIN Album
  ON Artist.ArtistId = Album.ArtistId
JOIN Track
  ON Album.AlbumId = Track.AlbumId
JOIN Genre
  ON Track.GenreId = Genre.GenreId
WHERE Genre.Name LIKE 'Rock'
GROUP BY Artist.ArtistId
ORDER BY rock_song_count DESC
LIMIT 10;

/* Question 5: Which country has the most customers? */
SELECT Customer.Country, 
       COUNT(Customer.CustomerId) AS customer_count
FROM Customer
GROUP BY Customer.Country
ORDER BY customer_count DESC
LIMIT 5;

/* Question 6: What is the total spending by each employee? */
SELECT Employee.FirstName || " " || Employee.LastName AS employee_name,
       ROUND(SUM(Invoice.Total), 2) AS total_spending
FROM Employee
JOIN Customer
  ON Employee.EmployeeId = Customer.SupportRepId
JOIN Invoice
  ON Customer.CustomerId = Invoice.CustomerId
GROUP BY employee_name
ORDER BY total_spending DESC;

/* Advanced Query 1: Revenue by Genre Across Years */
SELECT Genre.Name AS genre_name, 
       strftime('%Y', Invoice.InvoiceDate) AS year, 
       ROUND(SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity), 2) AS total_revenue
FROM InvoiceLine
JOIN Track 
  ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre 
  ON Track.GenreId = Genre.GenreId
JOIN Invoice 
  ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY genre_name, year
ORDER BY year DESC, total_revenue DESC;

/* Advanced Query 2: Longest Tracks by Genre */
SELECT Genre.Name AS genre_name, 
       Track.Name AS track_name, 
       Track.Milliseconds / 1000 AS duration_seconds
FROM Track
JOIN Genre 
  ON Track.GenreId = Genre.GenreId
ORDER BY genre_name, duration_seconds DESC
LIMIT 10;

/* Advanced Query 3: Average Revenue per Invoice by Employee */
SELECT Employee.FirstName || ' ' || Employee.LastName AS employee_name, 
       COUNT(DISTINCT Invoice.InvoiceId) AS invoice_count, 
       ROUND(SUM(Invoice.Total) / COUNT(DISTINCT Invoice.InvoiceId), 2) AS avg_revenue_per_invoice
FROM Employee
JOIN Customer 
  ON Employee.EmployeeId = Customer.SupportRepId
JOIN Invoice 
  ON Customer.CustomerId = Invoice.CustomerId
GROUP BY employee_name
ORDER BY avg_revenue_per_invoice DESC;

/* Advanced Query 4: Customer Segmentation by Spending */
SELECT Customer.FirstName || ' ' || Customer.LastName AS customer_name, 
       Customer.Country, 
       ROUND(SUM(Invoice.Total), 2) AS total_spent, 
       CASE 
           WHEN SUM(Invoice.Total) > 100 THEN 'High-Spender'
           WHEN SUM(Invoice.Total) BETWEEN 50 AND 100 THEN 'Medium-Spender'
           ELSE 'Low-Spender'
       END AS spending_category
FROM Customer
JOIN Invoice 
  ON Customer.CustomerId = Invoice.CustomerId
GROUP BY customer_name, Customer.Country
ORDER BY total_spent DESC;
