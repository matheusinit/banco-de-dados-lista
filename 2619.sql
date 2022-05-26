SELECT 
	products.name,
	providers.name,
	products.price
FROM products
JOIN providers on (products.id_providers = providers.id)
JOIN categories on (products.id_categories = categories.id)
WHERE products.price > '1000' AND categories.name = 'Super Luxury';