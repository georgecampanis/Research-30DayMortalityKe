ALTER TABLE [SpO2_HR_Bkwd1min] ADD [is1HourBetween] bit DEFAULT 0, [is1HourBetweenBwd] bit DEFAULT 0,  [is1HourBetweenFwd] bit DEFAULT 0;
ALTER TABLE [SpO2_HR_Fwd1min] ADD [is1HourBetween] bit DEFAULT 0, [is1HourBetweenBwd] bit DEFAULT 0,  [is1HourBetweenFwd] bit DEFAULT 0;
ALTER TABLE [SPO2_Bkwd1min] ADD [is1HourBetween] bit DEFAULT 0, [is1HourBetweenBwd] bit DEFAULT 0,  [is1HourBetweenFwd] bit DEFAULT 0;
ALTER TABLE [SPO2_Fwd1min] ADD [is1HourBetween] bit DEFAULT 0, [is1HourBetweenBwd] bit DEFAULT 0,  [is1HourBetweenFwd] bit DEFAULT 0;


WITH CTE ([CaseId], [DT],row_num )
AS
(
SELECT  [CaseId]
      ,[DT],
     ROW_NUMBER() OVER (
	PARTITION BY CaseId ORDER BY [DT] desc
   ) row_num
  FROM [IHPStudy].[dbo].[SpO2_HR_Bkwd1min] 
  )

 Update [IHPStudy].[dbo].[SpO2_HR_Bkwd1min]
 set [is1HourBetweenBwd]=1
 From [IHPStudy].[dbo].[SpO2_HR_Bkwd1min] bk
 Inner Join
 (Select CaseId, Min(Dt) as dt from
  (
  select c.CaseId caseId, c.Dt Dt from
  (
  (select * from cte) c
  inner join
  (select * from cte) c2
  On c.CaseId=c2.CaseId and c2.row_num=c.row_num+1

  ) where DateDiff(MINUTE, c2.Dt,c.Dt )>=60 
  )x group by caseId)y
  On bk.CaseId=y.caseId and bk.Dt>=y.dt;
  
  
  WITH CTE ([CaseId], [DT],row_num )
AS
(
SELECT  [CaseId]
      ,[DT],
     ROW_NUMBER() OVER (
	PARTITION BY CaseId ORDER BY [DT] desc
   ) row_num
  FROM [IHPStudy].[dbo].[SpO2_Bkwd1min] 
  )

 Update [IHPStudy].[dbo].[SpO2_Bkwd1min]
 set [is1HourBetweenBwd]=1
 From [IHPStudy].[dbo].[SpO2_Bkwd1min] bk
 Inner Join
 (Select CaseId, Min(Dt) as dt from
  (
  select c.CaseId caseId, c.Dt Dt from
  (
  (select * from cte) c
  inner join
  (select * from cte) c2
  On c.CaseId=c2.CaseId and c2.row_num=c.row_num+1

  ) where DateDiff(MINUTE, c2.Dt,c.Dt )>=60 
  )x group by caseId)y
  On bk.CaseId=y.caseId and bk.Dt>=y.dt;



WITH CTE ([CaseId], [DT],row_num )
AS
(
SELECT  [CaseId]
      ,[DT],
     ROW_NUMBER() OVER (
	PARTITION BY CaseId ORDER BY [DT] desc
   ) row_num
  FROM [IHPStudy].[dbo].[SPO2_HR_Fwd1min] 
  )

 Update [IHPStudy].[dbo].[SPO2_HR_Fwd1min]
 set [is1HourBetweenBwd]=1
 From [IHPStudy].[dbo].[SPO2_HR_Fwd1min] bk
 Inner Join
 (Select CaseId, Min(Dt) as dt from
  (
  select c.CaseId caseId, c.Dt Dt from
  (
  (select * from cte) c
  inner join
  (select * from cte) c2
  On c.CaseId=c2.CaseId and c2.row_num=c.row_num+1

  ) where DateDiff(MINUTE, c2.Dt,c.Dt )>=60 
  )x group by caseId)y
  On bk.CaseId=y.caseId and bk.Dt>=y.dt;
  
  
  WITH CTE ([CaseId], [DT],row_num )
AS
(
SELECT  [CaseId]
      ,[DT],
     ROW_NUMBER() OVER (
	PARTITION BY CaseId ORDER BY [DT] desc
   ) row_num
  FROM [IHPStudy].[dbo].[SPO2_Fwd1min] 
  )

 Update [IHPStudy].[dbo].[SPO2_Fwd1min] 
 set [is1HourBetweenBwd]=1
 From [IHPStudy].[dbo].[SPO2_Fwd1min] bk
 Inner Join
 (Select CaseId, Min(Dt) as dt from
  (
  select c.CaseId caseId, c.Dt Dt from
  (
  (select * from cte) c
  inner join
  (select * from cte) c2
  On c.CaseId=c2.CaseId and c2.row_num=c.row_num+1

  ) where DateDiff(MINUTE, c2.Dt,c.Dt )>=60 
  )x group by caseId)y
  On bk.CaseId=y.caseId and bk.Dt>=y.dt;
-----------------------------------------------
--Fwd 
----------------------------------------------

WITH CTE ([CaseId], [DT],row_num )
AS
(
SELECT  [CaseId]
      ,[DT],
     ROW_NUMBER() OVER (
	PARTITION BY CaseId ORDER BY [DT] desc
   ) row_num
  FROM [IHPStudy].[dbo].[SpO2_HR_Fwd1min] 
  )

 Update [IHPStudy].[dbo].[SpO2_HR_Fwd1min]
 set [is1HourBetweenFwd]=1
 From [IHPStudy].[dbo].[SpO2_HR_Fwd1min] bk
 Inner Join
 (
 Select z.CaseId, Min(Dt) as dt from
  (
  select c.CaseId caseId, c2.Dt Dt from
  (
  (select * from cte) c
  inner join
  (select * from cte) c2
  On c.CaseId=c2.CaseId and c2.row_num=c.row_num-1
  )where DateDiff(MINUTE, c2.Dt,c.Dt )>=60 
  )z group by z.CaseId

 )y
  On bk.CaseId=y.caseId and bk.Dt<=y.dt;


WITH CTE ([CaseId], [DT],row_num )
AS
(
SELECT  [CaseId]
      ,[DT],
     ROW_NUMBER() OVER (
	PARTITION BY CaseId ORDER BY [DT] 
   ) row_num
  FROM [IHPStudy].[dbo].[SpO2_Fwd1min] 
  )

 Update [IHPStudy].[dbo].[SpO2_Fwd1min]
 set [is1HourBetweenFwd]=1
 From [IHPStudy].[dbo].[SpO2_Fwd1min] bk
 Inner Join
 (
 
 Select z.CaseId, Min(Dt) as dt from
  (
  select c.CaseId caseId, c2.Dt Dt from
  (
  (select * from cte) c
  inner join
  (select * from cte) c2
  On c.CaseId=c2.CaseId and c2.row_num=c.row_num-1
  )where DateDiff(MINUTE, c2.Dt,c.Dt )>=60 
  )z group by z.CaseId
 )y
  On bk.CaseId=y.caseId and bk.Dt<=y.dt;


WITH CTE ([CaseId], [DT],row_num )
AS
(
SELECT  [CaseId]
      ,[DT],
     ROW_NUMBER() OVER (
	PARTITION BY CaseId ORDER BY [DT] desc
   ) row_num
  FROM [IHPStudy].[dbo].[SpO2_HR_Bkwd1min] 
  )

 Update [IHPStudy].[dbo].[SpO2_HR_Bkwd1min] 
 set [is1HourBetweenFwd]=1
 From [IHPStudy].[dbo].[SpO2_HR_Bkwd1min] bk
 Inner Join
 (
 Select z.CaseId, Min(Dt) as dt from
  (
  select c.CaseId caseId, c2.Dt Dt from
  (
  (select * from cte) c
  inner join
  (select * from cte) c2
  On c.CaseId=c2.CaseId and c2.row_num=c.row_num-1
  )where DateDiff(MINUTE, c2.Dt,c.Dt )>=60 
  )z group by z.CaseId

 )y
  On bk.CaseId=y.caseId and bk.Dt<=y.dt;


WITH CTE ([CaseId], [DT],row_num )
AS
(
SELECT  [CaseId]
      ,[DT],
     ROW_NUMBER() OVER (
	PARTITION BY CaseId ORDER BY [DT] 
   ) row_num
  FROM [IHPStudy].[dbo].[SpO2_Bkwd1min] 
  )

 Update [IHPStudy].[dbo].[SpO2_Bkwd1min] 
 set [is1HourBetweenFwd]=1
 From [IHPStudy].[dbo].[SpO2_Bkwd1min] bk
 Inner Join
 (
 
 Select z.CaseId, Min(Dt) as dt from
  (
  select c.CaseId caseId, c2.Dt Dt from
  (
  (select * from cte) c
  inner join
  (select * from cte) c2
  On c.CaseId=c2.CaseId and c2.row_num=c.row_num-1
  )where DateDiff(MINUTE, c2.Dt,c.Dt )>=60 
  )z group by z.CaseId
 )y
  On bk.CaseId=y.caseId and bk.Dt<=y.dt;




Update [SPO2_Fwd1min] Set is1hourbetween=0;
Update [SPO2_Bkwd1min] Set is1hourbetween=0;
Update [SpO2_HR_Bkwd1min] Set is1hourbetween=0;
Update [SpO2_HR_Fwd1min] Set is1hourbetween=0;


--=====================================================
Update [SPO2_Fwd1min]
Set is1hourbetween=1
From [SPO2_Fwd1min] a
Inner Join
(
Select bk.CaseId
, Case When lB<=[lF] Then DtBks else DtFws End as sDT,
Case When lB<=[lF] Then DtBke else DtFwe End as eDT

from
(
(SELECT  CaseId , Min(dt) as DtBks,Max(dt) as DtBke, Count(is1hourbetweenBwd) lB  FROM (select * from  [IHPStudy].[dbo].[SPO2_Fwd1min] where is1hourbetweenBwd=1 )x group by CaseId) bk
INNER JOIN
(SELECT  CaseId , Max(dt) as DtFwe, Min(dt) as DtFws, Count(is1hourbetweenFwd) lF  FROM (select * from  [IHPStudy].[dbo].[SPO2_Fwd1min] where is1hourbetweenFwd=1 )x group by CaseId) fw
on bk.CaseId=fw.CaseId
 ))b
 On a.CaseId=b.CaseId and a.Dt>=b.sDT and a.DT<=b.eDT
 --=======================================================
 
Update [SPO2_Bkwd1min]
Set is1hourbetween=1
From [SPO2_Bkwd1min] a
Inner Join
(
Select bk.CaseId
, Case When lB<=[lF] Then DtBks else DtFws End as sDT,
Case When lB<=[lF] Then DtBke else DtFwe End as eDT

from
(
(SELECT  CaseId , Min(dt) as DtBks,Max(dt) as DtBke, Count(is1hourbetweenBwd) lB  FROM (select * from  [IHPStudy].[dbo].[SPO2_Bkwd1min] where is1hourbetweenBwd=1 )x group by CaseId) bk
INNER JOIN
(SELECT  CaseId , Max(dt) as DtFwe, Min(dt) as DtFws, Count(is1hourbetweenFwd) lF  FROM (select * from  [IHPStudy].[dbo].[SPO2_Bkwd1min] where is1hourbetweenFwd=1 )x group by CaseId) fw
on bk.CaseId=fw.CaseId
 ))b
 On a.CaseId=b.CaseId and a.Dt>=b.sDT and a.DT<=b.eDT
 --=======================================================
 --[SpO2_HR_Bkwd1min]
Update [SpO2_HR_Bkwd1min]
Set is1hourbetween=1
From [SpO2_HR_Bkwd1min] a
Inner Join
(
Select bk.CaseId
, Case When lB<=[lF] Then DtBks else DtFws End as sDT,
Case When lB<=[lF] Then DtBke else DtFwe End as eDT

from
(
(SELECT  CaseId , Min(dt) as DtBks,Max(dt) as DtBke, Count(is1hourbetweenBwd) lB  FROM (select * from  [IHPStudy].[dbo].[SpO2_HR_Bkwd1min] where is1hourbetweenBwd=1 )x group by CaseId) bk
INNER JOIN
(SELECT  CaseId , Max(dt) as DtFwe, Min(dt) as DtFws, Count(is1hourbetweenFwd) lF  FROM (select * from  [IHPStudy].[dbo].[SpO2_HR_Bkwd1min] where is1hourbetweenFwd=1 )x group by CaseId) fw
on bk.CaseId=fw.CaseId
 ))b
 On a.CaseId=b.CaseId and a.Dt>=b.sDT and a.DT<=b.eDT
 --=======================================================
 --[SpO2_HR_Fwd1min]
Update [SpO2_HR_Fwd1min]
Set is1hourbetween=1
From [SpO2_HR_Fwd1min] a
Inner Join
(
Select bk.CaseId
, Case When lB<=[lF] Then DtBks else DtFws End as sDT,
Case When lB<=[lF] Then DtBke else DtFwe End as eDT

from
(
(SELECT  CaseId , Min(dt) as DtBks,Max(dt) as DtBke, Count(is1hourbetweenBwd) lB  FROM (select * from  [IHPStudy].[dbo].[SpO2_HR_Fwd1min] where is1hourbetweenBwd=1 )x group by CaseId) bk
INNER JOIN
(SELECT  CaseId , Max(dt) as DtFwe, Min(dt) as DtFws, Count(is1hourbetweenFwd) lF  FROM (select * from  [IHPStudy].[dbo].[SpO2_HR_Fwd1min] where is1hourbetweenFwd=1 )x group by CaseId) fw
on bk.CaseId=fw.CaseId
 ))b
 On a.CaseId=b.CaseId and a.Dt>=b.sDT and a.DT<=b.eDT
