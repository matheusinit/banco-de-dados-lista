SELECT 
	products.name,
	providers.name
FROM products
 JOIN providers ON products.id_providers = providers.id
 where providers.id = (
	select id from providers WHERE name = 'Ajax SA'
 )