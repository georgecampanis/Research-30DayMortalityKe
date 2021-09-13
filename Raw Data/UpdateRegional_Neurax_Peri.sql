update [IHPStudy].[dbo].[CaseBaseData]
set HadIntraopRegionalAnesMethod_neurax=1
Where CaseId in 
(

Select CaseId from (
Select a.Case_ID as caseId, t.na from 
(
(SELECT [Case_ID],[AnMethodType_ID] FROM [PeriopDM].[dbo].[CaseAnesthesiaRegionalMethod]) a
  Inner Join
  (SELECT  [AnMethodType_ID],[AnMethodTypeName] as na FROM [PeriopDM].[dbo].[AnesthesiaMethodType]) t
  On a.AnMethodType_ID=t.AnMethodType_ID

  )  where na='Regional - Neuraxial'
  )t2

)



update [IHPStudy].[dbo].[CaseBaseData]
set HadIntraopRegionalAnesMethod_peri=1
Where CaseId in 
(

Select CaseId from (
Select a.Case_ID as caseId, t.na from 
(
(SELECT [Case_ID],[AnMethodType_ID] FROM [PeriopDM].[dbo].[CaseAnesthesiaRegionalMethod]) a
  Inner Join
  (SELECT  [AnMethodType_ID],[AnMethodTypeName] as na FROM [PeriopDM].[dbo].[AnesthesiaMethodType]) t
  On a.AnMethodType_ID=t.AnMethodType_ID

  )  where na='Regional - Peripheral'
  )t2

)