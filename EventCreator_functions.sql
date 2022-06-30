USE EventCreator
GO

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