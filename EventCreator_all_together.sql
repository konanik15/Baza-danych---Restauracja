USE EventCreator
GO

-- ************************************** [dbo].[Clients]
CREATE TABLE [dbo].[Clients]
(
 [Id]                   uniqueidentifier default newid() NOT NULL,
 [FirstName]            varchar(50) NULL ,
 [LastName]             varchar(50) NULL ,
 [Created]              datetime NOT NULL ,
 [ClientInformationsId] uniqueidentifier NOT NULL ,


 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- ************************************** [dbo].[Conferences]

CREATE TABLE [dbo].[Conferences]
(
 [Id]                uniqueidentifier default newid() NOT NULL ,
 [Name]              varchar(200) NOT NULL ,
 [Description]       varchar(500) NOT NULL ,
 [StartOfConference] datetime NOT NULL ,
 [EndOfConference]   datetime NOT NULL ,


 CONSTRAINT [PK_Conferences] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- ************************************** [dbo].[WorkshopTypes]

CREATE TABLE [dbo].[WorkshopTypes]
(
 [Id]          uniqueidentifier default newid() NOT NULL ,
 [Name]        varchar(100) NOT NULL ,
 [Description] varchar(500) NOT NULL ,
 [Price]       numeric(18,2) NULL ,


 CONSTRAINT [PK_Workshops] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- ************************************** [dbo].[ConferenceDates]

CREATE TABLE [dbo].[ConferenceDates]
(
 [Id]                       uniqueidentifier default newid() NOT NULL ,
 [ConferenceId]             uniqueidentifier NOT NULL ,
 [Date]                     datetime NOT NULL ,
 [DayBasePrice]             numeric(10,2) NULL,

 
 CONSTRAINT [PK_ConferenceDates] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ConferenceDates_Conferences_ConferenceId] FOREIGN KEY ([ConferenceId])  REFERENCES [dbo].[Conferences]([Id])
);
GO

CREATE NONCLUSTERED INDEX [IN_ConferenceDates_ConferenceId] ON [dbo].[ConferenceDates] 
 (
  [ConferenceId] ASC
 )

GO

-- ************************************** [dbo].[ConferenceDatesPriceThresholds]

CREATE TABLE [dbo].[ConferenceDatesPriceThresholds]
(
 [Id]				uniqueidentifier default newid() NOT NULL ,
 [ConferenceDateId] uniqueidentifier NOT NULL ,
 [ThresholdDate]	datetime NOT NULL ,
 [Price]		    numeric(10,2) NOT NULL ,


 CONSTRAINT [PK_ConferenceDatesPriceThresholds] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ConferenceDatesPriceThresholds_ConferenceDateId] FOREIGN KEY ([ConferenceDateId]) REFERENCES [dbo].[ConferenceDates]([Id])
);
GO

CREATE NONCLUSTERED INDEX [IN_ConferenceDatesPriceThresholds_ConferenceDateId] ON [dbo].[ConferenceDatesPriceThresholds]
 (
  [ConferenceDateId] ASC
 )

GO

-- ************************************** [dbo].[DailyConferenceWorkshops]

CREATE TABLE [dbo].[DailyConferenceWorkshops]
(
 [Id]                uniqueidentifier default newid() NOT NULL ,
 [ConferenceDateId]  uniqueidentifier NOT NULL ,
 [WorkshopId]        uniqueidentifier NOT NULL ,
 [ParticipantsLimit] numeric(3,0) NOT NULL ,
 [Date]              datetime NOT NULL ,
 [StartOfWorkshop]  datetime NOT NULL ,
 [EndOfWorkshop]     datetime NOT NULL ,


 CONSTRAINT [PK_ConferenceWorkshops] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_DailyConferenceWorkshops_ConferenceDates_ConferenceDateId] FOREIGN KEY ([ConferenceDateId])  REFERENCES [dbo].[ConferenceDates]([Id]),
 CONSTRAINT [FK_DailyConferenceWorkshops_WorkshopTypes_WorkshopId] FOREIGN KEY ([WorkshopId])  REFERENCES [dbo].[WorkshopTypes]([Id])
);
GO


CREATE NONCLUSTERED INDEX [IN_DailyConferenceWorkshops_ConferenceDateId] ON [dbo].[DailyConferenceWorkshops] 
 (
  [ConferenceDateId] ASC
 )

GO

CREATE NONCLUSTERED INDEX [IN_DailyConferenceWorkshops_WorkshopId] ON [dbo].[DailyConferenceWorkshops] 
 (
  [WorkshopId] ASC
 )

GO

-- ************************************** [dbo].[Participant]

CREATE TABLE [dbo].[Participants]
(
 [Id]               uniqueidentifier default newid() NOT NULL ,
 [ConferenceDateId] uniqueidentifier NOT NULL ,
 [ClientId]         uniqueidentifier NOT NULL ,
 [FirstName]        varchar(50) NULL ,
 [LastName]         varchar(50) NULL ,
 [RegistrationDate] datetime NOT NULL ,
 [StudentId]        varchar(50) NULL ,


 CONSTRAINT [PK_Participants] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_Participants_ConferenceDates_ConferenceDateId] FOREIGN KEY ([ConferenceDateId])  REFERENCES [dbo].[ConferenceDates]([Id]),
 CONSTRAINT [FK_Participants_Clients_ClientId] FOREIGN KEY ([ClientId])  REFERENCES [dbo].[Clients]([Id])
);
GO


CREATE NONCLUSTERED INDEX [IN_Participants_ConferenceDateId] ON [dbo].[Participants] 
 (
  [ConferenceDateId] ASC
 )

GO

CREATE NONCLUSTERED INDEX [IN_Participants_ClientId] ON [dbo].[Participants] 
 (
  [ClientId] ASC
 )

GO

-- ************************************** [dbo].[Payments]

CREATE TABLE [dbo].[Payments]
(
 [Id]            uniqueidentifier default newid() NOT NULL ,
 [ClientId]      uniqueidentifier NOT NULL ,
 [Payment]       numeric(10,2) NOT NULL ,
 [PaymentDate]   datetime NOT NULL ,


 CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_Payments_Clients_ClientId] FOREIGN KEY ([ClientId])  REFERENCES [dbo].[Clients]([Id])
);
GO


CREATE NONCLUSTERED INDEX [IN_Payments_ClientId] ON [dbo].[Payments] 
 (
  [ClientId] ASC
 )

GO

-- ************************************** [dbo].[ParticipantWorkshops]

CREATE TABLE [dbo].[ParticipantWorkshops]
(
 [Id]                        uniqueidentifier default newid() NOT NULL ,
 [ParticipantId]             uniqueidentifier NOT NULL ,
 [DailyConferenceWorkshopId] uniqueidentifier NOT NULL ,


 CONSTRAINT [PK_ParticipantWorkshops] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ParticipantWorkshops_Participants_ParticipantId] FOREIGN KEY ([ParticipantId])  REFERENCES [dbo].[Participants]([Id]),
 CONSTRAINT [FK_ParticipantWorkshops_DailyConferenceWorkshops_DailyConferenceWorkshopId] FOREIGN KEY ([DailyConferenceWorkshopId])  REFERENCES [dbo].[DailyConferenceWorkshops]([Id])
);
GO


CREATE NONCLUSTERED INDEX [IN_ParticipantWorkshops_ParticipantId] ON [dbo].[ParticipantWorkshops] 
 (
  [ParticipantId] ASC
 )

GO

CREATE NONCLUSTERED INDEX [IN_ParticipantWorkshops_DailyConferenceWorkshopId] ON [dbo].[ParticipantWorkshops] 
 (
  [DailyConferenceWorkshopId] ASC
 )

GO

-- ************************************** [dbo].[ClientInformations]

CREATE TABLE [dbo].[ClientInformations]
(
 [Id]          uniqueidentifier default newid() NOT NULL ,
 [ClientId]    uniqueidentifier NOT NULL ,
 [IsCompany]   bit NOT NULL ,
 [BirthDate]   datetime NULL ,
 [Email]       varchar(200) NOT NULL ,
 [Country]     varchar(50) NOT NULL ,
 [City]        varchar(50) NOT NULL ,
 [ZipCode]     varchar(50) NOT NULL ,
 [Street]      varchar(50) NOT NULL ,
 [TaxId]       varchar(50) NULL ,
 [CompanyName] varchar(100) NULL ,


 CONSTRAINT [PK_ClientInformations] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ClientInformations_Clients_ClientId] FOREIGN KEY ([ClientId])  REFERENCES [dbo].[Clients]([Id])
);
GO


CREATE NONCLUSTERED INDEX [IN_ClientInformations_ClientId] ON [dbo].[ClientInformations] 
 (
  [ClientId] ASC
 )

GO

-- ************************************** [dbo].[Settings]

CREATE TABLE [dbo].[Settings]
(
 [Id]            uniqueidentifier default newid() NOT NULL ,
 [Name]          varchar(100) UNIQUE NOT NULL,
 [Description]   varchar(500) NULL,
 [VarcharValue]  varchar(200) NULL,
 [NumericValue]  numeric(38,23) NULL,
 [IntValue]      int NULL,
 [DatetimeValue] datetime NULL,


 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO


CREATE NONCLUSTERED INDEX [IN_Settings_Name] ON [dbo].[Settings] 
 (
  [Name] ASC
 )

GO


--types

ALTER TABLE [dbo].[Clients] ADD CONSTRAINT [FK_Clients_ClientInformations_ClientInformationsID] FOREIGN KEY ([ClientInformationsId]) REFERENCES [dbo].[ClientInformations]([Id])

IF TYPE_ID('ParticipantsNameType') IS NOT NULL
	DROP TYPE [dbo].ParticipantsNameType
GO

CREATE TYPE ParticipantsNameType
	AS
	TABLE(ParticipantId uniqueidentifier, FirstName varchar(50), LastName varchar(50), StudentId varchar(50))
GO


--functions

IF OBJECT_ID('TruncateDate') IS NOT NULL
	DROP FUNCTION [dbo].TruncateDate
GO

CREATE FUNCTION [dbo].TruncateDate(@date datetime)
returns datetime
as
begin
	declare @truncatedDate datetime = (SELECT  CAST(@date AS DATE));
	return @truncatedDate;
end;

GO

IF OBJECT_ID('GetConferencePrice') IS NOT NULL
	DROP FUNCTION [dbo].GetConferencePrice
GO

CREATE FUNCTION [dbo].GetConferencePrice(@conferenceDateId uniqueidentifier)
RETURNS numeric(10,2)
AS
BEGIN
	DECLARE @dayBasePrice numeric(10,2);
	DECLARE @actualPrice numeric(10,2);

	SELECT @dayBasePrice = DayBasePrice 
	FROM [dbo].ConferenceDates
	WHERE Id = @conferenceDateId;

	SELECT @actualPrice = cdpt.Price
	FROM [dbo].ConferenceDatesPriceThresholds cdpt 
	WHERE cdpt.ConferenceDateId = @conferenceDateId 
		AND cdpt.ThresholdDate = (SELECT MAX(cdpt2.ThresholdDate)
								  FROM [dbo].ConferenceDatesPriceThresholds cdpt2
								  WHERE cdpt2.ConferenceDateId = @conferenceDateId
									AND [dbo].TruncateDate(SYSDATETIME()) > [dbo].TruncateDate(cdpt2.ThresholdDate));
	IF(@actualPrice is null)
		return @dayBasePrice;
	return @actualPrice
END;
GO

IF OBJECT_ID('GetConferenceDatePriceForClient') IS NOT NULL
	DROP FUNCTION [dbo].GetConferenceDatePriceForClient
GO

CREATE FUNCTION [dbo].GetConferenceDatePriceForClient(@clientId uniqueidentifier,
													  @conferenceDateId uniqueidentifier)
RETURNS NUMERIC(10,2)
AS
BEGIN
	DECLARE @totalConferenceDatePrice numeric(10,2);
	DECLARE @totalWorkshopsPrice numeric(10,2);
	DECLARE @groupedConferenceDateId uniqueidentifier;
	DECLARE @studentPercentageDiscount int = 0;

	EXEC @studentPercentageDiscount = [dbo].GetIntSetting @settingName = 'StudentPercentageDiscount';

	SELECT @totalWorkshopsPrice = SUM(totalPrices.TotalWorkshopsPrice), 
		   @totalConferenceDatePrice = SUM(totalPrices.ConferenceDatePrice)
	FROM (SELECT p.Id ParticipantId,
				 SUM(ISNULL(CASE 
								WHEN p.StudentId is null 
									THEN wt.Price 
								ELSE wt.Price - wt.Price * (CAST(@studentPercentageDiscount as numeric(3,0)) / 100) 
							END, 0)) TotalWorkshopsPrice, 
				 [dbo].GetConferencePrice(cd.Id) ConferenceDatePrice 
		  FROM [dbo].ParticipantWorkshops pw 
			JOIN [dbo].DailyConferenceWorkshops dcw on pw.DailyConferenceWorkshopId = dcw.Id
			JOIN [dbo].WorkshopTypes wt on wt.Id = dcw.WorkshopId
			JOIN [dbo].ConferenceDates cd on cd.Id = dcw.ConferenceDateId 
			JOIN [dbo].Participants p on p.Id = pw.ParticipantId
		  WHERE p.ClientId = @clientId 
			AND dcw.ConferenceDateId = @conferenceDateId
		  GROUP BY p.Id, cd.Id) as totalPrices

	RETURN CAST(ROUND(ISNULL(@totalConferenceDatePrice,0) + ISNULL(@totalWorkshopsPrice,0),2) AS numeric(10,2));
END;
GO

IF OBJECT_ID('GetClientPrice') IS NOT NULL
	DROP FUNCTION [dbo].GetClientPrice
GO

CREATE FUNCTION [dbo].GetClientPrice(@clientId uniqueidentifier,
									 @conferenceId uniqueidentifier)
RETURNS numeric(10,2)
AS
BEGIN
	DECLARE @totalPrice numeric(10,2);

	SELECT @totalPrice = SUM(ISNULL([dbo].GetConferenceDatePriceForClient(@clientId, cd.Id),0))
	FROM [dbo].ConferenceDates cd 
	WHERE cd.ConferenceId = @conferenceId

	RETURN @totalPrice;
END
GO

IF OBJECT_ID('GetIntSetting') IS NOT NULL
	DROP FUNCTION [dbo].GetIntSetting
GO

CREATE FUNCTION [dbo].GetIntSetting(@settingName varchar(100))
RETURNS INT
AS
BEGIN
	DECLARE @intValue int;
	SELECT TOP(1) @intValue = IntValue FROM [dbo].Settings WHERE Name = @settingName;

	return @intValue;
END
GO

IF OBJECT_ID('GetVarcharSetting') IS NOT NULL
	DROP FUNCTION [dbo].GetVarcharSetting
GO

CREATE FUNCTION [dbo].GetVarcharSetting(@settingName varchar(100))
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @varcharValue varchar(200);
	SELECT TOP(1) @varcharValue = VarcharValue FROM [dbo].Settings WHERE Name = @settingName;

	return @varcharValue;
END
GO

IF OBJECT_ID('GetNumericSetting') IS NOT NULL
	DROP FUNCTION [dbo].GetNumericSetting
GO

CREATE FUNCTION [dbo].GetNumericSetting(@settingName varchar(100))
RETURNS NUMERIC(38,23)
AS
BEGIN
	DECLARE @numericValue numeric(38,23);
	SELECT TOP(1) @numericValue = NumericValue FROM [dbo].Settings WHERE Name = @settingName;

	return @numericValue;
END
GO

IF OBJECT_ID('GetDatetimeSetting') IS NOT NULL
	DROP FUNCTION [dbo].GetDatetimeSetting
GO

CREATE FUNCTION [dbo].GetDatetimeSetting(@settingName varchar(100))
RETURNS DATETIME
AS
BEGIN
	DECLARE @datetimeValue datetime;
	SELECT TOP(1) @datetimeValue = DatetimeValue FROM [dbo].Settings WHERE Name = @settingName;

	return @datetimeValue;
END
GO


-- procedures

IF OBJECT_ID('RegisterConference') IS NOT NULL
    DROP PROCEDURE [dbo].RegisterConference
GO

CREATE PROCEDURE [dbo].RegisterConference(@name varchar(200),
										  @description varchar(500),
										  @startOfConference datetime,
										  @endOfConference datetime)
AS
BEGIN
	DECLARE @sql varchar(1000);
	DECLARE @error varchar(100);
	DECLARE @newId uniqueidentifier = newid();
	SET @startOfConference = [dbo].TruncateDate(@startOfConference);
	SET @endOfConference = [dbo].TruncateDate(@endOfConference);

	if(@name is null or @name = '')
		THROW 50001, 'Nazwa konferencji nie może byc pusta', 1;

	if(@startOfConference > @endOfConference)
		THROW 50001, 'Konferencja nie może zaczynać się później niż się kończy.', 1;

	INSERT INTO [dbo].Conferences(Id, Name, Description, StartOfConference, EndOfConference)
		VALUES(@newId,@name,@description,@startOfConference,@endOfConference);

	WHILE(@startOfConference <= @endOfConference)
	BEGIN
		INSERT INTO [dbo].ConferenceDates(ConferenceId,Date) VALUES(@newId,@startOfConference)
		SET @startOfConference= DATEADD(day, 1, @startOfConference);
	END

	SELECT @newId;
END;
GO

IF OBJECT_ID('RegisterClient') IS NOT NULL
    DROP PROCEDURE [dbo].RegisterClient
GO

CREATE PROCEDURE [dbo].RegisterClient(@firstName varchar(50), 
									  @lastName varchar(50),
									  @birthDate datetime,
									  @email varchar(200),
									  @country varchar(50),
									  @city varchar(50),
									  @zipCode varchar(50),
									  @street varchar(50))
AS
BEGIN
	DECLARE @clientId uniqueidentifier = newid();
	DECLARE @clientInformationsId uniqueidentifier = newid();

	if(@firstName is null or @firstName = '')
		THROW 50001, 'Imię nie może być puste.', 1;
	if(@lastName is null or @lastName = '')
		THROW 50001, 'Nazwisko nie może być puste.', 1;
	if(@email is null or @email = '')
		THROW 50001, 'Email nie może być pusty.', 1;
	if(@country is null or @country = '')
		THROW 50001, 'Kraj nie może być pusty.', 1;
	if(@city is null or @city = '')
		THROW 50001, 'Miasto nie może być puste.', 1;
	if(@zipCode is null or @zipCode = '')
		THROW 50001, 'Kod pocztowy nie może być pusty.', 1;
	if(@street is null or @street = '')
		THROW 50001, 'Ulica nie może być pusta.', 1;

	if(@birthDate is null)
		THROW 50001, 'Data urodzin nie może być pusta.', 1;
	if(@birthDate > DATEADD(yy, -18, SYSDATETIME()))
		THROW 50002, 'Aby się zarejestrować użytkownik musi byc pełnoletni.', 1;

	INSERT INTO [dbo].Clients(Id, FirstName, LastName, Created, ClientInformationsId)
		VALUES(@clientId, @firstName, @lastName, SYSDATETIME(), @clientInformationsId);

	INSERT INTO [dbo].ClientInformations(Id, ClientId, IsCompany, BirthDate, Email, Country, City, ZipCode, Street)
		VALUES(@clientInformationsId, @clientId, 0, @birthDate, @email, @country, @city, @zipCode, @street)
	SELECT @clientId;
END;
GO

IF OBJECT_ID('RegisterCompany') IS NOT NULL
    DROP PROCEDURE [dbo].RegisterCompany
GO

CREATE PROCEDURE [dbo].RegisterCompany(@companyName varchar(100),
									  @taxId varchar(50),
									  @email varchar(200),
									  @country varchar(50),
									  @city varchar(50),
									  @zipCode varchar(50),
									  @street varchar(50))
AS
BEGIN
	DECLARE @clientId uniqueidentifier = newid();
	DECLARE @clientInformationsId uniqueidentifier = newid();

	if(@companyName is null or @companyName = '')
		THROW 50001, 'Nazwa firmy nie może być pusta.', 1;
	if(@taxId is null or @taxId = '')
		THROW 50001, 'NIP firmy nie może być pusty.', 1;
	if(@email is null or @email = '')
		THROW 50001, 'Email nie może być pusty.', 1;
	if(@country is null or @country = '')
		THROW 50001, 'Kraj nie może być pusty.', 1;
	if(@city is null or @city = '')
		THROW 50001, 'Miasto nie może być puste.', 1;
	if(@zipCode is null or @zipCode = '')
		THROW 50001, 'Kod pocztowy nie może być pusty.', 1;
	if(@street is null or @street = '')
		THROW 50001, 'Ulica nie może być pusta.', 1;

	INSERT INTO [dbo].Clients(Id, Created, ClientInformationsId)
		VALUES(@clientId, SYSDATETIME(), @clientInformationsId);

	INSERT INTO [dbo].ClientInformations(Id, ClientId, IsCompany, Email, Country, City, ZipCode, Street, TaxId, CompanyName)
		VALUES(@clientInformationsId, @clientId, 1, @email, @country, @city, @zipCode, @street, @taxId, @companyName);

	SELECT @clientId;
END
GO

IF OBJECT_ID('RegisterForConference') IS NOT NULL
    DROP PROCEDURE [dbo].RegisterForConference
GO

CREATE PROCEDURE [dbo].RegisterForConference(@clientId uniqueidentifier,
											 @conferenceDateId uniqueidentifier,
											 @participantsCount int = 1)
AS
BEGIN
	DECLARE @i int = 1;
	DECLARE @isCompany bit, @firstName varchar(50), @lastName varchar(50);
	DECLARE @participantId uniqueidentifier = null;
	DECLARE @addedParticipants table(ParticipantId uniqueidentifier, FirstName varchar(50), LastName varchar(50));

	if((SELECT Count(*) from [dbo].Clients where Id = @clientId) = 0)
		THROW 50002, 'Klient o podanym id nie istnieje.', 1;

	if((SELECT Count(*) from [dbo].ConferenceDates where Id = @conferenceDateId) = 0)
		THROW 50002, 'Konferencja o podanym id nie istnieje.', 1;

	if((SELECT Date FROM [dbo].ConferenceDates where Id = @conferenceDateId) < SYSDATETIME())
		THROW 50002, 'Nie ma możliwości na rejestracje na dzień konferencji który już się skończył lub trwa.', 1;
		
	SELECT @isCompany = IsCompany,
		   @firstName = FirstName,
		   @lastName = LastName
	FROM [dbo].Clients c join [dbo].ClientInformations ci ON c.Id = ci.ClientId 
	WHERE c.Id = @clientId

	if(@isCompany = 0)
	BEGIN
		SET @participantId = newid();
		INSERT INTO [dbo].Participants(Id, 
			ConferenceDateId, 
			ClientId, 
			RegistrationDate, 
			FirstName, 
			LastName) VALUES(@participantId, 
			@conferenceDateId, 
			@clientId, 
			SYSDATETIME(),
			@firstName,
			@lastName)
		INSERT INTO @addedParticipants values(@participantId, @firstName, @lastName)
	END
	if(@isCompany = 1)
	BEGIN
		WHILE(@i <= @participantsCount)
		BEGIN
			SET @participantId = newid();
			INSERT INTO [dbo].Participants(Id, ConferenceDateId, ClientId, RegistrationDate)
				VALUES(@participantId, @conferenceDateId, @clientId, SYSDATETIME())
			INSERT INTO @addedParticipants values(@participantId, null, null)
			SET @i = @i + 1;
		END
	END

	SELECT * from @addedParticipants
END
GO

IF OBJECT_ID('AddWorkshopType') IS NOT NULL
    DROP PROCEDURE [dbo].AddWorkshopType
GO

CREATE PROCEDURE [dbo].AddWorkshopType(@name varchar(100), 
									   @description varchar(500), 
									   @price numeric(18,2))
AS
BEGIN
	DECLARE @workshopTypeId uniqueidentifier = newid();

	if(@name is null or @name = '')
		THROW 50001, 'Nazwa warsztatu nie może być pusta.', 1;
	if(@price is null or @price <= 0)
		THROW 50001, 'Nieprawidłowa cena (<= 0).', 1;

	INSERT INTO [dbo].WorkshopTypes(Id, Name, Description, Price)
		VALUES(@workshopTypeId, @name, @description, @price);

	SELECT @workshopTypeId
END
GO

IF OBJECT_ID('RegisterConferenceDateWorkshop') IS NOT NULL
    DROP PROCEDURE [dbo].RegisterConferenceDateWorkshop
GO

CREATE PROCEDURE [dbo].RegisterConferenceDateWorkshop(@conferenceDateId uniqueidentifier,
													  @workshopTypeId uniqueidentifier,
													  @startOfWorkshop datetime,
													  @endOfWorkshop datetime,
													  @participantsLimit numeric(3,0)
													  )
AS
BEGIN
	DECLARE @dailyConferenceWorkshopId uniqueidentifier;
	DECLARE @startOfConference datetime = null;
	DECLARE @conferenceDayDate datetime;

	(select @startOfConference = StartOfConference,
			@conferenceDayDate = Date
	 from [dbo].ConferenceDates cd join [dbo].Conferences c on cd.ConferenceId = c.Id 
     where cd.Id = @conferenceDateId)

	if(@startOfConference is null or SYSDATETIME() > @startOfConference)
		THROW 50001, 'Konferencja o podanym id nie istnieje lub konferencja juz się zakończyła.', 1;

	if((SELECT 'EXISTS' from [dbo].WorkshopTypes where Id = @workshopTypeId) is null)
		THROW 50001, 'Warsztat o podanym id nie istnieje.', 1;

	if(@startOfWorkshop > @endOfWorkshop)
		THROW 50001, 'Konferencja nie może się zaczynać później niż się kończy.', 1;

	if(@participantsLimit <= 0)
		THROW 50001, 'Limit uczestników nie może być <= 0.', 1;

	if([dbo].TruncateDate(@startOfWorkshop) <> [dbo].TruncateDate(@conferenceDayDate)
		or [dbo].TruncateDate(@endOfWorkshop) <> [dbo].TruncateDate(@conferenceDayDate))
		THROW 50002, 'Data warsztatów nie zgadza się z data konferencji.', 1;

	SET @dailyConferenceWorkshopId = newid();

	INSERT INTO [dbo].DailyConferenceWorkshops(Id, ConferenceDateId, WorkshopId, ParticipantsLimit, Date, StartOfWorkshop, EndOfWorkshop)
		VALUES (@dailyConferenceWorkshopId,
				@conferenceDateId,
				@workshopTypeId,
				@participantsLimit,
				@conferenceDayDate,
				@startOfWorkshop,
				@endOfWorkshop)

	SELECT @dailyConferenceWorkshopId;
END
GO

IF OBJECT_ID('FillCompanyParticipantsNames') IS NOT NULL
    DROP PROCEDURE [dbo].FillCompanyParticipantsNames
GO

CREATE PROCEDURE [dbo].FillCompanyParticipantsNames(@participants ParticipantsNameType READONLY)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @participantId uniqueidentifier, @firstName varchar(50), @lastName varchar(50), @studentId varchar(50);
	DECLARE participantsCursor CURSOR LOCAL FAST_FORWARD FOR SELECT * FROM @participants;

	OPEN participantsCursor;

	FETCH NEXT FROM participantsCursor INTO @participantId, @firstName, @lastName, @studentId;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE [dbo].Participants set FirstName = @firstName, 
									  LastName = @lastName,
									  StudentId = @studentId where Id = @participantId;
		FETCH NEXT FROM participantsCursor INTO @participantId, @firstName, @lastName, @studentId;
	END

	CLOSE participantsCursor;
	DEALLOCATE participantsCursor;

	SELECT p1.Id,
		   p1.ClientId,
		   p1.ConferenceDateId,
		   p1.FirstName,
		   p1.LastName,
		   p1.RegistrationDate,
		   p1.StudentId 
	FROM [dbo].Participants p1 INNER JOIN @participants p2 ON p1.Id = p2.ParticipantId -- Validation and result in one. Since no participant will be updated
																								-- if doesn't exist in table
END
GO

IF OBJECT_ID('RegisterConferenceParticipantForWorkshop') IS NOT NULL
    DROP PROCEDURE [dbo].RegisterConferenceParticipantForWorkshop
GO

CREATE PROCEDURE [dbo].RegisterConferenceParticipantForWorkshop(@participantId uniqueidentifier, 
																@dailyConferenceWorkshopId uniqueidentifier)
AS
BEGIN
	DECLARE @participantWorkshopId uniqueidentifier;

	IF((SELECT Count(*) FROM [dbo].Participants WHERE Id = @participantId) = 0)
		THROW 50001, 'Uczestnik o podanym id nie istnieje.', 1;

	IF((SELECT Count(*) FROM [dbo].DailyConferenceWorkshops WHERE Id = @dailyConferenceWorkshopId) = 0)
		THROW 50001, 'Warsztat konferencji o podanym id nie istnieje.', 1;

	IF((SELECT Count(*) from [dbo].ParticipantWorkshops where DailyConferenceWorkshopId = @dailyConferenceWorkshopId)
		>= (SELECT ParticipantsLimit from [dbo].DailyConferenceWorkshops where Id = @dailyConferenceWorkshopId))
		THROW 50002, 'Limit uczestników został osiągnięty.', 1;

	IF((SELECT 'Registered' 
		FROM [dbo].ParticipantWorkshops
		WHERE ParticipantId = @participantId
			AND DailyConferenceWorkshopId = @dailyConferenceWorkshopId) is not null)
		THROW 50002, 'Uczestnik jest już zarejestrowany na warsztat o podanym id.', 1;

	IF((Select Count(*) FROM [dbo].ParticipantWorkshops pw
			INNER JOIN (
				SELECT dcw.Id, dcw.StartOfWorkshop, dcw.EndOfWorkshop
				FROM [dbo].DailyConferenceWorkshops dcw
				WHERE [dbo].TruncateDate(dcw.Date) = (SELECT [dbo].TruncateDate(dcw2.Date) 
													  FROM [dbo].DailyConferenceWorkshops dcw2 
													  WHERE dcw2.Id = @dailyConferenceWorkshopId)
			) dcw
			ON pw.DailyConferenceWorkshopId = dcw.Id
			WHERE pw.ParticipantId = @participantId
				AND (SELECT dcw3.StartOfWorkshop 
					 FROM [dbo].DailyConferenceWorkshops dcw3
					 WHERE dcw3.Id = @dailyConferenceWorkshopId) BETWEEN DATEADD(SECOND,-1,dcw.StartOfWorkshop) AND DATEADD(SECOND, 1, dcw.EndOfWorkshop)) -- we don't want 
																																						    -- to include border values
		> 0)
		THROW 50002, 'Uczestnik jest już zarejestrowany na inny warsztat równolegle odbywający się.', 1;

	SET @participantWorkshopId = newid();
	INSERT INTO [dbo].ParticipantWorkshops(Id, DailyConferenceWorkshopId, ParticipantId)
		VALUES(@participantWorkshopId, @dailyConferenceWorkshopId, @participantId)

	SELECT @participantWorkshopId;
END
GO

IF OBJECT_ID('ClientPayment') IS NOT NULL
	DROP PROCEDURE [dbo].ClientPayment
GO

CREATE PROCEDURE [dbo].ClientPayment(@clientId uniqueidentifier, 
									 @conferenceId uniqueidentifier, 
									 @payment numeric(10,2))
AS
BEGIN
	DECLARE @paymentId uniqueidentifier = newid();
	DECLARE @conferenceActualPrice numeric(10,2);
	DECLARE @conferenceEndOfConference datetime;
	DECLARE @error varchar(100);

	SELECT @conferenceEndOfConference = EndOfConference FROM [dbo].Conferences WHERE Id = @conferenceId;

	IF(@conferenceEndOfConference IS NULL)
		THROW 50001, 'Konferencja o podanym id nie istnieje.', 1;

	IF(@conferenceEndOfConference < SYSDATETIME())
		THROW 50002, 'Nie można opłacić konferencji która już się ukończyła', 1;

	IF(@payment <=0)
		THROW 50002, 'Błędna kwota.', 1;

	EXEC @conferenceActualPrice = [dbo].GetClientPrice @clientId = @clientId, @conferenceId = @conferenceId;

	IF(@payment != @conferenceActualPrice)
	BEGIN
		SET @error = 'Błędna kwota konferencji. Koszt całości to ' + CAST(@conferenceActualPrice AS VARCHAR(15));
		THROW 50002, @error, 1;
	END

	INSERT INTO [dbo].Payments(Id, ClientId, Payment, PaymentDate)
		VALUES(@paymentId, @clientId, @payment, SYSDATETIME());

	SELECT @paymentId;
END;
GO

IF OBJECT_ID('SetConferenceDatePrice') IS NOT NULL
	DROP PROCEDURE [dbo].SetConferenceDatePrice
GO

CREATE PROCEDURE [dbo].SetConferenceDatePrice(@conferenceDateId uniqueidentifier, 
											  @price numeric(10,2))
AS
BEGIN
	UPDATE [dbo].ConferenceDates set DayBasePrice = @price WHERE Id = @conferenceDateId;
	SELECT * FROM [dbo].ConferenceDates WHERE Id = @conferenceDateId;
END
GO

IF OBJECT_ID('SetConferenceDatePriceThreshold') IS NOT NULL
	DROP PROCEDURE [dbo].SetConferenceDatePriceThreshold
GO

CREATE PROCEDURE [dbo].SetConferenceDatePriceThreshold(@conferenceDateId uniqueidentifier,
													   @thresholdDate datetime,
													   @price numeric(10,2))
AS
BEGIN
	DECLARE @thresholdId uniqueidentifier = newid();
	INSERT INTO [dbo].ConferenceDatesPriceThresholds(Id, ConferenceDateId, ThresholdDate, Price)
	VALUES(@thresholdId, @conferenceDateId, @thresholdDate, @price);
END
GO


-- views

IF OBJECT_ID('GetConferenceParticipants') IS NOT NULL
	DROP VIEW [dbo].GetConferenceParticipants
GO

CREATE VIEW [dbo].GetConferenceParticipants
AS 
SELECT cd.ConferenceId, cd.Id ConferenceDateId, p.Id ParticipantId, p.FirstName, p.LastName, p.ClientId, p.StudentId
FROM [dbo].ConferenceDates cd 
JOIN [dbo].DailyConferenceWorkshops dcw on dcw.ConferenceDateId = cd.Id
JOIN [dbo].Participants p on p.ConferenceDateId = dcw.ConferenceDateId
GO

IF OBJECT_ID('GetClientsWithNotFilledParticipants') IS NOT NULL
	DROP VIEW [dbo].GetClientsWithNotFilledParticipants
GO

CREATE VIEW [dbo].GetClientsWithNotFilledParticipants
AS
SELECT c.Id, Count(*) NotFilledParticipantsCount
FROM [dbo].Clients c LEFT JOIN [dbo].Participants p on c.Id = p.ClientId
WHERE p.FirstName is null or p.LastName is null
GROUP BY c.Id
GO

IF OBJECT_ID('GetClientsPayments') IS NOT NULL
	DROP VIEW [dbo].GetClientsPayments
GO

CREATE VIEW [dbo].GetClientsPayments
AS
SELECT * FROM [dbo].Payments
GO


-- seed

INSERT INTO [dbo].Settings(Name,Description,IntValue) 
	VALUES('StudentPercentageDiscount', 
		   'Procent o jaki zostanie obniżona cena warsztatów/konferencji dla studenta.', 
	       15)

EXEC [dbo].AddWorkshopType @name = 'Marten jako event store w postgresql.', @description = '', @price = 499.99;
EXEC [dbo].AddWorkshopType @name = 'Event storming w Twojej firmie.', @description = '', @price = 899.99;
