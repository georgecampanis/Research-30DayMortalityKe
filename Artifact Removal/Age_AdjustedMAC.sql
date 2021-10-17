
--Get all SPO2 HR Dates to use as the base
Select *
INTO IHPStudy.dbo.MAC
from 

(Select   ihp.CaseId AS CaseId, ihp.age as age, CVDH.[LastUpdate] as dt,Sequence as seq 
	FROM
	(SELECT [CaseId],[Age] FROM [IHPStudy].[dbo].[CaseBaseData]-- where  CaseId not in (SELECT distinct [CaseID] FROM [IHPStudy].[dbo].[MACv1])
	) ihp
INNER JOIN (Select Case_ID, [LastUpdate], Sequence from [IHPStudy].[dbo].[CaseVitalsData] WHERE VitalData_ID=1607 ) CVDH on ihp.CaseId= CVDH.Case_ID
) v


--Add Columns
	ALTER TABLE MAC ADD 
	[n2o] [float] NULL,
	[n2oDt] [datetime] NULL,
	[sevo] [float] NULL,
	[sevoDt] [datetime] NULL,
	[des] [float] NULL,
	[desDt] [datetime] NULL,
	[iso] [float] NULL,
	[isoDt] [datetime] NULL,
	[hal] [float] NULL,
	[halDt] [datetime] NULL,
	[InnovMAC] [float] NULL,
	[n2oAdj] [float] NULL,
	[sevoAdj] [float] NULL,
	[desAdj] [float] NULL,
	[isoAdj] [float] NULL,
	[halAdj] [float] NULL,
	[k_TotalMAC] [float] NULL,
	[MAC] [float] NULL,
	[nxtTimeDiffSecs] int NULL,
	[TimeWeightedMAC] [float] NULL
	
-------------------------------------------------------
-- N2O data
-------------------------------------------------------		
Update MAC
Set  
[n2o]=n2o.Value, 
[n2oDt]=n2o.Dt, 
[n2oAdj]=Cast(CAST(n2o.Value AS float)/(cast(104 * POWER(CAST(10.0 AS float), -0.00269*(m.age-40) ) as float))as float)

From MAC m
Inner Join
(SELECT VitalData_ID, [Case_ID] as CaseId, [Value], [LastUpdate] as dt FROM [IHPStudy].[dbo].[CaseVitalsData] 
	where  VitalData_ID in (
		833, -- EXSP N2O
		1185, -- EXSP N2O
		1288, -- EXSP N2O
		1410, -- EXSP N2O
		1609, -- EXSP N2O
		1725 -- EXSP N2O)
		)
) n2o
on m.CaseId = n2o.CaseId  and ABS(DATEDIFF(SECOND, m.DT, n2o.DT)) <= 5--match time to 10sec


-------------------------------------------------------
-- SEVO data
-------------------------------------------------------		
Update MAC
Set  
[sevo]=sevo.Value, 
[sevoDt]=sevo.Dt, 
[sevoAdj]=Cast(CAST(sevo.Value AS float)/cast(1.8 * POWER(CAST(10.0 AS float), -0.00269*(m.age-40) ) as float)as float)

From MAC m
Inner Join
(SELECT VitalData_ID, [Case_ID] as CaseId, [Value], [LastUpdate] as dt FROM [IHPStudy].[dbo].[CaseVitalsData] 
	where  VitalData_ID in (
838, -- EXSP SEV
1165, -- EXSP SEV
1182, -- EXSP SEV
1282, -- EXSP SEV
1287, -- EXSP SEV
1381, -- EXSP SEV
1423, -- EXSP SEV
1615, -- EXSP SEV
1716, -- EXSP SEV
1817 -- EXSP SEV
		)
) sevo
on m.CaseId = sevo.CaseId  and ABS(DATEDIFF(SECOND, m.DT, sevo.DT)) <= 5--match time to 10sec

-------------------------------------------------------
-- DES data
-------------------------------------------------------		
Update MAC
Set  
[des]=des.Value, 
[desDt]=des.Dt, 
[desAdj]=Cast(CAST(des.Value AS float)/cast(6.6 * POWER(CAST(10.0 AS float), -0.00269*(m.age-40) ) as float)as float)

From MAC m
Inner Join
(SELECT VitalData_ID, [Case_ID] as CaseId, [Value], [LastUpdate] as dt FROM [IHPStudy].[dbo].[CaseVitalsData] 
	where  VitalData_ID in (
837, -- EXSP DES
1164, -- EXSP DES
1181, -- EXSP DES
1281, -- EXSP DES
1286, -- EXSP DES
1382, -- EXSP DES
1614, -- EXSP DES
1717, -- EXSP DES
1813 -- EXSP DES
		)
) des
on m.CaseId = des.CaseId  and ABS(DATEDIFF(SECOND, m.DT, des.DT)) <= 5--match time to 10sec

-------------------------------------------------------
-- ISO data
-------------------------------------------------------		
Update MAC
Set  
[iso]=iso.Value, 
[isoDt]=iso.Dt, 
[isoAdj]=Cast(CAST(iso.Value AS float)/cast(1.17 * POWER(CAST(10.0 AS float), -0.00269*(m.age-40) ) as float)as float)

From MAC m
Inner Join
(SELECT VitalData_ID, [Case_ID] as CaseId, [Value], [LastUpdate] as dt FROM [IHPStudy].[dbo].[CaseVitalsData] 
	where  VitalData_ID in (
835, -- EXSP ISO
1177, -- EXSP ISO
1180, -- EXSP ISO
1279, -- EXSP ISO
1284, -- EXSP ISO
1408, -- EXSP ISO
1422, -- EXSP ISO
1613, -- EXSP ISO
1816 -- EXSP ISO
		)
) iso
on m.CaseId = iso.CaseId  and ABS(DATEDIFF(SECOND, m.DT, iso.DT)) <= 5--match time to 10sec

-------------------------------------------------------
-- HAL data
-------------------------------------------------------		
Update MAC
Set  
[hal]=hal.Value, 
[halDt]=hal.Dt, 
[halAdj]=Cast(CAST(hal.Value AS float)/cast(0.75 * POWER(CAST(10.0 AS float), -0.00269*(m.age-40) ) as float)as float)

From MAC m
Inner Join
(SELECT VitalData_ID, [Case_ID] as CaseId, [Value], [LastUpdate] as dt FROM [IHPStudy].[dbo].[CaseVitalsData] 
	where  VitalData_ID in (
1175,--EXSP HAL
1611--EXSP HAL
		)
) hal
on m.CaseId = hal.CaseId  and ABS(DATEDIFF(SECOND, m.DT, hal.DT)) <= 5--match time to 10sec

-------------------------------------------------------
-- MAC data
-------------------------------------------------------		
Update MAC
Set  
[InnovMAC]=mac.Value 
From MAC m
Inner Join
(SELECT VitalData_ID, [Case_ID] as CaseId, [Value], [LastUpdate] as dt FROM [IHPStudy].[dbo].[CaseVitalsData] 
	where  VitalData_ID in (
1526
		)
) mac
on m.CaseId = mac.CaseId  and ABS(DATEDIFF(SECOND, m.DT, mac.DT)) <= 5--match time to 10sec

-------------------------------------------------------
-- k_TotalMAC data
-------------------------------------------------------		
Update MAC
Set k_TotalMAC=(COALESCE(n2oAdj, 0) + COALESCE(sevoAdj,0)+ COALESCE(desAdj,0) + COALESCE(isoAdj,0) + COALESCE(halAdj,0)) 

-------------------------------------------------------
-- MAC data
-------------------------------------------------------		
Update MAC
set MAC=[k_TotalMAC]
where [MAC].[k_TotalMAC] >= 0.2 and  [MAC].[k_TotalMAC] <=  2.5

-------------------------------------------------------
-- Time Diff data
-------------------------------------------------------		
;
WITH CTE AS (
  SELECT  rownum = ROW_NUMBER() over(PARTITION by  CaseID  order by  [DT] asc ), CaseID, DT, MAC FROM MAC where [MAC].MAC is not null
)

SELECT cur.CaseId, cur.DT, Abs(DateDiff(SECOND,cur.DT, nxt.DT)) as dif
Into MACTimeDiff
FROM CTE cur
LEFT JOIN CTE prev on prev.rownum = cur.rownum + 1 and prev.CaseId=cur.CaseId
LEFT JOIN CTE nxt on nxt.rownum = cur.rownum -1 and nxt.CaseId=cur.CaseId
;


Update MAC
Set  [nxtTimeDiffSecs]=b.dif
From MAC m
Inner Join
(
Select * from MACTimeDiff
  )b
On m.caseId=b.caseId and m.DT=b.DT

DROP TABLE [dbo].[MACTimeDiff]
------------------------------------------------------------------------------------------------------
--- TimeWeightedMAC Data
-------------------------------------------------------------------------------------------

Update MAC
Set  [TimeWeightedMAC]=t.TimeWeightedMAC
From MAC m
Inner Join
(
select m.*, m.MAC*(m.[nxtTimeDiffSecs]/CAST(t1.sumTime as float)) as TimeWeightedMAC from --(MACt  * (TD t /TT))  
(
(select [caseId], dt, MAC, [nxtTimeDiffSecs] from MAC where MAC is not Null and [nxtTimeDiffSecs] is not null ) m
Inner Join
(SELECT [caseId], Sum([nxtTimeDiffSecs]) as sumTime  FROM MAC group by caseId) t1
ON m.caseId=t1.caseId
)
)t
On m.caseId=t.caseId and m.DT=t.DT

