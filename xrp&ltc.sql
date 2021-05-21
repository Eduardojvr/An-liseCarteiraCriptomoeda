-- ***********************************************************************************************************
-- 											Análises XRP e LITCOIN
-- ***********************************************************************************************************

-- 
-- Valor Médio LITCOIN
--
select  sum(cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal))/(select count(*) from extrato e
																					inner join criptomoedas c2 
																						on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
																				where c2.Quantidade > 0 and e.qtdCompraVenda like '%LTC%'
																				) as 'Preço médio'
	from extrato e
		inner join criptomoedas c2 
			on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
where c2.Quantidade > 0	and e.qtdCompraVenda like '%LTC%'


-- 
-- Valor Médio XRP
--
select  sum(cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal))/(select count(*) from extrato e
																					inner join criptomoedas c2 
																						on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
																				where c2.Quantidade > 0 and e.qtdCompraVenda like '%XRP%'
																				) as 'Preço médio'
	from extrato e
		inner join criptomoedas c2 
			on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
where c2.Quantidade > 0	and e.qtdCompraVenda like '%XRP%'


-- 
-- Valor líquido
-- 	
select 
	(select sum(Quantidade) * 5.3900 from criptomoedas c where Moeda like 'XRP')
		+
	(select sum(Quantidade) * 548.31 from criptomoedas c where Moeda like 'LTC')
		
		-- 	where month(cast(c.`Data` as datetime)) = 5
		-- 		and year(cast(c.`Data` as datetime)) = 2021

-- 	
-- Qtd de LTC atual
-- 
	select sum(quantidade) from criptomoedas c where Moeda = 'LTC'
	
	-- 	
-- Qtd de XRP atual
-- 
	select sum(quantidade) from criptomoedas c where Moeda = 'XRP'

-- 
-- Valor desembolsado/investido em XRP
-- 
select sum(t.`R$ Gasto`) as 'R$ Gasto' from(
	select c2.*, cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal) * c2.Quantidade as 'R$ Gasto'
		from extrato e
			inner join criptomoedas c2 
				on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
	where c2.Quantidade > 0 and e.qtdCompraVenda like '%XRP%'
) as t

-- 
-- Valor desembolsado/investido em LTC
-- 
select sum(t.`R$ Gasto`) as 'R$ Gasto' from(
	select c2.*, cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal) * c2.Quantidade as 'R$ Gasto'
		from extrato e
			inner join criptomoedas c2 
				on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
	where c2.Quantidade > 0 and e.qtdCompraVenda like '%LTC%'
) as t


-- 
-- Valor lucro XRP (SEMPRE ATUALIZAR O VALOR ATUAL DO XRP)
-- 
set @val = (
	select sum(t.`R$ Gasto`) as 'R$ Gasto' from(
		select c2.*, cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal) * c2.Quantidade as 'R$ Gasto'
			from extrato e
				inner join criptomoedas c2 
					on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
		where c2.Quantidade > 0 and e.qtdCompraVenda like '%XRP%'
	) as t
)

select (select sum(Quantidade) * 14249.12 from criptomoedas c where Moeda like 'XRP') - @val



-- 
-- Valor lucro LTC (SEMPRE ATUALIZAR O VALOR ATUAL DO LTC)
-- 
set @val2 = (
	select sum(t.`R$ Gasto`) as 'R$ Gasto' from(
		select c2.*, cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal) * c2.Quantidade as 'R$ Gasto'
			from extrato e
				inner join criptomoedas c2 
					on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
		where c2.Quantidade > 0 and e.qtdCompraVenda like '%LTC%'
	) as t
)

select (select sum(Quantidade) * 14249.12 from criptomoedas c where Moeda like 'LTC') - @val2