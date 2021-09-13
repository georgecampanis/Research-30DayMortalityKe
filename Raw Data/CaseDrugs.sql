SELECT        CaseDrugHeader.Case_ID, Drug.Drug_ID, UPPER(Drug.DrugName) AS DrugName, Route.RouteName, Unit.UnitName, CaseDrugHeader.IntraOpTotal, CaseDrugHeader.LastUpdate, Upper(DrugGroup.DrugGroupName) as DrugGroup
INTO IHPStudy.dbo.CaseDrugs
FROM            (SELECT        Case_ID, CaseDrugHeader_ID, Drug_ID, Unit_ID, Route_ID, ModifiedUser_ID, ModifiedWorkstation_ID, TotalType_ID, LastUpdate, MedicationStatus_ID, PreOpTotal, PostOpTotal, HoldingTotal, UserLabel, 
                                                    AutoTrendId, ExternalID, UserIdentified, Port, IntraOpTotal, ExternalSource, FutureUse_CaseFluidHeaderLink_ID
                          FROM            CaseDrugHeader AS CaseDrugHeader_1
                          WHERE        (Case_ID IN
                                                        (SELECT        CaseId
                                                          FROM            IHPStudy.dbo.CaseData))) AS CaseDrugHeader INNER JOIN
                         Drug ON CaseDrugHeader.Drug_ID = Drug.Drug_ID INNER JOIN
                         Route ON CaseDrugHeader.Route_ID = Route.Route_ID INNER JOIN
                         Unit ON CaseDrugHeader.Unit_ID = Unit.Unit_ID AND Drug.Unit_ID = Unit.Unit_ID AND Drug.TotalUnit_ID = Unit.Unit_ID INNER JOIN
                         DrugGroup ON Drug.DrugGroup_ID = DrugGroup.DrugGroup_ID
						 