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

ALTER TABLE [dbo].[Clients] ADD CONSTRAINT [FK_Clients_ClientInformations_ClientInformationsID] FOREIGN KEY ([ClientInformationsId]) REFERENCES [dbo].[ClientInformations]([Id])
