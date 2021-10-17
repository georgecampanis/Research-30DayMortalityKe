

  SELECT        CaseVitalData.Case_ID, CaseVitalData.Sequence, CaseVitalData.LastUpdate, CaseVitalData.Value, Unit.UnitName, CaseVitalDataHeader.VitalData_ID, VitalParameter.VitalParameterName
INTO IHPStudy.dbo.BIS
FROM            VitalParameter INNER JOIN
                         VitalData ON VitalParameter.VitalParameter_ID = VitalData.VitalParameter_ID INNER JOIN
                         Unit ON VitalData.Unit_ID = Unit.Unit_ID INNER JOIN
                         CaseVitalDataHeader ON VitalData.VitalData_ID = CaseVitalDataHeader.VitalData_ID AND CaseVitalDataHeader.Unit_ID = Unit.Unit_ID INNER JOIN
                             (SELECT        vd.Case_ID, vd.Sequence, vd.CaseVitalDataHeader_ID, vd.Value, vd.LastUpdate, cd.CaseId
                               FROM            (SELECT        Case_ID, Sequence, CaseVitalDataHeader_ID, Value, LastUpdate
                                                         FROM            CaseVitalData) AS vd INNER JOIN
                                                             (SELECT        CaseId
                                                               FROM            IHPStudy.dbo.CaseData) AS cd ON vd.Case_ID = cd.CaseId) AS CaseVitalData ON CaseVitalDataHeader.Case_ID = CaseVitalData.Case_ID AND 
                         CaseVitalDataHeader.CaseVitalDataHeader_ID = CaseVitalData.CaseVitalDataHeader_ID
WHERE        (CaseVitalDataHeader.VitalData_ID IN (1512))



SELECT * 
INTO BIS46
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [LastUpdate] ,[Value] ,[case_Id] as Case_id   FROM [IHPStudy].[dbo].[CaseBIS] where [value] is not null'
,0, 45)
