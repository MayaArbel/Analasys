CREATE DATABASE ForRetail
USE ForRetail



CREATE TABLE CUSTOMER
(CUSTOMERID INT CONSTRAINT CUSTOMER_ID_PK PRIMARY KEY,
PERSONID INT CONSTRAINT PERSONID_UK UNIQUE,
STOREID INT,
TERRITORYID INT CONSTRAINT TERRITORY_ID_fk FOREIGN KEY (TERRITORYID) REFERENCES SalesTerritory(TerritoryId),
ACCOUNTNUMBER INT NOT NULL,
ROWGUIDE Uniqueidentifier,
MODIFIEDDATE DATE NOT NULL
)
 


CREATE TABLE SalesTerritory
(TerritoryId INT CONSTRAINT Territory_ID_PK PRIMARY KEY,
NAME VARCHAR (50) NOT NULL,
CountryRegionCode VARCHAR (3) NOT NULL,
[GROUP] VARCHAR (50) NOT NULL,
SalesLastYear MONEY NOT NULL,
CostYTD MONEY NOT NULL,
CostLastYear MONEY NOT NULL,
RowGuide INT CONSTRAINT RowGuide_UK UNIQUE NOT NULL,
MdifiedDate DATE NOT NULL
)

alter table SalesTerritory
add SalesYTD MONEY CONSTRAINT SalesYTD_fk FOREIGN KEY(SalesYTD) REFERENCES .SalesPerson(SalesYTD)
NOT NULL


CREATE TABLE SalesPerson
(BuisnessEntityId int constraint Buisness_Entity_Id_pk PRIMARY KEY,
TerritoryId INT CONSTRAINT TERRITORYID_fk FOREIGN KEY (TERRITORYID) REFERENCES SalesTerritory(TerritoryId),  
SalesQuota money,
Bunos MONEY NOT NULL,
CommissionPCT SMALLMONEY NOT NULL,
SalesYTD MONEY CONSTRAINT  Sales_YTD_UK UNIQUE NOT NULL,
SalesLastYear MONEY not null,
RowGuide Uniqueidentifier NOT NULL,
MdifiedDate DATETIME not null
)



CREATE TABLE CreditCard
(CreditCardId INT CONSTRAINT Credit_Card_Id_pk PRIMARY KEY,
CardType VARCHAR (50) NOT NULL,
CardNumber VARCHAR (25)NOT NULL,
ExpMonth TINYINT NOT NULL,
ExpYear SMALLINT NOT NULL,
ModifiedDate DATETIME NOT NULL,
)



CREATE TABLE SpecialOfferProduct
(SpecialOfferId INT CONSTRAINT Special_Offer_Id_pk PRIMARY KEY ,
ProductId INT CONSTRAINT Product_Id_UK UNIQUE NOT NULL,
RowGuide Uniqueidentifier not null,
ModifiedDate DateTime DEFAULT GETDATE() not null,
)




CREATe TABLE SalesOrderHeader
(SalesOrderId INT CONSTRAINT Sales_Order_Id_pk PRIMARY KEY,
AddressId INT CONSTRAINT Address_Id_FK FOREIGN KEY (AddressId) REFERENCES [Person.Address] (AddressId),
BuisnessEntityId INT CONSTRAINT Buisness_Entity_Id_FK FOREIGN KEY (BuisnessEntityId) REFERENCES  [SalesPerson] (BuisnessEntityId),
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



CREATE TABLE ShipMethod
(ShipMethodId INT CONSTRAINT Ship_Method_Id_pk PRIMARY KEY ,
Name NVARCHAR (50) NOT NULL,
ShipBase  MONEY NOT NULL,
ShipRate MONEY NOT NULL,
RowGuide UNIQUEIDENTIFIER not null,
ModifiedDate DATETIME DEFAULT GETDATE() not null,
)




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
