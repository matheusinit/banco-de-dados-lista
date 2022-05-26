

SELECT 
	departamento,
	nome,
	salario_bruto,
	total_desconto,
	(salario_bruto - total_desconto) AS salario_liquido
FROM 
(
	SELECT 
		departamento.nome AS departamento,
		empregado.nome,
		COALESCE((
			SELECT SUM(vencimento.valor)
			FROM empregado e
			JOIN emp_venc ON (emp_venc.matr = e.matr)
			JOIN vencimento ON (emp_venc.cod_venc = vencimento.cod_venc)
			WHERE e.matr = empregado.matr
		), 0) AS salario_bruto,
		COALESCE((
			SELECT SUM(desconto.valor)
			FROM empregado e
			JOIN emp_desc ON (emp_desc.matr = e.matr)
			JOIN desconto ON (emp_desc.cod_desc = desconto.cod_desc)
			WHERE e.matr = empregado.matr
		), 0) AS total_desconto
	FROM departamento
	JOIN empregado ON (empregado.lotacao = departamento.cod_dep)
) dados_empregado
ORDER BY salario_liquido DESC