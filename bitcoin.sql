-- ***********************************************************************************************************
-- 											Análises BITCOIN
-- ***********************************************************************************************************

-- 
-- Valor Médio bitcoin
--
select  sum(cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal))/(select count(*) from extrato e
																					inner join criptomoedas c2 
																						on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
																				where c2.Quantidade > 0 and e.qtdCompraVenda like '%BTC%'
																				) as 'Preço médio'
	from extrato e
		inner join criptomoedas c2 
			on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
where c2.Quantidade > 0	and e.qtdCompraVenda like '%BTC%'



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
-- Qtd de bitcoin atual
-- 
	select sum(quantidade) from criptomoedas c where Moeda = 'BTC'

-- 
-- Valor desembolsado/investido em bitcoin
-- 
select sum(t.`R$ Gasto`) as 'R$ Gasto' from(
	select c2.*, cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal) * c2.Quantidade as 'R$ Gasto'
		from extrato e
			inner join criptomoedas c2 
				on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
	where c2.Quantidade > 0 and e.qtdCompraVenda like '%BTC%'
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
		where c2.Quantidade > 0 and e.qtdCompraVenda like '%BTC%'
	) as t
)

select (select sum(Quantidade) * 210599.97 from criptomoedas c where Moeda like 'BTC') - @val


