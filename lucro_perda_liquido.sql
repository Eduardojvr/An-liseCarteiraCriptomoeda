-- 
-- Valor lucro ETHEREUM + BITCOIN (SEMPRE ATUALIZAR O VALOR ATUAL DO ETH e BTC)
-- 

set @btc = 209001.52
set @eth = 14138.11


set @valEth = (
	select sum(t.`R$ Gasto`) as 'R$ Gasto' from(
		select c2.*, cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal) * c2.Quantidade as 'R$ Gasto'
			from extrato e
				inner join criptomoedas c2 
					on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
		where c2.Quantidade > 0 and e.qtdCompraVenda like '%ETH%'
	) as t
)

set @valBtc = (
	select sum(t.`R$ Gasto`) as 'R$ Gasto' from(
		select c2.*, cast(replace(replace(valordiacompra, 'R$',''),'.','') as decimal) * c2.Quantidade as 'R$ Gasto'
			from extrato e
				inner join criptomoedas c2 
					on DATE_FORMAT(str_to_date (e.data, '%d/%m/%Y %T'), '%Y-%m-%d %T')  = c2.data
		where c2.Quantidade > 0 and e.qtdCompraVenda like '%BTC%'
	) as t
)



select concat('R$',cast((
			(select((select sum(Quantidade) * @eth from criptomoedas c where Moeda like 'ETH') - @valEth))
				+ 
			(select((select sum(Quantidade) * @btc from criptomoedas c where Moeda like 'BTC') - @valBtc))
		) as decimal(10,2))) as 'Lucro/Perda R$'

