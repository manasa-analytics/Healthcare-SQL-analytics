create database healthcareanalytics;

#Task-1 Write a query to fetch details of all completed appointments, including the patient’s name, doctor’s name, and specialization.
SELECT 
    a.appointment_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Completed';

#Task-2 Retrieve all patients who have never had an appointment. Include their name, contact details, and address in the output.
SELECT
p.patient_id,
p.name as patient_name,
p.contact_number,
p.address
from patients as p
left join appointments as a on p.patient_id=a.patient_id
where appointment_id is null;

#Task-3 Find the total number of diagnoses for each doctor, including doctors who haven’t diagnosed any patients. 
#Display the doctor’s name, specialization, and total diagnoses.
SELECT
do.name as doctorsname,do. doctor_id,
do.specialization,
count(d.diagnosis_id) as totaldiagnosis
from diagnoses as d
right join doctors as do on do.doctor_id=d.doctor_id
group by doctorsname,specialization,doctor_id
order by totaldiagnosis desc;

#Task-4 Write a query to identify mismatches between the appointments and diagnoses tables. 
#Include all appointments and diagnoses with their corresponding patient and doctor details.
SELECT 
    a.appointment_id,
    a.patient_id,
    p.name as patientname,
    a.doctor_id,
    d.name as doctorname,
    a.appointment_date,
    diag.diagnosis_id,
    diag.diagnosis,
    diag.diagnosis_date
FROM appointments a
LEFT JOIN diagnoses diag 
    ON a.patient_id = diag.patient_id and a.doctor_id=diag.doctor_id
LEFT JOIN patients p 
    ON a.patient_id = p.patient_id
LEFT JOIN doctors d 
    ON a.doctor_id = d.doctor_id
WHERE diag.diagnosis_id IS NULL 
    OR a.appointment_date <> diag.diagnosis_date;
    
# Task- 5 For each doctor, rank their patients based on the number of appointments in descending order.
select
a.doctor_id,
d.name as doctorname,
a.patient_id,
p.name as patientname,
count(a.appointment_id) as totalappointments,
rank() over(partition by a.doctor_id order by count(a.appointment_id) desc) as patientrank
from appointments as a 
join patients as p on p.patient_id=a.patient_id
join doctors as d on d.doctor_id=a.doctor_id
group by doctor_id,doctorname,patient_id,patientname
order by doctor_id,patientrank desc;

#Task-6 Write a query to categorize patients by age group (e.g., 18-30, 31-50, 51+). 
#Count the number of patients in each age group.
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 50 THEN '31-50'
        WHEN age >= 51 THEN '51+'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(*) AS patient_count
FROM (
    SELECT patient_id, 
		age
    FROM patients
) as patientage
GROUP BY age_group
ORDER BY age_group;

#Task-7 Retrieve a list of patients whose contact numbers end with "1234" and display their names in uppercase.
select upper(name) as patientname,contact_number
from patients
where contact_number Like '%1234';

 #Task-8 Find patients who have only been prescribed "Insulin" in any of their diagnoses.
SELECT p.patient_id, p.name as patientname,m.medication_name
FROM patients p
JOIN diagnoses d ON p.patient_id = d.patient_id
JOIN medications m ON d.diagnosis_id = m.diagnosis_id
GROUP BY patient_id, patientname,medication_name
HAVING COUNT(DISTINCT m.medication_name) = 1 AND MAX(m.medication_name) = 'Insulin';

#Task-9 Calculate the average duration (in days) for which medications are prescribed for each diagnosis.
select d.diagnosis,avg(datediff (m.start_date, m.end_date)) as avgduration
from diagnoses as d
join medications as m 
on d.diagnosis_id=m.diagnosis_id
WHERE m.end_date IS NOT NULL AND m.start_date IS NOT NULL
group by d.diagnosis
order by avgduration desc;

# Task-10 Write a query to identify the doctor who has attended the most unique patients.
#Include the doctor’s name, specialization, and the count of unique patients.
select d.name as doctorname, d.specialization,d.doctor_id,
count(distinct p.patient_id) as uniquepatientname
from patients as p
join appointments as a on a.patient_id=p.patient_id
join doctors as d on d.doctor_id=a.doctor_id
group by d.doctor_id,doctorname,d.specialization
order by uniquepatientname desc;


