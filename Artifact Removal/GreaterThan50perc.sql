--MAP
WITH CTE AS (
  SELECT
    rownum = ROW_NUMBER() over(PARTITION by  CaseID  order by  Dt asc ), CaseID, Dt, map FROM [MAP] where map Is not null 
)

Select CaseId, DT, p, c,n--, (n/c)as nx, (n/p) as pv
Into MapNxtPrevFinalRemoval
from
(
SELECT cur.map as c, prev.map as p, nxt.map as n, cur.CaseId as CaseId, cur.Dt as DT

FROM CTE cur
LEFT JOIN CTE nxt on nxt.rownum = cur.rownum +1 and nxt.CaseId=cur.CaseId
LEFT JOIN CTE prev on prev.rownum = cur.rownum -1 and prev.CaseId=cur.CaseId
)r
order by dt
-------------------------
update u
set [map_GreaterThan50perc_FinalRemove]=1, map=null
from [IHPStudy].[dbo].[MAP] u
    inner join (SELECT 
      [CaseId]
      ,[Dt]
  FROM [IHPStudy].[dbo].[MapNxtPrevFinalRemoval]
  where (c/p)<0.5 and (c/n)<0.5) s on
        u.caseId = s.CaseId and u.dt=s.Dt

--------------------------------------------------------------------------
--SBP
--------------------------------------------------------------------------
WITH CTE AS (
  SELECT
    rownum = ROW_NUMBER() over(PARTITION by  CaseID  order by  Dt asc ), CaseID, Dt, SBP FROM [MAP] where SBP Is not null 

Select CaseId, DT, p, c,n--, (n/c)as nx, (n/p) as pv
Into SBPNxtPrevFinalRemoval
from
(
SELECT cur.SBP as c, prev.SBP as p, nxt.SBP as n, cur.CaseId as CaseId, cur.Dt as DT

FROM CTE cur
LEFT JOIN CTE nxt on nxt.rownum = cur.rownum +1 and nxt.CaseId=cur.CaseId
LEFT JOIN CTE prev on prev.rownum = cur.rownum -1 and prev.CaseId=cur.CaseId
)r
order by dt
-------------------------
update u
set [SBP_GreaterThan50perc_FinalRemove]=1, SBP=null
from [IHPStudy].[dbo].[MAP] u
    inner join (SELECT 
      [CaseId]
      ,[Dt]
  FROM [IHPStudy].[dbo].[SBPNxtPrevFinalRemoval]
  where (c-p/c)<0.5 and (c/n)<0.5) s on
        u.caseId = s.CaseId and u.dt=s.Dt