--Bwd

select CaseId, DT, minVal
INTO SpO2_HR_Bkwd1min
from
(
Select CaseId, DT, Min(o2) as minVal

from
(

SELECT        x.Case_ID caseId,  DATEDIFF(second, x.DT_SpO2, y.DT_SpO2) d, x.DT_SpO2 as Dt, x.SpO2_HR, y.Case_ID AS Expr1, y.DT_SpO2 AS Expr2, y.SpO2_HR AS o2
FROM            (SELECT        Case_ID, DT_SpO2, 
CASE WHEN COALESCE(HR, 0 )>170 or COALESCE(HR, 0 )<30 THEN 0 ELSE HR END  as SpO2_HR

                          FROM            HR --where SpO2_HR<=100 and SpO2_HR>=50-- and 
                         --WHERE        (Case_ID IN (248127338, 24873759))
						  ) AS x LEFT OUTER JOIN
                             (SELECT        Case_ID, DT_SpO2, CASE WHEN COALESCE(HR, 0 )>170 or COALESCE(HR, 0 )<30 THEN 0 ELSE HR END  as SpO2_HR
                               FROM            HR AS SpO2_HR_1
                              -- WHERE        (Case_ID IN (248127338, 24873759))
							   ) AS y ON x.Case_ID = y.Case_ID AND (DATEDIFF(second, x.DT_SpO2, y.DT_SpO2) >= -60 and DATEDIFF(second, x.DT_SpO2, y.DT_SpO2) <= 0)
							   and x.DT_SpO2 > y.DT_SpO2
GROUP BY x.Case_ID, x.DT_SpO2, x.SpO2_HR, y.Case_ID, y.DT_SpO2, y.SpO2_HR
--order by  x.DT_SpO2, y.DT_SpO2
)c group by CaseId, DT
)z where minVal is not null
order by dt


--fwd

select CaseId, DT, minVal
INTO SpO2_HR_Fwd1min
from
(
Select CaseId, DT, Min(o2) as minVal

from
(
SELECT        x.Case_ID caseId,  DATEDIFF(second, x.DT_SpO2, y.DT_SpO2) d, x.DT_SpO2 as Dt, x.SpO2_HR, y.Case_ID AS Expr1, y.DT_SpO2 AS Expr2, y.SpO2_HR AS o2
FROM            (SELECT        Case_ID, DT_SpO2, CASE WHEN COALESCE(HR, 0 )>170 or COALESCE(HR, 0 )<30 THEN 0 ELSE HR END  as SpO2_HR
                          FROM            HR --where SpO2_HR<=100 and SpO2_HR>=50
                        
						  ) AS x LEFT OUTER JOIN
                             (SELECT        Case_ID, DT_SpO2, CASE WHEN COALESCE(HR, 0 )>170 or COALESCE(HR, 0 )<30 THEN 0 ELSE HR END  as SpO2_HR
                               FROM            HR AS SpO2_HR_1
                               
							   ) AS y ON x.Case_ID = y.Case_ID AND (DATEDIFF(second, x.DT_SpO2, y.DT_SpO2) <= 60 and DATEDIFF(second, x.DT_SpO2, y.DT_SpO2) >= 0)
							   and x.DT_SpO2 < y.DT_SpO2
GROUP BY x.Case_ID, x.DT_SpO2, x.SpO2_HR, y.Case_ID, y.DT_SpO2, y.SpO2_HR
--order by  x.DT_SpO2, y.DT_SpO2
)c group by CaseId, DT
)z where minVal is not null
order by dt
