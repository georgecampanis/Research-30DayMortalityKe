---------------------------------------------------------------------------------------------------
--TEMP
UPDATE CaseTEMP SET  [WithinStEndTime] = 0;

UPDATE v
SET  [WithinStEndTime] = 1
FROM
    (SELECT [Case_ID],[LastUpdate] as dt,[WithinStEndTime]  FROM [IHPStudy].[dbo].[CaseTEMP]) v
INNER JOIN
    (SELECT  [caseId] ,[PatArriveDT],[PatLeaveDT]  FROM [IHPStudy].[dbo].[CaseStartEnd]) c
ON v.Case_ID= c.[caseId] and (v.dt >= [PatArriveDT] and v.dt <= [PatLeaveDT]) 
-------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--etCo2
UPDATE EtCO2 SET  [WithinStEndTime] = 0;

UPDATE v
SET  [WithinStEndTime] = 1
FROM
    (SELECT [Case_ID],[LastUpdate] as dt,[WithinStEndTime]  FROM [IHPStudy].[dbo].EtCO2) v
INNER JOIN
    (SELECT  [caseId] ,[PatArriveDT],[PatLeaveDT]  FROM [IHPStudy].[dbo].[CaseStartEnd]) c
ON v.Case_ID= c.[caseId] and (v.dt >= [PatArriveDT] and v.dt <= [PatLeaveDT]) 
-------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--HR
UPDATE HR SET  [WithinStEndTime] = 0;

UPDATE v
SET  [WithinStEndTime] = 1
FROM
    (SELECT [Case_ID],DT_SpO2 as dt,[WithinStEndTime]  FROM [IHPStudy].[dbo].HR) v
INNER JOIN
    (SELECT  [caseId] ,[PatArriveDT],[PatLeaveDT]  FROM [IHPStudy].[dbo].[CaseStartEnd]) c
ON v.Case_ID= c.[caseId] and (v.dt >= [PatArriveDT] and v.dt <= [PatLeaveDT]) 
-------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
--MAC
UPDATE MAC SET  [WithinStEndTime] = 0;

UPDATE v
SET  [WithinStEndTime] = 1
FROM
    (SELECT [CaseID],DT as dt,[WithinStEndTime]  FROM [IHPStudy].[dbo].MAC) v
INNER JOIN
    (SELECT  [caseId] ,[PatArriveDT],[PatLeaveDT]  FROM [IHPStudy].[dbo].[CaseStartEnd]) c
ON v.CaseID= c.[caseId] and (v.dt >= [PatArriveDT] and v.dt <= [PatLeaveDT]) 
-------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--MAP
UPDATE MAP SET  [WithinStEndTime] = 0;

UPDATE v
SET  [WithinStEndTime] = 1
FROM
    (SELECT [CaseID],DT as dt,[WithinStEndTime]  FROM [IHPStudy].[dbo].MAP) v
INNER JOIN
    (SELECT  [caseId] ,[PatArriveDT],[PatLeaveDT]  FROM [IHPStudy].[dbo].[CaseStartEnd]) c
ON v.CaseID= c.[caseId] and (v.dt >= [PatArriveDT] and v.dt <= [PatLeaveDT]) 
-------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--SPO2
UPDATE SPO2 SET  [WithinStEndTime] = 0;

UPDATE v
SET  [WithinStEndTime] = 1
FROM
    (SELECT [Case_ID],[LastUpdate] as dt,[WithinStEndTime]  FROM [IHPStudy].[dbo].SPO2) v
INNER JOIN
    (SELECT  [caseId] ,[PatArriveDT],[PatLeaveDT]  FROM [IHPStudy].[dbo].[CaseStartEnd]) c
ON v.Case_ID= c.[caseId] and (v.dt >= [PatArriveDT] and v.dt <= [PatLeaveDT]) 
-------------------------------------------------------------------------------------------------------