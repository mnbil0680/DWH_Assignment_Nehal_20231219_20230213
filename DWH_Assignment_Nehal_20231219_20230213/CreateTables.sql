-- ============================================================
-- CreateTables.sql
-- Creates all tables required by the SSIS packages in the
-- DWH_Assignment_Nehal project.
-- Run this script in the target database BEFORE executing
-- any SSIS package.
--
-- Prerequisites:
--   Both databases listed below must already exist on the server
--   before running this script. Create them if needed:
--     CREATE DATABASE [data_warehouse_assignment];
--     CREATE DATABASE [DWH_Assignment];
--
-- Databases used:
--   data_warehouse_assignment  (Packages 1, 3, 4)
--   DWH_Assignment             (Package 2 – Data Connection)
-- ============================================================

USE [data_warehouse_assignment];
GO


-- ----------------------------------------------------------
-- Package 3 – Device Status SCD Type 2
-- Source table
-- ----------------------------------------------------------
IF OBJECT_ID('[dbo].[Device_Status]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Device_Status] (
        [Device_ID]     VARCHAR(10)  NOT NULL,
        [Device_Type]   VARCHAR(50)  NOT NULL,
        [Location]      VARCHAR(50)  NOT NULL,
        [Status]        VARCHAR(50)  NOT NULL,
        [Schedule_Date] DATE         NOT NULL,
        CONSTRAINT [PK_Device_Status] PRIMARY KEY CLUSTERED ([Device_ID] ASC)
    );
END;
GO

-- Target / dimension table (SCD Type 2)
IF OBJECT_ID('[dbo].[Device_Status_Target]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Device_Status_Target] (
        [Device_Key]  INT          IDENTITY(1,1) NOT NULL,
        [Device_ID]   VARCHAR(10)  NOT NULL,
        [Device_Type] VARCHAR(50)  NOT NULL,
        [Location]    VARCHAR(50)  NOT NULL,
        [Status]      VARCHAR(50)  NOT NULL,
        [Insert_Date] DATE         NOT NULL,
        [Active_Flag] INT          NOT NULL DEFAULT 1,
        [Version_No]  INT          NOT NULL DEFAULT 1,
        CONSTRAINT [PK_Device_Status_Target] PRIMARY KEY CLUSTERED ([Device_Key] ASC)
    );
    CREATE INDEX [IX_Device_Status_Target_Device_ID]
        ON [dbo].[Device_Status_Target] ([Device_ID], [Active_Flag]);
END;
GO

-- ----------------------------------------------------------
-- Package 4 – Trader Summary
-- Source table
-- ----------------------------------------------------------
IF OBJECT_ID('[dbo].[Raw_Trades]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Raw_Trades] (
        [ID]        INT          IDENTITY(1,1) NOT NULL,
        [Trader_ID] INT          NOT NULL,
        [Trade_TS]  DATETIME     NOT NULL,
        [Action]    VARCHAR(10)  NOT NULL,   -- 'BUY' or 'SELL'
        [Quantity]  INT          NOT NULL,
        CONSTRAINT [PK_Raw_Trades] PRIMARY KEY CLUSTERED ([ID] ASC)
    );
END;
GO

-- Summary / fact table
IF OBJECT_ID('[dbo].[Trader_Summary]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Trader_Summary] (
        [Att_Key]    INT      IDENTITY(1,1) NOT NULL,
        [Trader_ID]  INT      NOT NULL,
        [Trade_Date] DATE     NOT NULL,
        [Total_Buy]  BIGINT   NOT NULL DEFAULT 0,
        [Total_Sell] BIGINT   NOT NULL DEFAULT 0,
        CONSTRAINT [PK_Trader_Summary] PRIMARY KEY CLUSTERED ([Att_Key] ASC)
    );
END;
GO


