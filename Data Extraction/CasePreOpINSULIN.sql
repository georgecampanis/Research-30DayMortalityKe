Select d.* 
INTO IHPStudy.dbo.CasePreOpINSULIN from
(SELECT [CaseId]
      ,[drug1_name]
      ,[drug1_dose]
      ,[drug1_unit]
      ,[drug1_route]
      ,[drug1_freq]
      ,[drug1_dt], 'preadmission' as phase
  FROM [Drugs].[dbo].[HSM_OTHER_preadtest]
  UNION
  SELECT [CaseId]
      ,[drug1_name]
      ,[drug1_dose]
      ,[drug1_unit]
      ,[drug1_route]
      ,[drug1_freq]
      ,[drug1_dt], 'preop'
  FROM [Drugs].[dbo].[HSM_OTHER_preop])  d
  JOIN
  (Select Caseid from IHPStudy.dbo.CaseData) cs
  on d.CaseId=cs.CaseId


