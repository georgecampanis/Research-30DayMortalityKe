--Bwd
select CaseId, DT, minVal
INTO SPO2_Bkwd1min
from
(
Select CaseId, DT, Min(o2) as minVal

from
(

SELECT        x.Case_ID caseId,  DATEDIFF(second, x.LastUpdate, y.LastUpdate) d, x.LastUpdate as Dt, x.SPO2, y.Case_ID AS Expr1, y.LastUpdate AS Expr2, y.SPO2 AS o2
FROM            (SELECT        Case_ID, LastUpdate, CASE WHEN COALESCE(SPO2, 0 )>100 or COALESCE(SPO2, 0 )<50 THEN 0 ELSE SPO2 END  as SPO2
                          FROM            SPO2 --where SPO2<=100 and SPO2>=50-- and 
                         
						  ) AS x LEFT OUTER JOIN
                             (SELECT        Case_ID, LastUpdate, 
								CASE WHEN COALESCE(SPO2, 0 )>100 or COALESCE(SPO2, 0 )<50 THEN 0 ELSE SPO2 END  as SPO2
                               FROM            SPO2 AS SPO2_1
                             
							   ) AS y ON x.Case_ID = y.Case_ID AND (DATEDIFF(second, x.LastUpdate, y.LastUpdate) >= -60 and DATEDIFF(second, x.LastUpdate, y.LastUpdate) <= 0)
							   and x.LastUpdate > y.LastUpdate
GROUP BY x.Case_ID, x.LastUpdate, x.SPO2, y.Case_ID, y.LastUpdate, y.SPO2
--order by  x.LastUpdate, y.LastUpdate
)c group by CaseId, DT
)z where minVal is not null
order by dt


--fwd
select CaseId, DT, minVal
INTO SPO2_Fwd1min
from
(
Select CaseId, DT, Min(o2) as minVal

from
(
SELECT        x.Case_ID caseId,  DATEDIFF(second, x.LastUpdate, y.LastUpdate) d, x.LastUpdate as Dt, x.SPO2, y.Case_ID AS Expr1, y.LastUpdate AS Expr2, y.SPO2 AS o2
FROM            (SELECT        Case_ID, LastUpdate, CASE WHEN COALESCE(SPO2, 0 )>100 or COALESCE(SPO2, 0 )<50 THEN 0 ELSE SPO2 END  as SPO2
                          FROM            SPO2 --where SPO2<=100 and SPO2>=50
                        
						  ) AS x LEFT OUTER JOIN
                             (SELECT        Case_ID, LastUpdate, CASE WHEN COALESCE(SPO2, 0 )>100 or COALESCE(SPO2, 0 )<50 THEN 0 ELSE SPO2 END  as SPO2
                               FROM            SPO2 AS SPO2_1
                              
							   ) AS y ON x.Case_ID = y.Case_ID AND (DATEDIFF(second, x.LastUpdate, y.LastUpdate) <= 60 and DATEDIFF(second, x.LastUpdate, y.LastUpdate) >= 0)
							   and x.LastUpdate < y.LastUpdate
GROUP BY x.Case_ID, x.LastUpdate, x.SPO2, y.Case_ID, y.LastUpdate, y.SPO2
--order by  x.LastUpdate, y.LastUpdate
)c  group by CaseId, DT
)z where minVal is not null
order by dt










