

UPDATE MAP
SET [BothMAPMpogNullNxt60secs]=0;

UPDATE MAP
SET [BothMAPMpogNullPrev60secs]=0;



-------------------------------------------------------------------------------------------
--FORWARD
--------------------------------------------------------------------------------------------
WITH  cte
        AS ( SELECT  [caseId],[DT], map, MPOG_MAp FROM [IHPStudy].[dbo].[MAP]   )
/*
 
 Salmasi et al. + MPOG map/MAP artifact removal algos => Determine Case-DT that have only NULLS for 0-30secs

*/



UPDATE MAP
SET [BothmAPMpogNullNxt60secs]=1
FROM
Map m
INNER JOIN
(

Select * from(select a.CaseId, a.Dt, Max(b.MPOG_map) as mmxV,  Max(b.map) as smxV from
((Select * from cte where map is not null and MPOG_map is not null) a
	inner Join
	(Select  CaseId, Dt, MPOG_map, map from cte ) b
On a.caseId=b.caseId and (DateDiff(second, a.DT,b.Dt)<=60 and  DateDiff(second, a.DT,b.Dt)>0) --NXT
)
group by a.CaseId, a.Dt
)x where mmxV is null and smxV is null
)z1
ON m.caseId=z1.caseId and m.DT=z1.DT;
----------------------------------------------------------------------------
-- BACKWARDS
---------------------------------------------------------------------------
WITH  cte
        AS ( SELECT  [caseId],[DT], map, MPOG_map FROM [IHPStudy].[dbo].[MAP]   )
/*
 
 Salmasi et al. + MPOG map/MAP artifact removal algos => Determine Case-DT that have only NULLS for 0-30secs

*/



UPDATE MAP
SET [BothmapMpogNullPrev60secs]=1
FROM
Map m
INNER JOIN
(

Select * from(select a.CaseId, a.Dt, Max(b.MPOG_map) as mmxV,  Max(b.map) as smxV from
((Select * from cte where map is not null and MPOG_map is not null) a
	inner Join
	(Select  CaseId, Dt, MPOG_map, map from cte ) b
On a.caseId=b.caseId and (DateDiff(second, b.DT,a.Dt)<=60 and  DateDiff(second, b.DT,a.Dt)>0) --PREV
)
group by a.CaseId, a.Dt
)x where mmxV is null and smxV is null
)z1
ON m.caseId=z1.caseId and m.DT=z1.DT;
------------------------------------------------------------------------------------------------------
---Number Nulls in 60 secs where mpog and map are null => 1 if >2
-----------------------------------------------------------------------------------------------------

--FWD


UPDATE MAP
SET [GreaterThan2NULLSIn60SecsNxtmap]=0;




WITH  cte
        AS ( SELECT  [caseId],[DT], map, MPOG_map FROM [IHPStudy].[dbo].[MAP]   )
/*
 
 Salmasi et al. + MPOG map/MAP artifact removal algos => Determine Case-DT that have only NULLS for 0-30secs

*/

UPDATE MAP
SET [GreaterThan2NULLSIn60SecsNxtmap]=1
FROM
Map m
INNER JOIN
(

Select* From
(
select CaseId, Dt, Count(caseId) as cnt from -- 
(
Select a.CaseId  as CaseId, a.Dt as Dt, a.map, b.MPOG_map as mp, b.map as lmap, b.dt as bdt from
(Select * from cte where map is not null and MPOG_map is not null) a
	left Join
	(Select  CaseId, Dt, MPOG_map, map from cte ) b
On a.caseId=b.caseId and (DateDiff(second, a.DT,b.Dt)<=60 and  DateDiff(second, a.DT,b.Dt)>0 -- NXT
) Where b.MPOG_map  is null
)cc
group by CaseId, Dt)z
Where cnt>2
)z1
 ON m.caseId=z1.CaseId and m.DT=z1.DT;
--------------------------------------------------------------------------------------------------------


--FWD


UPDATE MAP
SET [GreaterThan2NULLSIn60SecsPrevmap]=0;

WITH  cte
        AS ( SELECT  [caseId],[DT], map, MPOG_map FROM [IHPStudy].[dbo].[MAP]   )
/*
 
 Salmasi et al. + MPOG map/MAP artifact removal algos => Determine Case-DT that have only NULLS for 0-30secs

*/

UPDATE MAP
SET [GreaterThan2NULLSIn60SecsPrevmap]=1
FROM
Map m
INNER JOIN
(

Select* From
(
select CaseId, Dt, Count(caseId) as cnt from -- 
(
Select a.CaseId  as CaseId, a.Dt as Dt, a.map, b.MPOG_map as mp, b.map as lmap, b.dt as bdt from
(Select * from cte where map is not null and MPOG_map is not null) a
	left Join
	(Select  CaseId, Dt, MPOG_map, map from cte ) b
On a.caseId=b.caseId and (DateDiff(second, b.DT,a.Dt)<=60 and  DateDiff(second, b.DT,a.Dt)>0 -- Prev
) Where b.MPOG_map  is null
)cc
group by CaseId, Dt)z
Where cnt>2
)z1
 ON m.caseId=z1.CaseId and m.DT=z1.DT;
--------------------------------------------------------------------------------------------------------
