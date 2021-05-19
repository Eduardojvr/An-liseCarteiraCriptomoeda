-- ***********************************************************************************************************
-- 											Análises ETHEREUM
-- ***********************************************************************************************************

-- 
-- Valor Médio ETHEREUM
--
select  sum(cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal))/(select count(*) from extrato e
																					inner join criptomoedas c2 
																						on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
																				where c2.Quantidade > 0 and e.qtdCompraVenda like '%ETH%'
																				) as 'Preço médio'
	from extrato e
		inner join criptomoedas c2 
			on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
where c2.Quantidade > 0	and e.qtdCompraVenda like '%ETH%'



-- 
-- Valor líquido
-- 	
select 
	(select sum(Quantidade) * 350000 from criptomoedas c where Moeda like 'BTC')
		+
	(select sum(Quantidade) * 18000 from criptomoedas c where Moeda like 'ETH')
		
		-- 	where month(cast(c.`Data` as datetime)) = 5
		-- 		and year(cast(c.`Data` as datetime)) = 2021

-- 	
-- Qtd de ETHEREUM atual
-- 
	select sum(quantidade) from criptomoedas c where Moeda = 'ETH'

-- 
-- Valor desembolsado/investido em ETHEREUM
-- 
select sum(t.`R$ Gasto`) as 'R$ Gasto' from(
	select c2.*, cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal) * c2.Quantidade as 'R$ Gasto'
		from extrato e
			inner join criptomoedas c2 
				on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
	where c2.Quantidade > 0 and e.qtdCompraVenda like '%ETH%'
) as t


-- 
-- Valor lucro ETHEREUM (SEMPRE ATUALIZAR O VALOR ATUAL DO ETH)
-- 
set @val = (
	select sum(t.`R$ Gasto`) as 'R$ Gasto' from(
		select c2.*, cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal) * c2.Quantidade as 'R$ Gasto'
			from extrato e
				inner join criptomoedas c2 
					on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
		where c2.Quantidade > 0 and e.qtdCompraVenda like '%ETH%'
	) as t
)

select (select sum(Quantidade) * 14249.12 from criptomoedas c where Moeda like 'ETH') - @val