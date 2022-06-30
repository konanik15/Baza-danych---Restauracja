-- 50001 - invalid parameter error code
-- 50002 - business logic error code

USE EventCreator
GO

EXEC [dbo].RegisterConference @name = 'Boiling frogs v2.0', 
							  @description = 'Najszybciej zdobywająca popularność konferencja IT w Polsce.',
							  @startOfConference = '2020-06-26', 
							  @endOfConference = '2020-06-28'

select * from [dbo].Conferences
select * from [dbo].ConferenceDates

EXEC [dbo].SetConferenceDatePrice @conferenceDateId = '', @price = 999.99;

EXEC [dbo].SetConferenceDatePriceThreshold @conferenceDateId = '', @thresholdDate = '2020-05-20', @price = 1100
EXEC [dbo].SetConferenceDatePriceThreshold @conferenceDateId = '', @thresholdDate = '2020-06-04', @price = 1500

EXEC [dbo].RegisterCompany @companyName = 'Company',
									  @taxId = '833-220-03-58',
									  @email = 'biuro@company.pl',
									  @country = 'PL',
									  @city = 'Kraków',
									  @zipCode = '99-999',
									  @street = 'Al. 29 listopada';

EXEC [dbo].RegisterForConference @clientId = '', 
								 @conferenceDateId = '', 
								 @participantsCount = 2;


SELECT * FROM [dbo].WorkshopTypes
EXEC [dbo].RegisterConferenceDateWorkshop @conferenceDateId = '', 
	@workshopTypeId = '',
	@startOfWorkshop = '2020-06-26 08:00:00.000',
	@endOfWorkshop = '2020-06-26 10:30:00.000',
	@participantsLimit = 10;

DECLARE @participants ParticipantsNameType;

INSERT INTO @participants VALUES('', 'Tomasz', 'Belczyk','123-123-AAA')
INSERT INTO @participants VALUES('', 'Michał', 'Dziarmaga', NULL)

EXEC [dbo].FillCompanyParticipantsNames @participants = @participants;

SELECT * FROM [dbo].Participants
SELECT * FROM [dbo].ParticipantWorkshops
SELECT * FROM [dbo].DailyConferenceWorkshops
EXEC [dbo].RegisterConferenceParticipantForWorkshop @participantId = '', 
													@dailyConferenceWorkshopId = ''
DECLARE @price numeric(10,2);

EXEC @price = [dbo].GetClientPrice @clientId = '', @conferenceId = ''

SELECT @price

DECLARE @discountPercentage int;

EXEC @discountPercentage = [dbo].GetIntSetting @settingName = 'StudentPercentageDiscount';

SELECT @discountPercentage;

EXEC [dbo].ClientPayment @clientId = '', 
						 @conferenceId = '', 
						 @payment = 0
