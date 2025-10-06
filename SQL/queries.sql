use [Severity Injury]
select * from severeinjury
select * from Event
select * from Nature
select * from Part
select * from Source

-- Analysis Question: Which types of events cause the most injuries?
-- Purpose: Helps prioritize safety interventions by focusing on the most common injury events.
SELECT e.CASE_CODE_TITLE AS EventType, COUNT(*) AS InjuryCount
FROM severeinjury s
JOIN Event e ON s.Event = e.CASE_CODE
GROUP BY e.CASE_CODE_TITLE
ORDER BY InjuryCount DESC;

-- Analysis Question: Which body parts are most frequently injured?
-- Purpose: Guides protective equipment purchase and ergonomic improvements.
SELECT p.CASE_CODE_TITLE AS BodyPart, COUNT(*) AS InjuryCount
FROM severeinjury s
JOIN Part p ON s.Part_of_Body = p.CASE_CODE
GROUP BY p.CASE_CODE_TITLE
ORDER BY InjuryCount DESC;

-- Analysis Question: What is the most common nature of injuries?
-- Purpose: Helps in medical preparation and first-aid training priorities.
SELECT n.CASE_CODE_TITLE AS NatureOfInjury, COUNT(*) AS InjuryCount
FROM severeinjury s
JOIN Nature n ON s.Nature = n.CASE_CODE
GROUP BY n.CASE_CODE_TITLE
ORDER BY InjuryCount DESC;

-- Analysis Question: How many injuries required hospitalization or resulted in amputations?
-- Purpose: Identifies severe cases to improve workplace safety and insurance planning.
SELECT COUNT(*) AS HospitalizedCount, 
       SUM(CASE WHEN Amputation > 0 THEN 1 ELSE 0 END) AS Amputations
FROM severeinjury
WHERE Hospitalized > 0;


-- Analysis Question: Which employers report the most injuries?
-- Purpose: Helps regulators and safety officers target inspections or audits.
SELECT Employer, COUNT(*) AS InjuryCount
FROM severeinjury
GROUP BY Employer
ORDER BY InjuryCount DESC;

-- Analysis Question: In which locations do most injuries occur?
-- Purpose: Supports resource allocation and local safety campaigns.
SELECT City, State, COUNT(*) AS InjuryCount
FROM severeinjury
GROUP BY City, State
ORDER BY InjuryCount DESC;

-- Analysis Question: Which event types most frequently injure specific body parts?
-- Purpose: To implement targeted protective measures for high-risk tasks.
SELECT e.CASE_CODE_TITLE AS EventType, p.CASE_CODE_TITLE AS BodyPart, COUNT(*) AS CountInjuries
FROM severeinjury s
JOIN Event e ON s.Event = e.CASE_CODE
JOIN Part p ON s.Part_of_Body = p.CASE_CODE
GROUP BY e.CASE_CODE_TITLE, p.CASE_CODE_TITLE
ORDER BY CountInjuries DESC;

-- Analysis Question: What sources (chemicals, machines, persons) cause the most injuries?
-- Purpose: Helps identify high-risk materials or equipment.
SELECT s2.CASE_CODE_TITLE AS SourceTitle, COUNT(*) AS InjuryCount
FROM severeinjury si
JOIN Source s2 ON si.Source = s2.CASE_CODE
GROUP BY s2.CASE_CODE_TITLE
ORDER BY InjuryCount DESC;

-- Analysis Question: How do injuries trend over time, monthly?
-- Purpose: Detect seasonal trends and plan preventive measures accordingly.
SELECT YEAR(EventDate) AS Year, MONTH(EventDate) AS Month, COUNT(*) AS InjuryCount
FROM severeinjury
GROUP BY YEAR(EventDate), MONTH(EventDate)
ORDER BY Year, Month;

-- Analysis Question: How many injuries involve co-workers versus others?
-- Purpose: Informs training programs on team safety and interpersonal risk management.
SELECT SourceTitle, COUNT(*) AS InjuryCount
FROM severeinjury s
JOIN Source src ON s.Source = src.CASE_CODE
GROUP BY SourceTitle
ORDER BY InjuryCount DESC;

-- Analysis Question: Which employers have the highest count of severe injuries?
-- Purpose: Targeting high-risk workplaces for inspections or safety audits.
SELECT TOP 10 Employer, COUNT(*) AS SevereInjuries
FROM severeinjury
WHERE cast(Hospitalized as datetime2) > 0 OR cast(Amputation as float) > 0
GROUP BY Employer
ORDER BY SevereInjuries DESC;

-- Analysis Question: Which events lead to which types of injuries most frequently?
-- Purpose: Helps prioritize interventions based on the event-injury combination.
SELECT e.CASE_CODE_TITLE AS EventType, n.CASE_CODE_TITLE AS InjuryNature, COUNT(*) AS CountInjuries
FROM severeinjury s
JOIN Event e ON s.Event = e.CASE_CODE
JOIN Nature n ON s.Nature = n.CASE_CODE
GROUP BY e.CASE_CODE_TITLE, n.CASE_CODE_TITLE
ORDER BY CountInjuries DESC;

-- Analysis Question: Which body parts are most often involved in injuries requiring hospitalization?
-- Purpose: Enhances protective equipment design and first-aid readiness.
SELECT p.CASE_CODE_TITLE AS BodyPart, COUNT(*) AS HospitalizedCount
FROM severeinjury s
JOIN Part p ON s.Part_of_Body = p.CASE_CODE
WHERE Hospitalized > 0
GROUP BY p.CASE_CODE_TITLE
ORDER BY HospitalizedCount DESC;

-- Analysis Question: Which events are most common per employer?
-- Purpose: Employer-specific safety policies and training plans.
SELECT Employer, e.CASE_CODE_TITLE AS EventType, COUNT(*) AS CountInjuries
FROM severeinjury s
JOIN Event e ON s.Event = e.CASE_CODE
GROUP BY Employer, e.CASE_CODE_TITLE
ORDER BY CountInjuries DESC;

-- Analysis Question: How are injuries distributed by severity?
-- Purpose: Determines resource allocation for safety programs and medical response.
SELECT 
    CASE 
        WHEN Hospitalized > 0 THEN 'Hospitalized' 
        WHEN Amputation > 0 THEN 'Amputation' 
        ELSE 'Non-severe' 
    END AS Severity, 
    COUNT(*) AS Count
FROM severeinjury
GROUP BY 
    CASE 
        WHEN Hospitalized > 0 THEN 'Hospitalized' 
        WHEN Amputation > 0 THEN 'Amputation' 
        ELSE 'Non-severe' 
    END;

-- Analysis Question: How many injuries involve inmates or detainees?
-- Purpose: Identifies risk in correctional facilities for staff training and policy changes.
SELECT COUNT(*) AS InjuryCount
FROM severeinjury s
WHERE Secondary_Source_Title LIKE '%Inmate%' OR Secondary_Source_Title LIKE '%Detainee%';



























