drop table [Bachlor Essay].dbo.MACD

USE [Bachlor Essay]

Create table MACD
(
PK int IDENTITY(1,1) PRIMARY KEY,
Ticker varchar(10),
Date_of_Price varchar(255),
signal float, 
MACD float,
constraint ticker_date UNIQUE(ticker, Date_of_Price)
)
