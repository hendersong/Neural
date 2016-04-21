USE [Bachlor Essay]
GO

/****** Object:  Table [dbo].[US_Yield]    Script Date: 2/10/2016 5:22:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[US_Yield](
	[PK] [int] IDENTITY(1,1) NOT NULL,
	[Date_] [varchar](255) NULL,
	[one_mo] [float] NULL,
	[three_mo] [float] NULL,
	[six_mo] [float] NULL,
	[one_yr] [float] NULL,
	[two_yr] [float] NULL,
	[three_yr] [float] NULL,
	[five_yr] [float] NULL,
	[seven_yr] [float] NULL,
	[ten_yr] [float] NULL,
	[twenty_yr] [float] NULL,
	[thirty_yr] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Date_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


