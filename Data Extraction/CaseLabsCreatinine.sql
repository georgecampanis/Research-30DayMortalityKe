
 Select CaseId,surgeryDate, labDt,  [OrderNumber],  LabName , [Value], (DateDiff(DAY, surgeryDate,labDt)) as diffDays 
INTO IHPStudy.dbo.Creatinine
 from 
(SELECT [ModifiedMRN] as MRN,[OrderNumber], [RESULT_DT_TM] as labDt, TASK_ASSAY as LabName, [RESULT_VALUE] as [Value]  
FROM [LabsReporting].[dbo].[HL7LabResultsAllData] WHERE (HL7LabResultsAllData.TASK_ASSAY like 'Creatinine') ) l
Inner Join
(SELECT        IHPStudy.dbo.CaseBaseData.CaseId, cs.SurgeryDate, cs.ModifiedMRN
FROM            IHPStudy.dbo.CaseBaseData INNER JOIN
                         PeriopDMReporting.dbo.QI_CaseSummaryData cs ON IHPStudy.dbo.CaseBaseData.CaseId = cs.CaseId) c
						 On l.MRN=c.ModifiedMRN
						 where (DateDiff(DAY, surgeryDate,labDt))<=0 and (DateDiff(DAY, surgeryDate,labDt))>=-30