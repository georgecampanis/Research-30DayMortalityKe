
----FINAL EXTRACTION TO HDNS
SELECT b.StudyId, b.SurgeryDate, b.Age, b.ASA, b.BMI,
ISNULL(oPreop_insulin.Preop_insulin, 0) AS Preop_insulin,
oPreop_creatinine.Preop_creatinine as Preop_creatinine,
oMAP_HSM_PreopPreAdmitMin.[MAP_HSM_PreopPreAdmitMin] as MAP_HSM_PreopPreAdmitMin,
oFirstInnvMAP.FirstInnvMAP as oFirstInnvMAP,
oSBP_HSM_PreopPreAdmitMin.SBP_HSM_PreopPreAdmitMin as SBP_HSM_PreopPreAdmitMin,
oFirstInnvHR.FirstInnvHR as FirstInnvHR,
oHR_HSM_PreopPreAdmitMin.HR_HSM_PreopPreAdmitMin as HR_HSM_PreopPreAdmitMin,
oFirstInnvSBP.FirstInnvSBP as FirstInnvSBP,
oSBP_maxdelta_abs_innov.SBP_maxdelta_abs_innov	as SBP_maxdelta_abs_innov,
oSBP_maxdelta_rel_innov.SBP_maxdelta_rel_innov	as SBP_maxdelta_rel_innov,
oSBP_maxdelta_abs_preop.SBP_maxdelta_abs_preop as SBP_maxdelta_abs_preop,
oSBP_maxdelta_rel_preop.SBP_maxdelta_rel_preop as SBP_maxdelta_rel_preop,
oSBP_duration_rel_innov.SBP_duration_rel_innov as SBP_duration_rel_innov,
oSBP_duration_rel_preop.SBP_duration_rel_PreOp as  SBP_duration_rel_PreOp,
oSBP_Longest_100.SBP_longest_100 as SBP_longest_100, 
oSBP_Longest_90.SBP_longest_90 as SBP_longest_90, 
oSBP_Longest_80.SBP_longest_80 as SBP_longest_80, 
oSBP_Total_100.SBP_Total_100 as SBP_Total_100, 
oSBP_Total_90.SBP_Total_90 as SBP_Total_90, 
oSBP_Total_80.SBP_Total_80 as SBP_Total_80,
oMAP_maxdelta_abs_innov.MAP_maxdelta_abs_innov	as MAP_maxdelta_abs_innov,
oMAP_maxdelta_abs_preop.MAP_maxdelta_abs_preop as MAP_maxdelta_abs_preop,
oMAP_maxdelta_rel_innov.MAP_maxdelta_rel_innov	as MAP_maxdelta_rel_innov,
oMAP_maxdelta_rel_preop.MAP_maxdelta_rel_preop as MAP_maxdelta_rel_preop,
oMAP_duration_rel_preop.Map_duration_rel_preop as Map_duration_rel_preop,
oMAP_duration_rel_innov.Map_duration_rel_innov as Map_duration_rel_innov,
oMAP_Longest_80.MAP_longest_80 as MAP_longest_80, 
oMAP_Longest_70.MAP_longest_70 as MAP_longest_70, 
oMAP_Longest_65.MAP_longest_65 as MAP_longest_65, 
oMAP_Longest_60.MAP_longest_60 as MAP_longest_60, 
oMAP_Total_80.MAP_Total_80 as MAP_Total_80, 
oMAP_Total_70.MAP_Total_70 as MAP_Total_70, 
oMAP_Total_65.MAP_Total_65 as MAP_Total_65,
oMAP_Total_60.MAP_Total_60 as MAP_Total_60,
oHR_max_pos_abs_innov.HR_max_pos_abs_innov as HR_max_pos_abs_innov,
oHR_max_neg_abs_innov.HR_max_neg_abs_innov as HR_max_neg_abs_innov,
oHR_max_pos_rel_innov.HR_max_pos_rel_innov as HR_max_pos_rel_innov,
oHR_max_neg_rel_innov.HR_max_neg_rel_innov as HR_max_neg_rel_innov,
oHR_max_pos_abs_preop.HR_max_pos_abs_preop as HR_max_pos_abs_preop,
oHR_max_neg_abs_preop.HR_max_neg_abs_preop as HR_max_neg_abs_preop,
oHR_max_pos_rel_preop.HR_max_pos_rel_preop as HR_max_pos_rel_preop,
oHR_max_neg_rel_preop.HR_max_neg_rel_preop as HR_max_neg_rel_preop,
oHR_pulse_var.HR_pulse_var as HR_pulse_var,
oHR_longest_60.HR_longest_60 as HR_longest_60,
oHR_longest_100.HR_longest_100 as HR_longest_100,
oHR_Total_60.HR_Total_60 as HR_Total_60,
oHR_Total_100.HR_Total_100 as HR_Total_100,
ISNULL(oVasoIno.vasoIno, 0) as vasoIno,
ISNULL(oVasoIno_Infusion.VasoIno_Infusion, 0) as VasoIno_Infusion,
oPhenyl_Ephed.Phenyl_Ephed as Phenyl_Ephed,
ISNULL(oVasodilator.[Vasodilator],0) as Vasodilator,
oVasodilator_Infusion.Vasodilator_Infusion as Vasodilator_Infusion,
oSPO2_longest_88.SPO2_longest_88 as SPO2_longest_88,
oSPO2_longest_90.SPO2_longest_90 as SPO2_longest_90,
oSPO2_Total_88.SPO2_Total_88 as SPO2_Total_88,
oSPO2_Total_90.SPO2_Total_90  as SPO2_Total_90,
oEtCO2_longest_30.EtCO2_longest_30 as EtCO2_longest_30,
oEtCO2_longest_45.EtCO2_longest_45 as EtCO2_longest_45,
oEtCO2_Total_30.EtCO2_Total_30 as EtCO2_Total_30,
oEtCO2_Total_45.EtCO2_Total_45  as EtCO2_Total_45,
oDuration_surgery.surgeryDuration as surgeryDuration,
ISNULL(oType_anesthesia.HadIntraopGeneralAnesMethod,0) as HadIntraopGeneralAnesMethod,
ISNULL(oType_anesthesia.HadIntraopRegionalAnesMethod,0) as HadIntraopRegionalAnesMethod,
ISNULL(oType_anesthesia.HadIntraopMAC,0) as HadIntraopMAC,
ISNULL(oType_anesthesia.HadIntraopRegionalAnesMethod_neurax,0) as HadIntraopRegionalAnesMethod_neurax,
ISNULL(oType_anesthesia.HadIntraopRegionalAnesMethod_peri,0) as HadIntraopRegionalAnesMethod_peri,
oType_anesthesia.IntraopGeneralAnesMethods as IntraopGeneralAnesMethods,
oType_anesthesia.IntraopRegionalAnesTypes as IntraopRegionalAnesTypes,
oType_anesthesia.IntraopAnesType as IntraopAnesType,
oMAC.MAC as MAC_adjusted,
oBIS.BIS as BIS,
ISNULL(oLaparoscopy_booked.laparoscopy_booked,0) as laparoscopy_booked,
oTempbelow_36.Tempbelow_36 AS Tempbelow_36,
oTempabove_38.Tempabove_38 AS Tempabove_38,
oEBL.ebl as EBL,
oCrystalloid.Crystalloid as Crystalloid,
oPostOpHGB.PostOpHGB as PostOpHGB,
oPRBC.prbc as PRBC,
oAPGAR.APGAR as APGAR
INTO INNOVIAN_HDNS_EXTRACTION
------------------------------------------------------------------------------------------------
FROM            (SELECT        CaseId, StudyId, surgeryDate, included
                          FROM            IHPStudy.dbo.CaseData
                          WHERE        (included = 1)) AS c INNER JOIN dbo.BaseData AS b ON c.StudyId = b.StudyId
----------------------------------------------------------------------------------------------
LEFT OUTER JOIN  dbo.oPreop_insulin AS oPreop_insulin ON c.StudyId= oPreop_insulin.StudyId
LEFT OUTER JOIN  dbo.oPreop_creatinine AS oPreop_creatinine ON c.StudyId= oPreop_creatinine.[StudyId]
LEFT OUTER JOIN  dbo.oMAP_HSM_PreopPreAdmitMin AS oMAP_HSM_PreopPreAdmitMin ON c.StudyId= oMAP_HSM_PreopPreAdmitMin.StudyId
LEFT OUTER JOIN  dbo.oFirstInnvMAP AS oFirstInnvMAP ON c.StudyId=oFirstInnvMAP.StudyId
LEFT OUTER JOIN  dbo.SBP_HSM_PreopPreAdmitMin AS oSBP_HSM_PreopPreAdmitMin ON c.StudyId= oSBP_HSM_PreopPreAdmitMin.StudyId
LEFT OUTER JOIN  dbo.oFirstInnvSBP AS oFirstInnvSBP ON c.StudyId= oFirstInnvSBP.StudyId
LEFT OUTER JOIN  dbo.oHR_HSM_PreopPreAdmitMin AS oHR_HSM_PreopPreAdmitMin ON c.StudyId= oHR_HSM_PreopPreAdmitMin.StudyId
LEFT OUTER JOIN  dbo.oFirstInnvHR AS oFirstInnvHR ON c.StudyId= oFirstInnvHR.StudyId
LEFT OUTER JOIN  dbo.oSBP_maxdelta_abs_innov AS oSBP_maxdelta_abs_innov ON c.StudyId= oSBP_maxdelta_abs_innov.StudyId
LEFT OUTER JOIN  dbo.oSBP_maxdelta_rel_innov AS oSBP_maxdelta_rel_innov ON c.StudyId= oSBP_maxdelta_rel_innov.StudyId
LEFT OUTER JOIN  dbo.oSBP_maxdelta_abs_preop AS oSBP_maxdelta_abs_preop ON c.StudyId= oSBP_maxdelta_abs_preop.StudyId
LEFT OUTER JOIN  dbo.oSBP_maxdelta_rel_preop AS oSBP_maxdelta_rel_preop ON c.StudyId= oSBP_maxdelta_rel_preop.StudyId
LEFT OUTER JOIN  dbo.oSBP_duration_rel_innov AS oSBP_duration_rel_innov ON c.StudyId= oSBP_duration_rel_innov.StudyId
LEFT OUTER JOIN  dbo.oSBP_duration_rel_preop AS oSBP_duration_rel_preop ON c.StudyId= oSBP_duration_rel_preop.StudyId
LEFT OUTER JOIN  dbo.oMAP_maxdelta_abs_innov AS oMAP_maxdelta_abs_innov ON c.StudyId= oMAP_maxdelta_abs_innov.StudyId
LEFT OUTER JOIN  dbo.oMAP_maxdelta_rel_innov AS oMAP_maxdelta_rel_innov ON c.StudyId= oMAP_maxdelta_rel_innov.StudyId
LEFT OUTER JOIN  dbo.oMAP_maxdelta_abs_preop AS oMAP_maxdelta_abs_preop ON c.StudyId= oMAP_maxdelta_abs_preop.StudyId
LEFT OUTER JOIN  dbo.oMAP_maxdelta_rel_preop AS oMAP_maxdelta_rel_preop ON c.StudyId= oMAP_maxdelta_rel_preop.StudyId
LEFT OUTER JOIN  dbo.oMAP_duration_rel_innov AS oMAP_duration_rel_innov ON c.StudyId= oMAP_duration_rel_innov.StudyId
LEFT OUTER JOIN  dbo.oMAP_duration_rel_preop AS oMAP_duration_rel_preop ON c.StudyId= oMAP_duration_rel_preop.StudyId
LEFT OUTER JOIN  dbo.oSBPLong100 AS oSBP_Longest_100 ON c.StudyId= oSBP_Longest_100.StudyId
LEFT OUTER JOIN  dbo.oSBPLong90 AS oSBP_Longest_90 ON c.StudyId= oSBP_Longest_90.StudyId	
LEFT OUTER JOIN  dbo.oSBPLong80 AS oSBP_Longest_80 ON c.StudyId= oSBP_Longest_80.StudyId
LEFT OUTER JOIN  dbo.oSBPTotal100 AS oSBP_Total_100 ON c.StudyId= oSBP_Total_100.StudyId
LEFT OUTER JOIN  dbo.oSBPTotal90 AS oSBP_Total_90 ON c.StudyId= oSBP_Total_90.StudyId	
LEFT OUTER JOIN  dbo.oSBPTotal80 AS oSBP_Total_80 ON c.StudyId= oSBP_Total_80.StudyId
LEFT OUTER JOIN  dbo.oMAPLong80 AS oMAP_Longest_80 ON c.StudyId= oMAP_Longest_80.StudyId
LEFT OUTER JOIN  dbo.oMAPLong70 AS oMAP_Longest_70 ON c.StudyId= oMAP_Longest_70.StudyId	
LEFT OUTER JOIN  dbo.oMAPLong65 AS oMAP_Longest_65 ON c.StudyId= oMAP_Longest_65.StudyId
LEFT OUTER JOIN  dbo.oMAPLong60 AS oMAP_Longest_60 ON c.StudyId= oMAP_Longest_60.StudyId
LEFT OUTER JOIN  dbo.oMAPTotal80 AS oMAP_Total_80 ON c.StudyId= oMAP_Total_80.StudyId
LEFT OUTER JOIN  dbo.oMAPTotal70 AS oMAP_Total_70 ON c.StudyId= oMAP_Total_70.StudyId	
LEFT OUTER JOIN  dbo.oMAPTotal65 AS oMAP_Total_65 ON c.StudyId= oMAP_Total_65.StudyId
LEFT OUTER JOIN  dbo.oMAPTotal60 AS oMAP_Total_60 ON c.StudyId= oMAP_Total_60.StudyId
LEFT OUTER JOIN  dbo.oHR_max_pos_abs_innov AS oHR_max_pos_abs_innov ON c.StudyId= oHR_max_pos_abs_innov.StudyId
LEFT OUTER JOIN  dbo.oHR_max_neg_abs_innov AS oHR_max_neg_abs_innov ON c.StudyId= oHR_max_neg_abs_innov.StudyId
LEFT OUTER JOIN  dbo.oHR_max_pos_rel_innov AS oHR_max_pos_rel_innov ON c.StudyId= oHR_max_pos_rel_innov.StudyId
LEFT OUTER JOIN  dbo.oHR_max_neg_rel_innov AS oHR_max_neg_rel_innov ON c.StudyId= oHR_max_neg_rel_innov.StudyId
LEFT OUTER JOIN  dbo.oHR_max_pos_abs_preop AS oHR_max_pos_abs_preop ON c.StudyId= oHR_max_pos_abs_preop.StudyId
LEFT OUTER JOIN  dbo.oHR_max_neg_abs_preop AS oHR_max_neg_abs_preop ON c.StudyId= oHR_max_neg_abs_preop.StudyId
LEFT OUTER JOIN  dbo.oHR_max_pos_rel_preop AS oHR_max_pos_rel_preop ON c.StudyId= oHR_max_pos_rel_preop.StudyId
LEFT OUTER JOIN  dbo.oHR_max_neg_rel_preop AS oHR_max_neg_rel_preop ON c.StudyId= oHR_max_neg_rel_preop.StudyId
LEFT OUTER JOIN  dbo.oHR_pulse_var AS oHR_pulse_var ON c.StudyId= oHR_pulse_var.StudyId
LEFT OUTER JOIN  dbo.oHRlong60 as oHR_longest_60 ON c.StudyId= oHR_longest_60.StudyId
LEFT OUTER JOIN  dbo.oHRlong100 as oHR_longest_100 ON c.StudyId= oHR_longest_100.StudyId
LEFT OUTER JOIN  dbo.oHRTotal60 as oHR_Total_60 ON c.StudyId= oHR_Total_60.StudyId
LEFT OUTER JOIN  dbo.oHRTotal100 as oHR_Total_100 ON c.StudyId= oHR_Total_100.StudyId
LEFT OUTER JOIN  dbo.oVasoIno as oVasoIno ON c.StudyId= oVasoIno.StudyId
LEFT OUTER JOIN  dbo.oVasoIno_Infusion as oVasoIno_Infusion ON c.StudyId= oVasoIno_Infusion.StudyId
LEFT OUTER JOIN  dbo.oPhenyl_Ephed as oPhenyl_Ephed ON c.StudyId= oPhenyl_Ephed.StudyId
LEFT OUTER JOIN  dbo.oVasodilator as oVasodilator ON c.StudyId= oVasodilator.StudyId
LEFT OUTER JOIN  dbo.oVasodilator_Infusion as oVasodilator_Infusion ON c.StudyId= oVasodilator_Infusion.StudyId
LEFT OUTER JOIN  dbo.oSPO2longest88 as oSPO2_longest_88 ON c.StudyId= oSPO2_longest_88.StudyId
LEFT OUTER JOIN  dbo.oSPO2longest90 as oSPO2_longest_90 ON c.StudyId= oSPO2_longest_90.StudyId
LEFT OUTER JOIN  dbo.oSPO2duration88 as oSPO2_Total_88 ON c.StudyId= oSPO2_Total_88.StudyId
LEFT OUTER JOIN  dbo.oSPO2duration90 as oSPO2_Total_90 ON c.StudyId= oSPO2_Total_90.StudyId
LEFT OUTER JOIN  dbo.oEtCO2longest30 as oEtCO2_longest_30 ON c.StudyId= oEtCO2_longest_30.StudyId
LEFT OUTER JOIN  dbo.oEtCO2longest45 as oEtCO2_longest_45 ON c.StudyId= oEtCO2_longest_45.StudyId
LEFT OUTER JOIN  dbo.oEtCO2duration30 as oEtCO2_Total_30 ON c.StudyId= oEtCO2_Total_30.StudyId
LEFT OUTER JOIN  dbo.oEtCO2duration45 as oEtCO2_Total_45 ON c.StudyId= oEtCO2_Total_45.StudyId
LEFT OUTER JOIN  dbo.oDuration_surgery as oDuration_surgery ON c.StudyId= oDuration_surgery.StudyId
LEFT OUTER JOIN  dbo.oType_anesthesia as oType_anesthesia ON c.StudyId= oType_anesthesia.StudyId
LEFT OUTER JOIN  dbo.oMAC as oMAC ON c.StudyId= oMAC.StudyId
LEFT OUTER JOIN  dbo.oBIS as oBIS ON c.StudyId= oBIS.StudyId
LEFT OUTER JOIN  dbo.oLaparoscopy  as oLaparoscopy_booked  ON c.StudyId= oLaparoscopy_booked.StudyId
LEFT OUTER JOIN  dbo.oTempbelow36 as oTempbelow_36 ON c.StudyId= oTempbelow_36.StudyId
LEFT OUTER JOIN  dbo.oTempabove38 as oTempabove_38 ON c.StudyId= oTempabove_38.StudyId
LEFT OUTER JOIN  dbo.oEBL as oEBL ON c.StudyId= oEBL.StudyId
LEFT OUTER JOIN  dbo.oCrystalloid as oCrystalloid ON c.StudyId= oCrystalloid.StudyId
LEFT OUTER JOIN  dbo.oPostOpHGB as oPostOpHGB ON c.StudyId= oPostOpHGB.StudyId
LEFT OUTER JOIN  dbo.oPRBC as oPRBC ON c.StudyId= oPRBC.StudyId
LEFT OUTER JOIN  dbo.oAPGAR as oAPGAR ON c.StudyId= oAPGAR.StudyId