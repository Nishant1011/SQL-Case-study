use db_nishant1;
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    genre VARCHAR(255),
    price DECIMAL(10, 2),
    quantity INT
);
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    book_id INT,
    customer_name VARCHAR(255),
    purchase_date DATE,
    quantity_sold INT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

INSERT INTO Books VALUES (1, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 19.99, 100);
INSERT INTO Books VALUES (2, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 15.99, 50);
INSERT INTO Books VALUES (3, '1984', 'George Orwell', 'Fiction', 12.99, 80);
INSERT INTO Books VALUES (4, 'Pride and Prejudice', 'Jane Austen', 'Fiction', 14.99, 75);
select * from Books;

INSERT INTO Sales VALUES (1, 1, 'John Doe', '2023-01-01', 2);
INSERT INTO Sales VALUES (2, 2, 'Jane Smith', '2023-02-15', 3);
INSERT INTO Sales VALUES (3, 3, 'John Doe', '2023-03-20', 1);
INSERT INTO Sales VALUES (4, 4, 'Jane Smith', '2023-04-05', 5);
select * from Sales;

-- 1 List all books.
SELECT * FROM Books;

-- 2 List all sales.
SELECT * FROM Sales;

-- 3 List all books by a specific author.
SELECT * FROM Books WHERE author = 'F. Scott Fitzgerald';

-- 4 List all books in a specific genre.
SELECT * FROM Books WHERE genre = 'Fiction';

-- 5 Find the book with the highest price.
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

-- 6 Find the book with the lowest quantity in stock.
SELECT * FROM Books ORDER BY quantity ASC LIMIT 1;

-- 7 Find the total number of books sold.
SELECT SUM(quantity_sold) FROM Sales;

-- 8 Find the total revenue generated.
SELECT SUM(quantity_sold * price) FROM Sales JOIN Books ON Sales.book_id = Books.book_id;

-- 9 Find the best-selling book (most copies sold).
SELECT Books.title, SUM(Sales.quantity_sold) AS total_sold
FROM Books
JOIN Sales ON Books.book_id = Sales.book_id
GROUP BY Books.title
ORDER BY total_sold DESC
LIMIT 1;

-- 10 Find the top 3 best-selling genres.
SELECT Books.genre, SUM(Sales.quantity_sold) AS total_sold
FROM Books
JOIN Sales ON Books.book_id = Sales.book_id
GROUP BY Books.genre
ORDER BY total_sold DESC
LIMIT 3;

-- 11 Find books that need to be reordered (quantity below a certain threshold).
SELECT * FROM Books WHERE quantity < 10;

-- 12 Update the quantity of a specific book.
UPDATE Books SET quantity = 100 WHERE book_id = 1;

-- 13 Find the average price of books in a specific genre.
SELECT AVG(price) FROM Books WHERE genre = 'Fiction';

-- 14 Count the number of books by each author.
SELECT author, COUNT(*) AS book_count
FROM Books
GROUP BY author;

-- 15 Find the total number of unique customers.
SELECT COUNT(DISTINCT customer_name) FROM Sales;

-- 16 Find the customer who has spent the most money.
SELECT customer_name, SUM(quantity_sold * price) AS total_spent
FROM Sales
JOIN Books ON Sales.book_id = Books.book_id
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 1;

-- 17 Find the most recent sale for a specific customer.
SELECT * FROM Sales WHERE customer_name = 'John Doe' ORDER BY purchase_date DESC LIMIT 1;

-- 18 Find the number of sales per month.
SELECT MONTH(purchase_date) AS month, COUNT(*) AS sales_count
FROM Sales
GROUP BY MONTH(purchase_date);

-- 19 Find the average number of books purchased per sale.
SELECT AVG(quantity_sold) FROM Sales;

-- 20 Find books that have been sold at least once but are currently out of stock
SELECT * FROM Books
WHERE book_id IN (SELECT book_id FROM Sales)
AND quantity = 0;

-- 21 Find customers who have purchased books from multiple genres.
SELECT customer_name
FROM Sales
JOIN Books ON Sales.book_id = Books.book_id
GROUP BY customer_name
HAVING COUNT(DISTINCT genre) > 1;

-- 22 Find books that have not been sold in the last 6 months.
SELECT * FROM Books
WHERE book_id NOT IN (SELECT book_id FROM Sales WHERE purchase_date >= DATE_ADD(NOW(), INTERVAL -6 MONTH));

-- 23 Calculate the average selling price of a book.
SELECT AVG(price) FROM Books;

-- 24 Find the percentage of books in stock that are fiction.
SELECT (COUNT(*) / (SELECT COUNT(*) FROM Books)) * 100 AS percentage
FROM Books
WHERE genre = 'Fiction';

-- 25 Calculate the total cost of the inventory.
SELECT SUM(quantity * price) FROM Books;

-- 26 Find the month with the highest total sales.
SELECT MONTH(purchase_date) AS month, SUM(quantity_sold * price) AS total_sales
FROM Sales
JOIN Books ON Sales.book_id = Books.book_id
GROUP BY MONTH(purchase_date)
ORDER BY total_sales DESC
LIMIT 1;

-- 27 Find the customer who has purchased the most books of a specific genre.
SELECT customer_name, COUNT(*) AS book_count
FROM Sales
JOIN Books ON Sales.book_id = Books.book_id
WHERE genre = 'Fiction'
GROUP BY customer_name
ORDER BY book_count DESC
LIMIT 1;

-- 28 Find customers who have purchased books from all genres.
SELECT customer_name
FROM Sales
JOIN Books ON Sales.book_id = Books.book_id
GROUP BY customer_name
HAVING COUNT(DISTINCT genre) = (SELECT COUNT(DISTINCT genre) FROM Books);

-- 29 Find the most popular day of the week for book purchases.
SELECT DAYNAME(purchase_date) AS day_of_week, COUNT(*) AS purchase_count
FROM Sales
GROUP BY DAYNAME(purchase_date)
ORDER BY purchase_count DESC
LIMIT 1;

-- 30 Calculate the percentage of customers who have made repeat purchases.
SELECT (COUNT(DISTINCT customer_name) / (SELECT COUNT(DISTINCT customer_name) FROM Sales)) * 100 AS repeat_purchase_percentage
FROM Sales
GROUP BY customer_name
HAVING COUNT(*) > 1;

-- 31 Find the total quantity sold of each book.
SELECT Books.title, SUM(Sales.quantity_sold) AS total_sold
FROM Books
JOIN Sales ON Books.book_id = Sales.book_id
GROUP BY Books.title;

-- 32  Find the average price of books sold.
SELECT AVG(Books.price)
FROM Sales
JOIN Books ON Sales.book_id = Books.book_id;

-- 33  Find the sales for a specific date range.
SELECT * FROM Sales WHERE purchase_date BETWEEN '2023-01-01' AND '2023-06-30';

-- 34 Find books that have not been sold in the last 6 months.
SELECT * FROM Books
WHERE book_id NOT IN (SELECT book_id FROM Sales WHERE purchase_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH));

-- 35  Find the number of customers who have made purchases in the past month.
SELECT COUNT(DISTINCT customer_name)
FROM Sales
WHERE purchase_date >= DATE_SUB(NOW(), INTERVAL 1 MONTH);

-- 36  Find the most popular author based on sales.
SELECT Books.author, SUM(Sales.quantity_sold) AS total_sold
FROM Books
JOIN Sales ON Books.book_id = Sales.book_id
GROUP BY Books.author
ORDER BY total_sold DESC
LIMIT 1;

-- 37 Find the average number of books purchased per customer.
SELECT AVG(purchase_count)
FROM (
    SELECT customer_name, COUNT(*) AS purchase_count
    FROM Sales
    GROUP BY customer_name
) AS customer_purchases;

-- 38 Find the average price paid per book by each customer
SELECT customer_name, AVG(price * quantity_sold) / AVG(quantity_sold) AS avg_price_per_book
FROM Sales
JOIN Books ON Sales.book_id = Books.book_id
GROUP BY customer_name;

-- 39 Identify books that have been sold in every month of the current year.
SELECT book_id, title
FROM Books
WHERE book_id IN (
  SELECT book_id
  FROM Sales
  WHERE YEAR(purchase_date) = YEAR(CURDATE())
  GROUP BY book_id
  HAVING COUNT(DISTINCT MONTH(purchase_date)) = 12
);


-- 40 Calculate the percentage of total sales each genre contributes.
SELECT genre, SUM(quantity_sold * price) AS total_sales,
       (SUM(quantity_sold * price) / (SELECT SUM(quantity_sold * price) FROM Sales JOIN Books ON Sales.book_id = Books.book_id)) * 100 AS percentage
FROM Sales
JOIN Books ON Sales.book_id = Books.book_id
GROUP BY genre;