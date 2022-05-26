----SELECT 
----	divisao.nome AS divisao,
----	empregado.nome,
----	COALESCE((
----		SELECT SUM(vencimento.valor)
----		FROM empregado e
----		JOIN emp_venc ON (emp_venc.matr = e.matr)
----		JOIN vencimento ON (emp_venc.cod_venc = vencimento.cod_venc)
----		WHERE e.matr = empregado.matr
----	), 0) AS salario_bruto,
----	COALESCE((
----		SELECT SUM(desconto.valor)
----		FROM empregado e
----		JOIN emp_desc ON (emp_desc.matr = e.matr)
----		JOIN desconto ON (emp_desc.cod_desc = desconto.cod_desc)
----		WHERE e.matr = empregado.matr
----	), 0) AS desconto_total
----FROM empregado
----JOIN divisao ON (empregado.lotacao_div = divisao.cod_divisao)

--SELECT 
--	nome,
--	salario_bruto,
--	(
--		SELECT
--			ROUND(AVG(salario_bruto - desconto_total), 2) AS media_salarial
--		FROM 
--		(
--			SELECT 
--				divisao.nome AS divisao,
--				empregado.nome,
--				COALESCE((
--					SELECT SUM(vencimento.valor)
--					FROM empregado e
--					JOIN emp_venc ON (emp_venc.matr = e.matr)
--					JOIN vencimento ON (emp_venc.cod_venc = vencimento.cod_venc)
--					WHERE e.matr = empregado.matr
--				), 0) AS salario_bruto,
--				COALESCE((
--					SELECT SUM(desconto.valor)
--					FROM empregado e
--					JOIN emp_desc ON (emp_desc.matr = e.matr)
--					JOIN desconto ON (emp_desc.cod_desc = desconto.cod_desc)
--					WHERE e.matr = empregado.matr
--				), 0) AS desconto_total
--			FROM empregado
--			JOIN divisao ON (empregado.lotacao_div = divisao.cod_divisao)
--		) dados_emp
--		WHERE dados_emp.divisao = dados_emp_por_div.divisao
--		GROUP BY divisao
--	) AS media_salaria_div
--FROM 
--(
--	SELECT 
--		divisao.nome AS divisao,
--		empregado.nome,
--		COALESCE((
--			SELECT SUM(vencimento.valor)
--			FROM empregado e
--			JOIN emp_venc ON (emp_venc.matr = e.matr)
--			JOIN vencimento ON (emp_venc.cod_venc = vencimento.cod_venc)
--			WHERE e.matr = empregado.matr
--		), 0) AS salario_bruto,
--		COALESCE((
--			SELECT SUM(desconto.valor)
--			FROM empregado e
--			JOIN emp_desc ON (emp_desc.matr = e.matr)
--			JOIN desconto ON (emp_desc.cod_desc = desconto.cod_desc)
--			WHERE e.matr = empregado.matr
--		), 0) AS desconto_total
--	FROM empregado
--	JOIN divisao ON (empregado.lotacao_div = divisao.cod_divisao)
--) dados_emp_por_div
--WHERE salario_bruto >
--(
--	SELECT
--		ROUND(AVG(salario_bruto - desconto_total), 2) AS media_salarial
--	FROM 
--	(
--		SELECT 
--			divisao.nome AS divisao,
--			empregado.nome,
--			COALESCE((
--				SELECT SUM(vencimento.valor)
--				FROM empregado e
--				JOIN emp_venc ON (emp_venc.matr = e.matr)
--				JOIN vencimento ON (emp_venc.cod_venc = vencimento.cod_venc)
--				WHERE e.matr = empregado.matr
--			), 0) AS salario_bruto,
--			COALESCE((
--				SELECT SUM(desconto.valor)
--				FROM empregado e
--				JOIN emp_desc ON (emp_desc.matr = e.matr)
--				JOIN desconto ON (emp_desc.cod_desc = desconto.cod_desc)
--				WHERE e.matr = empregado.matr
--			), 0) AS desconto_total
--		FROM empregado
--		JOIN divisao ON (empregado.lotacao_div = divisao.cod_divisao)
--	) dados_emp
--	WHERE dados_emp.divisao = dados_emp_por_div.divisao
--	GROUP BY divisao
--)

--SELECT 
--	divisao.nome AS divisao,
--	empregado.nome,
--	COALESCE((
--		SELECT SUM(vencimento.valor)
--		FROM empregado e
--		JOIN emp_venc ON (emp_venc.matr = e.matr)
--		JOIN vencimento ON (emp_venc.cod_venc = vencimento.cod_venc)
--		WHERE e.matr = empregado.matr
--	), 0) AS salario_bruto,
--	COALESCE((
--		SELECT SUM(desconto.valor)
--		FROM empregado e
--		JOIN emp_desc ON (emp_desc.matr = e.matr)
--		JOIN desconto ON (emp_desc.cod_desc = desconto.cod_desc)
--		WHERE e.matr = empregado.matr
--	), 0) AS desconto_total
--FROM empregado
--JOIN divisao ON (empregado.lotacao_div = divisao.cod_divisao)

SELECT 
	nome,
	(salario_bruto - desconto_total) AS salario
FROM 
(
	SELECT 
		divisao.nome AS divisao,
		empregado.nome,
		empregado.lotacao_div,
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
		), 0) AS desconto_total
	FROM empregado
	JOIN divisao ON (empregado.lotacao_div = divisao.cod_divisao)
) dados_emp_por_div
WHERE (salario_bruto - desconto_total) >
(
	SELECT
		ROUND(AVG(salario_bruto - desconto_total), 2) AS media_salarial
	FROM 
	(
		SELECT 
			divisao.nome AS divisao,
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
			), 0) AS desconto_total
		FROM empregado
		JOIN divisao ON (empregado.lotacao_div = divisao.cod_divisao)
	) dados_emp
	WHERE dados_emp.divisao = dados_emp_por_div.divisao
	GROUP BY divisao
) 
AND (salario_bruto - desconto_total) > 8000
ORDER BY lotacao_div