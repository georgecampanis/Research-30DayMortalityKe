update  [IHPStudy].[dbo].[HR] set [WithinStEndTime]=0;
update  [IHPStudy].[dbo].[CaseTEMP] set [WithinStEndTime]=0;
update  [IHPStudy].[dbo].[EtCO2] set [WithinStEndTime]=0;
update  [IHPStudy].[dbo].[MAC] set [WithinStEndTime]=0;
update  [IHPStudy].[dbo].[MAP] set [WithinStEndTime]=0;
update  [IHPStudy].[dbo].SPO2 set [WithinStEndTime]=0;


update  [IHPStudy].[dbo].[HR] set [WithinStEndTime]=1
From [IHPStudy].[dbo].[HR] a
INNER JOIN
(SELECT [CaseId],[startDt] ,[endDt] FROM [IHPStudy].[dbo].[CaseDurationSPO2HR])b
On a.Case_ID=b.CaseId and a.DT_SpO2>=b.startDt and dateAdd(Second,15,a.DT_SpO2)<=b.endDt;


update  [IHPStudy].[dbo].[CaseTEMP] set [WithinStEndTime]=1
From [IHPStudy].[dbo].[CaseTEMP] a
INNER JOIN
(SELECT [CaseId],[startDt] ,[endDt] FROM [IHPStudy].[dbo].[CaseDurationSPO2HR])b
On a.Case_ID=b.CaseId and a.LastUpdate>=b.startDt and dateAdd(Second,15,a.LastUpdate)<=b.endDt;


update  [IHPStudy].[dbo].[EtCO2] set [WithinStEndTime]=1
From [IHPStudy].[dbo].[EtCO2] a
INNER JOIN
(SELECT [CaseId],[startDt] ,[endDt] FROM [IHPStudy].[dbo].[CaseDurationSPO2HR])b
On a.Case_ID=b.CaseId and a.LastUpdate>=b.startDt and dateAdd(Second,15,a.LastUpdate)<=b.endDt;

update  [IHPStudy].[dbo].[MAC] set [WithinStEndTime]=1
From [IHPStudy].[dbo].[MAC] a
INNER JOIN
(SELECT [CaseId],[startDt] ,[endDt] FROM [IHPStudy].[dbo].[CaseDurationSPO2HR])b
On a.CaseID=b.CaseId and a.dt>=b.startDt and dateAdd(Second,15,a.dt)<=b.endDt;

update  [IHPStudy].[dbo].[MAP] set [WithinStEndTime]=1
From [IHPStudy].[dbo].[MAP] a
INNER JOIN
(SELECT [CaseId],[startDt] ,[endDt] FROM [IHPStudy].[dbo].[CaseDurationSPO2HR])b
On a.CaseID=b.CaseId and a.dt>=b.startDt and dateAdd(Second,15,a.dt)<=b.endDt;


update  [IHPStudy].[dbo].SPO2 set [WithinStEndTime]=1
From [IHPStudy].[dbo].SPO2 a
INNER JOIN
(SELECT [CaseId],[startDt] ,[endDt] FROM [IHPStudy].[dbo].[CaseDurationSPO2HR])b
On a.Case_ID=b.CaseId and a.LastUpdate>=b.startDt and dateAdd(Second,15,a.LastUpdate)<=b.endDt;

