USE EventCreator
GO

IF TYPE_ID('ParticipantsNameType') IS NOT NULL
	DROP TYPE [dbo].ParticipantsNameType
GO

CREATE TYPE ParticipantsNameType
	AS
	TABLE(ParticipantId uniqueidentifier, FirstName varchar(50), LastName varchar(50), StudentId varchar(50))
GO