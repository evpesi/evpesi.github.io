WITH
--CTE
state_min_READM_30_HIP_KNEE AS (
SELECT state, 
       MIN(TRY_TO_DECIMAL(score, 3, 1)) AS Min_READM_30_HIP_KNEE,
       AVG(TRY_TO_DECIMAL(score, 3, 2)) AS Avg_READM_30_HIP_KNEE
  FROM CMS_DB.PROD.CMS_UNPLANNED_HOSPITAL_VISITS
 WHERE MEASURE_ID = 'READM_30_HIP_KNEE' AND IS_DECIMAL(TRY_TO_DECIMAL(score, 3, 1)) = 1
 GROUP BY state
 )

--Query
SELECT c.state, c.facility_id, c.facility_name, s.Min_READM_30_HIP_KNEE, 
       ROUND(s.Min_READM_30_HIP_KNEE - s.Avg_READM_30_HIP_KNEE, 2) AS Diff_from_State_Avg_Pct
  FROM CMS_DB.PROD.CMS_UNPLANNED_HOSPITAL_VISITS c
  JOIN state_min_READM_30_HIP_KNEE s
    ON c.state = s.state AND TRY_TO_DECIMAL(c.score, 3, 1) = s.Min_READM_30_HIP_KNEE
 WHERE c.MEASURE_ID = 'READM_30_HIP_KNEE'
 ORDER BY s.Min_READM_30_HIP_KNEE ASC;