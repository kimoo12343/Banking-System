CREATE DATABASE IF NOT EXISTS banking_system;
USE banking_system;

DROP TABLE IF EXISTS LOAN_PAYMENT;
DROP TABLE IF EXISTS LOAN;
DROP TABLE IF EXISTS ACCOUNT_TRANSACTION;
DROP TABLE IF EXISTS ACCOUNT;
DROP TABLE IF EXISTS CLIENT;

CREATE TABLE CLIENT (
    client_id VARCHAR(20) NOT NULL,
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    phone      VARCHAR(20),
    email      VARCHAR(100),
    address    VARCHAR(200),
    date_of_birth DATE,

    CONSTRAINT CLIENT_PK PRIMARY KEY (client_id)
);

CREATE TABLE ACCOUNT (
    account_id VARCHAR(20) NOT NULL,
    account_number VARCHAR(30),
    client_id VARCHAR(20),
    account_type VARCHAR(20),
    balance INT,
    status VARCHAR(20),

    CONSTRAINT ACCOUNT_PK PRIMARY KEY (account_id),
    CONSTRAINT ACCOUNT_CLIENT_FK FOREIGN KEY (client_id)
        REFERENCES CLIENT (client_id)
);

CREATE TABLE ACCOUNT_TRANSACTION (
    txn_id VARCHAR(20) NOT NULL,
    account_id VARCHAR(20),
    txn_type VARCHAR(20),
    amount INT,
    txn_time DATE,
    direction VARCHAR(10),
    description VARCHAR(200),

    CONSTRAINT ACCOUNT_TRANSACTION_PK PRIMARY KEY (txn_id),
    CONSTRAINT ACCOUNT_TRANSACTION_ACCOUNT_FK FOREIGN KEY (account_id)
        REFERENCES ACCOUNT (account_id)
);

CREATE TABLE LOAN (
    loan_id VARCHAR(20) NOT NULL,
    client_id VARCHAR(20),
    amount INT,
    interest_rate INT,
    start_date DATE,
    term_months INT,

    CONSTRAINT LOAN_PK PRIMARY KEY (loan_id),
    CONSTRAINT LOAN_CLIENT_FK FOREIGN KEY (client_id)
        REFERENCES CLIENT (client_id)
);

CREATE TABLE LOAN_PAYMENT (
    payment_id VARCHAR(20) NOT NULL,
    loan_id VARCHAR(20),
    amount INT,
    paid_at DATE,
    method VARCHAR(20),

    CONSTRAINT LOAN_PAYMENT_PK PRIMARY KEY (payment_id),
    CONSTRAINT LOAN_PAYMENT_LOAN_FK FOREIGN KEY (loan_id)
        REFERENCES LOAN (loan_id)
);

-- inserting
INSERT INTO CLIENT
VALUES ('C001', 'Ahmed', 'Hassan', '01012345678',
        'ahmed@gmail.com', 'Cairo', '1999-05-10');
INSERT INTO ACCOUNT
VALUES ('A001', 'ACC1001', 'C001', 'SAVINGS', 5000, 'ACTIVE');

INSERT INTO ACCOUNT_TRANSACTION
VALUES ('T001', 'A001', 'DEPOSIT', 2000, '2024-05-01',
        'CREDIT', 'Initial deposit');
        INSERT INTO CLIENT
VALUES ('C010', 'Ali', 'Hassan', '01011111111',
        'ali@gmail.com', 'Cairo', '2000-01-01');

INSERT INTO ACCOUNT
VALUES ('A010', 'ACC2010', 'C010', 'CURRENT', 3000, 'ACTIVE');

INSERT INTO LOAN
VALUES ('L001', 'C001', 10000, 5, '2024-06-01', 24);

INSERT INTO LOAN_PAYMENT
VALUES ('P001', 'L001', 1500, '2024-07-01', 'CASH');

INSERT INTO ACCOUNT_TRANSACTION
VALUES ('T010', 'A010', 'DEPOSIT', 1000, '2024-05-01',
        'CREDIT', 'Deposit');

INSERT INTO ACCOUNT_TRANSACTION
VALUES ('T011', 'A010', 'WITHDRAWAL', 500, '2024-05-02',
        'DEBIT', 'ATM');
        
        INSERT INTO CLIENT
VALUES ('C020', 'Mona', 'Ali', '01123456789',
        'mona@gmail.com', 'Giza', '2001-02-15');

INSERT INTO ACCOUNT
VALUES ('A020', 'ACC2020', 'C020', 'SAVINGS', 7000, 'ACTIVE');

INSERT INTO LOAN
VALUES ('L010', 'C010', 15000, 6, '2024-06-10', 36);

INSERT INTO LOAN
VALUES ('L020', 'C020', 8000, 4, '2024-06-15', 18);

INSERT INTO LOAN_PAYMENT
VALUES ('P010', 'L010', 2000, '2024-07-05', 'CARD');

INSERT INTO LOAN_PAYMENT
VALUES ('P020', 'L020', 1000, '2024-07-10', 'CASH');


-- queries (5 groups of 10 DML queries Total:50)

-- Group 1 :

-- (1) Purpose: Retrieve all clients
SELECT * FROM CLIENT;

-- (2) Purpose: Retrieve all accounts
SELECT * FROM ACCOUNT;

-- (3) Purpose: Retrieve all transactions
SELECT * FROM ACCOUNT_TRANSACTION;

-- (4) Purpose: Show clients with their accounts
SELECT c.client_id, c.first_name, a.account_id, a.balance
FROM CLIENT c
JOIN ACCOUNT a ON c.client_id = a.client_id;

-- (5) Purpose: Show client transactions
SELECT c.first_name, t.txn_type, t.amount
FROM CLIENT c
JOIN ACCOUNT a ON c.client_id = a.client_id
JOIN ACCOUNT_TRANSACTION t ON a.account_id = t.account_id;

-- (6) Purpose: Calculate total balance per client
SELECT c.client_id, SUM(a.balance) AS total_balance
FROM CLIENT c
JOIN ACCOUNT a ON c.client_id = a.client_id
GROUP BY c.client_id;

-- (7) Purpose: Count transactions per account
SELECT account_id, COUNT(*) AS transaction_count
FROM ACCOUNT_TRANSACTION
GROUP BY account_id;

-- (8) Purpose: Find clients with more than one account
SELECT client_id
FROM ACCOUNT
GROUP BY client_id
HAVING COUNT(account_id) > 1;

-- (9) Purpose: Calculate total transaction amount per account
SELECT account_id, SUM(amount) AS total_amount
FROM ACCOUNT_TRANSACTION
GROUP BY account_id;

-- (10) Purpose: Calculate average transaction amount per account
SELECT account_id, AVG(amount) AS avg_amount
FROM ACCOUNT_TRANSACTION
GROUP BY account_id;


-- Group 2 :

-- (1) Purpose: Retrieve all loans
SELECT * FROM LOAN;

-- (2) Purpose: Retrieve all loan payments
SELECT * FROM LOAN_PAYMENT;

-- (3) Purpose: Retrieve all savings accounts
SELECT * FROM ACCOUNT
WHERE account_type = 'SAVINGS';

-- (4) Purpose: Show loans with client names
SELECT c.first_name, c.last_name, l.loan_id, l.amount
FROM CLIENT c
JOIN LOAN l ON c.client_id = l.client_id;

-- (5) Purpose: Calculate total loan amount per client
SELECT client_id, SUM(amount) AS total_loan
FROM LOAN
GROUP BY client_id;

-- (6) Purpose: Find clients with total loans above 9000
SELECT client_id
FROM LOAN
GROUP BY client_id
HAVING SUM(amount) > 9000;

-- (7) Purpose: Show loan payments with loan details
SELECT l.loan_id, p.amount, p.paid_at
FROM LOAN l
JOIN LOAN_PAYMENT p ON l.loan_id = p.loan_id;

-- (8) Purpose: Calculate total payments per loan
SELECT loan_id, SUM(amount) AS total_paid
FROM LOAN_PAYMENT
GROUP BY loan_id;

-- (9) Purpose: Count number of payments per loan
SELECT loan_id, COUNT(payment_id) AS payment_count
FROM LOAN_PAYMENT
GROUP BY loan_id;

-- (10) Purpose: Show loans that have payments
SELECT DISTINCT l.loan_id
FROM LOAN l
JOIN LOAN_PAYMENT p ON l.loan_id = p.loan_id;


-- Group 3 :


-- (1) Purpose: Retrieve all current accounts
SELECT * FROM ACCOUNT
WHERE account_type = 'CURRENT';

-- (2) Purpose: Retrieve accounts with balance greater than 4000
SELECT * FROM ACCOUNT
WHERE balance > 4000;

-- (3) Purpose: Retrieve all clients living in Cairo
SELECT * FROM CLIENT
WHERE address = 'Cairo';

-- (4) Purpose: Show clients and their account types
SELECT c.first_name, a.account_type
FROM CLIENT c
JOIN ACCOUNT a ON c.client_id = a.client_id;

-- (5) Purpose: Count number of accounts per client
SELECT client_id, COUNT(account_id) AS account_count
FROM ACCOUNT
GROUP BY client_id;

-- (6) Purpose: Calculate total balance per client
SELECT client_id, SUM(balance) AS total_balance
FROM ACCOUNT
GROUP BY client_id;

-- (7) Purpose: Find clients with total balance over 6000
SELECT client_id
FROM ACCOUNT
GROUP BY client_id
HAVING SUM(balance) > 6000;

-- (8) Purpose: Show accounts and their transactions
SELECT a.account_id, t.txn_type, t.amount
FROM ACCOUNT a
JOIN ACCOUNT_TRANSACTION t ON a.account_id = t.account_id;

-- (9) Purpose: Count deposits per account
SELECT account_id, COUNT(*) AS deposit_count
FROM ACCOUNT_TRANSACTION
WHERE txn_type = 'DEPOSIT'
GROUP BY account_id;

-- (10) Purpose: Sum withdrawals per account
SELECT account_id, SUM(amount) AS withdrawal_total
FROM ACCOUNT_TRANSACTION
WHERE txn_type = 'WITHDRAWAL'
GROUP BY account_id;


-- Group 4 :


-- (1) Purpose: Retrieve all transactions after a specific date
SELECT * FROM ACCOUNT_TRANSACTION
WHERE txn_time > '2024-05-01';

-- (2) Purpose: Retrieve all accounts with ACTIVE status
SELECT * FROM ACCOUNT
WHERE status = 'ACTIVE';

-- (3) Purpose: Retrieve all clients
SELECT * FROM CLIENT;

-- (4) Purpose: Show accounts and transaction count
SELECT a.account_id, COUNT(t.txn_id) AS txn_count
FROM ACCOUNT a
JOIN ACCOUNT_TRANSACTION t ON a.account_id = t.account_id
GROUP BY a.account_id;

-- (5) Purpose: Calculate total transaction amount per account
SELECT account_id, SUM(amount) AS total_amount
FROM ACCOUNT_TRANSACTION
GROUP BY account_id;

-- (6) Purpose: Calculate average transaction amount per account
SELECT account_id, AVG(amount) AS avg_amount
FROM ACCOUNT_TRANSACTION
GROUP BY account_id;

-- (7) Purpose: Show transaction types per account
SELECT a.account_id, t.txn_type
FROM ACCOUNT a
JOIN ACCOUNT_TRANSACTION t ON a.account_id = t.account_id;

-- (8) Purpose: Count withdrawals per account
SELECT account_id, COUNT(*) AS withdrawal_count
FROM ACCOUNT_TRANSACTION
WHERE txn_type = 'WITHDRAWAL'
GROUP BY account_id;

-- (9) Purpose: Count adjustments per account
SELECT account_id, COUNT(*) AS adjustment_count
FROM ACCOUNT_TRANSACTION
WHERE txn_type = 'ADJUSTMENT'
GROUP BY account_id;

-- (10) Purpose: Show accounts that have transactions
SELECT DISTINCT a.account_id
FROM ACCOUNT a
JOIN ACCOUNT_TRANSACTION t ON a.account_id = t.account_id;


-- Group 5 :


-- (1) Purpose: Retrieve all loan payments
SELECT * FROM LOAN_PAYMENT;

-- (2) Purpose: Retrieve all loans for a specific client
SELECT * FROM LOAN
WHERE client_id = 'C001';

-- (3) Purpose: Retrieve all accounts
SELECT * FROM ACCOUNT;

-- (4) Purpose: Show clients who have both loans and accounts
SELECT DISTINCT c.client_id
FROM CLIENT c
JOIN ACCOUNT a ON c.client_id = a.client_id
JOIN LOAN l ON c.client_id = l.client_id;

-- (5) Purpose: Show total loans and total payments per client
SELECT c.client_id,
       SUM(l.amount) AS total_loans,
       SUM(p.amount) AS total_paid
FROM CLIENT c
JOIN LOAN l ON c.client_id = l.client_id
JOIN LOAN_PAYMENT p ON l.loan_id = p.loan_id
GROUP BY c.client_id;

-- (6) Purpose: Show clients who made loan payments
SELECT DISTINCT c.client_id
FROM CLIENT c
JOIN LOAN l ON c.client_id = l.client_id
JOIN LOAN_PAYMENT p ON l.loan_id = p.loan_id;

-- (7) Purpose: Count number of loans per client
SELECT client_id, COUNT(loan_id) AS loan_count
FROM LOAN
GROUP BY client_id;

-- (8) Purpose: Count number of payments per client
SELECT c.client_id, COUNT(p.payment_id) AS payment_count
FROM CLIENT c
JOIN LOAN l ON c.client_id = l.client_id
JOIN LOAN_PAYMENT p ON l.loan_id = p.loan_id
GROUP BY c.client_id;

-- (9) Purpose: Find clients with more than one loan
SELECT client_id
FROM LOAN
GROUP BY client_id
HAVING COUNT(loan_id) > 1;

-- (10) Purpose: Calculate average loan amount
SELECT AVG(amount) AS avg_loan_amount
FROM LOAN; 