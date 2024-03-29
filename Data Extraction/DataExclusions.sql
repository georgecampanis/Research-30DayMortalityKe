Update  [IHPStudy].[dbo].[RawCaseData] set isCaseHSMMissing=1  where [caseMainId] is null;

Update  [IHPStudy].[dbo].[RawCaseData] 
set [age]=ch.Age, ASA_Id= ASAStatus_ID 
from [RawCaseData]  r
INNER JOIN
(SELECT Case_ID, ASAStatus_ID, Age  FROM PeriopDM.dbo.CaseHeader) ch
On r.caseId=ch.Case_ID;

Update  [IHPStudy].[dbo].[RawCaseData]  set [isLessThan45]=1
where Age < 45;

Update  [IHPStudy].[dbo].[RawCaseData]  set [isCardiac]=1
where (UPPER(SurgeonDivision)  LIKE '%CARDIAC%') AND (UPPER(ProcedureAnatomy)  LIKE '%HEART%');

Update  [IHPStudy].[dbo].[RawCaseData]  set [isOrganRetrieval]=1
where UPPER(Procedure1) LIKE '%ORGAN RETRIEVAL%'; --62

Update  [IHPStudy].[dbo].[RawCaseData]  set [isASA6]=1
where ASA_ID>=11; --16

