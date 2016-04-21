drop table Historic_NSE_Date

USE [Bachlor Essay]

Create table Historic_NSE_Date
(
PK int IDENTITY(1,1) PRIMARY KEY,
Ticker varchar(10),
Date_of_Price varchar(255),
Open_Price float, 
Close_Price float,
percent_change float,
Volume float, 
constraint tick_date UNIQUE(ticker, date_of_price)
)



