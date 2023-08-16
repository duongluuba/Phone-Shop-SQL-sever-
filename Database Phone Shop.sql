
USE [master]
GO

/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Phone_Shop')
BEGIN
	ALTER DATABASE [Phone_Shop] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [Phone_Shop] SET ONLINE;
	DROP DATABASE [Phone_Shop];
END

GO

CREATE DATABASE Phone_Shop
GO



USE Phone_Shop
GO

/*******************************************************************************
	Drop tables if exists
*******************************************************************************/
DECLARE @sql nvarchar(MAX) 
SET @sql = N'' 

SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(KCU1.TABLE_SCHEMA) 
    + N'.' + QUOTENAME(KCU1.TABLE_NAME) 
    + N' DROP CONSTRAINT ' -- + QUOTENAME(rc.CONSTRAINT_SCHEMA)  + N'.'  -- not in MS-SQL
    + QUOTENAME(rc.CONSTRAINT_NAME) + N'; ' + char(13) + char(10) 
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC 

INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU1 
    ON KCU1.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG  
    AND KCU1.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA 
    AND KCU1.CONSTRAINT_NAME = RC.CONSTRAINT_NAME 

EXECUTE(@sql) 

GO
DECLARE @sql2 nvarchar(max)=''

SELECT @sql2 += ' Drop table ' + QUOTENAME(TABLE_SCHEMA) + '.'+ QUOTENAME(TABLE_NAME) + '; '
FROM   INFORMATION_SCHEMA.TABLES
WHERE  TABLE_TYPE = 'BASE TABLE'

Exec Sp_executesql @sql2 
GO 

-- Create Table


create table [ProducingCountry]
(	
	[PcID] nvarchar(10) NOT NULL ,
	[PcName] nvarchar(20) NOT NULL,
	PRIMARY KEY (PcID) 
)
go

create table [Manufacture]
(	
	[ManID] nvarchar(20) NOT NULL , 
	[ManName] nvarchar(20) NOT NULL,
	[PcID] nvarchar(10) NOT NULL,
	PRIMARY KEY (ManID),
	foreign key([PcID]) references [dbo].[ProducingCountry]
)
go

create table [Phone]
(	
	[PhoneID] nvarchar(20) NOT NULL primary key ,
	[PhoneName] nvarchar(20) NOT NULL,
	[ManID] nvarchar(20) NOT NULL ,
	[Quantity] int CHECK ([Quantity]>0),
	[ImportPrice] int CHECK ([ImportPrice]>0),
	[Ram] nvarchar(30) NOT NULL,
	[Chip] nvarchar(50) NOT NULL,
	[Year] decimal(4,0) NOT NULL
	foreign key([ManID]) references [dbo].[Manufacture]
)
go

create table [User]
(
	[UserID] nvarchar(10) NOT NULL primary key,
	[UserName] nvarchar(30) NOT NULL,
	[Phone] nvarchar(20) NULL,
	[Address] nvarchar(250)  NULL,
	[Email] nvarchar(50) NULL
)
go

create table [dbo].[Order]
(
	[OrderID] int NOT NULL PRIMARY KEY (OrderID) ,
	[UserID] nvarchar(10)  FOREIGN KEY REFERENCES [User](UserID), 
	[OrderDate] datetime CHECK([OrderDate]<getdate())

)
go

create table [dbo].[OrderDetail]
(
	[OrderID] int NOT NULL FOREIGN KEY REFERENCES [Order](OrderID),
	[PhoneID] nvarchar(20)  NOT NULL FOREIGN KEY REFERENCES [Phone](PhoneID),
	PRIMARY KEY (OrderID, [PhoneID]),
	[Quantity] int CHECK ([Quantity]>0),
	[Price] int

)
go


create table [dbo].[Evaluat]
(
	[UserID] nvarchar(10) NOT NULL references [dbo].[User](UserID),
	[PhoneID] nvarchar(20) NOT NULL references [dbo].[Phone](PhoneID),
	[Comment] nvarchar(50) ,
	[Rate] int ,
	[Date] date,
	check([Rate] >= 1 AND [Rate] <= 5),
	CONSTRAINT ID_Evaluat PRIMARY KEY (UserID, PhoneID) 
)
go


-- INSERT into data

-- data table [ProducingCountry]
INSERT into [dbo].[ProducingCountry] ([PcID], [PcName]) VALUES (N'A1', N'AMERICA')
INSERT into [dbo].[ProducingCountry] ([PcID], [PcName]) VALUES (N'J1', N'JAPAN')
INSERT into [dbo].[ProducingCountry] ([PcID], [PcName]) VALUES (N'C1', N'China')


-- data table Manufacture
INSERT into [dbo].[Manufacture] ([ManID], [ManName],[PcID]) VALUES (N'IPHONE', N'APPLE', N'A1')
INSERT into [dbo].[Manufacture] ([ManID], [ManName],[PcID]) VALUES (N'SAMSUNG', N'Samsung technology', N'J1')
INSERT into [dbo].[Manufacture] ([ManID], [ManName],[PcID]) VALUES (N'OPPO', N'Oppo technology', N'J1')
INSERT into [dbo].[Manufacture] ([ManID], [ManName],[PcID]) VALUES (N'XIAOMI', N'Xiaomi technology', N'C1')
INSERT into [dbo].[Manufacture] ([ManID], [ManName],[PcID]) VALUES (N'HUAWEI', N'Hawei technology', N'C1')


--data table Phone
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP18', N'iPhone 14 Pro Max', N'IPHONE', 20, 1500, N'512GB', N'APPLE A23', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP17', N'iPhone 14 Pro Max', N'IPHONE', 18, 1300, N'256GB', N'APPLE A23', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP16', N'iPhone 14 Pro Max', N'IPHONE', 9, 1100, N'128GB', N'APPLE A23', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP15', N'iPhone 14 Pro', N'IPHONE', 15, 1400, N'512GB', N'APPLE A23', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP14', N'iPhone 14 Pro', N'IPHONE', 5, 1100, N'256GB', N'APPLE A23', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP13', N'iPhone 14 Pro', N'IPHONE', 4, 1000, N'128GB', N'APPLE A23', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP12', N'iPhone 14', N'IPHONE', 4, 1000, N'512GB', N'APPLE A23', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP11', N'iPhone 14', N'IPHONE', 5, 820, N'256GB', N'APPLE A23', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP10', N'iPhone 14', N'IPHONE', 7, 750, N'128GB', N'APPLE A23', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP9', N'iPhone 13 Pro Max', N'IPHONE', 8, 1000, N'512GB', N'APPLE A21', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP8', N'iPhone 13 Pro Max', N'IPHONE', 6, 800, N'256GB', N'APPLE A21', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP7', N'iPhone 13 Pro Max', N'IPHONE', 2, 650, N'128GB', N'APPLE A21', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP6', N'iPhone 13 Pro', N'IPHONE', 9, 950, N'512GB', N'APPLE A21', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP5', N'iPhone 13 Pro', N'IPHONE', 8, 750, N'256GB', N'APPLE A21', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP4', N'iPhone 13 Pro', N'IPHONE', 10, 700, N'128GB', N'APPLE A21', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP3', N'iPhone 13', N'IPHONE', 8, 820, N'256GB', N'APPLE A21', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP2', N'iPhone 12 Pro Max', N'IPHONE', 8, 820, N'256GB', N'APPLE A20', '2021')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'IP1', N'iPhone 12 Pro ', N'IPHONE', 8, 750, N'256GB', N'APPLE A20', '2021')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'SS6', N'SamSung S23 ', N'SAMSUNG', 8, 1500, N'512GB', N'Exynos 3', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'SS5', N'SamSung S23 ', N'SAMSUNG', 6, 1300, N'256GB', N'Exynos 3', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'SS4', N'SamSung S22 ', N'SAMSUNG', 12, 1000, N'512GB', N'Exynos 2', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'SS3', N'SamSung S22 ', N'SAMSUNG', 2, 850, N'256GB', N'Exynos 2', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'SS2', N'SamSung S21 ', N'SAMSUNG', 14, 750, N'512GB', N'Exynosn 1', '2021')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'SS1', N'SamSung S21 ', N'SAMSUNG', 4, 550, N'256GB', N'Exynos 1', '2021')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'O2', N'Oppo 1', N'OPPO', 12, 1400 , N'512GB', N'MediaTek Helio G33', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'O1', N'Oppo 12', N'OPPO', 12, 700 , N'128GB', N'MediaTek Helio G31', '2021')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'X4', N'Xiaomi 13', N'XIAOMI', 24, 1600, N'512GB', N'Snapdragon 3', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'X3', N'Xiaomi 13', N'XIAOMI', 4, 1300, N'256GB', N'Snapdragon 3', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'X2', N'Xiaomi 12', N'XIAOMI', 3, 1000 , N'512GB', N'Snapdragon 2', '2022')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'X1', N'Xiaomi 11', N'XIAOMI', 7, 800 , N'512GB', N'Snapdragon 1', '2021')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'H2', N'Huawei 14', N'HUAWEI', 12, 1400 , N'512GB', N'Huawei H3', '2023')
INSERT into [dbo].[Phone] ([PhoneID], [PhoneName], [ManID], [Quantity], [ImportPrice], [Ram], [Chip], [Year]) VALUES (N'H1', N'Huawei 13', N'HUAWEI', 4, 1000 , N'256GB', N'Huawei H2', '2022')


-- data taable [User]
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE172166', N'DuongLBQ', N'0366724688', N'Hà Nội', N'DuongLBQ@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE171288', N'HuyND', N'0366723850', N'Hà Nội', N'HuyND@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE176441', N'TruongNV', N'038765432',N'Hà Giang', N'TruongNV@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE170469', N'VuTT', N'039876543', N'Hà Nội', N'VuTT@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE176869', N'TuanMQ',N'092345678',N'Trại Cai Nghiện', N'TuanMQ@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE171758', N'ToanDX', N'033456789', N'Hà Nội', N'ToanDX@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE172666', N'ThangPQ', N'034567890', N'Hồ Chí Minh', N'ThangPQ@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE173144', N'NamNH', N'035678901', N'Thừa Thiên Huế', N'NamNH@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE173162', N'AnhVV', N'036789012', N'Thanh Hóa', N'AnhVV@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE171793', N'SonBM', N'037890123', N'Thái Bình', N'SonBM@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE176489', N'LinhTK', N'030123456', N'Hồ Chí Minh', N'LinhTK@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE161130', N'ManhNX', N'038976541', N'Hải Phòng', N'ManhNX@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE170047', N'NgaNTT', N'039865432', N'Đà Nẵng', N'NgaNTT@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HS173453', N'DinhNT', N'031234567', N'Thái Bình', N'DinhNT@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE170208', N'DatNT', N'033567890', N'Sài Gòn', N'DatNT@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE162999', N'ThanhLB', N'033456789', N'Hồ Chí Minh', N'ThanhLB@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE181868', N'VinhPQ', N'037901234', N'Hà Giang', N'VinhPQ@gmail.fpt.edu')
INSERT into [dbo].[User] ([UserID], [UserName], [Phone] , [Address] , [Email] ) VALUES (N'HE170136', N'SonNT', N'031345678', N'Hải Phòng', N'SonNT@gmail.fpt.edu')

-- data table Order
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (01, N'HE172166', CAST(N'2021-01-11' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (02, N'HE171288', CAST(N'2021-02-24' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (03, N'HE176441', CAST(N'2021-03-13' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (04, N'HE170469', CAST(N'2021-04-21' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (05, N'HE171758', CAST(N'2021-05-21' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (06, N'HE172666', CAST(N'2021-06-21' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (07, N'HE176869', CAST(N'2021-07-04' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (08, N'HE173144', CAST(N'2021-08-07' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (09, N'HE171793', CAST(N'2021-09-16' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (10, N'HE173162', CAST(N'2021-10-21' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (11, N'HE172166', CAST(N'2022-01-07' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (12, N'HE173144', CAST(N'2022-02-23' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (13, N'HE171793', CAST(N'2022-03-06' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (14, N'HE161130', CAST(N'2022-04-07' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (15, N'HE171793', CAST(N'2023-01-12' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (16, N'HS173453', CAST(N'2023-02-15' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (17, N'HE170047', CAST(N'2023-03-25' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (18, N'HE176489', CAST(N'2023-04-27' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (19, N'HE170208', CAST(N'2023-05-19' AS Date))
INSERT into [dbo].[Order] ([OrderID], [UserID], [OrderDate]) VALUES (20, N'HE170136', CAST(N'2023-06-20' AS Date))


-- data Ordertail
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (01, N'X1', 1, 850)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (02, N'SS1', 1, 600)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (03, N'SS1', 1, 600)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (04, N'IP2', 1,870)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (05, N'IP1', 1,800)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (06, N'IP2', 1,870)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (07, N'O1', 1,750)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (08, N'IP2', 1,870)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (09, N'X1', 1,850)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (10, N'SS2', 1,800)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (11, N'IP4', 1,750) 
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (12, N'IP8', 1,850)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (13, N'IP5', 1,800)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (14, N'O1', 1,750)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (15, N'SS2', 2, 800)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (16, N'IP18', 1, 1550)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (17, N'IP15', 1, 1450)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (18, N'X4', 1, 1650)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (19, N'SS5', 1, 1350)
INSERT into [dbo].[OrderDetail] ([OrderID], [PhoneID], [Quantity], [Price]) VALUES (20, N'H2', 2, 1450)



-- data evaluat
INSERT into [dbo].[Evaluat] ([UserID], [PhoneID], [Comment], [Rate],[Date]) VALUES (N'HE172166', N'X1', N'I love this phone shop', 5, CAST(N'2023-02-2' AS Date))
INSERT into [dbo].[Evaluat] ([UserID], [PhoneID], [Comment], [Rate],[Date]) VALUES (N'HE171288', N'SS1',N'I do not love this phone shop', 2, CAST(N'2023-04-24' AS Date))
INSERT into [dbo].[Evaluat] ([UserID], [PhoneID], [Comment], [Rate],[Date]) VALUES (N'HE176441', N'SS1',N'I love this phone shop', 5, CAST(N'2023-01-21' AS Date))
INSERT into [dbo].[Evaluat] ([UserID], [PhoneID], [Comment], [Rate],[Date]) VALUES (N'HE170469', N'IP2',N'I love this phone shop', 4, CAST(N'2022-10-21' AS Date))
INSERT into [dbo].[Evaluat] ([UserID], [PhoneID], [Comment], [Rate],[Date]) VALUES (N'HE171758', N'IP1',N'I love this phone shop', 5, CAST(N'2021-06-21' AS Date))
INSERT into [dbo].[Evaluat] ([UserID], [PhoneID], [Comment], [Rate],[Date]) VALUES (N'HE172666', N'IP2',N'I love this phone shop', 3, CAST(N'2020-08-21' AS Date))
INSERT into [dbo].[Evaluat] ([UserID], [PhoneID], [Comment], [Rate],[Date]) VALUES (N'HE176869', N'O1',N'I love this phone shop', 5, CAST(N'2023-07-26' AS Date))
INSERT into [dbo].[Evaluat] ([UserID], [PhoneID], [Comment], [Rate],[Date]) VALUES (N'HE173144', N'IP2',N'I love this phone shop', 4, CAST(N'2021-09-07' AS Date))
