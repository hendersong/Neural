USE [Bachlor Essay]

IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[India_GDP]') AND type in (N'U'))

BEGIN
Create Table India_GDP(
PK int IDENTITY(1,1) PRIMARY KEY,
Date_of_GDP varchar(255) UNIQUE,
GDP float,
)

END
IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[US_Yield]') AND type in (N'U'))
Begin

Create Table US_Yield(
PK int IDENTITY(1,1) PRIMARY KEY,
Date_of_Bond  varchar(255) UNIQUE,
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