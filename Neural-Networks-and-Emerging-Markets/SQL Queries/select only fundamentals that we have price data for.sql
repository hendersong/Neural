



(SELECT Distinct b.Ticker
FROM [Bachlor Essay].[dbo].[Fundamentals] as b
inner join [Bachlor Essay].dbo.Historic_NSE_Date as s On b.Ticker=s.Ticker)
