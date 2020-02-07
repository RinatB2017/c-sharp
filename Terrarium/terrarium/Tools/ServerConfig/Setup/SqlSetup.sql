-- -----------------------------------------------------------
-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- -----------------------------------------------------------

-- ----------------------------------------------------------
--
-- Create the [DBName] Database
--
-- ----------------------------------------------------------
    
CREATE DATABASE [[DBName]] 
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO

exec sp_dboption N'[DBName]', N'autoclose', N'false'
GO

exec sp_dboption N'[DBName]', N'bulkcopy', N'false'
GO

exec sp_dboption N'[DBName]', N'trunc. log', N'false'
GO

exec sp_dboption N'[DBName]', N'torn page detection', N'true'
GO

exec sp_dboption N'[DBName]', N'read only', N'false'
GO

exec sp_dboption N'[DBName]', N'dbo use', N'false'
GO

exec sp_dboption N'[DBName]', N'single', N'false'
GO

exec sp_dboption N'[DBName]', N'autoshrink', N'false'
GO

exec sp_dboption N'[DBName]', N'ANSI null default', N'false'
GO

exec sp_dboption N'[DBName]', N'recursive triggers', N'false'
GO

exec sp_dboption N'[DBName]', N'ANSI nulls', N'false'
GO

exec sp_dboption N'[DBName]', N'concat null yields null', N'false'
GO

exec sp_dboption N'[DBName]', N'cursor close on commit', N'false'
GO

exec sp_dboption N'[DBName]', N'default to local cursor', N'false'
GO

exec sp_dboption N'[DBName]', N'quoted identifier', N'false'
GO

exec sp_dboption N'[DBName]', N'ANSI warnings', N'false'
GO

exec sp_dboption N'[DBName]', N'auto create statistics', N'true'
GO

exec sp_dboption N'[DBName]', N'auto update statistics', N'true'
GO

-- ----------------------------------------------------------
--
-- Switch to [DBName] Database
--
-- ----------------------------------------------------------
use [[DBName]]
GO

-- ----------------------------------------------------------
--
-- Create Logins
--
-- ----------------------------------------------------------

if not exists (select * from master.dbo.syslogins where loginname = N'TerrariumUser')
BEGIN
	declare @logindb nvarchar(132), @loginlang nvarchar(132) select @logindb = N'master', @loginlang = N'us_english'
	if @logindb is null or not exists (select * from master.dbo.sysdatabases where name = @logindb)
		select @logindb = N'master'
	if @loginlang is null or (not exists (select * from master.dbo.syslanguages where name = @loginlang) and @loginlang <> N'us_english')
		select @loginlang = @@language
	exec sp_addlogin N'TerrariumUser', null, @logindb, @loginlang
END
GO
if not exists (select * from dbo.sysusers where name = N'TerrariumUser' and uid < 16382)
	EXEC sp_grantdbaccess N'TerrariumUser', N'TerrariumUser'
GO

exec sp_addrolemember N'db_accessadmin', N'TerrariumUser'
GO

exec sp_addrolemember N'db_backupoperator', N'TerrariumUser'
GO

exec sp_addrolemember N'db_datareader', N'TerrariumUser'
GO

exec sp_addrolemember N'db_datawriter', N'TerrariumUser'
GO

exec sp_addrolemember N'db_ddladmin', N'TerrariumUser'
GO

exec sp_addrolemember N'db_owner', N'TerrariumUser'
GO

exec sp_addrolemember N'db_securityadmin', N'TerrariumUser'
GO

-- ----------------------------------------------------------
--
-- Create Tables
--
-- ----------------------------------------------------------

CREATE TABLE [dbo].[DailyPopulation] (
	[SampleDateTime] [datetime] NOT NULL ,
	[SpeciesName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Population] [int] NOT NULL ,
	[BirthCount] [int] NOT NULL ,
	[StarvedCount] [int] NOT NULL ,
	[KilledCount] [int] NOT NULL ,
	[ErrorCount] [int] NOT NULL ,
	[TimeoutCount] [int] NOT NULL ,
	[SickCount] [int] NOT NULL ,
	[OldAgeCount] [int] NOT NULL ,
	[SecurityViolationCount] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[History] (
	[GUID] [uniqueidentifier] NOT NULL ,
	[TickNumber] [int] NOT NULL ,
	[SpeciesName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ContactTime] [datetime] NOT NULL ,
	[ClientTime] [datetime] NOT NULL ,
	[CorrectTime] [tinyint] NOT NULL ,
	[Population] [int] NOT NULL ,
	[BirthCount] [int] NOT NULL ,
	[TeleportedToCount] [int] NOT NULL ,
	[StarvedCount] [int] NOT NULL ,
	[KilledCount] [int] NOT NULL ,
	[TeleportedFromCount] [int] NOT NULL ,
	[ErrorCount] [int] NOT NULL ,
	[TimeoutCount] [int] NOT NULL ,
	[SickCount] [int] NOT NULL ,
	[OldAgeCount] [int] NOT NULL ,
	[SecurityViolationCount] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[NodeLastContact] (
	[GUID] [uniqueidentifier] NOT NULL ,
	[LastTick] [int] NOT NULL ,
	[LastContact] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Peers] (
	[Channel] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IPAddress] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Lease] [datetime] NOT NULL ,
	[Version] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Guid] [uniqueidentifier] NULL ,
	[FirstContact] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[RandomTips] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[tip] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ShutdownPeers] (
	[Guid] [uniqueidentifier] NULL ,
	[Channel] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IPAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Version] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FirstContact] [datetime] NOT NULL ,
	[LastContact] [datetime] NOT NULL ,
	[UnRegister] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Species] (
	[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Author] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AuthorEmail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DateAdded] [datetime] NOT NULL ,
	[AssemblyFullName] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Extinct] [tinyint] NOT NULL ,
	[LastReintroduction] [datetime] NULL ,
	[ReintroductionNode] [uniqueidentifier] NULL ,
	[Version] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[BlackListed] [bit] NOT NULL ,
	[ExtinctDate] [datetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[TimedOutNodes] (
	[GUID] [uniqueidentifier] NOT NULL ,
	[TimeoutDate] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UserRegister] (
	[IPAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[VersionedSettings] (
	[Version] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Disabled] [int] NOT NULL ,
	[Message] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Watson] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[LogType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MachineName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OSVersion] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[GameVersion] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CLRVersion] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ErrorLog] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UserEmail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UserComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DateSubmitted] [datetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


-- ----------------------------------------------------------
--
-- Create Default Data
--
-- ----------------------------------------------------------

INSERT INTO VersionedSettings (Version, Disabled, Message) 
VALUES						  ('Default',0,'')

GO

INSERT INTO RandomTips 
VALUES ('You can use Alt-Enter to enter a true Full-Screen view.')

GO

-- ----------------------------------------------------------
--
-- Create Stored Procedures
--
-- ----------------------------------------------------------

/****** Object:  Stored Procedure dbo.TerrariumAdminDisableAllVersions    Script Date: 11/8/2001 8:16:22 PM ******/
CREATE PROCEDURE [dbo].[TerrariumAdminDisableAllVersions]
AS
    UPDATE
        VersionedSettings
    SET
        Disabled=1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumAdminDisableVersion    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumAdminDisableVersion]
    @Version varchar(255)
AS
    SELECT
        *
    FROM
        VersionedSettings
    WHERE
        Version=@Version
    IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO
                VersionedSettings (
                    Version,
                    Disabled
                ) VALUES (
                    @Version,
                    1
                )
        END
    ELSE
        BEGIN
            UPDATE
                VersionedSettings
            SET
                Disabled=1
            WHERE
                Version=@Version
        END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumAdminEnableVersion    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumAdminEnableVersion]
    @Version varchar(255)
AS
    SELECT
        *
    FROM
        VersionedSettings
    WHERE
        Version=@Version
    IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO
                VersionedSettings (
                    Version,
                    Disabled
                ) VALUES (
                    @Version,
                    0
                )
        END
    ELSE
        BEGIN
            UPDATE
                VersionedSettings
            SET
                Disabled=0
            WHERE
                Version=@Version
        END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumAggregate    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE          PROCEDURE [dbo].[TerrariumAggregate] (
    @Expiration_Error int out,
    @Rollup_Error int out,
    @Timeout_Add_Error int out,
    @Timeout_Delete_Error int out,
    @Extinction_Error int out
)
AS
-- Timing Code
    -- Declarations
    DECLARE @Last datetime;
    DECLARE @Now datetime;
    DECLARE @Timeout datetime;
    -- Initialization
    SELECT @Last=Max(SampleDateTime) FROM DailyPopulation
    SET @Now = GETUTCDATE();
    SET @Timeout = DATEADD(hh, -48, @Now);
BEGIN TRANSACTION
-- Expire Peer Leases
    INSERT INTO
        ShutdownPeers (
            Guid,
            Channel,
            IPAddress,
            FirstContact,
            LastContact,
            Version,
            UnRegister
        )
    SELECT
        Guid,
        Channel,
        IPAddress,
        FirstContact,
        GETUTCDATE(),
        Version,
        0
    FROM
        Peers
    WHERE
        Lease < @Now
    DELETE FROM
        Peers
    WHERE
        Lease < @Now
    SET @Expiration_Error = @@ERROR;
IF @Expiration_Error = 0
    COMMIT TRAN
ELSE
    ROLLBACK TRAN
-- TRANSACTION 1
-- Reporting and Timeouts
BEGIN TRANSACTION
    -- Timeouts
        -- Add Timed Out Nodes
        INSERT INTO
            TimedOutNodes (
                GUID,
                TimeOutDate
            )
        SELECT
            GUID,
            @Timeout As Expr1
        FROM
            NodeLastContact
        WHERE
            LastContact < @Timeout
        SET @Timeout_Add_Error = @@ERROR;
        -- Removed Timed Out Nodes from Current Nodes
        DELETE FROM
            NodeLastContact
        WHERE
            GUID IN (
                SELECT
                    TimedOutNodes.GUID
                FROM
                    NodeLastContact INNER JOIN
                    TimedOutNodes ON
                        (NodeLastContact.GUID = TimedOutNodes.GUID)
            )
        SET @Timeout_Delete_Error = @@ERROR;
    IF @Timeout_Delete_Error = 0
        COMMIT TRAN
    ELSE
        ROLLBACK TRAN
-- TRANSACTION 2
BEGIN TRANSACTION
    -- Mark Extinct Animals
        CREATE TABLE #ExtinctSpecies (Name varchar(250) collate SQL_Latin1_General_CP1_CI_AS)
        IF @@ERROR = 0
        BEGIN
                INSERT INTO
                        #ExtinctSpecies
                SELECT
                    Name
                FROM
                    Species
                        WHERE
                            Species.Name NOT IN (
                                SELECT
                                    SpeciesName
                                FROM
                                    DailyPopulation
                                WHERE
                                    SampleDateTime=(SELECT Max(SampleDateTime) FROM DailyPopulation)
                            ) AND
                            Species.Name NOT IN (
                                SELECT
                                    Name
                                FROM
                                    Species INNER JOIN
                                    NodeLastContact ON
                                        (Species.ReintroductionNode = NodeLastContact.GUID)
                                WHERE
                                    NodeLastContact.LastContact < Species.LastReintroduction
                            ) AND
                            Species.Name NOT IN (
                                SELECT DISTINCT
                                        SpeciesName
                                FROM
                                        History
                            ) AND
                        Species.DateAdded < @Last AND
                        Extinct = 0;
                IF @@ERROR = 0
                BEGIN
                        UPDATE
                                Species
                        SET
                                Extinct = 1,
                                Species.ExtinctDate = @Now
                        WHERE
                                Name IN (
                                        SELECT Name From #ExtinctSpecies
                                );
                        IF @@ERROR = 0
                        BEGIN
                            INSERT INTO
                                        DailyPopulation (
                                            SampleDateTime,
                                            SpeciesName,
                                            Population,
                                            BirthCount,
                                            StarvedCount,
                                            KilledCount,
                                            ErrorCount,
                                            SecurityViolationCount,
                                            TimeoutCount,
                                            SickCount,
                                            OldAgeCount
                                        )
                                SELECT
                                        @Now As Expr1,
                                        Name, 0, 0, 0, 0, 0, 0, 0, 0, 0
                                FROM
                                        #ExtinctSpecies    
                        END
                END
        END
        SET @Extinction_Error = @@ERROR;
    IF @Extinction_Error = 0
        COMMIT TRAN
    ELSE
        ROLLBACK TRAN
        -- Mark Non Extinct Animals
        UPDATE
                Species
        SET
                Species.Extinct = 0
        WHERE
                Species.Name IN (SELECT DISTINCT SpeciesName From History)
-- TRANSACTION 3
    -- Rollup
    INSERT INTO
        DailyPopulation (
            SampleDateTime,
            SpeciesName,
            Population,
            BirthCount,
            StarvedCount,
            KilledCount,
            ErrorCount,
            SecurityViolationCount,
            TimeoutCount,
            SickCount,
            OldAgeCount
        )
    SELECT
        @Now As Expr1,
        History.SpeciesName,
        Sum(History.Population) As SumOfPopulation,
        Sum(History.BirthCount) As SumOfBirthCount,
        Sum(History.StarvedCount) As SumOfStarvedCount,
        Sum(History.KilledCount) As SumOfKilledCount,
        Sum(History.ErrorCount) As SumOfErrors,
        Sum(History.SecurityViolationCount) As SumOfSecurityViolations,
        Sum(History.TimeoutCount) As SumOfTimeouts,
        Sum(History.SickCount) As SumOfSickCount,
        Sum(History.OldAgeCount) As SumOfOldAgeCount
    FROM
        NodeLastContact INNER JOIN
        History ON
            (NodeLastContact.LastTick = History.TickNumber) AND
            (NodeLastContact.GUID = History.GUID) INNER JOIN
        Species ON
            (Species.Name = History.SpeciesName)
    WHERE
        Species.Extinct = 0
    GROUP BY
        History.SpeciesName
    SET @Rollup_Error = @@ERROR;
        DELETE
                History
        FROM
                NodeLastContact INNER JOIN
                History ON (
                        NodeLastContact.LastTick > History.TickNumber AND
                        NodeLastContact.GUID = History.GUID
                )

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create procedure TerrariumCheckSpeciesBlackList

@Name	varchar(255)

AS

	SELECT	Blacklisted
	FROM	Species
	WHERE	Name = @Name


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumCheckSpeciesExtinct    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumCheckSpeciesExtinct]
    @Name varchar(255)
AS
    SELECT
        Count(Name)
    FROM
        Species
    WHERE
        Name=@Name
            AND
        Extinct = 1
            AND
        BlackListed = 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumDeletePeer    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE  PROCEDURE [dbo].[TerrariumDeletePeer]
    @Channel varchar(255),
    @IPAddress varchar(50),
    @Guid uniqueidentifier
AS
    INSERT INTO
        ShutdownPeers (
            Guid,
            Channel,
            IPAddress,
            FirstContact,
            LastContact,
            Version,
            UnRegister
        )
    SELECT
        Guid,
        Channel,
        IPAddress,
        FirstContact,
        GETUTCDATE(),
        Version,
        1
    FROM
        Peers
    WHERE
        Channel = @Channel AND
        IPAddress = @IPAddress AND
        Guid = @Guid
    DELETE FROM
        Peers
    WHERE
        Channel = @Channel AND
        IPAddress = @IPAddress AND
        Guid = @Guid

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabAllPeers    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE  PROCEDURE [dbo].[TerrariumGrabAllPeers]
    @Version varchar(255),
    @Channel varchar(255)
AS
    SELECT
        *
    FROM
        Peers
    WHERE
        Version=@Version AND
        Channel=@Channel

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabAllRecentSpecies    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE  PROCEDURE [dbo].[TerrariumGrabAllRecentSpecies]
    @Version varchar(255)
AS
    DECLARE @RecentDate datetime
    SELECT @RecentDate = DATEADD(dd, -5, getutcdate());
    
    SELECT
        Name,
        Type,
        Author,
        AuthorEmail,
        DateAdded,
        AssemblyFullName,
        Extinct,
        LastReintroduction,
        ReintroductionNode,
        Version,
        BlackListed
    FROM
        Species
    WHERE
        Version=@Version AND
        BlackListed=0 AND
        (
                (ExtinctDate > @RecentDate AND Extinct = 1) OR
                Extinct = 0
        )

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabAllSpecies    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE  PROCEDURE [dbo].[TerrariumGrabAllSpecies]
    @Version varchar(255)
AS
    SELECT
        Name,
        Type,
        Author,
        AuthorEmail,
        DateAdded,
        AssemblyFullName,
        Extinct,
        LastReintroduction,
        ReintroductionNode,
        Version,
        BlackListed
    FROM
        Species
    WHERE
        Version=@Version
            AND
        BlackListed=0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabExtinctRecentSpecies    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE  PROCEDURE [dbo].[TerrariumGrabExtinctRecentSpecies]
    @Version varchar(255)
AS
    DECLARE @RecentDate datetime
    SELECT @RecentDate = DATEADD(dd, -5, getutcdate());
    SELECT
        Name,
        Type,
        Author,
        AuthorEmail,
        DateAdded,
        AssemblyFullName,
        Extinct,
        LastReintroduction,
        ReintroductionNode,
        Version,
        BlackListed
    FROM
        Species
    WHERE
        Version=@Version AND
        Extinct=1 AND
        BlackListed=0 AND
        ExtinctDate > @RecentDate

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabExtinctSpecies    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE  PROCEDURE [dbo].[TerrariumGrabExtinctSpecies]
    @Version varchar(255)
AS
    SELECT
        Name,
        Type,
        Author,
        AuthorEmail,
        DateAdded,
        AssemblyFullName,
        Extinct,
        LastReintroduction,
        ReintroductionNode,
        Version,
        BlackListed
    FROM
        Species
    WHERE
        Version=@Version AND
        Extinct=1 AND
        BlackListed=0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabLatestSpeciesData    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumGrabLatestSpeciesData] (
    @SpeciesName varchar(50)
)
AS
    SELECT
        *
    FROM
        DailyPopulation
    WHERE
        SpeciesName = @SpeciesName AND
        SampleDateTime = (
            SELECT
                Max(SampleDateTime)
            FROM
                DailyPopulation
            WHERE
                SpeciesName = @SpeciesName
        )

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabNumPeers    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumGrabNumPeers]
    @Version varchar(255),
    @Channel varchar(255)
AS
    SELECT
        Count(*)
    FROM
        Peers
    WHERE
        Version=@Version AND
        Channel=@Channel

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabScaledPeers    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE  PROCEDURE [dbo].[TerrariumGrabScaledPeers]
    @Version varchar(255),
    @Channel varchar(255),
    @IPAddress varchar(50)
AS
DECLARE @Total int
DECLARE @BelowCount int
DECLARE @AboveCount int
SELECT @Total=count(*) FROM Peers WHERE Version=@Version AND Channel=@Channel
IF @Total > 30
    BEGIN
        SELECT @AboveCount=count(*)
        FROM Peers
        WHERE Version=@Version AND Channel=@Channel AND IPAddress>@IPAddress
        
        SELECT @BelowCount=count(*)
        FROM Peers
        WHERE Version=@Version AND Channel=@Channel AND IPAddress<@IPAddress
        
        IF @BelowCount < 10
            BEGIN
                SELECT IPAddress,Lease
                FROM Peers
                WHERE Version=@Version AND Channel=@Channel AND
                    (IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress>@IPAddress ORDER BY IPAddress ASC) OR
                     IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress<@IPAddress ORDER BY IPAddress DESC) OR
                                         IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress<'255.255.255.255' ORDER BY IPAddress DESC)
                    )
            END
        ELSE
            BEGIN
                IF @AboveCount < 10
                    BEGIN
                        SELECT IPAddress,Lease
                        FROM Peers
                        WHERE Version=@Version AND Channel=@Channel AND
                            (IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress>@IPAddress ORDER BY IPAddress ASC) OR
                             IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress<@IPAddress ORDER BY IPAddress DESC) OR
                                                 IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress>'0.0.0.0' ORDER BY IPAddress ASC)
                            )
                    END
                ELSE
                    BEGIN
                        SELECT IPAddress,Lease
                        FROM Peers
                        WHERE Version=@Version AND Channel=@Channel AND
                            (IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress>@IPAddress ORDER BY IPAddress ASC) OR
                             IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress<@IPAddress ORDER BY IPAddress DESC)
                            )
                    END
            END
    END
ELSE
    BEGIN
        SELECT IPAddress, Lease FROM Peers WHERE Version=@Version AND Channel=@Channel
    END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabSpeciesDataInDateRange    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumGrabSpeciesDataInDateRange] (
    @SpeciesName varchar(50),
    @BeginDate datetime,
    @EndDate datetime
)
AS
    SELECT
        *
    FROM
        DailyPopulation
    WHERE
        SpeciesName = @SpeciesName AND
        SampleDateTime BETWEEN @BeginDate AND @EndDate

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumGrabSpeciesInfo    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE   PROCEDURE [dbo].[TerrariumGrabSpeciesInfo]
AS
    SELECT
        Species.Name As SpeciesName,
        Species.Author As AuthorName,
        Species.AuthorEmail As AuthorEmail,
        Species.Version As Version,
        DailyPopulation.Population As Population,
        Species.Type As Type
    FROM
        Species INNER JOIN
        DailyPopulation ON (Species.Name = DailyPopulation.SpeciesName)
    WHERE
        DailyPopulation.SampleDateTime = (
            SELECT
                Max(SampleDateTime)
            FROM
                DailyPopulation
            WHERE
                DailyPopulation.SpeciesName = Species.Name
        ) AND
        BlackListed=0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.TerrariumInsertHistory    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumInsertHistory]
    @Guid uniqueidentifier,
    @TickNumber int,
    @SpeciesName varchar(255),
    @ContactTime datetime,
    @ClientTime datetime,
    @CorrectTime tinyint,
    @Population int,
    @BirthCount int,
    @TeleportedToCount int,
    @StarvedCount int,
    @KilledCount int,
    @TeleportedFromCount int,
    @ErrorCount int,
    @TimeoutCount int,
    @SickCount int,
    @OldAgeCount int,
    @SecurityViolationCount int,
    @BlackListed int out
AS
    SELECT
        @BlackListed=BlackListed
    FROM
        Species
    WHERE
        Name=@SpeciesName
    INSERT INTO
        History(
            GUID,
            TickNumber,
            SpeciesName,
            ContactTime,
            ClientTime,
            CorrectTime,
            Population,
            BirthCount,
            TeleportedToCount,
            StarvedCount,
            KilledCount,
            TeleportedFromCount,
            ErrorCount,
            TimeoutCount,
            SickCount,
            OldAgeCount,
            SecurityViolationCount
        )
        VALUES(
            @Guid,
            @TickNumber,
            @SpeciesName,
            @ContactTime,
            @ClientTime,
            @CorrectTime,
            @Population,
            @BirthCount,
            @TeleportedToCount,
            @StarvedCount,
            @KilledCount,
            @TeleportedFromCount,
            @ErrorCount,
            @TimeoutCount,
            @SickCount,
            @OldAgeCount,
            @SecurityViolationCount
        )

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumInsertSpecies    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumInsertSpecies]
    @Name varchar(255),
    @Version varchar(255),
    @Type varchar(50),
    @Author varchar(255),
    @AuthorEmail varchar(255),
    @Extinct tinyint,
    @DateAdded datetime,
    @AssemblyFullName text,
    @BlackListed bit
AS
    INSERT INTO
        Species(
            [Name],
            [Version],
            [Type],
            [Author],
            [AuthorEmail],
            [Extinct],
            [DateAdded],
            [AssemblyFullName],
            [BlackListed]
        )
        VALUES(
            @Name,
            @Version,
            @Type,
            @Author,
            @AuthorEmail,
            @Extinct,
            @DateAdded,
            @AssemblyFullName,
            @BlackListed
        )

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumInsertWatson    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE  PROCEDURE [dbo].[TerrariumInsertWatson]
    @LogType varchar(50),
    @MachineName varchar(255),
    @OSVersion varchar(50),
    @GameVersion varchar(50),
    @CLRVersion varchar(50),
    @ErrorLog text,
    @UserComment text,
    @UserEmail varchar(255)
AS
    INSERT INTO
        Watson(
            [LogType],
            [MachineName],
            [OSVersion],
            [GameVersion],
            [CLRVersion],
            [ErrorLog],
            [UserComment],
            [UserEmail]
        )
        VALUES(
            @LogType,
            @MachineName,
            @OSVersion,
            @GameVersion,
            @CLRVersion,
            @ErrorLog,
            @UserComment,
            @UserEmail
        )

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create  procedure TerrariumIsVersionDisabled

	@Version	varchar(255),
	@FullVersion	varchar(255)
as

    	DECLARE @Disabled bit;
	DECLARE @Message varchar(255);

	SELECT
		@Disabled=Disabled,
		@Message=Message
	FROM
		VersionedSettings
	WHERE
		Version=@FullVersion
    IF @@ROWCOUNT = 0
        BEGIN
            SELECT
		@Disabled=Disabled,
		@Message=Message
            FROM
                VersionedSettings
            WHERE
                Version=@Version
            IF @@ROWCOUNT = 0
                BEGIN
                    SELECT
			@Disabled=Disabled,
			@Message=Message
                    FROM    
                        VersionedSettings
                    WHERE
                        Version='Default'
                    INSERT INTO
                        VersionedSettings (
                            Version,
                            Disabled
                        ) VALUES (
                            @Version,
                            @Disabled
                        )
                    INSERT INTO
                        VersionedSettings (
                            Version,
                            Disabled
                        ) VALUES (
                            @FullVersion,
                            @Disabled
                        )
                END
            ELSE
                BEGIN
                    INSERT INTO
                        VersionedSettings (
                            Version,
                            Disabled
                        ) VALUES (
                            @FullVersion,
                            @Disabled
                        )
                END
        END	

SELECT Disabled = @Disabled, Message = @Message
	


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumRegisterPeer    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE     PROCEDURE [dbo].[TerrariumRegisterPeer]
    @Version varchar(255),
    @FullVersion varchar(255),
    @Channel varchar(255),
    @IPAddress varchar(50),
    @Guid uniqueidentifier,
    @Disabled_Error bit output
AS
    DECLARE @Disabled bit;
    DECLARE @Lease datetime;
    SET @Lease = DATEADD(mi, 15, GETUTCDATE());
    SELECT
        @Disabled=Disabled
    FROM
        VersionedSettings
    WHERE
        Version=@FullVersion
    IF @@ROWCOUNT = 0
        BEGIN
            SELECT
                @Disabled=Disabled
            FROM
                VersionedSettings
            WHERE
                Version=@Version
            IF @@ROWCOUNT = 0
                BEGIN
                    SELECT
                        @Disabled=Disabled
                    FROM    
                        VersionedSettings
                    WHERE
                        Version='Default'
                    INSERT INTO
                        VersionedSettings (
                            Version,
                            Disabled
                        ) VALUES (
                            @Version,
                            @Disabled
                        )
                    INSERT INTO
                        VersionedSettings (
                            Version,
                            Disabled
                        ) VALUES (
                            @FullVersion,
                            @Disabled
                        )
                END
            ELSE
                BEGIN
                    INSERT INTO
                        VersionedSettings (
                            Version,
                            Disabled
                        ) VALUES (
                            @FullVersion,
                            @Disabled
                        )
                END
        END
    IF @Disabled = 1
        BEGIN
            Set @Disabled_Error = 1;
        END
    ELSE
        BEGIN
            SELECT
                NULL
            FROM
                Peers
            WHERE
                Channel = @Channel AND
                IPAddress = @IPAddress
        
            IF @@ROWCOUNT = 0
                BEGIN
                    INSERT INTO
                        Peers(
                            Channel,
                            Version,
                            IPAddress,
                            Lease,
                            Guid,
                            FirstContact
                        )
                        VALUES(
                            @Channel,
                            @Version,
                            @IPAddress,
                            @Lease,
                            @Guid,
                            GETUTCDATE()
                        )
                END
            ELSE
                BEGIN
                    UPDATE
                        Peers
                    SET
                        Lease = @Lease,
                        Version = @Version
                    WHERE
                        Channel = @Channel AND
                        IPAddress = @IPAddress
                END
            Set @Disabled_Error = 0
        END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumRegisterPeerCountAndList    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE        PROCEDURE [dbo].[TerrariumRegisterPeerCountAndList]
    @Version varchar(255),
    @FullVersion varchar(255),
    @Channel varchar(255),
    @IPAddress varchar(50),
    @Guid uniqueidentifier,
    @Disabled_Error bit output,
    @PeerCount int output
AS
    DECLARE @Disabled bit;
    DECLARE @Lease datetime;
    DECLARE @Total int
    DECLARE @BelowCount int
    DECLARE @AboveCount int
    SELECT @PeerCount=0;
    SET @Lease = DATEADD(mi, 15, GETUTCDATE());
    SELECT
        @Disabled=Disabled
    FROM
        VersionedSettings
    WHERE
        Version=@FullVersion
    IF @@ROWCOUNT = 0
        BEGIN
            SELECT
                @Disabled=Disabled
            FROM
                VersionedSettings
            WHERE
                Version=@Version
            IF @@ROWCOUNT = 0
                BEGIN
                    SELECT
                        @Disabled=Disabled
                    FROM    
                        VersionedSettings
                    WHERE
                        Version='Default'
                    INSERT INTO
                        VersionedSettings (
                            Version,
                            Disabled
                        ) VALUES (
                            @Version,
                            @Disabled
                        )
                    INSERT INTO
                        VersionedSettings (
                            Version,
                            Disabled
                        ) VALUES (
                            @FullVersion,
                            @Disabled
                        )
                END
            ELSE
                BEGIN
                    INSERT INTO
                        VersionedSettings (
                            Version,
                            Disabled
                        ) VALUES (
                            @FullVersion,
                            @Disabled
                        )
                END
        END
    IF @Disabled = 1
        BEGIN
            Set @Disabled_Error = 1;
            SELECT TOP 0
                Lease,IPAddress
            FROM
                Peers
        END
    ELSE
        BEGIN
            DECLARE @Self int;
            SELECT
                @Self=count(*)
            FROM
                Peers
            WHERE
                Channel = @Channel AND
                IPAddress = @IPAddress
        
            IF @Self = 0
                BEGIN
                    BEGIN TRAN
                    INSERT INTO
                        Peers(
                            Channel,
                            Version,
                            IPAddress,
                            Lease,
                            Guid,
                            FirstContact
                        )
                        VALUES(
                            @Channel,
                            @Version,
                            @IPAddress,
                            @Lease,
                            @Guid,
                            GETUTCDATE()
                        )
                    COMMIT TRAN
                END
            ELSE
                BEGIN
                    BEGIN TRAN
                    UPDATE
                        Peers
                    SET
                        Lease = @Lease,
                        Version = @Version
                    WHERE
                        Channel = @Channel AND
                        IPAddress = @IPAddress
                    COMMIT TRAN
                END
            Set @Disabled_Error = 0
        SELECT
        @PeerCount=Count(*)
        FROM
            Peers
        WHERE
            Version=@Version AND
            Channel=@Channel
            SELECT @Total=count(*) FROM Peers WHERE Version=@Version AND Channel=@Channel
            IF @Total > 30
                BEGIN
                    SELECT @AboveCount=count(*)
                    FROM Peers
                    WHERE Version=@Version AND Channel=@Channel AND IPAddress>@IPAddress
        
                    SELECT @BelowCount=count(*)
                    FROM Peers
                    WHERE Version=@Version AND Channel=@Channel AND IPAddress<@IPAddress
        
                    IF @BelowCount < 10
                        BEGIN
                            SELECT IPAddress,Lease
                            FROM Peers
                            WHERE Version=@Version AND Channel=@Channel AND
                                (IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress>@IPAddress ORDER BY IPAddress ASC) OR
                                 IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress<@IPAddress ORDER BY IPAddress DESC) OR
                                                     IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress<'255.255.255.255' ORDER BY IPAddress DESC)
                                )
                        END
                    ELSE
                        BEGIN
                            IF @AboveCount < 10
                                BEGIN
                                    SELECT IPAddress,Lease
                                    FROM Peers
                                    WHERE Version=@Version AND Channel=@Channel AND
                                        (IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress>@IPAddress ORDER BY IPAddress ASC) OR
                                         IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress<@IPAddress ORDER BY IPAddress DESC) OR
                                         IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress>'0.0.0.0' ORDER BY IPAddress ASC)
                                        )
                                END
                            ELSE
                                BEGIN
                                    SELECT IPAddress,Lease
                                    FROM Peers
                                    WHERE Version=@Version AND Channel=@Channel AND
                                        (IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress>@IPAddress ORDER BY IPAddress ASC) OR
                                         IPAddress IN (select top 10 IPAddress from Peers Where Version=@Version AND Channel=@Channel AND IPAddress<@IPAddress ORDER BY IPAddress DESC)
                                        )
                                END
                        END
                END
            ELSE
                BEGIN
                    SELECT IPAddress, Lease FROM Peers WHERE Version=@Version AND Channel=@Channel
                END
        END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumRegisterUser    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE  PROCEDURE [dbo].[TerrariumRegisterUser]
    @Email varchar(255),
    @IPAddress varchar(50)
AS
    SELECT
        NULL
    FROM
        UserRegister
    WHERE
        IPAddress = @IPAddress
    IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO
                UserRegister(
                    IPAddress,
                    Email
                )
                VALUES(
                    @IPAddress,
                    @Email
                )
        END
    ELSE
        BEGIN
            UPDATE
                UserRegister
            SET
                Email = @Email
            WHERE
                IPAddress = @IPAddress
        END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.TerrariumReintroduceSpecies    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumReintroduceSpecies]
    @Name varchar(255),
    @ReintroductionNode uniqueidentifier,
    @LastReintroduction datetime
AS
    UPDATE
        Species
    SET
        Extinct = 0,
        ReintroductionNode=@ReintroductionNode,
        LastReintroduction=@LastReintroduction
    WHERE
        Name = @Name;

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.TerrariumTimeoutReport    Script Date: 11/8/2001 8:16:23 PM ******/
CREATE PROCEDURE [dbo].[TerrariumTimeoutReport]
    @Guid uniqueidentifier,
    @LastContact datetime,
    @LastTick int,
    @ReturnCode int output
AS
    Declare @MaxTick int
    Select @ReturnCode=0
    SELECT
        @MaxTick=Max(LastTick)
    FROM
        NodeLastContact
    WHERE
        Guid=@Guid
    -- Check to see if we have a record in the NodeLastContact
    -- Table
    IF @MaxTick IS NOT NULL
        BEGIN
            -- Now check to see if that record is newer
            -- than the current record from the client
            IF @MaxTick >= @LastTick
                BEGIN
                    Select @ReturnCode = 2
                END
            ELSE
                BEGIN
                    UPDATE
                        NodeLastContact
                    SET
                        LastTick = @LastTick,
                        LastContact = @LastContact
                    WHERE
                        Guid=@Guid
                END
        END
    ELSE
        BEGIN
            DECLARE @TimeoutCount datetime
            SELECT
                @TimeoutCount=Max(TimeoutDate)
            FROM
                TimedOutNodes
            WHERE
                Guid=@Guid
            IF @TimeoutCount IS NULL
                BEGIN
                    INSERT INTO
                        NodeLastContact(
                            LastTick,
                            LastContact,
                            Guid
                        )
                        VALUES(
                            @LastTick,
                            @LastContact,
                            @Guid
                        )
                END
            ELSE
                BEGIN
                    Select @ReturnCode=1
                END
        END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE TerrariumTopAnimals

	@Count		int,
	@Version	varchar(25),
	@SpeciesType	varchar(50)

AS

SET ROWCOUNT @Count

SELECT	Species.Name As Name, 
	Species.Author As AuthorName, 
	DailyPopulation.Population Population 
FROM	SPECIES INNER JOIN DailyPopulation ON (Species.Name = DailyPopulation.SpeciesName)
WHERE 	DailyPopulation.SampleDateTime = (SELECT Max(SampleDateTime) FROM DailyPopulation)
	AND Species.Version = @Version 
	AND Species.Type = @SpeciesType 
	AND DailyPopulation.SecurityViolationCount = 0 
	ORDER BY DailyPopulation.Population DESC

SET ROWCOUNT 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create procedure Web_GetTips
as

select id, tip from tips



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

