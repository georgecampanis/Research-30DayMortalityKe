SELECT * 
INTO SPO2_88
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [LastUpdate] ,[SPO2] ,[case_Id] as Case_id   FROM [IHPStudy].[dbo].[SPO2] where SPO2 is not null and [WithinStEndTime]=1'
,1.0, 87)

SELECT * 
INTO SPO2_90
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [LastUpdate] ,[SPO2] ,[case_Id] as Case_id   FROM [IHPStudy].[dbo].[SPO2] where SPO2 is not null and [WithinStEndTime]=1'
,1.0, 89)


SELECT * 
INTO EtCO2_30
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [LastUpdate] ,[EtCO2] ,[case_Id] as Case_id   FROM [IHPStudy].[dbo].[EtCO2] where EtCO2 is not null and [WithinStEndTime]=1'
,1.0, 29)

SELECT * 
INTO EtCO2_45
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [LastUpdate] ,[EtCO2] ,[case_Id] as Case_id   FROM [IHPStudy].[dbo].[EtCO2] where EtCO2 is not null and [WithinStEndTime]=1'
,46, 10000)




