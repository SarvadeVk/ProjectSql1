

--Capstone Project

CREATE DATABASE MovieGO --Database

--******************Tables*******************

CREATE TABLE TheaterDetails
(
TheaterId INT CONSTRAINT pk_theaterid PRIMARY KEY IDENTITY(1,1),
TheaterName VARCHAR(50) NOT NULL,
Location VARCHAR(50) NOT NULL
)
INSERT INTO TheaterDetails VALUES ('PVR','Pune') , ('Inox','Delhi')
SELECT * FROM TheaterDetails

CREATE TABLE ShowDetails(
ShowId INT CONSTRAINT pk_showid PRIMARY KEY IDENTITY(1001,1),
TheaterId INT CONSTRAINT fk_theaterid REFERENCES TheaterDetails(TheaterId) NOT NULL,
ShowDate DATE NOT NULL,
ShowTime TIME NOT NULL,
MovieName VARCHAR(50) NOT NULL,
TicketCost DECIMAL(6,2) NOT NULL,
TicketsAvailable INT NOT NULL)

INSERT INTO ShowDetails VALUES
(2,'28-May-2018','14:30','Avengers',250.00,100),
(2,'30-May-2018','17:30','Hit Man',200.00,150)
SELECT * FROM ShowDetails

CREATE TABLE Users(
UserId VARCHAR(50) CONSTRAINT pk_userid PRIMARY KEY,
UserName VARCHAR(50) NOT NULL,
Password VARCHAR(50) NOT NULL,
Age INT NOT NULL,
Gender CHAR(1) CONSTRAINT ck_gender CHECK(Gender IN('M','F')),
EmailId VARCHAR(50) CONSTRAINT uk_emailid UNIQUE,
PhoneNumber NUMERIC(10) NOT NULL)

INSERT INTO Users VALUES ('mary_potter','Mary Potter','Mary@123',25,'F','mary_p@gmail.com',9786543211)
INSERT INTO Users VALUES ('jack_sparrow','Jack Sparrow','Spar78!jack',28,'M','jack_spa@yahoo.com',7865432102)
SELECT * FROM Users

CREATE TABLE BookingDetails(
BookingId VARCHAR(5) CONSTRAINT pk_bookingid PRIMARY KEY,
UserID VARCHAR(50) CONSTRAINT fk_userid REFERENCES Users(userId) NOT NULL,
ShowId INT CONSTRAINT fk_showid REFERENCES ShowDetails(ShowId) NOT NULL,
NoOfTickets INT NOT NULL,
TotalAmt DECIMAL(6,2) NOT NULL)

INSERT INTO BookingDetails VALUES ('B1001','jack_sparrow',1001,2,500.00)
INSERT INTO BookingDetails VALUES ('B1002','mary_potter',1002,5,1000.00)
SELECT * FROM BookingDetails
DELETE FROM BookingDetails WHERE BookingId = 'B1004'

/**************************** SP ********************/

CREATE PROCEDURE usp_BookTheTicket
(
@UserId VARCHAR(50), 
@ShowId INT, 
@NoOfTickets INT
)
AS 
BEGIN
 BEGIN TRY
	DECLARE @TicketCost DECIMAL(6,2),  @TotalAmt DECIMAL(6,2) , @tkavailable INT
	SELECT @ShowId = ShowId FROM ShowDetails
	SELECT @TicketCost = TicketCost FROM ShowDetails WHERE @ShowId = ShowId
	SET @TotalAmt =  @NoOfTickets * @TicketCost
	SELECT @tkavailable = TicketsAvailable FROM ShowDetails WHERE @ShowId= ShowId
	IF NOT EXISTS(SELECT UserId FROM Users WHERE @userId = Userid)
	BEGIN
		PRINT 'UserID is Invalid'
		RETURN -1
	END
	IF NOT EXISTS (SELECT ShowID FROM ShowDetails WHERE @ShowId = ShowId)
	BEGIN
		PRINT 'ShowId is Invalid'
		RETURN -2
	END
	IF @NoOfTickets <= 0 
	BEGIN
		PRINT 'No of Ticekts less than or equal to zero'
		RETURN -3
	END
	
	IF @NoOfTickets > @tkavailable
	BEGIN
		PRINT 'Number of Tickets is greater than Tickets Available'
		RETURN -4
	END
	BEGIN
	 BEGIN TRAN
		INSERT INTO BookingDetails VALUES (dbo.ufn_GenerateBookingID(),@UserId,@ShowId,@NoOfTickets,@TotalAmt)
		COMMIT TRAN
		PRINT 'Booking Successful'
		RETURN 1
	END
 END TRY
 
 BEGIN CATCH
	IF @@TRANCOUNT > 0
	ROLLBACK TRAN
	PRINT 'Some Error'
	RETURN -99
 END CATCH
END

--DROP PROCEDURE usp_BookTheTicket
DECLARE @RES INT
EXEC @RES = usp_BookTheTicket 'jack_sparrow',1001,120
SELECT @RES 

SELECT TicketsAvailable,* FROM ShowDetails WHERE ShowId = 1001
SELECT * FROM Users

/*************************************** Functions ***********************************/

CREATE FUNCTION ufn_GenerateBookingID()  --scalar function
RETURNS VARCHAR(5)
AS 
BEGIN
	DECLARE @BookingId VARCHAR(5)
	SELECT @BookingId = 'B' + CAST(CAST(SUBSTRING(MAX(BookingId),2,5) AS INT) +1 AS VARCHAR) FROM BookingDetails
	RETURN @BookingId
END
GO

DECLARE @res VARCHAR(10)
EXEC @res = dbo.ufn_GenerateBookingID
SELECT @RES

SELECT DBO.ufn_GenerateBookingID()
--DROP FUNCTION dbo.ufn_GenerateBookingID

CREATE FUNCTION ufn_GetMovieShowTimes  -- Multistatement Table values function
(
@MovieName VARCHAR(50),
@Location VARCHAR(50)
)
RETURNS @ShowTimes TABLE (MovieName VARCHAR(50),ShowDate DATE, ShowTime TIME, TheaterName VARCHAR(20),TicketCost DECIMAL(6,2))
AS 
BEGIN
INSERT @ShowTimes
SELECT MovieName,ShowDate,ShowTime,TheaterName,TicketCost FROM ShowDetails s JOIN TheaterDetails T
 ON s.TheaterId = t.TheaterId WHERE @MovieName = MovieName AND @Location = Location
RETURN
END
GO

--DROP FUNCTION ufn_GetMovieShowTimes

--SELECT * FROM ufn_GetMovieShowTimes('Hit Man','Pune')

CREATE FUNCTION ufn_BookedDetails  --Inline Table Valued Function
(
@BookingId VARCHAR(5)
)
RETURNS TABLE
AS
RETURN
	(SELECT BookingID,USERNAME,MovieName,TheaterName,ShowDate,ShowTime,NoOfTickets,TotalAmt
	FROM BookingDetails B JOIN Users U ON U.UserId = B.UserID
	JOIN ShowDetails S ON S.ShowId = B.ShowId JOIN TheaterDetails T ON T.TheaterId = S.TheaterId
	WHERE BookingId = @BookingId)

--SELECT * FROM ufn_BookedDetails('B1003')


	
