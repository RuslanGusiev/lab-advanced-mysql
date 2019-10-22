use publications;

# Challenge 1

# Step1

SELECT titleauthor.title_id, titleauthor.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
FROM titleauthor
INNER JOIN titles
ON titles.title_id = titleauthor.title_id
INNER JOIN sales
ON titles.title_id = sales.title_id
GROUP BY titles.title_id, titleauthor.au_id, sales.qty;

# Step 2

SELECT title_id, au_id, SUM(sales_royalty) AS Aggregated_royalties
FROM 
(
	SELECT titleauthor.title_id, titleauthor.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
	FROM titleauthor
	INNER JOIN titles
	ON titles.title_id = titleauthor.title_id
	INNER JOIN sales
	ON titles.title_id = sales.title_id
	GROUP BY titles.title_id, titleauthor.au_id, sales.qty
) summary
GROUP BY title_id, au_id;

# Step3

CREATE TEMPORARY TABLE result
SELECT au_id, SUM(advance + Aggregated_royalties) AS Profit
FROM 
(
SELECT title_id, au_id, SUM(sales_royalty) AS Aggregated_royalties
FROM 
(
	SELECT titleauthor.title_id, titleauthor.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
	FROM titleauthor
	INNER JOIN titles
	ON titles.title_id = titleauthor.title_id
	INNER JOIN sales
	ON titles.title_id = sales.title_id
	GROUP BY titles.title_id, titleauthor.au_id, sales.qty
) summary
GROUP BY title_id, au_id
) summary1
INNER JOIN titles
ON titles.title_id = summary1.title_id
GROUP BY au_id;

# Top 3 profitable authors:
SELECT au_id, Profit
FROM result
GROUP BY au_id
ORDER BY Profit DESC
LIMIT 3;


