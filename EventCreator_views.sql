USE EventCreator
GO

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