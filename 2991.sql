SELECT 
	departamento AS "Nome Departamento",
	COUNT(matricula) AS "Numero de Empregados",
	ROUND(AVG(vencimento-desconto), 2) AS "Media Salarial",
	MAX(vencimento-desconto) AS "Maior Salario",
	MIN(vencimento-desconto) AS "Menor Salario"
FROM (
	SELECT 
		departamento.nome AS departamento,
		empregado.matr AS matricula,
		COALESCE((
			SELECT 
				SUM(vencimento.valor)
			FROM empregado e
			JOIN emp_venc ON (emp_venc.matr = e.matr)
			JOIN vencimento ON (vencimento.cod_venc = emp_venc.cod_venc)
			WHERE e.matr = empregado.matr
		), 0) AS vencimento,
		COALESCE((
			SELECT 
				SUM(desconto.valor)
			FROM empregado e
			JOIN emp_desc ON (emp_desc.matr = e.matr)
			JOIN desconto ON (desconto.cod_desc = emp_desc.cod_desc)
			WHERE e.matr = empregado.matr
		), 0) AS desconto
	FROM departamento
	JOIN empregado ON (empregado.lotacao = departamento.cod_dep)
) empregado_dados
GROUP BY departamento
ORDER BY "Media Salarial" DESC

