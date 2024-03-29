USE [IHPStudy]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_HSM_Preadmit]
AS
SELECT        caseId, MIN(value) AS hr
FROM            (SELECT        ihp.surgeryDate, ihp.caseId, hs.CaseMainId, hs.phase_id, hs.chart_dt AS dt, hs.value, hs.label_seq
                          FROM            (SELECT        casemain_id AS CaseMainId, label_seq, chart_dt, phase_id, result_value AS value
                                                    FROM            PeriopDMReporting.dbo.CDHA_HSM_casevisitresultlistwt
                                                    WHERE        (label_seq = - 100003) AND (phase_id = 1) AND (CHARINDEX('/', result_value) = 0)) AS hs INNER JOIN
                                                        (SELECT        dbo.CaseBaseData.CaseId AS caseId, dbo.CaseBaseData.CasemainId, dbo.CaseData.surgeryDate
                                                          FROM            dbo.CaseBaseData INNER JOIN
                                                                                    dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId) AS ihp ON hs.CaseMainId = ihp.CasemainId) AS g
GROUP BY caseId, CaseMainId
GO
/****** Object:  View [dbo].[oHR_HSM_PreOp]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_HSM_PreOp]
AS
SELECT        caseId, MIN(value) AS hr
FROM            (SELECT        ihp.surgeryDate, ihp.caseId, hs.CaseMainId, hs.phase_id, hs.chart_dt AS dt, hs.value, hs.label_seq
                          FROM            (SELECT        casemain_id AS CaseMainId, label_seq, chart_dt, phase_id, result_value AS value
                                                    FROM            PeriopDMReporting.dbo.CDHA_HSM_casevisitresultlistwt
                                                    WHERE        (label_seq = - 100003) AND (phase_id = 2) AND (CHARINDEX('/', result_value) = 0)) AS hs INNER JOIN
                                                        (SELECT        dbo.CaseBaseData.CaseId AS caseId, dbo.CaseBaseData.CasemainId, dbo.CaseData.surgeryDate
                                                          FROM            dbo.CaseBaseData INNER JOIN
                                                                                    dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId) AS ihp ON hs.CaseMainId = ihp.CasemainId) AS g
GROUP BY caseId, CaseMainId
GO
/****** Object:  View [dbo].[oHR_HSM_PreopPreAdmitMin]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_HSM_PreopPreAdmitMin]
AS
SELECT        caseId, MIN(hr) AS hr
FROM            (SELECT        caseId, hr
                          FROM            dbo.oHR_HSM_Preadmit
                          UNION
                          SELECT        caseId, hr
                          FROM            dbo.oHR_HSM_PreOp) AS x
GROUP BY caseId
GO
/****** Object:  View [dbo].[oEBL]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oEBL]
AS
SELECT        Case_ID, SUM(value) AS ebl
FROM            (SELECT        Case_ID, FluidName, UnitName, Sequence, dt, value
                          FROM            dbo.CaseEBL
                          WHERE        (value > 0)) AS d
GROUP BY Case_ID
GO
/****** Object:  View [dbo].[oAPGAR]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oAPGAR]
AS
SELECT        CaseId, eblScore + MapScore + HRScore AS Surgical_APGAR_Score
FROM            (SELECT        CaseId, ebl, MinMap, MinHR, CASE WHEN ebl > 1000 THEN 0 WHEN ebl >= 601 AND ebl <= 1000 THEN 1 WHEN ebl >= 101 AND ebl <= 600 THEN 2 WHEN ebl <= 100 OR
                                                    ebl IS NULL THEN 3 END AS eblScore, CASE WHEN MinMap < 40 THEN 0 WHEN MinMap >= 40 AND MinMap <= 54 THEN 1 WHEN MinMap >= 55 AND 
                                                    MinMap <= 69 THEN 2 WHEN MinMap >= 70 THEN 3 END AS MapScore, CASE WHEN MinHR > 85 THEN 0 WHEN MinHR >= 76 AND MinHR <= 85 THEN 1 WHEN MinHR >= 66 AND 
                                                    MinHR <= 75 THEN 2 WHEN MinHR >= 56 AND MinHR <= 65 THEN 3 WHEN MinHR <= 55 THEN 4 END AS HRScore
                          FROM            (SELECT        dbo.CaseData.CaseId, dbo.oEBL.ebl, map.MinMap, hr.MinHR
                                                    FROM            dbo.CaseData LEFT OUTER JOIN
                                                                              dbo.oEBL ON dbo.CaseData.CaseId = dbo.oEBL.Case_ID LEFT OUTER JOIN
                                                                                  (SELECT        caseId, MIN(MAP) AS MinMap
                                                                                    FROM            dbo.MAP AS MAP_1
                                                                                    GROUP BY caseId) AS map ON dbo.CaseData.CaseId = map.caseId LEFT OUTER JOIN
                                                                                  (SELECT        Case_ID, MIN(HR) AS MinHR
                                                                                    FROM            dbo.HR AS HR_1
                                                                                    GROUP BY Case_ID) AS hr ON dbo.CaseData.CaseId = hr.Case_ID) AS d) AS f
GO
/****** Object:  View [dbo].[oBaseData]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oBaseData]
AS
SELECT        dbo.CaseData.StudyId, dbo.CaseData.surgeryDate AS SurgeryDate, dbo.CaseBaseData.Age, dbo.CaseBaseData.ASAStatusName AS ASA, dbo.CaseBaseData.BMI
FROM            dbo.CaseBaseData INNER JOIN
                         dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId
GO
/****** Object:  View [dbo].[oHR_HSM]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_HSM]
AS
SELECT        TOP (100) PERCENT caseId, MIN(hr) AS hr
FROM            (SELECT        dt AS hsm_dt, surgeryDate, caseId, CaseMainId, value AS hr, label_seq
                          FROM            (SELECT        ihp.surgeryDate, ihp.caseId, hs.CaseMainId, hs.phase_id, hs.chart_dt AS dt, hs.value, hs.label_seq
                                                    FROM            (SELECT        casemain_id AS CaseMainId, label_seq, chart_dt, phase_id, result_value AS value
                                                                              FROM            PeriopDMReporting.dbo.CDHA_HSM_casevisitresultlistwt
                                                                              WHERE        (label_seq = - 100003) AND (phase_id <= 2) AND (result_value >= 30) AND (result_value <= 170)) AS hs INNER JOIN
                                                                                  (SELECT        dbo.CaseBaseData.CaseId AS caseId, dbo.CaseBaseData.CasemainId, dbo.CaseData.surgeryDate
                                                                                    FROM            dbo.CaseBaseData INNER JOIN
                                                                                                              dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId) AS ihp ON hs.CaseMainId = ihp.CasemainId) AS a) AS g
GROUP BY caseId, CaseMainId
ORDER BY caseId
GO
/****** Object:  View [dbo].[oHR_pulse_var]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_pulse_var]
AS
SELECT        Case_ID, mxHR - minHR AS HR_pulse_var
FROM            (SELECT        Case_ID, MAX(HR) AS mxHR, MIN(HR) AS minHR
                          FROM            dbo.HR
                          GROUP BY Case_ID) AS t
GO
/****** Object:  View [dbo].[oHRlong100]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHRlong100]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS HR_longest_100
FROM            dbo.HR_100_Above
GO
/****** Object:  View [dbo].[oHRlong60]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHRlong60]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS HR_longest_60
FROM            dbo.HR_60
GO
/****** Object:  View [dbo].[oHRTotal100]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHRTotal100]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS HRduration100
FROM            dbo.HR_100_Above
GO
/****** Object:  View [dbo].[oHRTotal60]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHRTotal60]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS HRduration60
FROM            dbo.HR_60
GO
/****** Object:  View [dbo].[oLaparoscopy]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oLaparoscopy]
AS
SELECT        CaseId, 1 AS lapar
FROM            dbo.CaseBaseData
WHERE        ([procedure] LIKE '%lapar%')
GO
/****** Object:  View [dbo].[oMAPlong60]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAPlong60]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS Map_longest_60
FROM            dbo.MAP_60
GO
/****** Object:  View [dbo].[oMAPlong65]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAPlong65]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS Map_longest_65
FROM            dbo.MAP_65
GO
/****** Object:  View [dbo].[oMAPlong70]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAPlong70]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS Map_longest_70
FROM            dbo.MAP_70
GO
/****** Object:  View [dbo].[oMAPlong80]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAPlong80]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS Map_longest_80
FROM            dbo.MAP_80
GO
/****** Object:  View [dbo].[oMapTotal60]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMapTotal60]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS Map_Total_60
FROM            dbo.MAP_60
GO
/****** Object:  View [dbo].[oMapTotal65]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMapTotal65]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS Map_Total_65
FROM            dbo.MAP_65
GO
/****** Object:  View [dbo].[oMapTotal70]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMapTotal70]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS Map_Total_70
FROM            dbo.MAP_70
GO
/****** Object:  View [dbo].[oMapTotal80]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMapTotal80]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS Map_Total_80
FROM            dbo.MAP_80
GO
/****** Object:  View [dbo].[oPostOpHGB]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oPostOpHGB]
AS
SELECT        t.CaseId, t.MinHGB
FROM            dbo.CaseBaseData AS CaseBaseData_1 INNER JOIN
                             (SELECT        t_1.CaseId, MIN(t_1.Value) AS MinHGB
                               FROM            (SELECT        CaseId, OrderNumber, labDt, LabName, surgeryDate, diffDays, Value
                                                         FROM            dbo.CaseLabsHGB
                                                         WHERE        (diffDays >= 0) AND (diffDays <= 2)) AS t_1 INNER JOIN
                                                         dbo.CaseBaseData ON t_1.CaseId = dbo.CaseBaseData.CaseId
                               GROUP BY t_1.CaseId, dbo.CaseBaseData.CasemainId) AS t ON CaseBaseData_1.CaseId = t.CaseId
GO
/****** Object:  View [dbo].[oPRBC]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oPRBC]
AS
SELECT        Case_ID, SUM(value) AS prbc
FROM            (SELECT        Case_ID, FluidName, UnitName, Sequence, dt, value
                          FROM            dbo.CasePRBC
                          WHERE        (value > 0)) AS d
GROUP BY Case_ID
GO
/****** Object:  View [dbo].[oPreop_creatinine]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oPreop_creatinine]
AS
SELECT        t.CaseId, t.MaxCreatinine
FROM            dbo.CaseBaseData AS CaseBaseData_1 INNER JOIN
                             (SELECT        t_1.CaseId, MAX(t_1.Value) AS MaxCreatinine
                               FROM            (SELECT        CaseId, OrderNumber, labDt, LabName, surgeryDate, diffDays, Value
                                                         FROM            dbo.CaseLabsCreatinine
                                                         WHERE        (diffDays <= 0) AND (diffDays >= - 30)) AS t_1 INNER JOIN
                                                         dbo.CaseBaseData ON t_1.CaseId = dbo.CaseBaseData.CaseId
                               GROUP BY t_1.CaseId, dbo.CaseBaseData.CasemainId) AS t ON CaseBaseData_1.CaseId = t.CaseId
GO
/****** Object:  View [dbo].[oPreop_insulin]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*where phase='preop'*/
CREATE VIEW [dbo].[oPreop_insulin]
AS
SELECT DISTINCT CaseId, 1 AS ins
FROM            (SELECT        dbo.CasePreOpINSULIN.CaseId, dbo.CasePreOpINSULIN.drug1_name, dbo.CasePreOpINSULIN.drug1_dose, dbo.CasePreOpINSULIN.drug1_unit, dbo.CasePreOpINSULIN.drug1_route, 
                                                    dbo.CasePreOpINSULIN.drug1_freq, dbo.CasePreOpINSULIN.drug1_dt, dbo.CasePreOpINSULIN.phase
                          FROM            dbo.CasePreOpINSULIN INNER JOIN
                                                    dbo.CaseBaseData ON dbo.CasePreOpINSULIN.CaseId = dbo.CaseBaseData.CaseId) AS t
GO
/****** Object:  View [dbo].[oSBPlong100]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBPlong100]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS SBP_longest_100
FROM            dbo.SBP_100
GO
/****** Object:  View [dbo].[oSBPlong80]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBPlong80]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS SBP_longest_80
FROM            dbo.SBP_80
GO
/****** Object:  View [dbo].[oSBPlong90]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBPlong90]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS SBP_longest_90
FROM            dbo.SBP_90
GO
/****** Object:  View [dbo].[oSBPTotal100]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBPTotal100]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS SBP_Total_100
FROM            dbo.SBP_100
GO
/****** Object:  View [dbo].[oSBPTotal80]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBPTotal80]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS SBP_Total_80
FROM            dbo.SBP_80
GO
/****** Object:  View [dbo].[oSBPTotal90]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBPTotal90]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS SBP_Total_90
FROM            dbo.SBP_90
GO
/****** Object:  View [dbo].[oTempAbove38]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oTempAbove38]
AS
SELECT        Case_ID, SumTime / 60.0 AS TotalMin
FROM            (SELECT        Case_ID, SUM(TimeDiffs) AS SumTime
                          FROM            (SELECT        Case_ID, ABS(TimeDiff) AS TimeDiffs
                                                    FROM            (SELECT        Case_ID, Sequence, LastUpdate, Value, UnitName, VitalData_ID, VitalParameterName, TimeDiff, WithinStEndTime
                                                                              FROM            dbo.CaseTEMP
                                                                              WHERE        (WithinStEndTime = 1)) AS derivedtbl_1
                                                    WHERE        (ABS(TimeDiff) >= 2) AND (ABS(TimeDiff) <= 20) AND (Value > 38)) AS z
                          GROUP BY Case_ID) AS e
GO
/****** Object:  View [dbo].[oTempBelow36]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oTempBelow36]
AS
SELECT        Case_ID, SumTime / 60.0 AS TotalMin
FROM            (SELECT        Case_ID, SUM(TimeDiffs) AS SumTime
                          FROM            (SELECT        Case_ID, ABS(TimeDiff) AS TimeDiffs
                                                    FROM            (SELECT        Case_ID, Sequence, LastUpdate, Value, UnitName, VitalData_ID, VitalParameterName, TimeDiff, WithinStEndTime
                                                                              FROM            dbo.CaseTEMP
                                                                              WHERE        (WithinStEndTime = 1)) AS derivedtbl_1
                                                    WHERE        (ABS(TimeDiff) >= 2) AND (ABS(TimeDiff) <= 20) AND (Value < 36)) AS z
                          GROUP BY Case_ID) AS e
GO
/****** Object:  View [dbo].[FinalExtraction]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FinalExtraction]
AS
SELECT        b.StudyId, b.SurgeryDate, b.Age, b.ASA, b.BMI, ISNULL(ins.Preop_insulin, 0) AS Preop_insulin, creat.MaxCreatinine AS Preop_creatinine, dbo.oMAP_HSM.map AS MAP_preop_HSM, dbo.oPostOpHGB.MaxHGB AS Hemoglobin, 
                         dbo.oEBL.ebl, dbo.oSBP_HSM.sbp AS SBP_Preop_HSM, dbo.oHR_HSM.hr AS HR_Preop_HSM, dbo.oMAP_InnvFirstVal.map AS MAP_First_Innovian, dbo.oSBP_InnvFirstVal.SBP AS SBP_first_Innovian, 
                         ISNULL(dbo.oLaparoscopy.lapar, 0) AS Laparoscopy_booked, dbo.oPRBC.prbc, dbo.oTempBelow36.TotalMin AS Temperature36, dbo.oTempAbove38.TotalMin AS Temperature38, 
                         dbo.oSBPMaxDelta_emerg.d AS SBP_maxdelta_abs_emerg, dbo.oSBPMaxDelta_emerg_perc.d AS SBP_maxdelta_rel_emerg, dbo.oSBPMaxDelta_elect.d AS SBP_maxdelta_abs_elective, 
                         dbo.oSBPMaxDelta_elect_perc.d AS SBP_maxdelta_rel_elective, dbo.oSBP_20Perc_elect.SBP_duration_rel_elective, dbo.oSBP_20Perc_emerg.SBP_duration_rel_emergency, 
                         dbo.oSBPlong100.SBP_longest_100 AS SBPlongest100, dbo.oSBPlong90.SBP_longest_90 AS SBPlongest90, dbo.oSBPlong80.SBP_longest_80 AS SBPlongest80, dbo.oSBPTotal100.SBP_Total_100 AS SBPcumulative100, 
                         dbo.oSBPTotal90.SBP_Total_90 AS SBPcumulative90, dbo.oSBPTotal80.SBP_Total_80 AS SBPcumulative80, dbo.oMAPlong80.Map_longest_80 AS MAPlongest80, dbo.oMAPlong70.Map_longest_70 AS MAPlongest70, 
                         dbo.oMAPlong65.Map_longest_65 AS MAPlongest65, dbo.oMAPlong60.Map_longest_60 AS MAPlongest60, dbo.oMapTotal80.Map_Total_80 AS MAPcumulative80, dbo.oMapTotal70.Map_Total_70 AS MAPcumulative70, 
                         dbo.oMapTotal65.Map_Total_65 AS MAPcumulative65, dbo.oMapTotal60.Map_Total_60 AS MAPcumulative60, dbo.oMAPMaxDelta_emergency.d AS MAP_maxdelta_abs_emergency, 
                         dbo.oMAPMaxDelta_emerg_perc.d AS MAP_maxdelta_rel_emergency, dbo.oMAP_20Perc_elect.MAP_duration_rel_elective AS MAP_duration_rel_elect, dbo.oMAPMaxDelta_elect.d AS MAP_maxdelta_abs_elect, 
                         dbo.oMAPMaxDelta_elect_perc.d AS MAP_maxdelta_rel_elect, dbo.oMAP_20Perc_emerg.MAP_duration_rel_elective AS MAP_duration_rel_emerg, dbo.oHR_max_pos_abs_emerg.HR_max_pos_abs_emergency, 
                         dbo.oHR_max_pos_abs_elect.HR_max_pos_abs_elect, dbo.oHR_max_neg_abs_emerg.HR_max_pos_abs_emergency AS HR_max_neg_abs_emergency, 
                         dbo.oHR_max_pos_rel_emerg.HR_max_pos_rel_emerg AS HR_max_pos_rel_emergency, dbo.oHR_max_pos_rel_elect.HR_max_pos_rel_elect, dbo.oHR_max_neg_rel_emerg.HR_max_pos_rel_emerg, 
                         dbo.oHR_max_neg_rel_elect.HR_max_pos_rel_elect AS HR_max_pos_rel_elective, dbo.oHR_pulse_var.HR_pulse_var, dbo.oHRlong60.HR_longest_60, dbo.oHRlong100.HR_longest_100, dbo.oHRTotal60.HRduration60, 
                         dbo.oHRTotal100.HRduration100
FROM            (SELECT        CaseId, StudyId, surgeryDate, included
                          FROM            dbo.CaseData
                          WHERE        (included = 1)) AS c INNER JOIN
                         dbo.oBaseData AS b ON c.StudyId = b.StudyId INNER JOIN
                         dbo.oMapTotal70 ON c.CaseId = dbo.oMapTotal70.CaseId INNER JOIN
                         dbo.oMapTotal65 ON c.CaseId = dbo.oMapTotal65.CaseId INNER JOIN
                         dbo.oMapTotal60 ON c.CaseId = dbo.oMapTotal60.CaseId LEFT OUTER JOIN
                         dbo.oHRTotal100 ON c.CaseId = dbo.oHRTotal100.CaseId LEFT OUTER JOIN
                         dbo.oHRlong60 ON c.CaseId = dbo.oHRlong60.CaseId LEFT OUTER JOIN
                         dbo.oHRTotal60 ON c.CaseId = dbo.oHRTotal60.CaseId LEFT OUTER JOIN
                         dbo.oHRlong100 ON c.CaseId = dbo.oHRlong100.CaseId LEFT OUTER JOIN
                         dbo.oHR_pulse_var ON c.CaseId = dbo.oHR_pulse_var.Case_ID LEFT OUTER JOIN
                         dbo.oHR_max_neg_rel_elect ON c.CaseId = dbo.oHR_max_neg_rel_elect.Case_ID LEFT OUTER JOIN
                         dbo.oHR_max_neg_rel_emerg ON c.CaseId = dbo.oHR_max_neg_rel_emerg.Case_ID LEFT OUTER JOIN
                         dbo.oHR_max_pos_rel_elect ON c.CaseId = dbo.oHR_max_pos_rel_elect.Case_ID LEFT OUTER JOIN
                         dbo.oHR_max_pos_rel_emerg ON c.CaseId = dbo.oHR_max_pos_rel_emerg.Case_ID LEFT OUTER JOIN
                         dbo.oHR_max_neg_abs_elect ON c.CaseId = dbo.oHR_max_neg_abs_elect.Case_ID LEFT OUTER JOIN
                         dbo.oHR_max_neg_abs_emerg ON c.CaseId = dbo.oHR_max_neg_abs_emerg.Case_ID LEFT OUTER JOIN
                         dbo.oHR_max_pos_abs_elect ON c.CaseId = dbo.oHR_max_pos_abs_elect.Case_ID LEFT OUTER JOIN
                         dbo.oHR_max_pos_abs_emerg ON c.CaseId = dbo.oHR_max_pos_abs_emerg.Case_ID LEFT OUTER JOIN
                         dbo.oMAPMaxDelta_elect_perc ON c.CaseId = dbo.oMAPMaxDelta_elect_perc.caseId LEFT OUTER JOIN
                         dbo.oMAP_20Perc_emerg ON c.CaseId = dbo.oMAP_20Perc_emerg.caseId LEFT OUTER JOIN
                         dbo.oMAPMaxDelta_elect ON c.CaseId = dbo.oMAPMaxDelta_elect.caseId LEFT OUTER JOIN
                         dbo.oMAP_20Perc_elect ON c.CaseId = dbo.oMAP_20Perc_elect.caseId LEFT OUTER JOIN
                         dbo.oMAPMaxDelta_emerg_perc ON c.CaseId = dbo.oMAPMaxDelta_emerg_perc.caseId LEFT OUTER JOIN
                         dbo.oMAPMaxDelta_emergency ON c.CaseId = dbo.oMAPMaxDelta_emergency.caseId LEFT OUTER JOIN
                         dbo.oMapTotal80 ON c.CaseId = dbo.oMapTotal80.CaseId LEFT OUTER JOIN
                         dbo.oMAPlong80 ON c.CaseId = dbo.oMAPlong80.CaseId LEFT OUTER JOIN
                         dbo.oMAPlong60 ON c.CaseId = dbo.oMAPlong60.CaseId LEFT OUTER JOIN
                         dbo.oMAPlong65 ON c.CaseId = dbo.oMAPlong65.CaseId LEFT OUTER JOIN
                         dbo.oMAPlong70 ON c.CaseId = dbo.oMAPlong70.CaseId LEFT OUTER JOIN
                         dbo.oSBPTotal80 ON c.CaseId = dbo.oSBPTotal80.CaseId LEFT OUTER JOIN
                         dbo.oSBPTotal90 ON c.CaseId = dbo.oSBPTotal90.CaseId LEFT OUTER JOIN
                         dbo.oSBPTotal100 ON c.CaseId = dbo.oSBPTotal100.CaseId LEFT OUTER JOIN
                         dbo.oSBPlong80 ON c.CaseId = dbo.oSBPlong80.CaseId LEFT OUTER JOIN
                         dbo.oSBPlong90 ON c.CaseId = dbo.oSBPlong90.CaseId LEFT OUTER JOIN
                         dbo.oSBPlong100 ON c.CaseId = dbo.oSBPlong100.CaseId LEFT OUTER JOIN
                         dbo.oPRBC ON c.CaseId = dbo.oPRBC.Case_ID LEFT OUTER JOIN
                         dbo.oSBP_20Perc_emerg ON c.CaseId = dbo.oSBP_20Perc_emerg.caseId LEFT OUTER JOIN
                         dbo.oSBP_20Perc_elect ON c.CaseId = dbo.oSBP_20Perc_elect.caseId LEFT OUTER JOIN
                         dbo.oSBPMaxDelta_elect ON c.CaseId = dbo.oSBPMaxDelta_elect.caseId LEFT OUTER JOIN
                         dbo.oSBPMaxDelta_elect_perc ON c.CaseId = dbo.oSBPMaxDelta_elect_perc.caseId LEFT OUTER JOIN
                         dbo.oSBPMaxDelta_emerg_perc ON c.CaseId = dbo.oSBPMaxDelta_emerg_perc.caseId LEFT OUTER JOIN
                         dbo.oSBPMaxDelta_emerg ON c.CaseId = dbo.oSBPMaxDelta_emerg.caseId LEFT OUTER JOIN
                         dbo.oTempAbove38 ON c.CaseId = dbo.oTempAbove38.Case_ID LEFT OUTER JOIN
                         dbo.oTempBelow36 ON c.CaseId = dbo.oTempBelow36.Case_ID LEFT OUTER JOIN
                         dbo.oEBL ON c.CaseId = dbo.oEBL.Case_ID LEFT OUTER JOIN
                         dbo.oLaparoscopy ON c.CaseId = dbo.oLaparoscopy.CaseId LEFT OUTER JOIN
                         dbo.oSBP_InnvFirstVal ON c.CaseId = dbo.oSBP_InnvFirstVal.caseId LEFT OUTER JOIN
                         dbo.oMAP_InnvFirstVal ON c.CaseId = dbo.oMAP_InnvFirstVal.caseId LEFT OUTER JOIN
                         dbo.oHR_HSM ON c.CaseId = dbo.oHR_HSM.caseId LEFT OUTER JOIN
                         dbo.oMAP_HSM ON c.CaseId = dbo.oMAP_HSM.caseId LEFT OUTER JOIN
                         dbo.oSBP_HSM ON c.CaseId = dbo.oSBP_HSM.caseId LEFT OUTER JOIN
                         dbo.oPostOpHGB ON c.CaseId = dbo.oPostOpHGB.CaseId LEFT OUTER JOIN
                         dbo.oPreop_creatinine AS creat ON c.CaseId = creat.CaseId LEFT OUTER JOIN
                             (SELECT        CaseId, 1 AS Preop_insulin
                               FROM            dbo.oPreop_insulin) AS ins ON c.CaseId = ins.CaseId
GO
/****** Object:  View [dbo].[_oHR_max_neg_abs_elect]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oHR_max_neg_abs_elect]
AS
SELECT        Case_ID, ABS(minHR - HRBaseline) AS HR_max_neg_abs_elect
FROM            (SELECT        Case_ID, MIN(HR) AS minHR, HRBaseline
                          FROM            dbo.HR
                          GROUP BY Case_ID, HRBaseline) AS a
WHERE        (minHR - HRBaseline < 0)
GO
/****** Object:  View [dbo].[_oHR_max_neg_abs_emerg]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oHR_max_neg_abs_emerg]
AS
SELECT        HR.Case_ID, ABS(HR.minHR - dbo.oHR_InnvFirstVal.HR) AS HR_max_neg_abs_emergency
FROM            (SELECT        Case_ID, MIN(HR) AS minHR
                          FROM            dbo.HR AS HR_1
                          GROUP BY Case_ID) AS HR INNER JOIN
                         dbo.oHR_InnvFirstVal ON HR.Case_ID = dbo.oHR_InnvFirstVal.Case_ID
WHERE        (HR.minHR - dbo.oHR_InnvFirstVal.HR < 0)
GO
/****** Object:  View [dbo].[_oHR_max_neg_rel_elect]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oHR_max_neg_rel_elect]
AS
SELECT        Case_ID, ABS(minHR - HRBaseline) / HRBaseline AS HR_max_neg_rel_elect
FROM            (SELECT        Case_ID, MIN(HR) AS minHR, HRBaseline
                          FROM            dbo.HR
                          GROUP BY Case_ID, HRBaseline) AS a
WHERE        (minHR - HRBaseline < 0)
GO
/****** Object:  View [dbo].[_oHR_max_neg_rel_emerg]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oHR_max_neg_rel_emerg]
AS
SELECT        Case_ID, ABS(minHR - FirstInnov) / FirstInnov AS HR_max_neg_rel_emerg
FROM            (SELECT        Case_ID, MIN(HR) AS minHR, HR_firstInnov AS FirstInnov
                          FROM            dbo.HR
                          GROUP BY Case_ID, HR_firstInnov) AS a
WHERE        (minHR - FirstInnov < 0)
GO
/****** Object:  View [dbo].[_oHR_max_pos_abs_elect]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oHR_max_pos_abs_elect]
AS
SELECT        Case_ID, mxHR - HRBaseline AS HR_max_pos_abs_elect
FROM            (SELECT        Case_ID, MAX(HR) AS mxHR, HRBaseline
                          FROM            dbo.HR
                          GROUP BY Case_ID, HRBaseline) AS a
WHERE        (mxHR - HRBaseline >= 0)
GO
/****** Object:  View [dbo].[_oHR_max_pos_abs_emerg]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oHR_max_pos_abs_emerg]
AS
SELECT        HR.Case_ID, HR.mxHR - dbo.oHR_InnvFirstVal.HR AS HR_max_pos_abs_emergency
FROM            (SELECT        Case_ID, MAX(HR) AS mxHR
                          FROM            dbo.HR AS HR_1
                          GROUP BY Case_ID) AS HR INNER JOIN
                         dbo.oHR_InnvFirstVal ON HR.Case_ID = dbo.oHR_InnvFirstVal.Case_ID
WHERE        (HR.mxHR - dbo.oHR_InnvFirstVal.HR >= 0)
GO
/****** Object:  View [dbo].[_oHR_max_pos_rel_elect]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oHR_max_pos_rel_elect]
AS
SELECT        (mxHR - HRBaseline) / HRBaseline AS HR_max_pos_rel_elect, Case_ID
FROM            (SELECT        Case_ID, MAX(HR) AS mxHR, HRBaseline
                          FROM            dbo.HR
                          GROUP BY Case_ID, HRBaseline) AS a
WHERE        (mxHR - HRBaseline >= 0)
GO
/****** Object:  View [dbo].[_oHR_max_pos_rel_emerg]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oHR_max_pos_rel_emerg]
AS
SELECT        (mxHR - FirstInnov) / FirstInnov AS HR_max_pos_rel_emerg, Case_ID
FROM            (SELECT        Case_ID, MAX(HR) AS mxHR, HR_firstInnov AS FirstInnov
                          FROM            dbo.HR
                          GROUP BY Case_ID, HR_firstInnov) AS a
WHERE        (mxHR - FirstInnov >= 0)
GO
/****** Object:  View [dbo].[_oMAP_20Perc_elect]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oMAP_20Perc_elect]
AS
SELECT        caseId, SUM(nxtTimeDiffSecs) / 60.0 AS MAP_duration_rel_elective
FROM            dbo.MAP
WHERE        (MAP_Below20perc_PreOp_Baseline = 1)
GROUP BY caseId
GO
/****** Object:  View [dbo].[_oMAP_20Perc_emerg]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oMAP_20Perc_emerg]
AS
SELECT        caseId, SUM(nxtTimeDiffSecs) / 60.0 AS MAP_duration_rel_elective
FROM            dbo.MAP
WHERE        (MAP_Below20perc_PreOp_Baseline = 1)
GROUP BY caseId
GO
/****** Object:  View [dbo].[_oMAPMaxDelta_elect]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oMAPMaxDelta_elect]
AS
SELECT        caseId, ABS(minMAP - MAPbaseline) AS d, minMAP, MAPbaseline
FROM            (SELECT        caseId, MIN(MAP) AS minMAP, MAPbaseline
                          FROM            dbo.MAP
                          GROUP BY caseId, MAPbaseline) AS x
GO
/****** Object:  View [dbo].[_oMAPMaxDelta_elect_perc]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oMAPMaxDelta_elect_perc]
AS
SELECT        caseId, ABS(minMAP - MAP_benchmark) / MAP_benchmark AS d, minMAP, MAP_benchmark
FROM            (SELECT        caseId, MIN(MAP) AS minMAP, MAPbaseline AS MAP_benchmark
                          FROM            dbo.MAP
                          GROUP BY caseId, MAPbaseline) AS x
GO
/****** Object:  View [dbo].[_oMAPMaxDelta_emerg_perc]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oMAPMaxDelta_emerg_perc]
AS
SELECT        caseId, ABS(minMAP - MAP_benchmark) / MAP_benchmark AS d, minMAP, MAP_benchmark
FROM            (SELECT        caseId, MIN(MAP) AS minMAP, firstInnvMap AS MAP_benchmark
                          FROM            dbo.MAP
                          GROUP BY caseId, firstInnvMap) AS x
GO
/****** Object:  View [dbo].[_oMAPMaxDelta_emergency]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oMAPMaxDelta_emergency]
AS
SELECT        caseId, ABS(minMAP - MAP_benchmark) AS d, minMAP, MAP_benchmark
FROM            (SELECT        caseId, MIN(MAP) AS minMAP, firstInnvMap AS MAP_benchmark
                          FROM            dbo.MAP
                          GROUP BY caseId, firstInnvMap) AS x
GO
/****** Object:  View [dbo].[_oSBP_20Perc_elect]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oSBP_20Perc_elect]
AS
SELECT        caseId, SUM(nxtTimeDiffSecs) / 60.0 AS SBP_duration_rel_elective
FROM            dbo.MAP
WHERE        (sbp_Below20perc_PreOp_Baseline = 1)
GROUP BY caseId
GO
/****** Object:  View [dbo].[_oSBP_20Perc_emerg]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oSBP_20Perc_emerg]
AS
SELECT        caseId, SUM(nxtTimeDiffSecs) / 60.0 AS SBP_duration_rel_emergency
FROM            dbo.MAP
WHERE        (sbp_Below20perc_PreOp_Baseline = 1)
GROUP BY caseId
GO
/****** Object:  View [dbo].[_oSBPMaxDelta_elect]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oSBPMaxDelta_elect]
AS
SELECT        caseId, ABS(minSBP - sbp_benchmark) AS d, minSBP, sbp_benchmark
FROM            (SELECT        caseId, MIN(SBP) AS minSBP, SBPbaseline AS sbp_benchmark
                          FROM            dbo.MAP
                          GROUP BY caseId, SBPbaseline) AS x
GO
/****** Object:  View [dbo].[_oSBPMaxDelta_elect_perc]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oSBPMaxDelta_elect_perc]
AS
SELECT        caseId, ABS(minSBP - sbp_benchmark) / sbp_benchmark AS d, minSBP, sbp_benchmark
FROM            (SELECT        caseId, MIN(SBP) AS minSBP, SBPbaseline AS sbp_benchmark
                          FROM            dbo.MAP
                          GROUP BY caseId, SBPbaseline) AS x
GO
/****** Object:  View [dbo].[_oSBPMaxDelta_emerg]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oSBPMaxDelta_emerg]
AS
SELECT        caseId, ABS(minSBP - sbp_benchmark) AS d, minSBP, sbp_benchmark
FROM            (SELECT        caseId, MIN(SBP) AS minSBP, firstInnvSBP AS sbp_benchmark
                          FROM            dbo.MAP
                          GROUP BY caseId, firstInnvSBP) AS x
GO
/****** Object:  View [dbo].[_oSBPMaxDelta_emerg_perc]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_oSBPMaxDelta_emerg_perc]
AS
SELECT        caseId, ABS(minSBP - sbp_benchmark) / sbp_benchmark AS d, sbp_benchmark
FROM            (SELECT        caseId, MIN(SBP) AS minSBP, firstInnvSBP AS sbp_benchmark
                          FROM            dbo.MAP
                          GROUP BY caseId, firstInnvSBP) AS x
GO
/****** Object:  View [dbo].[oBIS]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oBIS]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS BIS
FROM            dbo.BIS46
GO
/****** Object:  View [dbo].[oCrystalloid]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oCrystalloid]
AS
SELECT        Case_ID, [Crystalloid(mL)]
FROM            (SELECT        Case_ID, SUM(value) AS [Crystalloid(mL)]
                          FROM            dbo.CaseCrystalloid
                          GROUP BY Case_ID) AS a
WHERE        ([Crystalloid(mL)] > 1000)
GO
/****** Object:  View [dbo].[oDuration_surgery]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oDuration_surgery]
AS
SELECT        dbo.CaseBaseData.CaseId, dbo.CaseBaseData.CasemainId, dbo.CaseDurationSPO2HR.startDt, dbo.CaseDurationSPO2HR.endDt, dbo.CaseDurationSPO2HR.DurationMins AS surgeryDuration
FROM            dbo.CaseBaseData LEFT OUTER JOIN
                         dbo.CaseDurationSPO2HR ON dbo.CaseBaseData.CaseId = dbo.CaseDurationSPO2HR.CaseId
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oEtCO2duration30]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS EtCO2duration30
FROM            dbo.EtCO2_30
GO
/****** Object:  View [dbo].[oEtCO2duration45]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oEtCO2duration45]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS EtCO2duration45
FROM            dbo.EtCO2_45
GO
/****** Object:  View [dbo].[oEtCO2longest30]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oEtCO2longest30]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS EtCO2longest30
FROM            dbo.EtCO2_30
GO
/****** Object:  View [dbo].[oEtCO2longest45]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oEtCO2longest45]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS EtCO2longest45
FROM            dbo.EtCO2_45
GO
/****** Object:  View [dbo].[oFirstInnvHR]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* where  m.HR is not null*/
CREATE VIEW [dbo].[oFirstInnvHR]
AS
SELECT        m.Case_ID, MIN(m.HR) AS HR
FROM            (SELECT        Case_ID, MIN(DT) AS mdt
                          FROM            (SELECT        Case_ID, DT_SpO2 AS DT
                                                    FROM            dbo.HR
                                                    WHERE        (HR IS NOT NULL)) AS mm
                          GROUP BY Case_ID) AS d LEFT OUTER JOIN
                             (SELECT        Case_ID, DT_SpO2, seq, HR_SpO2, prevVal, nxt1Val, nxt2Val, nxtVal30secMax, [isOutOfRange(30-170)], isflag50PercPrev, isflag50PercNxt30sec, isflagECGDiff10, ECG_DT, HR_ECG, HR
                               FROM            dbo.HR AS HR_1
                               WHERE        (HR IS NOT NULL)) AS m ON d.Case_ID = m.Case_ID AND d.mdt = m.DT_SpO2
GROUP BY m.Case_ID
GO
/****** Object:  View [dbo].[oFirstInnvMAP]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oFirstInnvMAP]
AS
SELECT        m.caseId, m.map
FROM            (SELECT        caseId, MIN(DT) AS dt
                          FROM            dbo.MAP
                          WHERE        (map IS NOT NULL)
                          GROUP BY caseId) AS d INNER JOIN
                         dbo.MAP AS m ON d.caseId = m.caseId AND d.dt = m.DT
GO
/****** Object:  View [dbo].[oFirstInnvSBP]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oFirstInnvSBP]
AS
SELECT        m.caseId, m.SBP
FROM            (SELECT        caseId, MIN(DT) AS dt
                          FROM            dbo.MAP
                          WHERE        (SBP IS NOT NULL)
                          GROUP BY caseId) AS d INNER JOIN
                         dbo.MAP AS m ON d.caseId = m.caseId AND d.dt = m.DT
GO
/****** Object:  View [dbo].[oHR_max_neg_abs_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_max_neg_abs_innov]
AS
SELECT        HR.Case_ID, ABS(HR.minHR - oHR_InnvFirstVal.HR) AS HR_max_neg_abs_innov
FROM            (SELECT        Case_ID, MIN(HR) AS minHR
                          FROM            dbo.HR AS HR_1
                          GROUP BY Case_ID) AS HR INNER JOIN
                             (SELECT        Case_ID, HR_firstInnov AS HR
                               FROM            dbo.HR AS HR_2
                               GROUP BY Case_ID, HR_firstInnov) AS oHR_InnvFirstVal ON HR.Case_ID = oHR_InnvFirstVal.Case_ID
GO
/****** Object:  View [dbo].[oHR_max_neg_abs_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_max_neg_abs_preop]
AS
SELECT        Case_ID, ABS(minHR - HR_HSM_PreopPreamit_Min) AS HR_max_neg_abs_preop
FROM            (SELECT        dbo.HR.Case_ID, MIN(dbo.HR.HR) AS minHR, preop.HR_HSM_PreopPreamit_Min
                          FROM            dbo.HR INNER JOIN
                                                        (SELECT        Case_ID, HR_HSM_PreopPreamit_Min
                                                          FROM            dbo.HR AS HR_1
                                                          GROUP BY Case_ID, HR_HSM_PreopPreamit_Min) AS preop ON dbo.HR.Case_ID = preop.Case_ID
                          GROUP BY dbo.HR.Case_ID, preop.HR_HSM_PreopPreamit_Min) AS a
WHERE        (minHR - HR_HSM_PreopPreamit_Min < 0)
GO
/****** Object:  View [dbo].[oHR_max_neg_rel_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_max_neg_rel_innov]
AS
SELECT        HR.Case_ID, ABS(HR.minHR - oHR_InnvFirstVal.HR) / oHR_InnvFirstVal.HR AS HR_max_neg_rel_innov
FROM            (SELECT        Case_ID, MIN(HR) AS minHR
                          FROM            dbo.HR AS HR_1
                          GROUP BY Case_ID) AS HR INNER JOIN
                             (SELECT        Case_ID, HR_firstInnov AS HR
                               FROM            dbo.HR AS HR_2
                               GROUP BY Case_ID, HR_firstInnov) AS oHR_InnvFirstVal ON HR.Case_ID = oHR_InnvFirstVal.Case_ID
WHERE        (HR.minHR - oHR_InnvFirstVal.HR < 0)
GO
/****** Object:  View [dbo].[oHR_max_neg_rel_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_max_neg_rel_preop]
AS
SELECT        Case_ID, ABS(minHR - HR_HSM_PreopPreamit_Min) / HR_HSM_PreopPreamit_Min AS HR_max_neg_rel_preop
FROM            (SELECT        dbo.HR.Case_ID, MIN(dbo.HR.HR) AS minHR, preop.HR_HSM_PreopPreamit_Min
                          FROM            dbo.HR INNER JOIN
                                                        (SELECT        Case_ID, HR_HSM_PreopPreamit_Min
                                                          FROM            dbo.HR AS HR_1
                                                          GROUP BY Case_ID, HR_HSM_PreopPreamit_Min) AS preop ON dbo.HR.Case_ID = preop.Case_ID
                          GROUP BY dbo.HR.Case_ID, preop.HR_HSM_PreopPreamit_Min) AS a
WHERE        (minHR - HR_HSM_PreopPreamit_Min < 0)
GO
/****** Object:  View [dbo].[oHR_max_pos_abs_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_max_pos_abs_innov]
AS
SELECT        HR.Case_ID, HR.mxHR - oHR_InnvFirstVal.HR AS HR_max_pos_abs_innov
FROM            (SELECT        Case_ID, MAX(HR) AS mxHR
                          FROM            dbo.HR AS HR_1
                          GROUP BY Case_ID) AS HR INNER JOIN
                             (SELECT        Case_ID, HR_firstInnov AS HR
                               FROM            dbo.HR AS HR_2
                               GROUP BY Case_ID, HR_firstInnov) AS oHR_InnvFirstVal ON HR.Case_ID = oHR_InnvFirstVal.Case_ID
WHERE        (HR.mxHR - oHR_InnvFirstVal.HR >= 0)
GO
/****** Object:  View [dbo].[oHR_max_pos_abs_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_max_pos_abs_preop]
AS
SELECT        mxHR - HR_HSM_PreopPreamit_Min AS HR_max_pos_abs_preop, Case_ID
FROM            (SELECT        HR.Case_ID, MAX(HR.HR) AS mxHR, preop.HR_HSM_PreopPreamit_Min
FROM            HR INNER JOIN (SELECT Case_ID, HR_HSM_PreopPreamit_Min FROM HR GROUP BY Case_ID, HR_HSM_PreopPreamit_Min) AS preop 
ON HR.Case_ID = preop.Case_ID
GROUP BY HR.Case_ID, preop.HR_HSM_PreopPreamit_Min ) AS a
WHERE        (mxHR - HR_HSM_PreopPreamit_Min >=0)
GO
/****** Object:  View [dbo].[oHR_max_pos_rel_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_max_pos_rel_innov]
AS
SELECT        HR.Case_ID, (HR.mxHR - oHR_InnvFirstVal.HR) / oHR_InnvFirstVal.HR AS HR_max_pos_rel_innov
FROM            (SELECT        Case_ID, MAX(HR) AS mxHR
                          FROM            dbo.HR AS HR_1
                          GROUP BY Case_ID) AS HR INNER JOIN
                             (SELECT        Case_ID, HR_firstInnov AS HR
                               FROM            dbo.HR AS HR_2
                               GROUP BY Case_ID, HR_firstInnov) AS oHR_InnvFirstVal ON HR.Case_ID = oHR_InnvFirstVal.Case_ID
WHERE        (HR.mxHR - oHR_InnvFirstVal.HR >= 0)
GO
/****** Object:  View [dbo].[oHR_max_pos_rel_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oHR_max_pos_rel_preop]
AS
SELECT        (mxHR - HR_HSM_PreopPreamit_Min) / HR_HSM_PreopPreamit_Min AS HR_max_pos_rel_preop, Case_ID
FROM            (SELECT        dbo.HR.Case_ID, MAX(dbo.HR.HR) AS mxHR, preop.HR_HSM_PreopPreamit_Min
                          FROM            dbo.HR INNER JOIN
                                                        (SELECT        Case_ID, HR_HSM_PreopPreamit_Min
                                                          FROM            dbo.HR AS HR_1
                                                          GROUP BY Case_ID, HR_HSM_PreopPreamit_Min) AS preop ON dbo.HR.Case_ID = preop.Case_ID
                          GROUP BY dbo.HR.Case_ID, preop.HR_HSM_PreopPreamit_Min) AS a
WHERE        (mxHR - HR_HSM_PreopPreamit_Min >= 0)
GO
/****** Object:  View [dbo].[oMAC]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAC]
AS
SELECT        CaseId, SUM(TimeWeightedMAC) AS MAC_adjusted
FROM            (SELECT        CaseId, age, dt, seq, n2o, n2oDt, sevo, sevoDt, des, desDt, iso, isoDt, hal, halDt, InnovMAC, n2oAdj, sevoAdj, desAdj, isoAdj, halAdj, k_TotalMAC, MAC, nxtTimeDiffSecs, TimeWeightedMAC, WithinStEndTime
                          FROM            dbo.MAC
                          WHERE        (WithinStEndTime = 1)) AS derivedtbl_1
GROUP BY CaseId
HAVING        (SUM(TimeWeightedMAC) IS NOT NULL)
GO
/****** Object:  View [dbo].[oMap_duration_rel_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMap_duration_rel_innov]
AS
SELECT        caseId, SUM(nxtTimeDiffSecs) / 60.0 AS Map_duration_rel_innov
FROM            dbo.MAP
WHERE        (map_Below20perc_Innov_Baseline = 1)
GROUP BY caseId
GO
/****** Object:  View [dbo].[omap_duration_rel_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[omap_duration_rel_preop]
AS
SELECT        caseId, SUM(nxtTimeDiffSecs) / 60.0 AS map_duration_rel_PreOp
FROM            dbo.MAP
WHERE        (map_Below20perc_PreOpPreAdmit_Baseline = 1)
GROUP BY caseId
GO
/****** Object:  View [dbo].[oMAP_HSM_Preadmit]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAP_HSM_Preadmit]
AS
SELECT        caseId, MIN(map) AS map
FROM            (SELECT        caseId, (2 * dbp + sbp) / 3 AS map
                          FROM            (SELECT        dt AS hsm_dt, surgeryDate, caseId, CaseMainId, CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) AS sbp, CAST(SUBSTRING(value, CHARINDEX('/', value) + 1, LEN(value)) AS int) AS dbp, 
                                                                              label_seq
                                                    FROM            (SELECT        ihp.surgeryDate, ihp.caseId, hs.CaseMainId, hs.phase_id, hs.chart_dt AS dt, hs.value, hs.label_seq
                                                                              FROM            (SELECT        casemain_id AS CaseMainId, label_seq, chart_dt, phase_id, result_value AS value
                                                                                                        FROM            PeriopDMReporting.dbo.CDHA_HSM_casevisitresultlistwt
                                                                                                        WHERE        (label_seq = - 100001 OR
                                                                                                                                  label_seq = - 100002) AND (phase_id = 1) AND (ISNUMERIC(REPLACE(result_value, '/', '')) = 1)) AS hs INNER JOIN
                                                                                                            (SELECT        dbo.CaseBaseData.CaseId AS caseId, dbo.CaseBaseData.CasemainId, dbo.CaseData.surgeryDate
                                                                                                              FROM            dbo.CaseBaseData INNER JOIN
                                                                                                                                        dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId) AS ihp ON hs.CaseMainId = ihp.CasemainId) AS a) AS g) AS z
GROUP BY caseId
GO
/****** Object:  View [dbo].[oMAP_HSM_PreOp]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAP_HSM_PreOp]
AS
SELECT        caseId, MIN(map) AS map
FROM            (SELECT        caseId, (2 * dbp + sbp) / 3 AS map
                          FROM            (SELECT        dt AS hsm_dt, surgeryDate, caseId, CaseMainId, CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) AS sbp, CAST(SUBSTRING(value, CHARINDEX('/', value) + 1, LEN(value)) AS int) AS dbp, 
                                                                              label_seq
                                                    FROM            (SELECT        ihp.surgeryDate, ihp.caseId, hs.CaseMainId, hs.phase_id, hs.chart_dt AS dt, hs.value, hs.label_seq
                                                                              FROM            (SELECT        casemain_id AS CaseMainId, label_seq, chart_dt, phase_id, result_value AS value
                                                                                                        FROM            PeriopDMReporting.dbo.CDHA_HSM_casevisitresultlistwt
                                                                                                        WHERE        (label_seq = - 100001 OR
                                                                                                                                  label_seq = - 100002) AND (phase_id = 2) AND (ISNUMERIC(REPLACE(result_value, '/', '')) = 1)) AS hs INNER JOIN
                                                                                                            (SELECT        dbo.CaseBaseData.CaseId AS caseId, dbo.CaseBaseData.CasemainId, dbo.CaseData.surgeryDate
                                                                                                              FROM            dbo.CaseBaseData INNER JOIN
                                                                                                                                        dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId) AS ihp ON hs.CaseMainId = ihp.CasemainId) AS a) AS g) AS z
GROUP BY caseId
GO
/****** Object:  View [dbo].[oMAP_HSM_PreopPreAdmitMin]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAP_HSM_PreopPreAdmitMin]
AS
SELECT        caseId, MIN(map) AS map
FROM            (SELECT        caseId, (2 * dbp + sbp) / 3 AS map
                          FROM            (SELECT        dt AS hsm_dt, surgeryDate, caseId, CaseMainId, CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) AS sbp, CAST(SUBSTRING(value, CHARINDEX('/', value) + 1, LEN(value)) AS int) AS dbp, 
                                                                              label_seq
                                                    FROM            (SELECT        ihp.surgeryDate, ihp.caseId, hs.CaseMainId, hs.phase_id, hs.chart_dt AS dt, hs.value, hs.label_seq
                                                                              FROM            (SELECT        casemain_id AS CaseMainId, label_seq, chart_dt, phase_id, result_value AS value
                                                                                                        FROM            PeriopDMReporting.dbo.CDHA_HSM_casevisitresultlistwt
                                                                                                        WHERE        (label_seq = - 100001 OR
                                                                                                                                  label_seq = - 100002) AND (phase_id <= 2) AND (ISNUMERIC(REPLACE(result_value, '/', '')) = 1)) AS hs INNER JOIN
                                                                                                            (SELECT        dbo.CaseBaseData.CaseId AS caseId, dbo.CaseBaseData.CasemainId, dbo.CaseData.surgeryDate
                                                                                                              FROM            dbo.CaseBaseData INNER JOIN
                                                                                                                                        dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId) AS ihp ON hs.CaseMainId = ihp.CasemainId) AS a) AS g) AS z
GROUP BY caseId
GO
/****** Object:  View [dbo].[oMAP_maxdelta_abs_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAP_maxdelta_abs_innov]
AS
SELECT        caseId, ABS(minMAP - firstInnvMap) AS MAP_maxdelta_abs_innov, minMAP, firstInnvMap
FROM            (SELECT        caseId, MIN(MAP) AS minMAP, firstInnvMap
                          FROM            dbo.MAP
                          GROUP BY caseId, firstInnvMap) AS x
WHERE        (minMAP - firstInnvMap < 0)
GO
/****** Object:  View [dbo].[oMAP_maxdelta_abs_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAP_maxdelta_abs_preop]
AS
SELECT        caseId, ABS(minMAP - MAP_HSM_PreopPreAdmitMin) AS MAP_maxdelta_abs_preop, MAP_HSM_PreopPreAdmitMin
FROM            (SELECT        caseId, MIN(MAP) AS minMAP, MAP_HSM_PreopPreAdmitMin
                          FROM            dbo.MAP
                          GROUP BY caseId, MAP_HSM_PreopPreAdmitMin) AS x
WHERE        (minMAP - MAP_HSM_PreopPreAdmitMin < 0)
GO
/****** Object:  View [dbo].[oMAP_maxdelta_rel_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAP_maxdelta_rel_innov]
AS
SELECT        caseId, ABS(minMAP - firstInnvMap) / firstInnvMap AS MAP_maxdelta_rel_innov, minMAP, firstInnvMap
FROM            (SELECT        caseId, MIN(MAP) AS minMAP, firstInnvMap
                          FROM            dbo.MAP
                          GROUP BY caseId, firstInnvMap) AS x
WHERE        (minMAP - firstInnvMap < 0)
GO
/****** Object:  View [dbo].[oMAP_maxdelta_rel_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oMAP_maxdelta_rel_preop]
AS
SELECT        caseId, ABS(minMAP - MAP_HSM_PreopPreAdmitMin) / MAP_HSM_PreopPreAdmitMin AS MAP_maxdelta_rel_preop, MAP_HSM_PreopPreAdmitMin
FROM            (SELECT        caseId, MIN(MAP) AS minMAP, MAP_HSM_PreopPreAdmitMin
                          FROM            dbo.MAP
                          GROUP BY caseId, MAP_HSM_PreopPreAdmitMin) AS x
WHERE        (minMAP - MAP_HSM_PreopPreAdmitMin < 0)
GO
/****** Object:  View [dbo].[oPhenyl_Ephed]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oPhenyl_Ephed]
AS
SELECT        Case_ID, 1 AS VasoIno_Phenyl_ephed
FROM            dbo.Phenyl_Ephed
GROUP BY Case_ID
GO
/****** Object:  View [dbo].[oSBP_duration_rel_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBP_duration_rel_innov]
AS
SELECT        caseId, SUM(nxtTimeDiffSecs) / 60.0 AS SBP_duration_rel_innov
FROM            dbo.MAP
WHERE        (sbp_Below20perc_Innov_Baseline = 1)
GROUP BY caseId
GO
/****** Object:  View [dbo].[oSBP_duration_rel_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBP_duration_rel_preop]
AS
SELECT        caseId, SUM(nxtTimeDiffSecs) / 60.0 AS SBP_duration_rel_PreOp
FROM            dbo.MAP
WHERE        (sbp_Below20perc_PreOpPreAdmit_Baseline = 1)
GROUP BY caseId
GO
/****** Object:  View [dbo].[oSBP_HSM_Preadmit]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBP_HSM_Preadmit]
AS
SELECT        TOP (100) PERCENT caseId, MIN(sbp) AS sbp
FROM            (SELECT        dt AS hsm_dt, surgeryDate, caseId, CaseMainId, CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) AS sbp, CAST(SUBSTRING(value, CHARINDEX('/', value) + 1, LEN(value)) AS int) AS dbp, label_seq
                          FROM            (SELECT        ihp.surgeryDate, ihp.caseId, hs.CaseMainId, hs.phase_id, hs.chart_dt AS dt, hs.value, hs.label_seq
                                                    FROM            (SELECT        casemain_id AS CaseMainId, label_seq, chart_dt, phase_id, result_value AS value
                                                                              FROM            PeriopDMReporting.dbo.CDHA_HSM_casevisitresultlistwt
                                                                              WHERE        (label_seq = - 100001 OR
                                                                                                        label_seq = - 100002) AND (phase_id = 1) AND (ISNUMERIC(REPLACE(result_value, '/', '')) = 1)) AS hs INNER JOIN
                                                                                  (SELECT        dbo.CaseBaseData.CaseId AS caseId, dbo.CaseBaseData.CasemainId, dbo.CaseData.surgeryDate
                                                                                    FROM            dbo.CaseBaseData INNER JOIN
                                                                                                              dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId) AS ihp ON hs.CaseMainId = ihp.CasemainId) AS a) AS g
GROUP BY caseId, CaseMainId
ORDER BY caseId
GO
/****** Object:  View [dbo].[oSBP_HSM_PreOp]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBP_HSM_PreOp]
AS
SELECT        TOP (100) PERCENT caseId, MIN(sbp) AS sbp
FROM            (SELECT        dt AS hsm_dt, surgeryDate, caseId, CaseMainId, CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) AS sbp, CAST(SUBSTRING(value, CHARINDEX('/', value) + 1, LEN(value)) AS int) AS dbp, label_seq
                          FROM            (SELECT        ihp.surgeryDate, ihp.caseId, hs.CaseMainId, hs.phase_id, hs.chart_dt AS dt, hs.value, hs.label_seq
                                                    FROM            (SELECT        casemain_id AS CaseMainId, label_seq, chart_dt, phase_id, result_value AS value
                                                                              FROM            PeriopDMReporting.dbo.CDHA_HSM_casevisitresultlistwt
                                                                              WHERE        (label_seq = - 100001 OR
                                                                                                        label_seq = - 100002) AND (phase_id = 2) AND (ISNUMERIC(REPLACE(result_value, '/', '')) = 1)) AS hs INNER JOIN
                                                                                  (SELECT        dbo.CaseBaseData.CaseId AS caseId, dbo.CaseBaseData.CasemainId, dbo.CaseData.surgeryDate
                                                                                    FROM            dbo.CaseBaseData INNER JOIN
                                                                                                              dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId) AS ihp ON hs.CaseMainId = ihp.CasemainId) AS a
                          WHERE        (CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) >= 21) AND (CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) <= 250)) AS g
GROUP BY caseId, CaseMainId
ORDER BY caseId
GO
/****** Object:  View [dbo].[oSBP_HSM_PreopPreAdmitMin]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBP_HSM_PreopPreAdmitMin]
AS
SELECT        TOP (100) PERCENT caseId, MIN(sbp) AS sbp
FROM            (SELECT        dt AS hsm_dt, surgeryDate, caseId, CaseMainId, CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) AS sbp, CAST(SUBSTRING(value, CHARINDEX('/', value) + 1, LEN(value)) AS int) AS dbp, label_seq
                          FROM            (SELECT        ihp.surgeryDate, ihp.caseId, hs.CaseMainId, hs.phase_id, hs.chart_dt AS dt, hs.value, hs.label_seq
                                                    FROM            (SELECT        casemain_id AS CaseMainId, label_seq, chart_dt, phase_id, result_value AS value
                                                                              FROM            PeriopDMReporting.dbo.CDHA_HSM_casevisitresultlistwt
                                                                              WHERE        (label_seq = - 100001 OR
                                                                                                        label_seq = - 100002) AND (phase_id <= 2) AND (ISNUMERIC(REPLACE(result_value, '/', '')) = 1)) AS hs INNER JOIN
                                                                                  (SELECT        dbo.CaseBaseData.CaseId AS caseId, dbo.CaseBaseData.CasemainId, dbo.CaseData.surgeryDate
                                                                                    FROM            dbo.CaseBaseData INNER JOIN
                                                                                                              dbo.CaseData ON dbo.CaseBaseData.CaseId = dbo.CaseData.CaseId) AS ihp ON hs.CaseMainId = ihp.CasemainId) AS a
                          WHERE        (CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) >= 21) AND (CAST(SUBSTRING(value, 0, CHARINDEX('/', value, 0)) AS int) <= 250)) AS g
GROUP BY caseId
ORDER BY caseId
GO
/****** Object:  View [dbo].[oSBP_maxdelta_abs_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBP_maxdelta_abs_innov]
AS
SELECT        caseId, ABS(minSBP - firstInnvSBP) AS SBP_maxdelta_abs_innov, minSBP, firstInnvSBP
FROM            (SELECT        caseId, MIN(SBP) AS minSBP, firstInnvSBP
                          FROM            dbo.MAP
                          GROUP BY caseId, firstInnvSBP) AS x
WHERE        (minSBP - firstInnvSBP < 0)
GO
/****** Object:  View [dbo].[oSBP_maxdelta_abs_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBP_maxdelta_abs_preop]
AS
SELECT        caseId, ABS(minSBP - SBP_HSM_PreopPreAdmitMin) AS SBP_maxdelta_abs_preop, minSBP, SBP_HSM_PreopPreAdmitMin
FROM            (SELECT        caseId, MIN(SBP) AS minSBP, SBP_HSM_PreopPreAdmitMin
                          FROM            dbo.MAP
                          GROUP BY caseId, SBP_HSM_PreopPreAdmitMin) AS x
WHERE        (minSBP - SBP_HSM_PreopPreAdmitMin < 0)
GO
/****** Object:  View [dbo].[oSBP_maxdelta_rel_innov]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBP_maxdelta_rel_innov]
AS
SELECT        caseId, ABS(minSBP - firstInnvSBP) / firstInnvSBP AS SBP_maxdelta_rel_innov, minSBP, firstInnvSBP
FROM            (SELECT        caseId, MIN(SBP) AS minSBP, firstInnvSBP
                          FROM            dbo.MAP
                          GROUP BY caseId, firstInnvSBP) AS x
WHERE        (minSBP - firstInnvSBP < 0)
GO
/****** Object:  View [dbo].[oSBP_maxdelta_rel_preop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSBP_maxdelta_rel_preop]
AS
SELECT        caseId, ABS(minSBP - SBP_HSM_PreopPreAdmitMin) / SBP_HSM_PreopPreAdmitMin AS SBP_maxdelta_rel_preop, minSBP, SBP_HSM_PreopPreAdmitMin
FROM            (SELECT        caseId, MIN(SBP) AS minSBP, SBP_HSM_PreopPreAdmitMin
                          FROM            dbo.MAP
                          GROUP BY caseId, SBP_HSM_PreopPreAdmitMin) AS x
WHERE        (minSBP - SBP_HSM_PreopPreAdmitMin < 0)
GO
/****** Object:  View [dbo].[oSPO2duration88]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSPO2duration88]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS SPO2duration88
FROM            dbo.SPO2_88
GO
/****** Object:  View [dbo].[oSPO2duration90]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSPO2duration90]
AS
SELECT        CaseId, VitalTotalTimeInSecs / 60.0 AS SPO2duration90
FROM            dbo.SPO2_90
GO
/****** Object:  View [dbo].[oSPO2longest88]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSPO2longest88]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS SPO2longest88
FROM            dbo.SPO2_88
GO
/****** Object:  View [dbo].[oSPO2longest90]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oSPO2longest90]
AS
SELECT        CaseId, LongestEpisodeInSecs / 60.0 AS SPO2longest90
FROM            dbo.SPO2_90
GO
/****** Object:  View [dbo].[oType_anesthesia]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oType_anesthesia]
AS
SELECT        CaseId, HadIntraopGeneralAnesMethod, HadIntraopRegionalAnesMethod, HadIntraopMAC, HadIntraopRegionalAnesMethod_neurax, HadIntraopRegionalAnesMethod_peri, IntraopGeneralAnesMethods, 
                         IntraopRegionalAnesTypes, IntraopAnesType
FROM            dbo.CaseBaseData
GO
/****** Object:  View [dbo].[oVasodilator]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oVasodilator]
AS
SELECT DISTINCT Case_ID, 1 AS Vasodilator
FROM            dbo.VASODILATOR
GO
/****** Object:  View [dbo].[oVasodilator_Infusion]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oVasodilator_Infusion]
AS
SELECT        Case_ID, 1 AS Vasodilator_Infusion
FROM            dbo.Vasodilator
WHERE        (Unit_ID IN (26, 8, 13))
GROUP BY Case_ID
GO
/****** Object:  View [dbo].[oVasoIno]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oVasoIno]
AS
SELECT DISTINCT Case_ID, 1 AS vasoIno
FROM            dbo.VASO_INOTROPE
GO
/****** Object:  View [dbo].[oVasoIno_Infusion]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[oVasoIno_Infusion]
AS
SELECT        Case_ID, 1 AS VasoIno_Infusion
FROM            dbo.VASO_INOTROPE
WHERE        (Unit_ID IN (26, 8, 13))
GROUP BY Case_ID
GO
/****** Object:  View [dbo].[STATS_SBP_MAP_HR_SPO2_etCO2]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[STATS_SBP_MAP_HR_SPO2_etCO2]
AS
SELECT        cs.StudyId, sbp.SBPmin, sbp.SBPmax, sbp.SBPmu, sbp.SBPsigma, sbp_a.SBP_allCount, sbp.SBP_validCount, COALESCE (sbp_b.SBP_artifactCount, 0) AS SBP_artifactCount, map.MAPmin, map.MAPmax, map.MAPmu, 
                         map.MAPsigma, map_a.MAP_allCount, map.MAP_validCount, COALESCE (map_b.MAP_artifactCount, 0) AS MAP_artifactCount, hr.HRmin, hr.HRmax, hr.HRmu, hr.HRsigma, hr_a.HR_allCount, hr.HR_validCount, 
                         COALESCE (hr_b.HR_artifactCount, 0) AS HR_artifactCount, SPO2.SPO2min, SPO2.SPO2max, SPO2.SPO2mu, SPO2.SPO2sigma, SPO2_a.SPO2_allCount, SPO2.SPO2_validCount, COALESCE (SPO2_b.SPO2_artifactCount, 0) 
                         AS SPO2_artifactCount, etCO2.etCO2min, etCO2.etCO2max, etCO2.etCO2mu, etCO2.etCO2sigma, etCO2_a.etCO2_allCount, etCO2.etCO2_validCount, COALESCE (etCO2_b.etCO2_artifactCount, 0) AS etCO2_artifactCount
FROM            (SELECT        StudyId, CaseId
                          FROM            dbo.CaseData
                          WHERE        (included = 1)) AS cs LEFT OUTER JOIN
                             (SELECT        caseId, MIN(SBP) AS SBPmin, MAX(SBP) AS SBPmax, AVG(SBP) AS SBPmu, STDEV(SBP) AS SBPsigma, COUNT(caseId) AS SBP_validCount
                               FROM            (SELECT        caseId, SBP
                                                         FROM            dbo.MAP AS MAP_6
                                                         WHERE        (SBP IS NOT NULL)) AS a
                               GROUP BY caseId) AS sbp ON cs.CaseId = sbp.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_allCount, caseId
                               FROM            dbo.MAP AS MAP_5
                               GROUP BY caseId) AS sbp_a ON cs.CaseId = sbp_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_4
                               WHERE        (SBP IS NULL)
                               GROUP BY caseId) AS sbp_b ON cs.CaseId = sbp_b.caseId LEFT OUTER JOIN
                             (SELECT        caseId, MIN(MAP) AS MAPmin, MAX(MAP) AS MAPmax, AVG(MAP) AS MAPmu, STDEV(MAP) AS MAPsigma, COUNT(caseId) AS MAP_validCount
                               FROM            (SELECT        caseId, MAP
                                                         FROM            dbo.MAP AS MAP_3
                                                         WHERE        (MAP IS NOT NULL)) AS a
                               GROUP BY caseId) AS map ON cs.CaseId = map.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_allCount, caseId
                               FROM            dbo.MAP AS MAP_2
                               GROUP BY caseId) AS map_a ON cs.CaseId = map_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_1
                               WHERE        (MAP IS NULL)
                               GROUP BY caseId) AS map_b ON cs.CaseId = map_b.caseId LEFT OUTER JOIN
                             (SELECT        Case_ID, MIN(HR) AS HRmin, MAX(HR) AS HRmax, AVG(HR) AS HRmu, STDEV(HR) AS HRsigma, COUNT(Case_ID) AS HR_validCount
                               FROM            (SELECT        Case_ID, HR
                                                         FROM            dbo.HR AS HR_3
                                                         WHERE        (HR IS NOT NULL)) AS a
                               GROUP BY Case_ID) AS hr ON cs.CaseId = hr.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS HR_allCount, Case_ID
                               FROM            dbo.HR AS HR_2
                               GROUP BY Case_ID) AS hr_a ON cs.CaseId = hr_a.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS HR_artifactCount, Case_ID
                               FROM            dbo.HR AS HR_1
                               WHERE        (HR IS NULL)
                               GROUP BY Case_ID) AS hr_b ON cs.CaseId = hr_b.Case_ID LEFT OUTER JOIN
                             (SELECT        Case_ID, MIN(SPO2) AS SPO2min, MAX(SPO2) AS SPO2max, AVG(SPO2) AS SPO2mu, STDEV(SPO2) AS SPO2sigma, COUNT(Case_ID) AS SPO2_validCount
                               FROM            (SELECT        Case_ID, SPO2
                                                         FROM            dbo.SPO2 AS SPO2_3
                                                         WHERE        (SPO2 IS NOT NULL)) AS a
                               GROUP BY Case_ID) AS SPO2 ON cs.CaseId = SPO2.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS SPO2_allCount, Case_ID
                               FROM            dbo.SPO2 AS SPO2_2
                               GROUP BY Case_ID) AS SPO2_a ON cs.CaseId = SPO2_a.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS SPO2_artifactCount, Case_ID
                               FROM            dbo.SPO2 AS SPO2_1
                               WHERE        (SPO2 IS NULL)
                               GROUP BY Case_ID) AS SPO2_b ON cs.CaseId = SPO2_b.Case_ID LEFT OUTER JOIN
                             (SELECT        Case_ID, MIN(EtCO2) AS etCO2min, MAX(EtCO2) AS etCO2max, AVG(EtCO2) AS etCO2mu, STDEV(EtCO2) AS etCO2sigma, COUNT(Case_ID) AS etCO2_validCount
                               FROM            (SELECT        Case_ID, EtCO2
                                                         FROM            dbo.EtCO2 AS EtCO2_3
                                                         WHERE        (EtCO2 IS NOT NULL)) AS a
                               GROUP BY Case_ID) AS etCO2 ON cs.CaseId = etCO2.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS etCO2_allCount, Case_ID
                               FROM            dbo.EtCO2 AS EtCO2_2
                               GROUP BY Case_ID) AS etCO2_a ON cs.CaseId = etCO2_a.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS etCO2_artifactCount, Case_ID
                               FROM            dbo.EtCO2 AS EtCO2_1
                               WHERE        (EtCO2 IS NULL)
                               GROUP BY Case_ID) AS etCO2_b ON cs.CaseId = etCO2_b.Case_ID
GO
/****** Object:  View [dbo].[STATS_SBP_MAP_MPOG_Only]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[STATS_SBP_MAP_MPOG_Only]
AS
SELECT        cs.StudyId, sbp.SBPmin, sbp.SBPmax, sbp.SBPmu, sbp.SBPsigma, sbp_a.SBP_allCount, sbp.SBP_validCount, COALESCE (sbp_b.SBP_artifactCount, 0) AS SBP_artifactCount, map.MAPmin, map.MAPmax, map.MAPmu, 
                         map.MAPsigma, map_a.MAP_allCount, map.MAP_validCount, COALESCE (map_b.MAP_artifactCount, 0) AS MAP_artifactCount
FROM            (SELECT        StudyId, CaseId
                          FROM            dbo.CaseData
                          WHERE        (included = 1)) AS cs LEFT OUTER JOIN
                             (SELECT        caseId, MIN(MPOG_SBP) AS SBPmin, MAX(MPOG_SBP) AS SBPmax, AVG(MPOG_SBP) AS SBPmu, STDEV(MPOG_SBP) AS SBPsigma, COUNT(caseId) AS SBP_validCount
                               FROM            (SELECT        caseId, MPOG_SBP
                                                         FROM            dbo.MAP AS MAP_6
                                                         WHERE        (SBP IS NOT NULL)) AS a
                               GROUP BY caseId) AS sbp ON cs.CaseId = sbp.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_allCount, caseId
                               FROM            dbo.MAP AS MAP_5
                               GROUP BY caseId) AS sbp_a ON cs.CaseId = sbp_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_4
                               WHERE        (SBP IS NULL)
                               GROUP BY caseId) AS sbp_b ON cs.CaseId = sbp_b.caseId LEFT OUTER JOIN
                             (SELECT        caseId, MIN(MPOG_MAP) AS MAPmin, MAX(MPOG_MAP) AS MAPmax, AVG(MPOG_MAP) AS MAPmu, STDEV(MPOG_MAP) AS MAPsigma, COUNT(caseId) AS MAP_validCount
                               FROM            (SELECT        caseId, MPOG_MAP
                                                         FROM            dbo.MAP AS MAP_3
                                                         WHERE        (MPOG_MAP IS NOT NULL)) AS a
                               GROUP BY caseId) AS map ON cs.CaseId = map.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_allCount, caseId
                               FROM            dbo.MAP AS MAP_2
                               GROUP BY caseId) AS map_a ON cs.CaseId = map_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_1
                               WHERE        (MPOG_MAP IS NULL)
                               GROUP BY caseId) AS map_b ON cs.CaseId = map_b.caseId 
                             
GO
/****** Object:  View [dbo].[STATS_SBP_MAP_MPOG_SALMASI]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[STATS_SBP_MAP_MPOG_SALMASI]
AS
SELECT        cs.StudyId, sbp.SBPmin, sbp.SBPmax, sbp.SBPmu, sbp.SBPsigma, sbp_a.SBP_allCount, sbp.SBP_validCount, COALESCE (sbp_b.SBP_artifactCount, 0) AS SBP_artifactCount, map.MAPmin, map.MAPmax, map.MAPmu, 
                         map.MAPsigma, map_a.MAP_allCount, map.MAP_validCount, COALESCE (map_b.MAP_artifactCount, 0) AS MAP_artifactCount
FROM            (SELECT        StudyId, CaseId
                          FROM            dbo.CaseData
                          WHERE        (included = 1)) AS cs LEFT OUTER JOIN
                             (SELECT        caseId, MIN(SBP_Final) AS SBPmin, MAX(SBP_Final) AS SBPmax, AVG(SBP_Final) AS SBPmu, STDEV(SBP_Final) AS SBPsigma, COUNT(caseId) AS SBP_validCount
                               FROM            (SELECT        caseId, SBP_Final
                                                         FROM            dbo.MAP AS MAP_6
                                                         WHERE        (SBP IS NOT NULL)) AS a
                               GROUP BY caseId) AS sbp ON cs.CaseId = sbp.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_allCount, caseId
                               FROM            dbo.MAP AS MAP_5
                               GROUP BY caseId) AS sbp_a ON cs.CaseId = sbp_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_4
                               WHERE        (SBP IS NULL)
                               GROUP BY caseId) AS sbp_b ON cs.CaseId = sbp_b.caseId LEFT OUTER JOIN
                             (SELECT        caseId, MIN(MAP_Final) AS MAPmin, MAX(MAP_Final) AS MAPmax, AVG(MAP_Final) AS MAPmu, STDEV(MAP_Final) AS MAPsigma, COUNT(caseId) AS MAP_validCount
                               FROM            (SELECT        caseId, MAP_Final
                                                         FROM            dbo.MAP AS MAP_3
                                                         WHERE        (MAP_Final IS NOT NULL)) AS a_1
                               GROUP BY caseId) AS map ON cs.CaseId = map.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_allCount, caseId
                               FROM            dbo.MAP AS MAP_2
                               GROUP BY caseId) AS map_a ON cs.CaseId = map_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_1
                               WHERE        (MAP_Final IS NULL)
                               GROUP BY caseId) AS map_b ON cs.CaseId = map_b.caseId
GO
/****** Object:  View [dbo].[STATS_SBP_MAP_SALMASI_SUN_Only]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[STATS_SBP_MAP_SALMASI_SUN_Only]
AS
SELECT        cs.StudyId, sbp.SBPmin, sbp.SBPmax, sbp.SBPmu, sbp.SBPsigma, sbp_a.SBP_allCount, sbp.SBP_validCount, COALESCE (sbp_b.SBP_artifactCount, 0) AS SBP_artifactCount, map.MAPmin, map.MAPmax, map.MAPmu, 
                         map.MAPsigma, map_a.MAP_allCount, map.MAP_validCount, COALESCE (map_b.MAP_artifactCount, 0) AS MAP_artifactCount
FROM            (SELECT        StudyId, CaseId
                          FROM            dbo.CaseData
                          WHERE        (included = 1)) AS cs LEFT OUTER JOIN
                             (SELECT        caseId, MIN(SBP) AS SBPmin, MAX(SBP) AS SBPmax, AVG(SBP) AS SBPmu, STDEV(SBP) AS SBPsigma, COUNT(caseId) AS SBP_validCount
                               FROM            (SELECT        caseId, SBP
                                                         FROM            dbo.MAP AS MAP_6
                                                         WHERE        (SBP IS NOT NULL)) AS a
                               GROUP BY caseId) AS sbp ON cs.CaseId = sbp.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_allCount, caseId
                               FROM            dbo.MAP AS MAP_5
                               GROUP BY caseId) AS sbp_a ON cs.CaseId = sbp_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_4
                               WHERE        (SBP IS NULL)
                               GROUP BY caseId) AS sbp_b ON cs.CaseId = sbp_b.caseId LEFT OUTER JOIN
                             (SELECT        caseId, MIN(MAP) AS MAPmin, MAX(MAP) AS MAPmax, AVG(MAP) AS MAPmu, STDEV(MAP) AS MAPsigma, COUNT(caseId) AS MAP_validCount
                               FROM            (SELECT        caseId, MAP
                                                         FROM            dbo.MAP AS MAP_3
                                                         WHERE        (MAP IS NOT NULL)) AS a_1
                               GROUP BY caseId) AS map ON cs.CaseId = map.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_allCount, caseId
                               FROM            dbo.MAP AS MAP_2
                               GROUP BY caseId) AS map_a ON cs.CaseId = map_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_1
                               WHERE        (MAP IS NULL)
                               GROUP BY caseId) AS map_b ON cs.CaseId = map_b.caseId
GO
/****** Object:  View [dbo].[vALLCaseData]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*WHERE        (cs.CaseMainId_HSM IS NOT NULL) AND (cs.HasVitalData = 1) AND (cs.IsValid = 1)*/
CREATE VIEW [dbo].[vALLCaseData]
AS
SELECT        cs.CaseId, cs.CaseMainId_HSM, cs.VisitId, cs.ModifiedMRN, cs.SurgeryDate, p.MSI, cs.PatientArrivesORTime, cs.HSMProcedureStartTime, cs.HasVitalData, cs.IsValid
FROM            (SELECT        CaseId, CasemainId AS CaseMainId_HSM, VisitId, ModifiedMRN, SurgeryDate, PatientArrivesORTime, HSMProcedureStartTime, HasVitalData, IsValid
                          FROM            dbo.QI_CaseSummaryData) AS cs LEFT OUTER JOIN
                             (SELECT        CaseId, MSI
                               FROM            PeriopDMReporting.dbo.vMSICaseLink) AS p ON cs.CaseId = p.CaseId
GO
/****** Object:  View [dbo].[vCaseDayFilter]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vCaseDayFilter]
AS
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
GO
/****** Object:  View [dbo].[vStudyId_SurgeryDate_submittedToHDNS]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vStudyId_SurgeryDate_submittedToHDNS]
AS
SELECT        TOP (100) PERCENT StudyId, DATEADD(DAY, DATEDIFF(DAY, 0, SurgeryDate), 0) AS SurgeryDate
FROM            dbo.vALLStudyData_SubmittedToMedavie
ORDER BY SurgeryDate DESC
GO
/****** Object:  View [dbo].[vwArtifacts]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwArtifacts]
AS
SELECT        cs.StudyId, sbp.SBPmin, sbp.SBPmax, sbp.SBPmu, sbp.SBPsigma, sbp_a.SBP_allCount, sbp.SBP_validCount, COALESCE (sbp_b.SBP_artifactCount, 0) AS SBP_artifactCount, map.MAPmin, map.MAPmax, map.MAPmu, 
                         map.MAPsigma, map_a.MAP_allCount, map.MAP_validCount, COALESCE (map_b.MAP_artifactCount, 0) AS MAP_artifactCount, hr.HRmin, hr.HRmax, hr.HRmu, hr.HRsigma, hr_a.HR_allCount, hr.HR_validCount, 
                         COALESCE (hr_b.HR_artifactCount, 0) AS HR_artifactCount, SPO2.SPO2min, SPO2.SPO2max, SPO2.SPO2mu, SPO2.SPO2sigma, SPO2_a.SPO2_allCount, SPO2.SPO2_validCount, COALESCE (SPO2_b.SPO2_artifactCount, 0) 
                         AS SPO2_artifactCount, etCO2.etCO2min, etCO2.etCO2max, etCO2.etCO2mu, etCO2.etCO2sigma, etCO2_a.etCO2_allCount, etCO2.etCO2_validCount, COALESCE (etCO2_b.etCO2_artifactCount, 0) AS etCO2_artifactCount
FROM            (SELECT        StudyId, CaseId
                          FROM            dbo.CaseData
                          WHERE        (included = 1)) AS cs LEFT OUTER JOIN
                             (SELECT        caseId, MIN(SBP) AS SBPmin, MAX(SBP) AS SBPmax, AVG(SBP) AS SBPmu, STDEV(SBP) AS SBPsigma, COUNT(caseId) AS SBP_validCount
                               FROM            (SELECT        caseId, SBP
                                                         FROM            dbo.MAP AS MAP_6
                                                         WHERE        (SBP IS NOT NULL)) AS a
                               GROUP BY caseId) AS sbp ON cs.CaseId = sbp.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_allCount, caseId
                               FROM            dbo.MAP AS MAP_5
                               GROUP BY caseId) AS sbp_a ON cs.CaseId = sbp_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS SBP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_4
                               WHERE        (SBP IS NULL)
                               GROUP BY caseId) AS sbp_b ON cs.CaseId = sbp_b.caseId LEFT OUTER JOIN
                             (SELECT        caseId, MIN(MAP) AS MAPmin, MAX(MAP) AS MAPmax, AVG(MAP) AS MAPmu, STDEV(MAP) AS MAPsigma, COUNT(caseId) AS MAP_validCount
                               FROM            (SELECT        caseId, MAP
                                                         FROM            dbo.MAP AS MAP_3
                                                         WHERE        (MAP IS NOT NULL)) AS a
                               GROUP BY caseId) AS map ON cs.CaseId = map.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_allCount, caseId
                               FROM            dbo.MAP AS MAP_2
                               GROUP BY caseId) AS map_a ON cs.CaseId = map_a.caseId LEFT OUTER JOIN
                             (SELECT        COUNT(caseId) AS MAP_artifactCount, caseId
                               FROM            dbo.MAP AS MAP_1
                               WHERE        (MAP IS NULL)
                               GROUP BY caseId) AS map_b ON cs.CaseId = map_b.caseId LEFT OUTER JOIN
                             (SELECT        Case_ID, MIN(HR) AS HRmin, MAX(HR) AS HRmax, AVG(HR) AS HRmu, STDEV(HR) AS HRsigma, COUNT(Case_ID) AS HR_validCount
                               FROM            (SELECT        Case_ID, HR
                                                         FROM            dbo.HR AS HR_3
                                                         WHERE        (HR IS NOT NULL)) AS a
                               GROUP BY Case_ID) AS hr ON cs.CaseId = hr.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS HR_allCount, Case_ID
                               FROM            dbo.HR AS HR_2
                               GROUP BY Case_ID) AS hr_a ON cs.CaseId = hr_a.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS HR_artifactCount, Case_ID
                               FROM            dbo.HR AS HR_1
                               WHERE        (HR IS NULL)
                               GROUP BY Case_ID) AS hr_b ON cs.CaseId = hr_b.Case_ID LEFT OUTER JOIN
                             (SELECT        Case_ID, MIN(SPO2) AS SPO2min, MAX(SPO2) AS SPO2max, AVG(SPO2) AS SPO2mu, STDEV(SPO2) AS SPO2sigma, COUNT(Case_ID) AS SPO2_validCount
                               FROM            (SELECT        Case_ID, SPO2
                                                         FROM            dbo.SPO2 AS SPO2_3
                                                         WHERE        (SPO2 IS NOT NULL)) AS a
                               GROUP BY Case_ID) AS SPO2 ON cs.CaseId = SPO2.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS SPO2_allCount, Case_ID
                               FROM            dbo.SPO2 AS SPO2_2
                               GROUP BY Case_ID) AS SPO2_a ON cs.CaseId = SPO2_a.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS SPO2_artifactCount, Case_ID
                               FROM            dbo.SPO2 AS SPO2_1
                               WHERE        (SPO2 IS NULL)
                               GROUP BY Case_ID) AS SPO2_b ON cs.CaseId = SPO2_b.Case_ID LEFT OUTER JOIN
                             (SELECT        Case_ID, MIN(EtCO2) AS etCO2min, MAX(EtCO2) AS etCO2max, AVG(EtCO2) AS etCO2mu, STDEV(EtCO2) AS etCO2sigma, COUNT(Case_ID) AS etCO2_validCount
                               FROM            (SELECT        Case_ID, EtCO2
                                                         FROM            dbo.EtCO2 AS EtCO2_3
                                                         WHERE        (EtCO2 IS NOT NULL)) AS a
                               GROUP BY Case_ID) AS etCO2 ON cs.CaseId = etCO2.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS etCO2_allCount, Case_ID
                               FROM            dbo.EtCO2 AS EtCO2_2
                               GROUP BY Case_ID) AS etCO2_a ON cs.CaseId = etCO2_a.Case_ID LEFT OUTER JOIN
                             (SELECT        COUNT(Case_ID) AS etCO2_artifactCount, Case_ID
                               FROM            dbo.EtCO2 AS EtCO2_1
                               WHERE        (EtCO2 IS NULL)
                               GROUP BY Case_ID) AS etCO2_b ON cs.CaseId = etCO2_b.Case_ID
GO
