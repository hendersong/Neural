/****** Script for SelectTopNRows command from SSMS  ******/
select num2.*, us.one_mo, us.three_mo, us.six_mo, us.one_yr, us.two_yr, us.three_yr, us.five_yr, us.seven_yr, us.ten_yr, us.twenty_yr, us.thirty_yr
from
(SELECT num.*, india.GDP
from
(select rsi_macd.*, price.Open_Price, price.Close_Price, price.percent_change, price.Volume
from
(SELECT r.date_t,r.ticker, r.RSI,m.MACD, m.signal
  FROM [Bachlor Essay].[dbo].[RSI] as r
  inner join [Bachlor Essay].dbo.MACD as m
  on m.Date_of_Price=r.date_t and m.Ticker=r.ticker) as rsi_macd
  inner join [Bachlor Essay].dbo.Historic_NSE_Date as price
  on price.Date_of_Price = rsi_macd.date_t and rsi_macd.Ticker= price.Ticker) as num
  left join [Bachlor Essay].dbo.India_GDP as india
  on india.Date_of_GDP=num.date_t) as num2
  left join [Bachlor Essay].dbo.US_Yield as us
  on us.Date_of_Bond= num2.date_t


  where year(num2.date_t) < 2007
