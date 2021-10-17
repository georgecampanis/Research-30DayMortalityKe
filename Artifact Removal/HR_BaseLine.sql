
Update HR Set [HR_firstInnov]= b.HR From HR m Inner Join (SELECT  [Case_ID],[HR] FROM [IHPStudy].[dbo].[oHR_InnvFirstVal]) b On m.case_Id=b.[Case_ID];
Update HR Set [HR_HSM_PreopPreamit_Min]= b.HR From HR m Inner Join (SELECT  [CaseID],[HR] FROM [IHPStudy].[dbo].oHR_HSM) b On m.case_Id=b.[CaseID];





UPDATE       HR
SET                HRbaseline = null , HRBaseline_used= null;

UPDATE       HR
SET                HRbaseline = [oHR_HSM_PreOp].HR , HRBaseline_used= 'HSM-PreOp'--
FROM            HR INNER JOIN
                         [oHR_HSM_PreOp] ON HR.case_Id = [oHR_HSM_PreOp].caseId
Where HR.HRbaseline is null or HR.HRbaseline>[oHR_HSM_PreOp].HR ;


						 UPDATE       HR
SET                HRbaseline = oHR_HSM_Preadmit.hr , HRBaseline_used= 'HSM-PreAd'--
FROM            HR INNER JOIN
                         oHR_HSM_Preadmit ON HR.case_Id = oHR_HSM_Preadmit.caseId
Where HR.HRbaseline is null or HR.HRbaseline>oHR_HSM_Preadmit.hr;


---------------------------------------------------------------------

UPDATE       HR
SET                HRbaseline =oHR_InnvFirstVal.HR , HRBaseline_used= 'Innov'--
FROM            HR INNER JOIN
                         oHR_InnvFirstVal ON HR.case_Id = oHR_InnvFirstVal.case_Id
Where HR.HRbaseline is null
---------------------------------------------------------------------------------

---IS ELECTIVE

UPDATE       HR
SET               Iselective=1
FROM            HR INNER JOIN
                         [oHR_HSM_PreOp] ON HR.case_Id = [oHR_HSM_PreOp].caseId

						 UPDATE       HR
SET                Iselective=1
FROM            HR INNER JOIN
                         oHR_HSM_Preadmit ON HR.case_Id = oHR_HSM_Preadmit.caseId

