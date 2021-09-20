						 Select l.* 
INTO  [IHPStudy].[dbo].[CaseLabsInnovian]
from
(
SELECT        CasePatientLabHeader.Case_ID, Lab.LabName, Lab.LastUpdate, CasePatientLab.Sequence, CasePatientLab.LabTestResult, LabUnit_1.LabUnitName,CasePatientLab.OrderNumber
FROM            PeriopDM.dbo.Lab INNER JOIN
                         PeriopDM.dbo.LabGroup ON Lab.LabGroup_ID = LabGroup.LabGroup_ID INNER JOIN
                         PeriopDM.dbo.LabUnit ON Lab.LabUnit_ID = LabUnit.LabUnit_ID INNER JOIN
                         PeriopDM.dbo.CasePatientLabHeader ON Lab.Lab_ID = CasePatientLabHeader.Lab_ID AND LabUnit.LabUnit_ID = CasePatientLabHeader.LabUnit_ID INNER JOIN
                         PeriopDM.dbo.CasePatientLab ON CasePatientLabHeader.Case_ID = CasePatientLab.Case_ID AND CasePatientLabHeader.CasePatientLabHeader_ID = CasePatientLab.CasePatientLabHeader_ID INNER JOIN
                         PeriopDM.dbo.LabUnit AS LabUnit_1 ON Lab.LabUnit_ID = LabUnit_1.LabUnit_ID AND CasePatientLabHeader.LabUnit_ID = LabUnit_1.LabUnit_ID
						 where LabName ='Creatinine')l
						  INNER JOIN 
						  (SELECT  [CaseId]  FROM [IHPStudy].[dbo].[CaseData]) cs
						  On l.Case_ID=cs.CaseId
