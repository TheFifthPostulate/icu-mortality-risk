CREATE OR REPLACE TABLE `mimic-iv-ext-icumort-1.mimiciv_ext_icumort_1.mimiciv_ext_icu_cohort_1` AS
WITH base AS (
  SELECT
    icu.subject_id,
    icu.hadm_id,
    icu.stay_id,
    icu.intime,
    icu.outtime,
    adm.hospital_expire_flag AS mortality,
    pat.gender,
    pat.anchor_age,
    adm.insurance,
    ROW_NUMBER() OVER (
      PARTITION BY icu.subject_id
      ORDER BY icu.intime
    ) AS rn
  FROM `physionet-data.mimiciv_3_1_icu.icustays` icu
  JOIN `physionet-data.mimiciv_3_1_hosp.admissions` adm
    ON icu.hadm_id = adm.hadm_id
  JOIN `physionet-data.mimiciv_3_1_hosp.patients` pat
    ON icu.subject_id = pat.subject_id
)
SELECT
  subject_id,
  hadm_id,
  stay_id,
  intime,
  outtime,
  mortality,
  gender,
  anchor_age,
  insurance
FROM base
WHERE rn = 1
  AND anchor_age >= 18
  AND TIMESTAMP_DIFF(outtime, intime, HOUR) >= 24;