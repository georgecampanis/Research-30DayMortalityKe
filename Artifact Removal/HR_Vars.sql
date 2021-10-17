
--Initialize vars
update [IHPStudy].[dbo].[HR]
set [isflag50PercPrev]=0

update [IHPStudy].[dbo].[HR]
set [isArtifact]=0

update [IHPStudy].[dbo].[HR]
set [isflagECGDiff10]=0

update [IHPStudy].[dbo].[HR]
set [isOutOfRange(30-170)]=0;


--Heart rate > 170 or < 30 BPM will be removed. To reduce the influence from outlier artifacts (e.g. temporary disconnection or adjustment of a monitor), single episodes of deviation in any variable greater than 50% above or below the preceding value will be flagged. If the flagged heart rate from the pulse oximeter and ECG (and/or arterial line) differ by >10, the heart rate will be removed as artifact. 
update [IHPStudy].[dbo].[HR]
set [isflagECGDiff10]=1 
where (Abs([HR_ECG] - [HR_SpO2])>10) AND [HR_ECG]is not null ;

update [IHPStudy].[dbo].[HR]
set [isOutOfRange(30-170)]=1 
where ([HR_SpO2]>170 OR [HR_SpO2]<30) OR [HR_SpO2] is null ;


update [IHPStudy].[dbo].[HR]
set [isflag50PercPrev]=1
where ((abs([HR_SpO2]-[prevVal]))/[HR_SpO2])>0.5;


update [IHPStudy].[dbo].[HR]
set [isArtifact]=1
where ([isflag50PercPrev]=1 and [isflagECGDiff10]=1) or ([isOutOfRange(30-170)]=1) or ([WithinStEndTime]=0);


update [IHPStudy].[dbo].[HR]
set HR= null;

update [IHPStudy].[dbo].[HR]
set HR= HR_SpO2 where [isArtifact]=0;




Drop table HR_60;
Drop table HR_100;
Drop table HR_100_Above;


SELECT * 
INTO HR_60
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT_SpO2] ,[HR] ,[case_Id] as Case_id   FROM [IHPStudy].[dbo].[HR] where HR is not null'
,1.0, 60)

SELECT * 
INTO HR_100 
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT_SpO2] ,[HR] ,[case_Id] as Case_id   FROM [IHPStudy].[dbo].[HR] where HR is not null'
,1.0, 100)


SELECT * 
INTO HR_100_Above
FROM  PeriopDMReporting.dbo.CaseVitalsStats(
'SELECT  [DT_SpO2] ,[HR] ,[case_Id] as Case_id   FROM [IHPStudy].[dbo].[HR] where HR is not null'
,101.0, 1000)

