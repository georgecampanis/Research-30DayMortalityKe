SELECT        CaseVitalData.Case_ID, CaseVitalData.Sequence, CaseVitalData.LastUpdate, CaseVitalData.Value, Unit.UnitName, CaseVitalDataHeader.VitalData_ID, VitalParameter.VitalParameterName
INTO IHPStudy.dbo.CaseTEMP
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
WHERE        (CaseVitalDataHeader.VitalData_ID IN (1434,
1435,
1458,
1459,
702))


-------------------------------------------------------------------------------------------------------
WITH CTE AS (
  SELECT
    rownum = ROW_NUMBER() over(PARTITION by  Case_ID  order by  [LastUpdate] asc ), Case_ID, [LastUpdate]  FROM CaseTEMP
)
SELECT cur.Case_Id, cur.[LastUpdate], DateDiff(SECOND,cur.[LastUpdate], nxt.[LastUpdate]) as dif
Into TEMPTimeDiff


FROM CTE cur
LEFT JOIN CTE prev on prev.rownum = cur.rownum + 1 and prev.Case_Id=cur.Case_Id
LEFT JOIN CTE nxt on nxt.rownum = cur.rownum -1 and nxt.Case_Id=cur.Case_Id

