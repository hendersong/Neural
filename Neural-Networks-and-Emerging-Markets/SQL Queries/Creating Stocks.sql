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


