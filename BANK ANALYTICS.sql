CREATE DATABASE Bank_Analytics;
SHOW DATABASES;
SELECT DATABASE();
USE Bank_Analytics;

CREATE TABLE finance_1 (
    id INT PRIMARY KEY,
    member_id INT,
    loan_amnt INT,
    funded_amnt INT,
    funded_amnt_inv INT,
    term VARCHAR(20),
    int_rate DECIMAL(10,4),
    installment DECIMAL(10,2),
    grade VARCHAR(5),
    sub_grade VARCHAR(5),
    emp_title VARCHAR(255),
    emp_length VARCHAR(50),
    home_ownership VARCHAR(50),
    annual_inc DECIMAL(15,2),
    verification_status VARCHAR(50),
    issue_d VARCHAR(20), 
    loan_status VARCHAR(50),
    pymnt_plan VARCHAR(5),
    purpose VARCHAR(100),
    addr_state VARCHAR(10),
    dti DECIMAL(10,2)
);

CREATE TABLE finance_2 (
    id INT PRIMARY KEY,
    delinq_2yrs INT,
    earliest_cr_line DATE,
    inq_last_6mths INT,
    mths_since_last_delinq INT,
    mths_since_last_record INT,
    open_acc INT,
    pub_rec INT,
    revol_bal INT,
    revol_util DECIMAL(10,2),
    total_acc INT,
    initial_list_status VARCHAR(5),
    total_pymnt DECIMAL(15,2),
    total_pymnt_inv DECIMAL(15,2),
    total_rec_prncp DECIMAL(15,2),
    total_rec_int DECIMAL(15,2),
    total_rec_late_fee DECIMAL(15,2),
    recoveries DECIMAL(15,2),
    collection_recovery_fee DECIMAL(15,2),
    last_pymnt_d DATE,
    last_pymnt_amnt DECIMAL(15,2),
    last_credit_pull_d DATE
);

SELECT 
    f1.id, 
    f1.grade, 
    f1.loan_amnt, 
    f2.total_pymnt, 
    f2.revol_bal
FROM finance_1 f1
INNER JOIN finance_2 f2 ON f1.id = f2.id;

SELECT COUNT(*) 
FROM finance_1 f1
INNER JOIN finance_2 f2 ON f1.id = f2.id;

SELECT RIGHT(issue_d, 4) AS loan_year, 
       SUM(loan_amnt) AS total_loan_amnt
FROM finance_1
GROUP BY loan_year
ORDER BY loan_year;

SELECT f1.grade, f1.sub_grade, SUM(f2.revol_bal) AS total_revol_bal
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
GROUP BY f1.grade, f1.sub_grade
ORDER BY f1.grade;

SELECT f1.verification_status, SUM(f2.total_pymnt) AS total_payment
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
GROUP BY f1.verification_status;

CREATE VIEW master_bank_data AS
SELECT f1.*, f2.delinq_2yrs, f2.revol_bal, f2.total_pymnt, f2.last_pymnt_d
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id;
SHOW TABLES;
DESCRIBE  finance_2;

SELECT initial_list_status, 
       SUM(total_pymnt) AS total_payment, 
       SUM(total_rec_int) AS total_interest
FROM finance_2
GROUP BY initial_list_status;

SELECT delinq_2yrs, 
       AVG(last_pymnt_amnt) AS avg_payment
FROM finance_2
GROUP BY delinq_2yrs
ORDER BY delinq_2yrs;

SELECT DATE_FORMAT(last_pymnt_d, '%Y-%m') AS payment_month, 
       SUM(recoveries) AS total_recoveries
FROM finance_2
WHERE last_pymnt_d IS NOT NULL
GROUP BY payment_month
ORDER BY payment_month;

SELECT COUNT(*) FROM finance_2;
SELECT COUNT(*) FROM finance_1;

SELECT f1.id, f1.grade, f2.total_pymnt
FROM finance_1 f1
INNER JOIN finance_2 f2 ON f1.id = f2.id
LIMIT 10;

SELECT SUM(loan_amnt) FROM finance_1;



