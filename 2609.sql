SELECT 
	categories.name AS category,
    sum(amount) AS quantidade
FROM products
JOIN categories
ON id_categories = categories.id
group by categories.name