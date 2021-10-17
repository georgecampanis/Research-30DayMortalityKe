SELECT  b.StudyId,ISNULL(oPreop_insulin.ins, 0) AS Preop_insulin INTO  IHPStudyDeIdentified.dbo.oPreop_insulin FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId 
LEFT OUTER JOIN  dbo.oPreop_insulin AS oPreop_insulin ON c.CaseId =  oPreop_insulin.CaseId;
SELECT  b.StudyId,oPreop_creatinine.MaxCreatinine as Preop_creatinine INTO   IHPStudyDeIdentified.dbo.oPreop_creatinine FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oPreop_creatinine AS oPreop_creatinine ON c.CaseId =  oPreop_creatinine.CaseId;
SELECT  b.StudyId,oMAP_HSM.map as MAP_preop_HSM INTO   IHPStudyDeIdentified.dbo.oMAP_HSM FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAP_HSM AS oMAP_HSM ON c.CaseId =  oMAP_HSM.CaseId;
SELECT  b.StudyId,oMAP_InnvFirstVal.map as MAP_first_Innovian INTO   IHPStudyDeIdentified.dbo.oMAP_InnvFirstVal FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAP_InnvFirstVal AS oMAP_InnvFirstVal ON c.CaseId =  oMAP_InnvFirstVal.CaseId;
SELECT  b.StudyId,oSBP_HSM.SBP as SBP_preop_HSM INTO   IHPStudyDeIdentified.dbo.oSBP_HSM FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBP_HSM AS oSBP_HSM ON c.CaseId =  oSBP_HSM.CaseId;
SELECT  b.StudyId,oSBP_InnvFirstVal.SBP as SBP_first_Innovian INTO   IHPStudyDeIdentified.dbo.oSBP_InnvFirstVal FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBP_InnvFirstVal AS oSBP_InnvFirstVal ON c.CaseId =  oSBP_InnvFirstVal.CaseId;
SELECT  b.StudyId,oHR_HSM.HR as HR_preop_HSM INTO   IHPStudyDeIdentified.dbo.oHR_HSM FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_HSM AS oHR_HSM ON c.CaseId =  oHR_HSM.CaseId;
SELECT  b.StudyId,oHR_InnvFirstVal.HR as HR_first_Innovian INTO   IHPStudyDeIdentified.dbo.oHR_InnvFirstVal FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_InnvFirstVal AS oHR_InnvFirstVal ON c.CaseId =  oHR_InnvFirstVal.Case_Id;
SELECT  b.StudyId,oSBP_maxdelta_abs_innov.SBP_maxdelta_abs_innov as SBP_maxdelta_abs_innov INTO   IHPStudyDeIdentified.dbo.oSBP_maxdelta_abs_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBP_maxdelta_abs_innov AS oSBP_maxdelta_abs_innov ON c.CaseId =  oSBP_maxdelta_abs_innov.CaseId;
SELECT  b.StudyId,oSBP_maxdelta_rel_innov.SBP_maxdelta_rel_innov as SBP_maxdelta_rel_innov INTO   IHPStudyDeIdentified.dbo.oSBP_maxdelta_rel_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBP_maxdelta_rel_innov AS oSBP_maxdelta_rel_innov ON c.CaseId =  oSBP_maxdelta_rel_innov.CaseId;
SELECT  b.StudyId,oSBP_maxdelta_abs_preop.SBP_maxdelta_abs_preop as SBP_maxdelta_abs_preop INTO   IHPStudyDeIdentified.dbo.oSBP_maxdelta_abs_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBP_maxdelta_abs_preop AS oSBP_maxdelta_abs_preop ON c.CaseId =  oSBP_maxdelta_abs_preop.CaseId;
SELECT  b.StudyId,oSBP_maxdelta_rel_preop.SBP_maxdelta_rel_preop as SBP_maxdelta_rel_preop INTO   IHPStudyDeIdentified.dbo.oSBP_maxdelta_rel_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBP_maxdelta_rel_preop AS oSBP_maxdelta_rel_preop ON c.CaseId =  oSBP_maxdelta_rel_preop.CaseId;
SELECT  b.StudyId,oSBP_duration_rel_innov.SBP_duration_rel_innov as SBP_duration_rel_innov INTO   IHPStudyDeIdentified.dbo.oSBP_duration_rel_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBP_duration_rel_innov AS oSBP_duration_rel_innov ON c.CaseId =  oSBP_duration_rel_innov.CaseId;
SELECT  b.StudyId,oSBP_duration_rel_preop.SBP_duration_rel_PreOp as  SBP_duration_rel_PreOp INTO   IHPStudyDeIdentified.dbo.oSBP_duration_rel_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBP_duration_rel_preop AS oSBP_duration_rel_preop ON c.CaseId =  oSBP_duration_rel_preop.CaseId;
SELECT  b.StudyId,oSBPLong100.SBP_longest_100 as SBP_longest_100  INTO  IHPStudyDeIdentified.dbo.oSBPLong100 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBPLong100 AS oSBPLong100 ON c.CaseId =  oSBPLong100.CaseId;
SELECT  b.StudyId,oSBPLong90.SBP_longest_90 as SBP_longest_90  INTO  IHPStudyDeIdentified.dbo.oSBPLong90 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBPLong90 AS oSBPLong90 ON c.CaseId =  oSBPLong90.CaseId;
SELECT  b.StudyId,oSBPLong80.SBP_longest_80 as SBP_longest_80  INTO  IHPStudyDeIdentified.dbo.oSBPLong80 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBPLong80 AS oSBPLong80 ON c.CaseId =  oSBPLong80.CaseId;
SELECT  b.StudyId,oSBPTotal100.SBP_Total_100 as SBP_Total_100  INTO  IHPStudyDeIdentified.dbo.oSBPTotal100 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBPTotal100 AS oSBPTotal100 ON c.CaseId =  oSBPTotal100.CaseId;
SELECT  b.StudyId,oSBPTotal90.SBP_Total_90 as SBP_Total_90  INTO  IHPStudyDeIdentified.dbo.oSBPTotal90 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBPTotal90 AS oSBPTotal90 ON c.CaseId =  oSBPTotal90.CaseId;
SELECT  b.StudyId,oSBPTotal80.SBP_Total_80 as SBP_Total_80 INTO   IHPStudyDeIdentified.dbo.oSBPTotal80 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSBPTotal80 AS oSBPTotal80 ON c.CaseId =  oSBPTotal80.CaseId;
SELECT  b.StudyId,oMAP_maxdelta_abs_innov.MAP_maxdelta_abs_innov as MAP_maxdelta_abs_innov INTO   IHPStudyDeIdentified.dbo.oMAP_maxdelta_abs_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAP_maxdelta_abs_innov AS oMAP_maxdelta_abs_innov ON c.CaseId =  oMAP_maxdelta_abs_innov.CaseId;
SELECT  b.StudyId,oMAP_maxdelta_rel_innov.MAP_maxdelta_abs_innov as MAP_maxdelta_abs_innov INTO   IHPStudyDeIdentified.dbo.oMAP_maxdelta_rel_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAP_maxdelta_rel_innov AS oMAP_maxdelta_rel_innov ON c.CaseId =  oMAP_maxdelta_rel_innov.CaseId;
SELECT  b.StudyId,oMAP_maxdelta_abs_preop.MAP_maxdelta_abs_preop as MAP_maxdelta_abs_preop INTO   IHPStudyDeIdentified.dbo.oMAP_maxdelta_abs_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAP_maxdelta_abs_preop AS oMAP_maxdelta_abs_preop ON c.CaseId =  oMAP_maxdelta_abs_preop.CaseId;
SELECT  b.StudyId,oMAP_maxdelta_rel_preop.MAP_maxdelta_rel_preop as MAP_maxdelta_rel_preop INTO   IHPStudyDeIdentified.dbo.oMAP_maxdelta_rel_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAP_maxdelta_rel_preop AS oMAP_maxdelta_rel_preop ON c.CaseId =  oMAP_maxdelta_rel_preop.CaseId;
SELECT  b.StudyId,oMAP_duration_rel_innov.Map_duration_rel_innov as Map_duration_rel_innov INTO   IHPStudyDeIdentified.dbo.oMAP_duration_rel_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAP_duration_rel_innov AS oMAP_duration_rel_innov ON c.CaseId =  oMAP_duration_rel_innov.CaseId;
SELECT  b.StudyId,oMAP_duration_rel_preop.map_duration_rel_PreOp as MAP_maxdelta_rel_preop INTO   IHPStudyDeIdentified.dbo.oMAP_duration_rel_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAP_duration_rel_preop AS oMAP_duration_rel_preop ON c.CaseId =  oMAP_duration_rel_preop.CaseId;
SELECT  b.StudyId,oMAPLong80.MAP_longest_80 as MAP_longest_80  INTO  IHPStudyDeIdentified.dbo.oMAPLong80 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAPLong80 AS oMAPLong80 ON c.CaseId =  oMAPLong80.CaseId;
SELECT  b.StudyId,oMAPLong70.MAP_longest_70 as MAP_longest_70  INTO  IHPStudyDeIdentified.dbo.oMAPLong70 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAPLong70 AS oMAPLong70 ON c.CaseId =  oMAPLong70.CaseId;
SELECT  b.StudyId,oMAPLong65.MAP_longest_65 as MAP_longest_65  INTO  IHPStudyDeIdentified.dbo.oMAPLong65 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAPLong65 AS oMAPLong65 ON c.CaseId =  oMAPLong65.CaseId;
SELECT  b.StudyId,oMAPLong60.MAP_longest_60 as MAP_longest_60  INTO  IHPStudyDeIdentified.dbo.oMAPLong60 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAPLong60 AS oMAPLong60 ON c.CaseId =  oMAPLong60.CaseId;
SELECT  b.StudyId,oMAPTotal80.MAP_Total_80 as MAP_Total_80  INTO  IHPStudyDeIdentified.dbo.oMAPTotal80 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAPTotal80 AS oMAPTotal80 ON c.CaseId =  oMAPTotal80.CaseId;
SELECT  b.StudyId,oMAPTotal70.MAP_Total_70 as MAP_Total_70  INTO  IHPStudyDeIdentified.dbo.oMAPTotal70 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAPTotal70 AS oMAPTotal70 ON c.CaseId =  oMAPTotal70.CaseId;
SELECT  b.StudyId,oMAPTotal65.MAP_Total_65 as MAP_Total_65 INTO   IHPStudyDeIdentified.dbo.oMAPTotal65 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAPTotal65 AS oMAPTotal65 ON c.CaseId =  oMAPTotal65.CaseId;
SELECT  b.StudyId,oMAPTotal60.MAP_Total_60 as MAP_Total_60 INTO   IHPStudyDeIdentified.dbo.oMAPTotal60 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAPTotal60 AS oMAPTotal60 ON c.CaseId =  oMAPTotal60.CaseId;
SELECT  b.StudyId,oHR_max_pos_abs_innov.HR_max_pos_abs_innov as HR_max_pos_abs_innov INTO   IHPStudyDeIdentified.dbo.oHR_max_pos_abs_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_max_pos_abs_innov AS oHR_max_pos_abs_innov ON c.CaseId =  oHR_max_pos_abs_innov.Case_Id;
SELECT  b.StudyId,oHR_max_neg_abs_innov.HR_max_neg_abs_innov as HR_max_neg_abs_innov INTO   IHPStudyDeIdentified.dbo.oHR_max_neg_abs_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_max_neg_abs_innov AS oHR_max_neg_abs_innov ON c.CaseId =  oHR_max_neg_abs_innov.Case_Id;
SELECT  b.StudyId,oHR_max_pos_rel_innov.HR_max_pos_rel_innov as HR_max_pos_rel_innov INTO   IHPStudyDeIdentified.dbo.oHR_max_pos_rel_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_max_pos_rel_innov AS oHR_max_pos_rel_innov ON c.CaseId =  oHR_max_pos_rel_innov.Case_Id;
SELECT  b.StudyId,oHR_max_neg_rel_innov.HR_max_neg_rel_innov as HR_max_neg_rel_innov INTO   IHPStudyDeIdentified.dbo.oHR_max_neg_rel_innov FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_max_neg_rel_innov AS oHR_max_neg_rel_innov ON c.CaseId =  oHR_max_neg_rel_innov.Case_Id;
SELECT  b.StudyId,oHR_max_pos_abs_preop.HR_max_pos_abs_preop as HR_max_pos_abs_preop INTO   IHPStudyDeIdentified.dbo.oHR_max_pos_abs_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_max_pos_abs_preop AS oHR_max_pos_abs_preop ON c.CaseId =  oHR_max_pos_abs_preop.Case_Id;
SELECT  b.StudyId,oHR_max_neg_abs_preop.HR_max_neg_abs_preop as HR_max_neg_abs_preop INTO   IHPStudyDeIdentified.dbo.oHR_max_neg_abs_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_max_neg_abs_preop AS oHR_max_neg_abs_preop ON c.CaseId =  oHR_max_neg_abs_preop.Case_Id;
SELECT  b.StudyId,oHR_max_pos_rel_preop.HR_max_pos_rel_preop as HR_max_pos_rel_preop INTO   IHPStudyDeIdentified.dbo.oHR_max_pos_rel_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_max_pos_rel_preop AS oHR_max_pos_rel_preop ON c.CaseId =  oHR_max_pos_rel_preop.Case_Id;
SELECT  b.StudyId,oHR_max_neg_rel_preop.HR_max_neg_rel_preop as HR_max_neg_rel_preop INTO   IHPStudyDeIdentified.dbo.oHR_max_neg_rel_preop FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_max_neg_rel_preop AS oHR_max_neg_rel_preop ON c.CaseId =  oHR_max_neg_rel_preop.Case_Id;
SELECT  b.StudyId,oHR_pulse_var.HR_pulse_var as HR_pulse_var INTO   IHPStudyDeIdentified.dbo.oHR_pulse_var FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHR_pulse_var AS oHR_pulse_var ON c.CaseId =  oHR_pulse_var.Case_Id;
SELECT  b.StudyId,oHRlong60.HR_longest_60 as HR_longest_60 INTO   IHPStudyDeIdentified.dbo.oHRlong60 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHRlong60 AS oHRlong60 ON c.CaseId =  oHRlong60.CaseId;
SELECT  b.StudyId,oHRlong100.HR_longest_100 as HR_longest_100 INTO   IHPStudyDeIdentified.dbo.oHRlong100 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHRlong100 AS oHRlong100 ON c.CaseId =  oHRlong100.CaseId;
SELECT  b.StudyId,oHRTotal60.HRduration60 as HR_Duration_60 INTO   IHPStudyDeIdentified.dbo.oHRTotal60 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHRTotal60 AS oHRTotal60 ON c.CaseId =  oHRTotal60.CaseId;
SELECT  b.StudyId,oHRTotal100.HRduration100 as HR_Duration_100 INTO   IHPStudyDeIdentified.dbo.oHRTotal100 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oHRTotal100 AS oHRTotal100 ON c.CaseId =  oHRTotal100.CaseId;
SELECT  b.StudyId,ISNULL(oVasoIno.vasoIno, 0) as vasoIno INTO   IHPStudyDeIdentified.dbo.oVasoIno FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oVasoIno AS oVasoIno ON c.CaseId =  oVasoIno.Case_Id;
SELECT  b.StudyId,ISNULL(oVasoIno_Infusion.VasoIno_Infusion, 0) as VasoIno_Infusion INTO   IHPStudyDeIdentified.dbo.oVasoIno_Infusion FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oVasoIno_Infusion AS oVasoIno_Infusion ON c.CaseId =  oVasoIno_Infusion.Case_Id;
SELECT  b.StudyId,oPhenyl_Ephed.VasoIno_Phenyl_ephed as Phenyl_Ephed INTO   IHPStudyDeIdentified.dbo.oPhenyl_Ephed FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oPhenyl_Ephed AS oPhenyl_Ephed ON c.CaseId =  oPhenyl_Ephed.Case_Id;
SELECT  b.StudyId,ISNULL(oVasodilator.[Vasodilator],0) as Vasodilator INTO   IHPStudyDeIdentified.dbo.oVasodilator FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oVasodilator AS oVasodilator ON c.CaseId =  oVasodilator.Case_Id;
SELECT  b.StudyId,oVasodilator_Infusion.Vasodilator_Infusion as Vasodilator_Infusion INTO   IHPStudyDeIdentified.dbo.oVasodilator_Infusion FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oVasodilator_Infusion AS oVasodilator_Infusion ON c.CaseId =  oVasodilator_Infusion.Case_Id;
SELECT  b.StudyId,oSPO2longest88.SPO2longest88 asSPO2longest88 INTO   IHPStudyDeIdentified.dbo.oSPO2longest88 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSPO2longest88 AS oSPO2longest88 ON c.CaseId =  oSPO2longest88.CaseId;
SELECT  b.StudyId,oSPO2longest90.SPO2longest90 as SPO2longest90 INTO   IHPStudyDeIdentified.dbo.oSPO2longest90 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSPO2longest90 AS oSPO2longest90 ON c.CaseId =  oSPO2longest90.CaseId;
SELECT  b.StudyId,oSPO2duration88.SPO2duration88 as SPO2duration88 INTO   IHPStudyDeIdentified.dbo.oSPO2duration88 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSPO2duration88 AS oSPO2duration88 ON c.CaseId =  oSPO2duration88.CaseId;
SELECT  b.StudyId,oSPO2duration90.SPO2duration90  as SPO2duration90 INTO   IHPStudyDeIdentified.dbo.oSPO2duration90 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oSPO2duration90 AS oSPO2duration90 ON c.CaseId =  oSPO2duration90.CaseId;
SELECT  b.StudyId,oEtCO2longest30.EtCO2longest30 asEtCO2longest30 INTO   IHPStudyDeIdentified.dbo.oEtCO2longest30 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oEtCO2longest30 AS oEtCO2longest30 ON c.CaseId =  oEtCO2longest30.CaseId;
SELECT  b.StudyId,oEtCO2longest45.EtCO2longest45 as EtCO2longest45 INTO   IHPStudyDeIdentified.dbo.oEtCO2longest45 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oEtCO2longest45 AS oEtCO2longest45 ON c.CaseId =  oEtCO2longest45.CaseId;
SELECT  b.StudyId,oEtCO2duration30.EtCO2duration30 as EtCO2duration30 INTO   IHPStudyDeIdentified.dbo.oEtCO2duration30 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oEtCO2duration30 AS oEtCO2duration30 ON c.CaseId =  oEtCO2duration30.CaseId;
SELECT  b.StudyId,oEtCO2duration45.EtCO2duration45  as EtCO2duration45 INTO   IHPStudyDeIdentified.dbo.oEtCO2duration45 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oEtCO2duration45 AS oEtCO2duration45 ON c.CaseId =  oEtCO2duration45.CaseId;
SELECT  b.StudyId,oDuration_surgery.surgeryDuration as surgeryDuration INTO   IHPStudyDeIdentified.dbo.oDuration_surgery FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oDuration_surgery AS oDuration_surgery ON c.CaseId =  oDuration_surgery.CaseId;

SELECT  b.StudyId,
ISNULL(oType_anesthesia.HadIntraopGeneralAnesMethod,0) as HadIntraopGeneralAnesMethod, 
ISNULL(oType_anesthesia.HadIntraopRegionalAnesMethod,0) as HadIntraopRegionalAnesMethod,
ISNULL(oType_anesthesia.HadIntraopMAC,0) as HadIntraopMAC,
ISNULL(oType_anesthesia.HadIntraopRegionalAnesMethod_neurax,0) as HadIntraopRegionalAnesMethod_neurax,
ISNULL(oType_anesthesia.HadIntraopRegionalAnesMethod_peri,0) as HadIntraopRegionalAnesMethod_peri,
oType_anesthesia.IntraopGeneralAnesMethods as IntraopGeneralAnesMethods,
oType_anesthesia.IntraopRegionalAnesTypes as IntraopRegionalAnesTypes,
oType_anesthesia.IntraopAnesType as IntraopAnesType INTO   IHPStudyDeIdentified.dbo.oType_anesthesia FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oType_anesthesia AS oType_anesthesia ON c.CaseId =  oType_anesthesia.CaseId;

SELECT  b.StudyId,oMAC.MAC_adjusted as MAC_adjusted INTO   IHPStudyDeIdentified.dbo.oMAC FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oMAC AS oMAC ON c.CaseId =  oMAC.CaseId;
SELECT  b.StudyId,oBIS.BIS as BIS INTO   IHPStudyDeIdentified.dbo.oBIS FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oBIS AS oBIS ON c.CaseId =  oBIS.CaseId;
SELECT  b.StudyId,ISNULL(oLaparoscopy.lapar,0) as laparoscopy_booked INTO   IHPStudyDeIdentified.dbo.oLaparoscopy FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oLaparoscopy AS oLaparoscopy ON c.CaseId =  oLaparoscopy.CaseId;
SELECT  b.StudyId,oTempBelow36.TotalMin AS Temperature36 INTO   IHPStudyDeIdentified.dbo.oTempBelow36 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oTempBelow36 AS oTempBelow36 ON c.CaseId =  oTempBelow36.Case_Id;
SELECT  b.StudyId,oTempAbove38.TotalMin AS Temperature38 INTO   IHPStudyDeIdentified.dbo.oTempAbove38 FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oTempAbove38 AS oTempAbove38 ON c.CaseId =  oTempAbove38.Case_Id;
SELECT  b.StudyId,oEBL.ebl as EBL INTO   IHPStudyDeIdentified.dbo.oEBL FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oEBL AS oEBL ON c.CaseId =  oEBL.Case_Id;
SELECT  b.StudyId,oCrystalloid.[Crystalloid(mL)] as Crystalloid INTO   IHPStudyDeIdentified.dbo.oCrystalloid FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oCrystalloid AS oCrystalloid ON c.CaseId =  oCrystalloid.Case_Id;
SELECT  b.StudyId,oPostOpHGB.MaxHGB as Hemoglobin INTO   IHPStudyDeIdentified.dbo.oPostOpHGB FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oPostOpHGB AS oPostOpHGB ON c.CaseId =  oPostOpHGB.CaseId;
SELECT  b.StudyId,oPRBC.prbc as PRBC INTO   IHPStudyDeIdentified.dbo.oPRBC FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oPRBC AS oPRBC ON c.CaseId =  oPRBC.Case_Id;
SELECT  b.StudyId,oAPGAR.Surgical_APGAR_Score as Surgical_APGAR_Score INTO  IHPStudyDeIdentified.dbo.oAPGAR FROM   (SELECT   CaseId, StudyId, surgeryDate, included FROM dbo.CaseData WHERE (included = 1)) AS c INNER JOIN dbo.oBaseData AS b ON c.StudyId = b.StudyId LEFT OUTER JOIN  dbo.oAPGAR AS oAPGAR ON c.CaseId =  oAPGAR.CaseId;
