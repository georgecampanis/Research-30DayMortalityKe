  SELECT        CaseFluid.Case_ID, Fluid.FluidName, Unit.UnitName, CaseFluid.Sequence, CaseFluid.LastUpdate AS dt, CaseFluid.Dosage AS value
INTO CaseEBL

FROM            PeriopDM.dbo.Unit INNER JOIN
                         PeriopDM.dbo.Fluid ON Unit.Unit_ID = Fluid.Unit_ID AND Unit.Unit_ID = Fluid.Unit_ID INNER JOIN
                         PeriopDM.dbo.CaseFluidHeader ON Unit.Unit_ID = CaseFluidHeader.Unit_ID AND Fluid.Fluid_ID = CaseFluidHeader.Fluid_ID INNER JOIN
                             (SELECT        PeriopDM.dbo.CaseFluid.Case_ID, PeriopDM.dbo.CaseFluid.CaseFluidHeader_ID, PeriopDM.dbo.CaseFluid.Sequence, PeriopDM.dbo.CaseFluid.LastUpdate, PeriopDM.dbo.CaseFluid.Dosage
FROM            PeriopDM.dbo.CaseFluid INNER JOIN
                         CaseData ON PeriopDM.dbo.CaseFluid.Case_ID = CaseData.CaseId) AS CaseFluid ON CaseFluidHeader.Case_ID = CaseFluid.Case_ID AND CaseFluidHeader.CaseFluidHeader_ID = CaseFluid.CaseFluidHeader_ID
WHERE        (CaseFluid.Dosage IS NOT NULL and  (CaseFluidHeader.Fluid_ID = 3))