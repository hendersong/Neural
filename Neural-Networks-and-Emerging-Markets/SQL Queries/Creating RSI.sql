
drop table dbo.RSI

USE [Bachlor Essay]
create table RSI(
pk int IDENTITY(1,1) Primary Key,
ticker varchar(255),
date_t varchar(255),
RSI float,
constraint ticerk_date_rsi UNIQUE(ticker, date_t)
);