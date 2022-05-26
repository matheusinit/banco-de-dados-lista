--SELECT 
--	departamento.nome AS departamento,
--	divisao.nome AS divisao,
--	empregado.matr AS matricula,
--	empregado.nome AS empregado,
--	isnull((
--		SELECT
--			SUM(vencimento.valor)
--		FROM empregado E
--		JOIN emp_venc ON (E.matr = emp_venc.matr)
--		JOIN vencimento ON (emp_venc.cod_venc = vencimento.cod_venc)
--		WHERE E.matr = empregado.matr
--	), 0) AS vencimento,
--	isnull((
--		SELECT 
--			SUM(desconto.valor)
--		FROM empregado E
--		JOIN emp_desc ON (E.matr = emp_desc.matr)
--		JOIN desconto ON (emp_desc.cod_desc = desconto.cod_desc)
--		WHERE E.matr = empregado.matr
--	), 0) AS desconto
--FROM departamento
--JOIN divisao ON (departamento.cod_dep = divisao.cod_dep)
--JOIN empregado ON (divisao.cod_divisao = empregado.lotacao_div)
--ORDER BY empregado.nome;

SELECT 
	departamento,
	divisao,
	ROUND(AVG(vencimento - desconto), 2) AS media,
	MAX(vencimento-desconto) AS maior
FROM 
	(SELECT 
		departamento.nome AS departamento,
		divisao.nome AS divisao,
		empregado.matr AS matricula,
		empregado.nome AS empregado,
		isnull((
			SELECT
				SUM(vencimento.valor)
			FROM empregado E
			JOIN emp_venc ON (E.matr = emp_venc.matr)
			JOIN vencimento ON (emp_venc.cod_venc = vencimento.cod_venc)
			WHERE E.matr = empregado.matr
		), 0) AS vencimento,
		isnull((
			SELECT 
				SUM(desconto.valor)
			FROM empregado E
			JOIN emp_desc ON (E.matr = emp_desc.matr)
			JOIN desconto ON (emp_desc.cod_desc = desconto.cod_desc)
			WHERE E.matr = empregado.matr
		), 0) AS desconto
	FROM departamento
	JOIN divisao ON (departamento.cod_dep = divisao.cod_dep)
	JOIN empregado ON (divisao.cod_divisao = empregado.lotacao_div)
) salarios
GROUP BY departamento, divisao
ORDER BY media