SELECT 
	products.name,
	providers.name,
	categories.name
FROM products
JOIN Categories ON categories.id = products.id_categories
JOIN Providers ON providers.id = products.id_providers
WHERE Providers.id = (
	SELECT id FROM providers where name = 'Sansul SA'
) AND Categories.id = (
	SELECT id FROM categories where name = 'Imported'
)