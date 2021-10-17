

----Initialize flags
Update Map set	[isbpFlag(missing)]	=0 ;
Update Map set	[idbpFlag(missing)]	=0 ;
Update Map set	[nsbpFlag(missing)]	=0;
Update Map set	[ndbpFlag(missing)]	=0;
Update Map set	[map_nibpFlag(missing)]	=0 ;
Update Map set	[map_iabpFlag(missing)]	=0 ;
Update  MAP set   [iabpFlagEqual]= 0;
Update  MAP set   [nibpFlagEqual]= 0;
Update  MAP set   MissingNIBP = 0;
Update  MAP set   [MissingIABP]=0;

Update Map set isFirstSBPLessThan60Flag=0;
Update Map set isFirstMAPLessThan40Flag=0;

Update  MAP set   iabpMissingEqualFlag = 0;
Update  MAP set   nsbpMissingEqualFlag = 0; 
Update  MAP set  nISBP = null;
Update  MAP set  nIMAP = null;

--Update Equal
Update  MAP set   [iabpFlagEqual]=  1  FROM [IHPStudy].[dbo].[MAP]  where (isbp = idbp) or ( isbp = map_iabp) or (idbp = map_iabp);
Update  MAP set   [nibpFlagEqual]=  1  FROM [IHPStudy].[dbo].[MAP]  where (nsbp = ndbp) or ( nsbp = map_nibp) or (ndbp = map_nibp);
Update  MAP set   [iabpFlagEqual]=  1  FROM [IHPStudy].[dbo].[MAP]  where (isbp = idbp) or ( isbp = map_iabp) or (idbp = map_iabp);
Update  MAP set   [nibpFlagEqual]=  1  FROM [IHPStudy].[dbo].[MAP]  where (nsbp = ndbp) or ( nsbp = map_nibp) or (ndbp = map_nibp);

--Update Missing
Update Map set	      [isbpFlag(missing)]	=1 where [isbp] is null ;
Update Map set	      [idbpFlag(missing)]	=1 where [idbp] is null ;
Update Map set	      [nsbpFlag(missing)]	=1 where [nsbp] is null ;
Update Map set	      [ndbpFlag(missing)]	=1 where [ndbp] is null ;
Update Map set	      [map_nibpFlag(missing)]	=1 where [map_nibp] is null ;
Update Map set	      [map_iabpFlag(missing)]	=1 where [map_iabp] is null ;

Update  MAP set   MissingNIBP = 1  FROM [IHPStudy].[dbo].[MAP] where [nsbp] is null or [ndbp] is null or [map_nibp] is null;
Update  MAP set   [MissingIABP]= 1  FROM [IHPStudy].[dbo].[MAP] where [isbp] is null or [idbp] is null or [map_iabp] is null;

--Update Equal
Update  MAP set   [iabpFlagEqual]=  1  FROM [IHPStudy].[dbo].[MAP]  where (isbp = idbp) or ( isbp = map_iabp) or (idbp = map_iabp);
Update  MAP set   [nibpFlagEqual]=  1  FROM [IHPStudy].[dbo].[MAP]  where (nsbp = ndbp) or ( nsbp = map_nibp) or (ndbp = map_nibp);
Update  MAP set   [iabpFlagEqual]=  1  FROM [IHPStudy].[dbo].[MAP]  where (isbp = idbp) or ( isbp = map_iabp) or (idbp = map_iabp);
Update  MAP set   [nibpFlagEqual]=  1  FROM [IHPStudy].[dbo].[MAP]  where (nsbp = ndbp) or ( nsbp = map_nibp) or (ndbp = map_nibp);

--Combined Flags
Update  MAP set   iabpMissingEqualFlag = 1 FROM [IHPStudy].[dbo].[MAP]  where   [isbpFlag(missing)]  = 1 or [idbpFlag(missing)]  = 1 or [map_iabpFlag(missing)]=1 or[iabpFlagEqual] = 1;
Update  MAP set   nsbpMissingEqualFlag = 1  FROM [IHPStudy].[dbo].[MAP]  where    [nsbpFlag(missing)]  = 1 or  [ndbpFlag(missing)]  = 1 or  [map_nibpFlag(missing)] = 1 or  [nibpFlagEqual] = 1;

Update  MAP set  nISBP = isbp where iabpMissingEqualFlag=0 and WithinStEndTime=1 ;
Update  MAP set  nIMAP = map_iabp where iabpMissingEqualFlag=0 and WithinStEndTime=1 ;


Update MAP
Set isBeforeFirstSBPMAPFlag40_60=0;

Update MAP
Set isBeforeFirstSBPMAPFlag40_60=1
from
Map m
Inner Join
(Select [caseId],[DT] ,[nISBP],[nIMAP]   
	   from
	   (
SELECT  [caseId] ,[DT],[nISBP],[nIMAP], ROW_NUMBER() OVER(Partition by CaseId ORDER BY Dt asc) AS rn
  FROM (select * from [IHPStudy].[dbo].[MAP] where [WithinStEndTime]=1) map where ([nISBP]>60 and [nISBP]< 200 ) and ( [nIMAP]>40 and [nIMAP]<150)
  ) x where rn=1
  )x
  On m.caseId=x.caseId and m.DT<x.DT

  --Last
  
  
Update MAP
Set isBeforeLastSBPMAPFlag40_60=0;

Update MAP
Set isBeforeLastSBPMAPFlag40_60=1
from
Map m
Inner Join
(Select [caseId]
       ,[DT] ,[nISBP]
     ,[nIMAP]
	   
	   from
	   (
SELECT  [caseId]
       ,[DT]
      
      ,[nISBP]
     ,[nIMAP], 
	 ROW_NUMBER() OVER(Partition by CaseId ORDER BY Dt desc) AS rn
  FROM (select * from [IHPStudy].[dbo].[MAP] where [WithinStEndTime]=1) map where ([nISBP]>60 and [nISBP]< 200 ) and ( [nIMAP]>40 and [nIMAP]<150)
  ) x where rn=1
  )x
  On m.caseId=x.caseId and m.DT>x.DT;

  update map
  set  [nISBP] = null, [nIMAP] = null
  where isBeforeLastSBPMAPFlag40_60=1 or isBeforeFirstSBPMAPFlag40_60=1;

------------------------------------------
--MPOG
------------------------------------------



--where WithinStEndTime=1;
--WHERE NOT  isBeforeLastSBPMAPFlag40_60=1 or isBeforeFirstSBPMAPFlag40_60=1;
--Where iabpMissingEqualFlag=0 and nsbpMissingEqualFlag=0;

--
--------------------
--MPOG
--------------------
--init vars
Update MAP set MPOG_NIMAP=null;
Update MAP set MPOG_NIPP=null;
Update MAP set MPOG_NISYS=null;
Update MAP set MPOG_NIDIAS=null;
Update MAP set MPOG_PP=null;
Update MAP set MPOG_IMAP=null;
Update MAP set MPOG_ISYS=null;
Update MAP set MPOG_IDIAS=null;

Update MAP set MPOG_MAP=null;
Update MAP set MPOG_SBP=null;

--Non-Ivasive
Update MAP set MPOG_NIPP = nsbp-ndbp; -- NIPP=NISys-NIDias;

Update MAP set MPOG_NIMAP=map_nibp where WithinStEndTime=1 and nsbpMissingEqualFlag=0 ;
Update MAP set MPOG_NISYS=nsbp where WithinStEndTime=1 and nsbpMissingEqualFlag=0 ;
Update MAP set MPOG_NIDIAS=ndbp where WithinStEndTime=1 and nsbpMissingEqualFlag=0 ;

Update MAP set MPOG_NIFlag=0;
Update MAP set MPOG_NIFlag=2 where nsbp>150 and (MPOG_NIPP is null OR MPOG_NIPP<30 )--[157]--if NISYS>150 and .<NIPP<30 then NIFlag=2;
Update MAP set MPOG_NIFlag=3 where (nsbp>=100 and nsbp<=150) and (MPOG_NIPP is null OR MPOG_NIPP<15 ) --[564] --if 100<=NISYS<=150 and .<NIPP<15 then NIFlag=3;
Update MAP set MPOG_NIFlag=4 where (nsbp<100) and (MPOG_NIPP is null OR MPOG_NIPP<10 ) --[402] --if .<NISYS<100 and .<NIPP<10 then NIFlag=4;
Update MAP set MPOG_NIFlag=5 where (nsbp>200) and (MPOG_NIPP is null OR MPOG_NIPP<50 ) --[31] --if  NISYS>200 and .<NIPP<50 then NIFlag=5;
Update MAP set MPOG_NIFlag=6 where (nsbp is null OR nsbp<=10) OR (ndbp is null OR ndbp<10 ) --[5385926]--if .<NISYS<=10 or .<NIDIas<=10   then NIFlag=6;
Update MAP set MPOG_NIFlag=7 where (nsbp = ndbp) or ( nsbp = map_nibp) or (ndbp = map_nibp); --[0]--if .<NISYS=NIDIas=NIMAP then NIFlag=7;
Update MAP set MPOG_NIFlag=9 where map_nibp>=140;--[5841]--if 140<=NIMAP then NIFlag=9;

Update MAP set MPOG_NIMAP= null where MPOG_NIFLAG in (2,3,4,5,6,7,9);
Update MAP set MPOG_NISYS= null where MPOG_NIFLAG in (2,3,4,5,6,7,9);
Update MAP set MPOG_NIDIAS= null where MPOG_NIFLAG in (2,3,4,5,6,7,9);

--Invasive
Update MAP set MPOG_PP= isbp-idbp;--PP=Sys-Dias;

Update MAP set MPOG_IMAP=map_iabp where WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0  ;
Update MAP set MPOG_ISYS=isbp where WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0  ;
Update MAP set MPOG_IDIAS=idbp where WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 ;

Update MAP set MPOG_Flag=2 where isbp>150 and (MPOG_PP is null OR MPOG_PP<30 )--[]if SYS>150 and .<PP<30 then Flag=2;
Update MAP set MPOG_Flag=3 where (isbp>=100 and isbp<=150) and (MPOG_PP is null OR MPOG_PP<15 ) --[] --if 100<=SYS<=150 and .<PP<15 then Flag=3;
Update MAP set MPOG_Flag=4 where (isbp<100) and (MPOG_PP is null OR MPOG_PP<10 ) --[] --if .<SYS<100 and .<PP<10 then Flag=4;
Update MAP set MPOG_Flag=5 where (isbp>200) and (MPOG_PP is null OR MPOG_PP<50 ) --[] --if  SYS>200 and .<PP<50 then Flag=5;
Update MAP set MPOG_Flag=6 where (isbp is null OR isbp<=10) OR (idbp is null OR idbp<10 ) --[]--if .<SYS<=10 or .<DIas<=10  then Flag=6;
Update MAP set MPOG_Flag=7 where (isbp = idbp) or ( isbp = map_iabp) or (idbp = map_iabp); --[]--if .<SYS=DIas=MAP then Flag=7;
Update MAP set MPOG_Flag=9 where map_iabp>=140;--[280538]--if 140<=MAP then Flag=9;

Update MAP set MPOG_IMAP=null where MPOG_FLAG in (2,3,4,5,6,7,9);
Update MAP set MPOG_ISYS=null where MPOG_FLAG in (2,3,4,5,6,7,9);
Update MAP set MPOG_IDIAS=null where MPOG_FLAG in (2,3,4,5,6,7,9);

Update MAP set MPOG_MAP = CASE WHEN  COALESCE(MPOG_IMAP, 0) >=COALESCE(MPOG_NIMAP, 0) THEN MPOG_IMAP else MPOG_NIMAP end 
where MPOG_IMAP is not null OR MPOG_NIMAP is not null ;--Pick max
Update MAP set MPOG_SBP = CASE WHEN  COALESCE(MPOG_ISYS, 0) >=COALESCE(MPOG_NISYS, 0) THEN MPOG_ISYS else MPOG_NISYS end where MPOG_ISYS is not null OR MPOG_NISYS is not null;

--identify artifact
Update MAP set [isMPOGArtifactSBP]=1 where MPOG_SBP is null;
Update MAP set [isMPOGArtifactMAP]=1 where MPOG_MAP is null;
Update MAP set [isMPOGArtifactSBP]=0 where [isMPOGArtifactSBP] is null;
Update MAP set [isMPOGArtifactMAP]=0 where [isMPOGArtifactMAP] is null;
---------------------------
--Map Remove Sun et al.
-------------------------
Update Map Set [prevmap]=null, [nxtmap] = null;
Update Map Set  map_GreaterThan50perc_Remove=0;
Update Map Set  map_GreaterThan50perc_Remove=0;

DROP TABLE [dbo].MapNxtPrev;

WITH CTE AS (
  SELECT
    rownum = ROW_NUMBER() over(PARTITION by  CaseID  order by  Dt asc ), CaseID, Dt, [map_iabp] as map FROM Map where WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 
)
SELECT cur.map as c, prev.map as n, nxt.map as p, cur.CaseId, cur.Dt Into MapNxtPrev FROM CTE cur LEFT JOIN CTE prev on prev.rownum = cur.rownum + 1 and prev.CaseId=cur.CaseId LEFT JOIN CTE nxt on nxt.rownum = cur.rownum -1 and nxt.CaseId=cur.CaseId

Update Map Set [prevmap]=b.p, [nxtmap]=b.n From map m Inner Join (Select * from MapNxtPrev)b On m.caseId=b.caseId and m.DT=b.DT;
Update Map Set  map_GreaterThan50perc_Remove=1, map = null From map where  [prevmap] is not null and ((map/([prevmap] + 0.00001))<0.5);-- add 0.00001 to deal with divisin by zero issue
Update Map Set  map_GreaterThan50perc_Remove=1, map = null From map where  [nxtmap] is not null and ((map/([nxtmap] + 0.00001))<0.5);

Update MAP set [isSunEtalArtifactMAP_iabp]=0 where [isSunEtalArtifactMAP_iabp] is null;

----------------------------------
-- SBP Remove Salmasi et al\
-----------------------------------

--====================================================================
-- IABP Fwd-Bwd 1min Salmasi
--=====================================================================
Select caseId, DT, Max(absDiff)as mxDiff , 'backwards' as fb 
INTO SBP_Salmasi_BackForw1min_iabp
from
(
select caseId, DT, abs(isbp1-isbp) as absDiff
from(
SELECT  x.CaseID caseId,  DATEDIFF(second, x.DT, y.DT) d, x.DT as Dt,y.DT as yDT, x.isbp, y.isbp isbp1
FROM 
((SELECT CaseID, DT, isbp  FROM Map WHERE  WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 and isbp is not null)x
LEFT OUTER JOIN
(SELECT CaseID, DT, isbp  FROM Map WHERE WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 and isbp is not null)y
ON x.CaseID = y.CaseID AND (DATEDIFF(second, x.DT, y.DT) >= -60 and DATEDIFF(second, x.DT, y.DT) <= 0) and x.DT >= y.DT)
GROUP BY x.CaseID, x.DT, x.isbp, y.isbp , y.DT
--order by x.dt
)c group by caseId, DT,isbp1, isbp
)z group by caseId, DT

--------------------------------------------

INSERT INTO SBP_Salmasi_BackForw1min_iabp
Select caseId, DT, Max(absDiff)as mxDiff, 'forwards' as fb  from
(
select caseId, DT,  Max(abs(isbp1-isbp)) as absDiff
from(
SELECT  x.CaseID caseId,  DATEDIFF(second, x.DT, y.DT) d, x.DT as Dt,y.DT as yDT, x.isbp, y.isbp isbp1
FROM 
((SELECT CaseID, DT, isbp  FROM Map WHERE WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 and isbp is not null)x
LEFT OUTER JOIN
(SELECT CaseID, DT, isbp  FROM Map WHERE WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 and isbp is not null)y
ON x.CaseID = y.CaseID AND (DATEDIFF(second, x.DT, y.DT) >= 0 and DATEDIFF(second, x.DT, y.DT) <= 60) and x.DT <= y.DT)
GROUP BY x.CaseID, x.DT, x.isbp, y.isbp , y.DT
--order by x.dt
)c group by caseId, DT,isbp1, isbp
)z group by caseId, DT

--====================================================================
-- IABP Fwd-Bwd 2min Salmasi
--=====================================================================
Select caseId, DT, Max(absDiff)as mxDiff, 'backwards' as fb 
INTO SBP_Salmasi_BackForw2min_iabp
from
(
select caseId, DT, abs(isbp1-isbp) as absDiff
from(
SELECT  x.CaseID caseId,  DATEDIFF(second, x.DT, y.DT) d, x.DT as Dt,y.DT as yDT, x.isbp, y.isbp isbp1
FROM 
((SELECT CaseID, DT, isbp  FROM Map WHERE  WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 and isbp is not null)x
LEFT OUTER JOIN
(SELECT CaseID, DT, isbp  FROM Map WHERE WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 and isbp is not null)y
ON x.CaseID = y.CaseID AND (DATEDIFF(second, x.DT, y.DT) >= -60 and DATEDIFF(second, x.DT, y.DT) <= 0) and x.DT >= y.DT)
GROUP BY x.CaseID, x.DT, x.isbp, y.isbp , y.DT
--order by x.dt
)c group by caseId, DT,isbp1, isbp
)z group by caseId, DT

--------------------------------------------

INSERT INTO SBP_Salmasi_BackForw2min_iabp
Select caseId, DT, Max(absDiff)as mxDiff, 'forwards' as fb  from
(
select caseId, DT,  Max(abs(isbp1-isbp)) as absDiff
from(
SELECT  x.CaseID caseId,  DATEDIFF(second, x.DT, y.DT) d, x.DT as Dt,y.DT as yDT, x.isbp, y.isbp isbp1
FROM 
((SELECT CaseID, DT, isbp  FROM Map WHERE WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 and isbp is not null)x
LEFT OUTER JOIN
(SELECT CaseID, DT, isbp  FROM Map WHERE WithinStEndTime=1 and iabpMissingEqualFlag=0 and isBeforeFirstSBPMAPFlag40_60=0 and isBeforeLastSBPMAPFlag40_60=0 and isbp is not null)y
ON x.CaseID = y.CaseID AND (DATEDIFF(second, x.DT, y.DT) >= 0 and DATEDIFF(second, x.DT, y.DT) <= 60) and x.DT <= y.DT)
GROUP BY x.CaseID, x.DT, x.isbp, y.isbp , y.DT
--order by x.dt
)c group by caseId, DT,isbp1, isbp
)z group by caseId, DT

--=====================================================
--Update Map tbl
--=====================================================
Update Map 
set [isSalmasiArtifact_SBP_iabp]=0;

Update Map 
set [isSalmasiArtifact_SBP_iabp]=1
from Map m
Inner Join
(
SELECT  [caseId],[DT]   FROM [IHPStudy].[dbo].[SBP_Salmasi_BackForw1min_iabp] where mxDiff>=80)x
on m.caseId=x.CaseId and m.dt=x.dt;

Update Map 
set [isSalmasiArtifact_SBP_iabp]=1
from Map m
Inner Join
(
SELECT  [caseId],[DT]   FROM [IHPStudy].[dbo].[SBP_Salmasi_BackForw2min_iabp] where mxDiff>=40)x
on m.caseId=x.CaseId and m.dt=x.dt;
----------------------------------------------------------------------------------------





--====================================================================
-- NIBP Fwd-Bwd 1min Salmasi
--=====================================================================
Select caseId, DT, Max(absDiff)as mxDiff , 'backwards' as fb 
INTO SBP_Salmasi_BackForw1min_nibp
from
(
select caseId, DT, abs(nsbp1-nsbp) as absDiff
from(
SELECT  x.CaseID caseId,  DATEDIFF(second, x.DT, y.DT) d, x.DT as Dt,y.DT as yDT, x.nsbp, y.nsbp nsbp1
FROM 
((SELECT CaseID, DT, nsbp  FROM Map WHERE  WithinStEndTime=1 and nsbpMissingEqualFlag=0  and nsbp is not null)x
LEFT OUTER JOIN
(SELECT CaseID, DT, nsbp  FROM Map WHERE WithinStEndTime=1 and nsbpMissingEqualFlag=0  and nsbp is not null)y
ON x.CaseID = y.CaseID AND (DATEDIFF(second, x.DT, y.DT) >= -60 and DATEDIFF(second, x.DT, y.DT) <= 0) and x.DT >= y.DT)
GROUP BY x.CaseID, x.DT, x.nsbp, y.nsbp , y.DT
--order by x.dt
)c group by caseId, DT,nsbp1, nsbp
)z group by caseId, DT

--------------------------------------------

INSERT INTO SBP_Salmasi_BackForw1min_nibp
Select caseId, DT, Max(absDiff)as mxDiff, 'forwards' as fb  from
(
select caseId, DT,  Max(abs(nsbp1-nsbp)) as absDiff
from(
SELECT  x.CaseID caseId,  DATEDIFF(second, x.DT, y.DT) d, x.DT as Dt,y.DT as yDT, x.nsbp, y.nsbp nsbp1
FROM 
((SELECT CaseID, DT, nsbp  FROM Map WHERE WithinStEndTime=1 and nsbpMissingEqualFlag=0  and nsbp is not null)x
LEFT OUTER JOIN
(SELECT CaseID, DT, nsbp  FROM Map WHERE WithinStEndTime=1 and nsbpMissingEqualFlag=0  and nsbp is not null)y
ON x.CaseID = y.CaseID AND (DATEDIFF(second, x.DT, y.DT) >= 0 and DATEDIFF(second, x.DT, y.DT) <= 60) and x.DT <= y.DT)
GROUP BY x.CaseID, x.DT, x.nsbp, y.nsbp , y.DT
--order by x.dt
)c group by caseId, DT,nsbp1, nsbp
)z group by caseId, DT

--====================================================================
-- NIBP Fwd-Bwd 2min Salmasi
--=====================================================================
Select caseId, DT, Max(absDiff)as mxDiff, 'backwards' as fb 
INTO SBP_Salmasi_BackForw2min_nibp
from
(
select caseId, DT, abs(nsbp1-nsbp) as absDiff
from(
SELECT  x.CaseID caseId,  DATEDIFF(second, x.DT, y.DT) d, x.DT as Dt,y.DT as yDT, x.nsbp, y.nsbp nsbp1
FROM 
((SELECT CaseID, DT, nsbp  FROM Map WHERE  WithinStEndTime=1 and nsbpMissingEqualFlag=0  and nsbp is not null)x
LEFT OUTER JOIN
(SELECT CaseID, DT, nsbp  FROM Map WHERE WithinStEndTime=1 and nsbpMissingEqualFlag=0  and nsbp is not null)y
ON x.CaseID = y.CaseID AND (DATEDIFF(second, x.DT, y.DT) >= -120 and DATEDIFF(second, x.DT, y.DT) <= 0) and x.DT >= y.DT)
GROUP BY x.CaseID, x.DT, x.nsbp, y.nsbp , y.DT
--order by x.dt
)c group by caseId, DT,nsbp1, nsbp
)z group by caseId, DT

--------------------------------------------

INSERT INTO SBP_Salmasi_BackForw2min_nibp
Select caseId, DT, Max(absDiff)as mxDiff, 'forwards' as fb  from
(
select caseId, DT,  Max(abs(nsbp1-nsbp)) as absDiff
from(
SELECT  x.CaseID caseId,  DATEDIFF(second, x.DT, y.DT) d, x.DT as Dt,y.DT as yDT, x.nsbp, y.nsbp nsbp1
FROM 
((SELECT CaseID, DT, nsbp  FROM Map WHERE   WithinStEndTime=1 and nsbpMissingEqualFlag=0  and nsbp is not null)x
LEFT OUTER JOIN
(SELECT CaseID, DT, nsbp  FROM Map WHERE   WithinStEndTime=1 and nsbpMissingEqualFlag=0  and nsbp is not null)y
ON x.CaseID = y.CaseID AND (DATEDIFF(second, x.DT, y.DT) >= 0 and DATEDIFF(second, x.DT, y.DT) <= 120) and x.DT <= y.DT)
GROUP BY x.CaseID, x.DT, x.nsbp, y.nsbp , y.DT
--order by x.dt
)c group by caseId, DT,nsbp1, nsbp
)z group by caseId, DT

--=====================================================
--Update Map tbl
--=====================================================
Update Map 
set [isSalmasiArtifact_SBP_nibp]=0;

Update Map 
set [isSalmasiArtifact_SBP_nibp]=1
from Map m
Inner Join
(
SELECT  [caseId],[DT]   FROM [IHPStudy].[dbo].[SBP_Salmasi_BackForw1min_nibp] where mxDiff>=80)x
on m.caseId=x.CaseId and m.dt=x.dt;

Update Map 
set [isSalmasiArtifact_SBP_nibp]=1
from Map m
Inner Join
(
SELECT  [caseId],[DT]   FROM [IHPStudy].[dbo].[SBP_Salmasi_BackForw2min_nibp] where mxDiff>=40)x
on m.caseId=x.CaseId and m.dt=x.dt;
----------------------------------------------------------------------------------------

Update MAP 
set isNIBP_Artifact_Flag_MAP=0, isNIBP_Artifact_Flag_SBP=0, [isIABP_Artifact_Flag_MAP]=0, [isIABP_Artifact_Flag_SBP]=0 ;


Update MAP 
set isNIBP_Artifact_Flag_MAP=1
Where [nsbpMissingEqualFlag]=1 or [WithinStEndTime]=0 or [isMPOGArtifactMAP]=1;

Update MAP 
set isNIBP_Artifact_Flag_SBP=1
Where [nsbpMissingEqualFlag]=1 or [WithinStEndTime]=0 or [isSalmasiArtifact_SBP_nibp]=1 or [isMPOGArtifactSBP]=1;

--iabp
Update MAP 
set [isIABP_Artifact_Flag_MAP]=1
Where [iabpMissingEqualFlag]=1 or [WithinStEndTime]=0 or [isMPOGArtifactMAP]=1 or [isSunEtalArtifactMAP_iabp]=1
or [isBeforeFirstSBPMAPFlag40_60]=1 or [isBeforeLastSBPMAPFlag40_60]=1;


Update MAP 
set [isIABP_Artifact_Flag_SBP]=1
Where [iabpMissingEqualFlag]=1 or [WithinStEndTime]=0 or [isMPOGArtifactSBP]=1 or [isSalmasiArtifact_SBP_iabp]=1
or [isBeforeFirstSBPMAPFlag40_60]=1 or [isBeforeLastSBPMAPFlag40_60]=1;

--================================================================================
-- Final Update sbp
--================================================================================

Update Map set SBP=null, MAP=null;


update Map set SBP= x.sbp
from Map m
Inner Join

(
  select caseId,  dt,
  Case 
  When([isNIBP_Artifact_Flag_SBP]=0 and [isIABP_Artifact_Flag_SBP]=0)  Then  
	Case When nsbp>isbp Then nsbp Else isbp End
  When([isNIBP_Artifact_Flag_SBP]=1 and [isIABP_Artifact_Flag_SBP]=0)  Then 
  isbp
  When([isNIBP_Artifact_Flag_SBP]=0 and [isIABP_Artifact_Flag_SBP]=1) Then 
  nsbp
  End as sbp
  FROM [IHPStudy].[dbo].[MAP] where ([isNIBP_Artifact_Flag_SBP]=0 or [isIABP_Artifact_Flag_SBP]=0) and [WithinStEndTime]=1
 )x
 On m.caseId=x.caseId and m.dt=x.dt
--MAP
update Map set MAP= x.map
from Map m
Inner Join
(
  select caseId,  dt,
  Case 
  When([isNIBP_Artifact_Flag_map]=0 and [isIABP_Artifact_Flag_map]=0)  Then  
	Case When  map_nibp>map_iabp Then  map_nibp Else map_iabp End
  When([isNIBP_Artifact_Flag_map]=1 and [isIABP_Artifact_Flag_map]=0)  Then 
  map_iabp
  When([isNIBP_Artifact_Flag_map]=0 and [isIABP_Artifact_Flag_map]=1) Then 
   map_nibp
  End as map
  FROM [IHPStudy].[dbo].[MAP] where ([isNIBP_Artifact_Flag_map]=0 or [isIABP_Artifact_Flag_map]=0) and [WithinStEndTime]=1
 )x
  On m.caseId=x.caseId and m.dt=x.dt
-------------------------------------------------------------------------------------------------------------------------------

Update MAP 
set 
isNIBP_Artifact_Flag_MAP=0, 
isNIBP_Artifact_Flag_SBP=0, 
[isIABP_Artifact_Flag_MAP]=0, 
[isIABP_Artifact_Flag_SBP]=0 ;


Update MAP 
set isNIBP_Artifact_Flag_MAP=1
Where [nsbpMissingEqualFlag]=1 or [WithinStEndTime]=0 OR MPOG_NIFLAG in (2,3,4,5,6,7,8,9)


Update MAP 
set isNIBP_Artifact_Flag_SBP=1
Where [nsbpMissingEqualFlag]=1 or [WithinStEndTime]=0 or [isSalmasiArtifact_SBP_nibp]=1 OR MPOG_NIFLAG in (2,3,4,5,6,7,8,9)


--iabp
Update MAP 
set [isIABP_Artifact_Flag_MAP]=1
Where [iabpMissingEqualFlag]=1 or [WithinStEndTime]=0 
OR MPOG_FLAG in (2,3,4,5,6,7,8,9) OR
[isSunEtalArtifactMAP_iabp]=1
or [isBeforeFirstSBPMAPFlag40_60]=1 
or [isBeforeLastSBPMAPFlag40_60]=1;


Update MAP 
set [isIABP_Artifact_Flag_SBP]=1
Where [iabpMissingEqualFlag]=1 or [WithinStEndTime]=0 
OR MPOG_FLAG in (2,3,4,5,6,7,8,9) 
or [isSalmasiArtifact_SBP_iabp]=1
or [isBeforeFirstSBPMAPFlag40_60]=1 or [isBeforeLastSBPMAPFlag40_60]=1;


--For IABP MAP and SBP if either are artifact then make both =1 
--[isIABP_Artifact_Flag_MAP]=1 or  [isIABP_Artifact_Flag_SBP]=1 Make Artifact

Update MAP 
set [isIABP_Artifact_Flag_SBP]=1
Where [isIABP_Artifact_Flag_MAP]=1;

Update MAP 
set [isIABP_Artifact_Flag_MAP]=1
Where [isIABP_Artifact_Flag_SBP]=1


--isNIBP_Artifact_Flag_SBP  Or isNIBP_Artifact_Flag_MAP make artifact

Update MAP 
set [isNIBP_Artifact_Flag_SBP]=1
Where [isNIBP_Artifact_Flag_MAP]=1;

Update MAP 
set [isNIBP_Artifact_Flag_MAP]=1
Where [isNIBP_Artifact_Flag_SBP]=1

--================================================================================
-- Final Update sbp
--================================================================================

Update Map set SBP=null, MAP=null;


update Map set SBP= x.sbp
from Map m
Inner Join

(
  select caseId,  dt,
  Case 
  When([isNIBP_Artifact_Flag_SBP]=0 and [isIABP_Artifact_Flag_SBP]=0)  Then  
	Case When nsbp>isbp Then nsbp Else isbp End
  When([isNIBP_Artifact_Flag_SBP]=1 and [isIABP_Artifact_Flag_SBP]=0)  Then 
  isbp
  When([isNIBP_Artifact_Flag_SBP]=0 and [isIABP_Artifact_Flag_SBP]=1) Then 
  nsbp
  End as sbp
  FROM [IHPStudy].[dbo].[MAP] where ([isNIBP_Artifact_Flag_SBP]=0 or [isIABP_Artifact_Flag_SBP]=0) and [WithinStEndTime]=1
 )x
 On m.caseId=x.caseId and m.dt=x.dt
--MAP
update Map set MAP= x.map
from Map m
Inner Join
(
  select caseId,  dt,
  Case 
  When([isNIBP_Artifact_Flag_map]=0 and [isIABP_Artifact_Flag_map]=0)  Then  
	Case When  map_nibp>map_iabp Then  map_nibp Else map_iabp End
  When([isNIBP_Artifact_Flag_map]=1 and [isIABP_Artifact_Flag_map]=0)  Then 
  map_iabp
  When([isNIBP_Artifact_Flag_map]=0 and [isIABP_Artifact_Flag_map]=1) Then 
   map_nibp
  End as map
  FROM [IHPStudy].[dbo].[MAP] where ([isNIBP_Artifact_Flag_map]=0 or [isIABP_Artifact_Flag_map]=0) and [WithinStEndTime]=1
 )x
  On m.caseId=x.caseId and m.dt=x.dt
-------------------------------------------------------------------------------------------------------------------------------



UPDATE Map SET [firstInnvMap] =  b.MAP FROM MAP INNER JOIN   (SELECT m.caseId, m.MAP FROM (SELECT caseId, MIN(DT) AS dt  FROM dbo.MAP   WHERE (MAP IS NOT NULL)  GROUP BY caseId) AS d INNER JOIN  dbo.MAP AS m ON d.caseId = m.caseId AND d.dt = m.DT) b ON  b.CaseId = Map.CaseID 
UPDATE Map SET [firstInnvSBP] =  b.sbp FROM MAP INNER JOIN   (SELECT m.caseId, m.SBP FROM (SELECT caseId, MIN(DT) AS dt  FROM dbo.MAP   WHERE (SBP IS NOT NULL)  GROUP BY caseId) AS d INNER JOIN  dbo.MAP AS m ON d.caseId = m.caseId AND d.dt = m.DT) b ON  b.CaseId = Map.CaseID 


-- MAP and SBP VARS
-----------------------------------------------------------------------
DROP TABLE [dbo].MAP_80
DROP TABLE [dbo].MAP_70 
DROP TABLE [dbo].MAP_65
DROP TABLE [dbo].MAP_60 

SELECT * 
INTO MAP_80 
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT] ,[Map] ,[caseId] as Case_id   FROM [IHPStudy].[dbo].[MAP] where map is not null'
,1.0, 80)

SELECT * 
INTO MAP_70 
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT] ,[Map] ,[caseId] as Case_id   FROM [IHPStudy].[dbo].[MAP] where map is not null'
,1.0, 70)

SELECT * 
INTO MAP_65 
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT] ,[Map] ,[caseId] as Case_id   FROM [IHPStudy].[dbo].[MAP] where map is not null'
,1.0, 65)

SELECT * 
INTO MAP_60
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT] ,[Map] ,[caseId] as Case_id   FROM [IHPStudy].[dbo].[MAP] where map is not null'
,1.0, 60)


DROP TABLE [dbo].SBP_100
DROP TABLE [dbo].SBP_90 
DROP TABLE [dbo].SBP_80



SELECT * 
INTO SBP_100 
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT] ,[SBP] ,[caseId] as Case_id   FROM [IHPStudy].[dbo].[MAP] where sbp is not null'
,10.0, 100)

SELECT * 
INTO SBP_90 
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT] ,[SBP] ,[caseId] as Case_id  FROM [IHPStudy].[dbo].[MAP] where sbp is not null'
,10.0, 90)


SELECT * 
INTO SBP_80
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT] ,[SBP] ,[caseId]as Case_id  FROM [IHPStudy].[dbo].[MAP] where sbp is not null'
,10.0, 80)



