SELECT        CaseVitalData.Case_ID, CaseVitalData.Sequence, CaseVitalData.LastUpdate, CaseVitalData.Value, Unit.UnitName, CaseVitalDataHeader.VitalData_ID, VitalParameter.VitalParameterName
INTO IHPStudy.dbo.CaseVitalsData
FROM            VitalParameter INNER JOIN
                         VitalData ON VitalParameter.VitalParameter_ID = VitalData.VitalParameter_ID INNER JOIN
                         Unit ON VitalData.Unit_ID = Unit.Unit_ID INNER JOIN
                         CaseVitalDataHeader ON VitalData.VitalData_ID = CaseVitalDataHeader.VitalData_ID AND CaseVitalDataHeader.Unit_ID = Unit.Unit_ID INNER JOIN
                             (SELECT        vd.Case_ID, vd.Sequence, vd.CaseVitalDataHeader_ID, vd.Value, vd.LastUpdate, cd.CaseId
                               FROM            (SELECT        Case_ID, Sequence, CaseVitalDataHeader_ID, Value, LastUpdate
                                                         FROM            CaseVitalData) AS vd INNER JOIN
                                                             (SELECT        CaseId
                                                               FROM            IHPStudy.dbo.CaseData) AS cd ON vd.Case_ID = cd.CaseId) AS CaseVitalData ON CaseVitalDataHeader.Case_ID = CaseVitalData.Case_ID AND 
                         CaseVitalDataHeader.CaseVitalDataHeader_ID = CaseVitalData.CaseVitalDataHeader_ID
WHERE        (CaseVitalDataHeader.VitalData_ID IN (1424, 838, 1165, 1182, 1282, 1287, 1381, 1423, 1615, 1716, 1817, 837, 1164, 1181, 1281, 1286, 1382, 1614, 1717, 1813, 835, 1177, 1180, 1279, 1284, 1408, 1422, 1613, 1816, 1175, 1611, 
                         1526, 1524, 1607, 1424, 719, 733, 741, 749, 757, 765, 773, 781, 1042, 1043, 1044, 1045, 1329, 1332, 1447, 1708, 711, 987, 1304, 1425, 1698, 1805, 823, 841, 851, 861, 871, 881, 891, 901, 1188, 1191, 1194, 1197, 1394, 1395, 
                         1618, 1722, 824, 842, 852, 862, 872, 882, 892, 902, 1187, 1190, 1193, 1196, 1391, 1393, 1619, 1721, 816, 1152, 1153, 1376, 1604, 1715, 1829, 1831, 817, 1150, 1151, 1385, 1605, 1720, 1830, 1832, 719, 733, 741, 749, 757, 765, 
                         773, 781, 1042, 1043, 1044, 1045, 1329, 1332, 1447, 1708, 711, 987, 1304, 1425, 1698, 1805, 823, 841, 851, 861, 871, 881, 891, 901, 1188, 1191, 1194, 1197, 1394, 1395, 1618, 1722, 824, 842, 852, 862, 872, 882, 892, 902, 
                         1187, 1190, 1193, 1196, 1391, 1393, 1619, 1721, 816, 1152, 1153, 1376, 1604, 1715, 1829, 1831, 817, 1150, 1151, 1385, 1605, 1720, 1830, 1832, 1428, 1434))
