USE [Bachlor Essay]
GO

/****** Object:  Table [dbo].[Historic_NSE_Date]    Script Date: 4/4/2016 4:21:56 PM ******/
DROP TABLE [dbo].[Historic_NSE_Date]
GO


USE [Bachlor Essay]
GO

/****** Object:  Table [dbo].[India_GDP]    Script Date: 4/4/2016 4:22:13 PM ******/
DROP TABLE [dbo].[India_GDP]
GO

USE [Bachlor Essay]
GO

/****** Object:  Table [dbo].[MACD]    Script Date: 4/4/2016 4:22:33 PM ******/
DROP TABLE [dbo].[MACD]
GO

USE [Bachlor Essay]
GO

/****** Object:  Table [dbo].[RSI]    Script Date: 4/4/2016 4:22:42 PM ******/
DROP TABLE [dbo].[RSI]
GO

USE [Bachlor Essay]
GO

/****** Object:  Table [dbo].[Stocks]    Script Date: 4/4/2016 4:22:49 PM ******/
DROP TABLE [dbo].[Stocks]
GO

USE [Bachlor Essay]
GO

/****** Object:  Table [dbo].[US_Yield]    Script Date: 4/4/2016 4:22:58 PM ******/
DROP TABLE [dbo].[US_Yield]
GO

USE [Bachlor Essay]
GO

/****** Object:  Table [dbo].[Stocks]    Script Date: 2/10/2016 5:23:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Stocks](
	[company] [varchar](1) NULL,
	[ticker] [varchar](1) NOT NULL,
	[shares] [int] NULL,
	[purchase_price] [money] NULL,
	[current_price] [money] NULL,
	[purchase_date] [date] NULL,
	[unrealized] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[ticker] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



Create table Historic_NSE_Date
(
PK int IDENTITY(1,1) PRIMARY KEY,
Ticker varchar(10),
Date_of_Price datetime,
Open_Price float, 
Close_Price float,
percent_change float,
Volume float, 
constraint tick_date UNIQUE(Ticker, Date_of_Price)
)

USE [Bachlor Essay]
create table RSI(
pk int IDENTITY(1,1) Primary Key,
ticker varchar(10),
date_t datetime,
RSI float,
constraint ticker_date_rsi UNIQUE(ticker, date_t)
);

USE [Bachlor Essay]

Create table MACD
(
PK int IDENTITY(1,1) PRIMARY KEY,
Ticker varchar(10),
Date_of_Price datetime,
signal float, 
MACD float,
constraint ticker_date_macd UNIQUE(Ticker, Date_of_Price)
)


IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[India_GDP]') AND type in (N'U'))

BEGIN
Create Table India_GDP(
PK int IDENTITY(1,1) PRIMARY KEY,
Date_of_GDP datetime UNIQUE,
GDP float,
)

END
IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[US_Yield]') AND type in (N'U'))
Begin

Create Table US_Yield(
PK int IDENTITY(1,1) PRIMARY KEY,
Date_of_Bond  datetime UNIQUE,
one_mo float,
three_mo float,
six_mo float,
one_yr float,
two_yr float,
three_yr float,
five_yr float,
seven_yr float,
ten_yr float,
twenty_yr float,
thirty_yr float,
)
END

USE [Bachlor Essay]
GO

