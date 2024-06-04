CREATE DATABASE SCHOOLPROJ
USE SCHOOLPROJ



CREATE TABLE CUSTOMER
(CUSTOMERID INT CONSTRAINT CUSTOMER_ID_PK PRIMARY KEY,
PERSONID INT CONSTRAINT PERSONID_UK UNIQUE,
STOREID INT,
TERRITORYID INT,
ACCOUNTNUMBER INT ,
ROEGUIDE INT ,
MODIFIEDDATE DATE
)

ALTER TERRITORYID
ADD CONSTRAINT TERRITORY_ID_fk FOREIGN KEY (TERRITORYID) REFERENCES SalesTerritory(TerritoryId)

alter TABLE CUSTOMER
alter column ACCOUNTNUMBER INT not null;

alter TABLE CUSTOMER
alter column ROEGUIDE INT not null

alter TABLE CUSTOMER
alter column MODIFIEDDATE DATE not null

alter TABLE customer
drop column ROEGUIDE

alter TABLE customer
ADD RowGuide Uniqueidentifier 


CREATE TABLE SalesTerritory
(TerritoryId INT CONSTRAINT Territory_ID_PK PRIMARY KEY,
NAME VARCHAR (50),
CountryRegionCode VARCHAR (3),
[GROUP] VARCHAR (50),
SalesYTD MONEY,
SalesLastYear MONEY,
CostYTD MONEY,
CostLastYear MONEY,
RowGuide INT  CONSTRAINT RowGuide_UK UNIQUE,
MdifiedDate DATE 
)

alter TABLE SalesTerritory
alter column NAME VARCHAR not null

alter TABLE SalesTerritory
alter column CountryRegionCode VARCHAR not null

alter TABLE SalesTerritory
alter column 
--[GROUP] VARCHAR (50) not null,
--SalesYTD MONEY not null,
--SalesLastYear MONEY not null,
--CostYTD MONEY not null,
--CostLastYear MONEY not null,
MdifiedDate DATE not null;

alter TABLE SalesTerritory

alter column RowGuide INT (RowGuide_UK)   not null

alter TABLE SalesTerritory
ADD CONSTRAINT SalesYTD_fk FOREIGN KEY(SalesYTD) REFERENCES .SalesPerson(SalesYTD)

alter TABLE SalesTerritory
DROP CONSTRAINT RowGuide_UK

alter TABLE SalesTerritory
ALTER COLUMN RowGuide MONEY

alter TABLE SalesTerritory
ALTER COLUMN RowGuide Uniqueidentifier

alter TABLE SalesTerritory
DROP COLUMN RowGuide

alter TABLE SalesTerritory
ADD RowGuide Uniqueidentifier 

CREATE TABLE SalesPerson
(BuisnessEntityId int constraint Buisness_Entity_Id_pk PRIMARY KEY,
TerritoryId INT CONSTRAINT TERRITORYID_fk FOREIGN KEY (TERRITORYID) REFERENCES SalesTerritory(TerritoryId),  
SalesQuota money,
Bunos MONEY NOT NULL,
CommissionPCT SMALLMONEY NOT NULL,
SalesYTD INT NOT NULL,
SalesLastYear MONEY not null,
RowGuide INT  CONSTRAINT RowGuideUK UNIQUE NOT NULL,
MdifiedDate DATE not null
)

ALTER TABLE SalesPerson
ADD  CONSTRAINT  Sales_YTD_UK  UNIQUE (SalesYTD)

ALTER TABLE SalesPerson
DROP CONSTRAINT  Sales_YTD_UK


ALTER TABLE SalesPerson
ALTER COLUMN SalesYTD MONEY

ALTER TABLE SalesPerson
ADD  CONSTRAINT  Sales_YTD_UK  UNIQUE (SalesYTD)

ALTER TABLE SalesPerson
DROP COLUMN MdifiedDate

ALTER TABLE SalesPerson
add ModifiedDate DateTime not null



CREATE TABLE CreditCard
(CreditCardId INT CONSTRAINT Credit_Card_Id_pk PRIMARY KEY,
CardType VARCHAR (50) NOT NULL,
CardNumber VARCHAR (25)NOT NULL,
ExpMonth TINYINT NOT NULL,
ExpYear SMALLINT NOT NULL,
ModifiedDate date NOT NULL,
)

ALTER TABLE CreditCard
ALTER COLUMN ModifiedDate DateTime

ALTER TABLE CreditCard
alter column ModifiedDate DateTime not null

CREATE TABLE SpecialOfferProduct
(SpecialOfferId INT CONSTRAINT Special_Offer_Id_pk PRIMARY KEY ,
ProductId INT CONSTRAINT Product_Id_UK UNIQUE,
RowGuide Uniqueidentifier not null,
ModifiedDate DateTime not null,
)

ALTER TABLE SpecialOfferProduct
alter column ModifiedDate DateTime not null

ALTER TABLE SpecialOfferProduct
alter column RowGuide Uniqueidentifier not null

ALTER TABLE SpecialOfferProduct
drop CONSTRAINT  Product_Id_UK

ALTER TABLE SpecialOfferProduct
alter column ProductId int not null

ALTER TABLE SpecialOfferProduct
drop column ProductId

ALTER TABLE SpecialOfferProduct
ADD ProductId int CONSTRAINT ProductId_UK UNIQUE NOT NULL

ALTER TABLE SpecialOfferProduct
drop column ModifiedDate

ALTER TABLE SpecialOfferProduct
ADD ModifiedDate DATETIME DEFAULT GETDATE() not null




CREATe TABLE SalesOrderHeader
(SalesOrderId INT CONSTRAINT Sales_Order_Id_pk PRIMARY KEY ,
RevisionNumber SMALLINT NOT NULL,
OrderDate DATETIME NOT NULL,
DueDate DATETIME NOT NULL,
ShipDate DATETIME,
[Status] TINYINT NOT NULL,
OnlineOrderFlag BIT NOT NULL,
SalesOrderNumber INT CONSTRAINT Sales_Order_Number_UK UNIQUE NOT NULL,
PurchesOrderNumber INT CONSTRAINT Purches_Order_Number_UK UNIQUE,
AccountNumber VARCHAR (7),
CustomerId INT CONSTRAINT Customer_Id_FK FOREIGN KEY(CustomerId) REFERENCES Customer(CustomerId) NOT NULL,
SalesPersonId INT ,
TerritoryId INT CONSTRAINT TerritoryIdFK FOREIGN KEY(TerritoryId) REFERENCEs SalesTerritory(TerritoryId),
BillToAddressId INT NOT NULL,
ShipToAddressId INT NOT NULL,
ShipMethodId INT CONSTRAINT Ship_MethodId_FK FOREIGN KEY (ShipMethodId) REFERENCES ShipMethod(ShipMethodId) NOT NULL,
CreditCardId INT CONSTRAINT Credit_Card_Id_FK FOREIGN KEY(CreditCardId) REFERENCES CreditCard(CreditCardId),
CreditCardApprovalCode VARCHAR (15),
CurrencyRateId INT CONSTRAINT Currency_Rate_Id_FK FOREIGN KEY(CurrencyRateId) REFERENCES CurrencyRate(CurrencyRateId),
SubTotal MONEY NOT NULL,
TaxAmt MONEY NOT NULL,
Freight MONEY NOT NULL,
)

ALTER TABLE SalesOrderHeader
ADD AddressId INT CONSTRAINT Address_Id_FK FOREIGN KEY (AddressId) REFERENCES  [Person.Address] (AddressId) 

ALTER TABLE SalesOrderHeader
ADD BuisnessEntityId INT CONSTRAINT Buisness_Entity_Id_FK FOREIGN KEY (BuisnessEntityId) REFERENCES  [SalesPerson] (BuisnessEntityId)

CREATE TABLE ShipMethod
(ShipMethodId INT CONSTRAINT Ship_Method_Id_pk PRIMARY KEY ,
Name NVARCHAR (50) NOT NULL,
ShipBase  MONEY NOT NULL,
ShipRate MONEY NOT NULL,
RowGuide UNIQUEIDENTIFIER not null,
ModifiedDate DATETIME DEFAULT GETDATE() not null,
)




 CREATE TABLE CurrencyRate
(CurrencyRate INT CONSTRAINT Currency_Rate_Id_pk PRIMARY KEY,
CurrencyRateDate DATETIME DEFAULT GETDATE() NOT NULL,
FromCurrencyCode NCHAR (3) NOT NULL,
ToCurrencyCode NCHAR (3) NOT NULL,
AverageRate MONEY NOT NULL, 
EndOfDayRate MONEY NOT NULL,
ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
)

DROP TABLE CurrencyRate

 CREATE TABLE CurrencyRate
(CurrencyRateId INT CONSTRAINT Currency_Rate_Id_pk PRIMARY KEY,
CurrencyRateDate DATETIME DEFAULT GETDATE() NOT NULL,
FromCurrencyCode NCHAR (3) NOT NULL,
ToCurrencyCode NCHAR (3) NOT NULL,
AverageRate MONEY NOT NULL, 
EndOfDayRate MONEY NOT NULL,
ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
)



CREATE TABLE SalesOrderDetail
(SalesOrderDetailId INT CONSTRAINT Sales_Order_Detail_Id_pk PRIMARY KEY,
SalesOrderId INT CONSTRAINT Sales_Order_Id_FK FOREIGN KEY (SalesOrderId) REFERENCES SalesOrderHeader(SalesOrderId) NOT NULL,
CarrierTrackingNumber VARCHAR (25),
OrderQty SMALLINT NOT NULL,
ProductId INT CONSTRAINT ProductIdUK UNIQUE NOT NULL,
SpecialOfferId INT CONSTRAINT Special_Offer_Id_FK FOREIGN KEY (SpecialOfferId) REFERENCES  SpecialOfferProduct(SpecialOfferId) NOT NULL,
UnitPrice MONEY NOT NULL,
UnitPriceDiscount MONEY NOT NULL,
LineTotal INT NOT NULL,
RowGuide UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
)



CREATE TABLE [Person.Address]
(AddressId int CONSTRAINT Address_Id_PK PRIMARY KEY,
AddressLine1 VARCHAR(60) NOT NULL,
AddressLine2 VARCHAR(60),
City VARCHAR (25) NOT NULL,
StateProvinceId INT NOT NULL,
PostalCode NVARCHAR (15) NOT NULL,
SpatialLocation GEOGRAPHY,
RowGuide UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
)
