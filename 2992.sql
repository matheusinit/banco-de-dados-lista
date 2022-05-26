--SELECT 
--	departamento.nome AS departamento,
--	divisao.nome AS divisao
--FROM departamento
--JOIN divisao ON (departamento.cod_dep = divisao.cod_dep)

--SELECT *
--FROM empregado
--JOIN emp_venc ON (emp_venc.matr = empregado.matr)
--JOIN vencimento ON (vencimento.cod_venc = emp_venc.cod_venc)





SELECT 
	departamento,
	divisao,
	ROUND(media_salarial, 2) AS media
FROM 
(
	SELECT 
		departamento,
		divisao,
		AVG(vencimento-desconto) AS media_salarial
	FROM 
	(
		SELECT 
			departamento.nome AS departamento,
			divisao.nome AS divisao,
			empregado.matr AS matricula,
			empregado.nome AS nome,
			COALESCE((
				SELECT SUM(vencimento.valor)
				FROM empregado e
				JOIN emp_venc ON (emp_venc.matr = e.matr)
				JOIN vencimento ON (vencimento.cod_venc = emp_venc.cod_venc)
				WHERE e.matr = empregado.matr
			), 0) AS vencimento,
			COALESCE((
				SELECT SUM(desconto.valor)
				FROM empregado e
				JOIN emp_desc ON (emp_desc.matr = e.matr)
				JOIN desconto ON (desconto.cod_desc = emp_desc.cod_desc)
				WHERE e.matr = empregado.matr
			), 0) AS desconto
		FROM departamento
		JOIN divisao ON (departamento.cod_dep = divisao.cod_dep)
		JOIN empregado ON (empregado.lotacao_div = divisao.cod_divisao)
	) empregados_dados
	GROUP BY divisao, departamento
) media_por_depart_div 
WHERE departamento IN (
	SELECT
		departamento
	FROM 
	(
		SELECT 
			departamento,
			divisao,
			AVG(vencimento-desconto) AS media_salarial
		FROM 
		(
			SELECT 
				departamento.nome AS departamento,
				divisao.nome AS divisao,
				empregado.matr AS matricula,
				empregado.nome AS nome,
				COALESCE((
					SELECT SUM(vencimento.valor)
					FROM empregado e
					JOIN emp_venc ON (emp_venc.matr = e.matr)
					JOIN vencimento ON (vencimento.cod_venc = emp_venc.cod_venc)
					WHERE e.matr = empregado.matr
				), 0) AS vencimento,
				COALESCE((
					SELECT SUM(desconto.valor)
					FROM empregado e
					JOIN emp_desc ON (emp_desc.matr = e.matr)
					JOIN desconto ON (desconto.cod_desc = emp_desc.cod_desc)
					WHERE e.matr = empregado.matr
				), 0) AS desconto
			FROM departamento
			JOIN divisao ON (departamento.cod_dep = divisao.cod_dep)
			JOIN empregado ON (empregado.lotacao_div = divisao.cod_divisao)
		) empregados_dados
		GROUP BY departamento, divisao
	) dep_div_salario
	GROUP BY departamento
) 
AND 
media_salarial IN 
(
	SELECT
		MAX(media_salarial) AS media
	FROM 
	(
		SELECT 
			departamento,
			divisao,
			AVG(vencimento-desconto) AS media_salarial
		FROM 
		(
			SELECT 
				departamento.nome AS departamento,
				divisao.nome AS divisao,
				empregado.matr AS matricula,
				empregado.nome AS nome,
				COALESCE((
					SELECT SUM(vencimento.valor)
					FROM empregado e
					JOIN emp_venc ON (emp_venc.matr = e.matr)
					JOIN vencimento ON (vencimento.cod_venc = emp_venc.cod_venc)
					WHERE e.matr = empregado.matr
				), 0) AS vencimento,
				COALESCE((
					SELECT SUM(desconto.valor)
					FROM empregado e
					JOIN emp_desc ON (emp_desc.matr = e.matr)
					JOIN desconto ON (desconto.cod_desc = emp_desc.cod_desc)
					WHERE e.matr = empregado.matr
				), 0) AS desconto
			FROM departamento
			JOIN divisao ON (departamento.cod_dep = divisao.cod_dep)
			JOIN empregado ON (empregado.lotacao_div = divisao.cod_divisao)
		) empregados_dados
		GROUP BY departamento, divisao
	) dep_div_salario
	GROUP BY departamento
) 
ORDER BY media DESC