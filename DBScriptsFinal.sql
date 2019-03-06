CREATE DATABASE MyCoderDB
GO
USE MyCoderDB
GO


IF OBJECT_ID('Users')  IS NOT NULL
DROP TABLE Users
GO
IF OBJECT_ID('Project')  IS NOT NULL
DROP TABLE Project
GO
IF OBJECT_ID('PaymentDetails')  IS NOT NULL
DROP TABLE PaymentDetails
GO
IF OBJECT_ID('Coder')  IS NOT NULL
DROP TABLE Coder
GO
IF OBJECT_ID('Buyer')  IS NOT NULL
DROP TABLE Buyer
GO
IF OBJECT_ID('Rating')  IS NOT NULL
DROP TABLE Rating
GO
IF OBJECT_ID('Enroll')  IS NOT NULL
DROP TABLE Enroll
GO
IF OBJECT_ID('Auction')  IS NOT NULL
DROP TABLE Auction
GO
IF OBJECT_ID('ProjectFeedback')  IS NOT NULL
DROP TABLE ProjectFeedback
GO
IF OBJECT_ID('ProjectDetails')  IS NOT NULL
DROP TABLE ProjectDetails
GO
IF OBJECT_ID('UserFeedback')  IS NOT NULL
DROP TABLE UserFeedback
GO



CREATE TABLE Users
(
	[UserId] INT PRIMARY KEY IDENTITY, 
	[EmailId] VARCHAR(50) unique NOT NULL,
	[UserPassword] VARCHAR(15) NOT NULL,
	[Role] VARCHAR(50) not null,
	[ApprovalStatus] tinyint default 0,
	[AccountStatus] tinyint default 1
	
)
GO

CREATE TABLE Buyer
(
	[BuyerId] INT PRIMARY KEY IDENTITY,
	[UserID] INT REFERENCES Users(UserId) NOT NULL,
	[BuyerName] VARCHAR(30) NOT NULL,
	[PhoneNumber] NUMERIC(10) NOT NULL,
	[Country] VARCHAR(50) NOT NULL,
	[Exchange] int
)

CREATE TABLE Project
(
	[ProjectId] INT  PRIMARY KEY identity(100,1),
	[ProjectName] VARCHAR(50)  UNIQUE NOT NULL,
	[ProjDescription] VARCHAR(500) NOT NULL,
	[BuyerId] INT  REFERENCES Buyer(BuyerId),
	[TechnicalDescription] VARCHAR(50)  NOT NULL,
	[Duration] SMALLDATETIME NOT NULL,
	[Status] VARCHAR(15) NOT NULL
)
GO

CREATE TABLE Coder
(
	[CoderId] INT PRIMARY KEY IDENTITY,
	[UserID] INT REFERENCES Users(UserId) NOT NULL,
	[CoderName]  VARCHAR(30) NOT NULL,
	[ProjectId] INT REFERENCES Project(ProjectId),
	[BuyerId] INT  REFERENCES Buyer(BuyerId),
	[PhoneNumber] NUMERIC(10) NOT NULL,
	[LanguageProficiency] VARCHAR(50)  NOT NULL,
	[Country] VARCHAR(50) NOT NULL
	
	
)
GO


CREATE TABLE PaymentDetails
(
	[PaymentId] BIGINT PRIMARY KEY IDENTITY(1000,1),
	[ProjectId] INT REFERENCES Project(ProjectId)NOT NULL,
	[PayeeId] int references users(UserId)NOT NULL,
	[PayerId] int references users(UserId)NOT NULL,
	[DateOfPayment] SMALLDATETIME  NOT NULL
)
GO


CREATE TABLE ProjectFeedback
(
	FeedbackId int primary key identity,
	[ProjectId] INT references Project(ProjectId)NOT NULL ,
	[ProjectName] VARCHAR(50) references Project(ProjectName)NOT NULL,
	[CoderId] INT  REFERENCES Coder(CoderId)NOT NULL,
	[Feedback] VARCHAR(500)NOT NULL
	
	
)
GO

CREATE TABLE Enroll
(
	EnrollId int primary key identity,
	[ProjectId] INT references Project(ProjectId)NOT NULL ,
	[ProjectName] VARCHAR(50) references Project(ProjectName)NOT NULL,
	[CoderId] INT  REFERENCES Coder(CoderId)
)
GO


CREATE TABLE Rating
(
	[UserId] INT references Users(UserId) primary key,
	[Ratings] DECIMAL(2,1) CHECK(Ratings between 0 and 10) default 0,
	[NoOfRatings] BIGINT default 0
)
GO
CREATE TABLE Auction
(
	AuctionId INT primary key IDENTITY,
	CoderId INT REFERENCES Users(UserId) NOT NULL, 
	NoOfBuyers INT default 0,
	BidHolder INT  REFERENCES Users(UserId),
	FinalPrice BIGINT default 20000
)


GO
CREATE TABLE ProjectDetails
(
 ProjectDetailsId int primary key identity, 
 [ProjectId] INT references Project(ProjectId)NOT NULL ,
 CoderId INT REFERENCES Coder(CoderId) NOT NULL,
 CoderName varchar(30) not null
)
GO

CREATE TABLE UserFeedback
(
 UserFeedbackId int primary key identity,
 FromUserId INT references Users(UserId) ,
 ToUserId INT references Users(UserId) ,
 FeedBackOfUser  VARCHAR(250) 
)
GO
 --rating calculation procedure
create procedure usp_calculate_rating
(
	@new_rating decimal(2,1),
	@user_id int
)
as	
begin
	declare @rating decimal(2,1)
	declare @count int
	select  @rating=Ratings,@count=NoOfRatings from Rating where UserId=@user_id
	set @rating=(@count*@rating+@new_rating)/(@count+1)
	update Rating set ratings=@rating,NoOfRatings=@count+1 where UserId=@user_id
end

GO


--1.insertion scripts for Users

INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('madhu@gmail.com', 'Madhu@100','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('kirusaruv@gmail.com', 'Kiru@9899','Buyer')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('mugilan@gmail.com', 'Mugil@1997','Admin')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('karthikeyan@gmail.com', 'Karthi@100','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('abinaya@gmail.com', 'Abhi@101','Buyer')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('rengasri@gmail.com', 'Renga@102','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('pranesh@gmail.com', 'Prans@103','Buyer')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('jilly@gmail.com', 'jilly@103','Coder')

INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('jones@gmail.com', 'Abhi@101','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('james@gmail.com', 'Renga@102','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('john@gmail.com', 'Prans@103','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('don@gmail.com', 'jilly@103','Coder')

INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('akash@gmail.com', 'Abhi@101','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('riya@gmail.com', 'Renga@102','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('reena@gmail.com', 'Prans@103','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('deepa@gmail.com', 'jilly@103','Coder')
INSERT INTO Users ([EmailId], [UserPassword],[Role]) VALUES ('deepak@gmail.com', 'deepak@103','Coder')

select * from Users



--2.insertion scripts for Buyer

INSERT INTO Buyer ([UserID], [BuyerName],[PhoneNumber],[Country]) VALUES (2, 'Kiruthika',9003322203,'India')
INSERT INTO Buyer ([UserID], [BuyerName],[PhoneNumber],[Country],[Exchange]) VALUES (5, 'Abhinaya',9947123658,'India',3)
INSERT INTO Buyer ([UserID], [BuyerName],[PhoneNumber],[Country]) VALUES (7, 'Pranesh',8126479514,'Canada')
select * from Buyer


--3.insertion scripts for project--
 Insert into Project([ProjectName],[ProjDescription],[BuyerId],[TechnicalDescription],[Duration],[Status]) values('QuickKart','It is an online shopping application which enables customers to buy products',1,'.Net Core','2019-04-15 12:00:00','Not Started')
 Insert into Project([ProjectName],[ProjDescription],[BuyerId],[TechnicalDescription],[Duration],[Status]) values('CureWell','This project gives brief information about doctors and their availability which eases the appointment booking process for the patients ',2,'Python','2019-10-17 12:00:00','In Progress')
 Insert into Project([ProjectName],[ProjDescription],[BuyerId],[TechnicalDescription],[Duration],[Status]) values('EasyBasket','This project focuses on door-to-door delivery of groceries and other goods to customers through online purchase',3,'Java','2019-02-04 12:00:00','Completed')
 Insert into Project([ProjectName],[ProjDescription],[BuyerId],[TechnicalDescription],[Duration],[Status]) values('MarketBilling','This project focuses on billing system that eases the work of biller',3,'Java','2019-10-20 12:00:00','In Progress')

 select * from Project

 --4.coder

 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(4,101,'Karthikeyan',2,8446821749,'python','singapore')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(6,102,'Rengasri',3,9546821289,'java','japan')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(8,102,'Jilly',3,9754624657,'java','canada')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(1,101,'Madullika',2,8874821859,'python','india')

 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(9,101,'jones',2,8446821749,'python','singapore')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(10,102,'James',3,9546821289,'java','japan')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(11,102,'John',3,9754624657,'java','canada')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(12,101,'Don',2,8874821859,'python','india')
 
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(13,101,'Akash',2,8446821749,'python','singapore')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(14,102,'Riya',3,9546821289,'java','japan')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(15,102,'Reena',3,9754624657,'java','canada')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(16,101,'Deepa',2,8874821859,'python','india')
 insert into coder([UserID],[ProjectId],[CoderName],[BuyerID],[PhoneNumber],[LanguageProficiency],[Country]) values(17,103,'Deepak',3,8874821859,'java','india')
 

 --drop table Coder




 select * from coder
 --5.ProjectFeedback
 insert into ProjectFeedback([ProjectId],[ProjectName],[CoderId],[Feedback]) values (101,'CureWell',1,'bad')
 insert into ProjectFeedback([ProjectId],[ProjectName],[CoderId],[Feedback]) values (102,'EasyBasket',2,'ok')
 insert into ProjectFeedback([ProjectId],[ProjectName],[CoderId],[Feedback]) values (102,'EasyBasket',3,'good')

 --drop table ProjectFeedback

  select * from ProjectFeedback

--6.Enroll
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (101,'CureWell',1)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (101,'CureWell',4)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (102,'EasyBasket',2)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (102,'EasyBasket',3)


insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (101,'CureWell',5)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (102,'EasyBasket',6)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (102,'EasyBasket',7)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (101,'CureWell',8)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (101,'CureWell',9)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (102,'EasyBasket',10)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (102,'EasyBasket',11)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (101,'CureWell',12)
insert into Enroll([ProjectId],[ProjectName],[CoderId]) values (103,'MarketBilling',12)


select * from Enroll
 --drop table Enroll
--7.Rating
insert into Rating([UserId]) values (1)
insert into Rating([UserId]) values (2)
insert into Rating([UserId]) values (3)
insert into Rating([UserId]) values (4)
insert into Rating([UserId]) values (5)
insert into Rating([UserId],[Ratings],[NoOfRatings]) values (6,8,1)
insert into Rating([UserId],[Ratings],[NoOfRatings]) values (7,7,1)
insert into Rating([UserId],[Ratings],[NoOfRatings]) values (8,7,1)

select * from Rating
--drop table Rating

--8.Auction
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(1,2,2,40000)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(2,1,3,42500)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(3,1,3,41250)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(4,1,2,41000)

insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(5,3,2,70000)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(6,4,3,22500)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(7,2,3,81250)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(8,6,2,61000)

insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(9,2,2,60000)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(10,3,3,50500)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(11,4,3,21250)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(12,2,2,16000)
insert into Auction(CoderId,NoOfBuyers,BidHolder,FinalPrice) values(13,2,3,17000)

select * from Auction
 --drop table Auction

 --insertion scripts for paymentDetails--
 Insert into PaymentDetails([ProjectId],[PayeeId],[PayerId],[DateOfPayment]) values(102,2,3,'2019-02-06 12:00:00')
 Insert into PaymentDetails([ProjectId],[PayeeId],[PayerId],[DateOfPayment]) values(102,3,3,'2019-02-06 12:00:00')

  Insert into PaymentDetails([ProjectId],[PayeeId],[PayerId],[DateOfPayment]) values(102,6,3,'2019-02-06 12:00:00')
  Insert into PaymentDetails([ProjectId],[PayeeId],[PayerId],[DateOfPayment]) values(102,7,3,'2019-02-06 12:00:00')
  Insert into PaymentDetails([ProjectId],[PayeeId],[PayerId],[DateOfPayment]) values(102,10,3,'2019-02-06 12:00:00')
  Insert into PaymentDetails([ProjectId],[PayeeId],[PayerId],[DateOfPayment]) values(102,11,3,'2019-02-06 12:00:00')

  

   select* from PaymentDetails
 --drop table PaymentDetails

 --insertion scripts for projectDetails--
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(101,1,'Karthikeyan')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(101,4,'Madullika')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(102,2,'Rengasri')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(102,3,'Jilly')

 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(101,5,'jones')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(102,6,'James')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(102,7,'John')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(101,8,'Don')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(101,9,'Akash')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(102,10,'Riya')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(102,11,'Reena')
 Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(101,12,'Deepa')
  Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(102,1,'Karthikeyan')
  Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(102,4,'Madullika')
   Insert into ProjectDetails(ProjectId,CoderId,CoderName) values(103,13,'Deepak')
 select * from ProjectDetails

 --drop table ProjectDetails
 Insert into UserFeedback(FromUserId,ToUserId,FeedBackOfUser) values(4,5,'good')
Insert into UserFeedback(FromUserId,ToUserId,FeedBackOfUser) values(5,4,'very good')
Insert into UserFeedback(FromUserId,ToUserId,FeedBackOfUser) values(6,7,'good')
Insert into UserFeedback(FromUserId,ToUserId,FeedBackOfUser) values(7,6,'good')
Insert into UserFeedback(FromUserId,ToUserId,FeedBackOfUser) values(8,7,'very good')


select * from UserFeedback


 
 
