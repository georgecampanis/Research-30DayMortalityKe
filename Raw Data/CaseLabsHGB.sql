---------------------------------------------------------------------------------------------------
 Select CaseId,surgeryDate, labDt,  [OrderNumber],  LabName , [Value], (DateDiff(DAY, surgeryDate,labDt)) as diffDays 
INTO IHPStudy.dbo.CaseLabsHGB
 from 
(SELECT [ModifiedMRN] as MRN,[OrderNumber], [RESULT_DT_TM] as labDt, TASK_ASSAY as LabName, [RESULT_VALUE] as [Value]  
FROM [LabsReporting].[dbo].[HL7LabResultsAllData] WHERE (HL7LabResultsAllData.TASK_ASSAY like 'Hgb') ) l
Inner Join
(SELECT        IHPStudy.dbo.CaseBaseData.CaseId, cs.SurgeryDate, cs.ModifiedMRN
FROM            IHPStudy.dbo.CaseBaseData INNER JOIN
                         PeriopDMReporting.dbo.QI_CaseSummaryData cs ON IHPStudy.dbo.CaseBaseData.CaseId = cs.CaseId) c
						 On l.MRN=c.ModifiedMRN
						 where (DateDiff(DAY, surgeryDate,labDt))>=0 and (DateDiff(DAY, surgeryDate,labDt))<=2


----------------------------------------------------------------------------------------------------------------------

-----OLD QUERY
SELECT        LabCaseIdMatch.CaseId, LabCaseIdMatch.OrderNumber, HL7LabResultsAllData.RESULT_DT_TM  as labDt, HL7LabResultsAllData.TASK_ASSAY, IHPStudy.dbo.CaseData.surgeryDate, DateDiff(DAY, HL7LabResultsAllData.RESULT_DT_TM,IHPStudy.dbo.CaseData.surgeryDate) as diffDays, HL7LabResultsAllData.RESULT_VALUE AS value
INTO IHPStudy.dbo.CaseLabsHGB
FROM            LabCaseIdMatch INNER JOIN
                         IHPStudy.dbo.CaseData ON LabCaseIdMatch.CaseId = IHPStudy.dbo.CaseData.CaseId INNER JOIN
                         HL7LabResultsAllData ON LabCaseIdMatch.OrderNumber = HL7LabResultsAllData.OrderNumber
WHERE        (HL7LabResultsAllData.TASK_ASSAY = 'Hgb') and ABS(DATEDIFF(day, IHPStudy.dbo.CaseData.SurgeryDate, [HL7LabResultsAllData].RESULT_DT_TM)) <= 2