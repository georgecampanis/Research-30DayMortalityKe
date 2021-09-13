SELECT        c.CaseId, c.CasemainId, c.VisitId, cf.Age, c.AgeAtTimeOfSurgeryInDays, c.PatientType, c.IsArchived, c.HasVitalData, c.IsValid, c.HospitalLocation, c.ORGroup, c.SurgeonDivision, c.ModifiedMRN, c.SurgeryDate, c.CaseYear, 
                         c.CaseMonth, c.CaseDayOfMonth, c.Procedure1, c.Procedure2, c.Procedure3, c.ProcedureCategory, c.AdmissionDate, c.DischargeDate, c.LengthOfStayInDays, c.ProcedureAnatomy, cf.ASAStatus_ID, c.ASAStatusName, 
                         c.ASADescription
FROM            (SELECT        cs.CaseId, cs.CasemainId, cs.VisitId, cs.VisitAdmissionType, cs.AgeAtTimeOfSurgeryInDays, cs.PatientType, cs.IsArchived, cs.HasVitalData, cs.IsValid, cs.HospitalLocation, cs.ORGroup, cs.SurgeonDivision, 
                                                    cs.ModifiedMRN, cs.SurgeryDate, cs.CaseYear, cs.CaseMonth, cs.CaseDayOfMonth, cs.Procedure1, cs.Procedure2, cs.Procedure3, cs.ProcedureCategory, cs.AdmissionDate, cs.DischargeDate, 
                                                    cs.LengthOfStayInDays, cs.ProcedureAnatomy, cs.isValid4Mins, ch_1.ASAStatus_ID, ch_1.ASAStatusName, ch_1.ASADescription
                          FROM            (SELECT        CaseId, CasemainId, VisitId, VisitAdmissionType, AgeAtTimeOfSurgeryInDays, PatientType, IsArchived, HasVitalData, IsValid, HospitalLocation, ORGroup, SurgeonDivision, ModifiedMRN, SurgeryDate, 
                                                                              CaseYear, CaseMonth, CaseDayOfMonth, Procedure1, Procedure2, Procedure3, ProcedureCategory, AdmissionDate, DischargeDate, LengthOfStayInDays, ProcedureAnatomy, isValid4Mins
                                                    FROM            dbo.QI_CaseSummaryData
                                                    WHERE        (ModifiedMRN IS NOT NULL) AND (YEAR(SurgeryDate) >= 2013) AND (YEAR(SurgeryDate) <= 2017) AND (IsValid = 1) AND (HasVitalData = 1) AND (UPPER(SurgeonDivision) NOT LIKE '%CARDIAC%') AND 
                                                                              (UPPER(ProcedureAnatomy) NOT LIKE '%HEART%') AND (NOT (UPPER(Procedure1) LIKE '%ORGAN RETRIEVAL%'))) AS cs LEFT OUTER JOIN
                                                        (SELECT        PeriopDM.dbo.CaseHeader.Case_ID, a.ASAStatus_ID, a.ASAStatusName, a.ASADescription
                                                          FROM            PeriopDM.dbo.CaseHeader INNER JOIN
                                                                                    PeriopDM.dbo.ASAStatus AS a ON PeriopDM.dbo.CaseHeader.ASAStatus_ID = a.ASAStatus_ID
                                                          WHERE        (PeriopDM.dbo.CaseHeader.ASAStatus_ID < 11) OR
                                                                                    (PeriopDM.dbo.CaseHeader.ASAStatus_ID IS NULL)) AS ch_1 ON cs.CaseId = ch_1.Case_ID) AS c INNER JOIN
                             (SELECT        Case_ID, ASAStatus_ID, Age
                               FROM            PeriopDM.dbo.CaseHeader AS ch) AS cf ON c.CaseId = cf.Case_ID
WHERE        (cf.Age >= 45) AND (c.SurgeryDate BETWEEN CONVERT(DATETIME, '2013-01-01 00:00:00', 102) AND CONVERT(DATETIME, '2017-12-02 00:00:00', 102))
