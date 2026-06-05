-- ============================================================
-- RBI AGENTIC AI HACKATHON 2026
-- SQL SETUP: Table Creation + Dummy Data Insertion
-- Order: bank_entities → rbi_circulars_registry → npa_accounts
--        → bank_inspection_reports → penalty_orders
--        → digital_payment_metrics → fraud_reports
-- ============================================================

-- ============================================================
-- STEP 1: CREATE DATABASE
-- ============================================================
CREATE DATABASE rbi_supervision_db;
\c rbi_supervision_db;

-- ============================================================
-- TABLE 1: bank_entities (Master — seed first)
-- ============================================================
CREATE TABLE bank_entities (
    bank_id             VARCHAR(10)     PRIMARY KEY,
    bank_name           VARCHAR(100)    NOT NULL,
    bank_type           VARCHAR(10)     NOT NULL CHECK (bank_type IN ('PSB','PVT','UCB','NBFC','RRB')),
    hq_city             VARCHAR(50)     NOT NULL,
    total_assets_cr     DECIMAL(14,2)   NOT NULL,
    license_status      VARCHAR(15)     NOT NULL CHECK (license_status IN ('ACTIVE','WATCH','SUSPENDED')),
    rbi_zone            VARCHAR(10)     NOT NULL CHECK (rbi_zone IN ('North','South','East','West','Central')),
    registered_on       DATE            NOT NULL,
    ceo_name            VARCHAR(100),
    capital_adequacy_pct DECIMAL(5,2),
    gross_npa_pct       DECIMAL(5,2),
    net_npa_pct         DECIMAL(5,2),
    created_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO bank_entities VALUES
('BNK-001','State Bank of India',       'PSB', 'Mumbai',   5800000.00,'ACTIVE',   'West',   '1955-07-01','Dinesh Kumar Khara',   16.28, 2.42, 0.62, DEFAULT),
('BNK-002','Punjab National Bank',      'PSB', 'New Delhi',1450000.00,'ACTIVE',   'North',  '1895-04-12','Atul Kumar Goel',      15.46, 7.73, 1.98, DEFAULT),
('BNK-003','Bank of Baroda',            'PSB', 'Vadodara', 1280000.00,'ACTIVE',   'West',   '1908-07-20','Debadatta Chand',      16.24, 3.79, 0.89, DEFAULT),
('BNK-004','HDFC Bank',                 'PVT', 'Mumbai',   2800000.00,'ACTIVE',   'West',   '1994-08-30','Sashidhar Jagdishan',  18.80, 1.26, 0.31, DEFAULT),
('BNK-005','ICICI Bank',                'PVT', 'Mumbai',   2100000.00,'ACTIVE',   'West',   '1994-01-05','Sandeep Bakhshi',      17.60, 2.30, 0.48, DEFAULT),
('BNK-006','Axis Bank',                 'PVT', 'Mumbai',    980000.00,'ACTIVE',   'West',   '1993-12-03','Amitabh Chaudhry',     17.53, 1.58, 0.34, DEFAULT),
('BNK-007','Kotak Mahindra Bank',       'PVT', 'Mumbai',    720000.00,'ACTIVE',   'West',   '2003-02-22','Ashok Vaswani',        21.80, 1.73, 0.37, DEFAULT),
('BNK-008','Yes Bank',                  'PVT', 'Mumbai',    380000.00,'WATCH',    'West',   '2004-11-21','Prashant Kumar',       17.90, 1.70, 0.48, DEFAULT),
('BNK-009','Punjab & Maharashtra UCB',  'UCB', 'Mumbai',    12000.00, 'SUSPENDED','West',   '1984-02-13','Administrator RBI',    NULL,  21.40, 8.90, DEFAULT),
('BNK-010','Deccan Urban Co-op Bank',   'UCB', 'Pune',       8500.00, 'WATCH',    'West',   '1991-06-15','Ramesh Kulkarni',      9.20,  18.30, 7.40, DEFAULT),
('BNK-011','Muthoot Finance',           'NBFC','Kochi',     120000.00,'ACTIVE',   'South',  '1997-03-18','George Alexander',     26.40, 1.20, 0.70, DEFAULT),
('BNK-012','Bajaj Finance',             'NBFC','Pune',      340000.00,'ACTIVE',   'West',   '2007-07-01','Rajeev Jain',          24.00, 1.06, 0.41, DEFAULT),
('BNK-013','Canara Bank',               'PSB', 'Bengaluru',  980000.00,'ACTIVE',  'South',  '1906-07-01','K Satyanarayana Raju', 16.68, 4.23, 1.27, DEFAULT),
('BNK-014','Union Bank of India',       'PSB', 'Mumbai',    980000.00,'ACTIVE',   'West',   '1919-11-11','A Manimekhalai',       16.00, 4.76, 1.03, DEFAULT),
('BNK-015','IndusInd Bank',             'PVT', 'Pune',      420000.00,'WATCH',    'West',   '1994-04-01','Sumant Kathpalia',     15.20, 2.10, 0.60, DEFAULT);


-- ============================================================
-- TABLE 2: rbi_circulars_registry (seed second — no dependencies)
-- ============================================================
CREATE TABLE rbi_circulars_registry (
    circular_ref        VARCHAR(30)     PRIMARY KEY,
    circular_title      VARCHAR(300)    NOT NULL,
    issued_date         DATE            NOT NULL,
    issuing_dept        VARCHAR(80)     NOT NULL,
    subject             VARCHAR(300)    NOT NULL,
    applicable_to       VARCHAR(100),
    vector_doc_id       VARCHAR(50)
);

INSERT INTO rbi_circulars_registry VALUES
('RBI/2023-24/53',  'Prudential Norms on Income Recognition, Asset Classification and Provisioning',
 '2023-09-12', 'Department of Regulation',
 'IRACP norms — NPA classification, provisioning requirements, upgrade conditions',
 'All Scheduled Commercial Banks', 'RBI_IRACP_2023'),

('RBI/2023-24/85',  'Master Direction on Frauds — Classification and Reporting by Commercial Banks',
 '2023-11-07', 'Department of Supervision',
 'Fraud classification types, FMRS reporting timelines, SARFAESI applicability, wilful defaulter norms',
 'All Commercial Banks and UCBs', 'RBI_FRAUD_MD_2024'),

('RBI/2022-23/178', 'Guidelines on Digital Lending',
 '2022-09-02', 'Department of Regulation',
 'Digital lending apps, LSP regulations, disbursement norms, cooling-off period',
 'All Banks and NBFCs', 'RBI_DIGITAL_LENDING_2022'),

('RBI/2024-25/12',  'Cyber Security Framework for Banks',
 '2024-04-15', 'Department of Information Technology',
 'IT risk, cyber incident reporting, SOC requirements, third-party risk management',
 'All Scheduled Commercial Banks', 'RBI_CYBER_2024'),

('RBI/2023-24/101', 'Master Direction on KYC',
 '2024-01-04', 'Department of Regulation',
 'Customer due diligence, beneficial ownership, PEP identification, re-KYC norms',
 'All Regulated Entities', 'RBI_KYC_MD_2024'),

('RBI/2024-25/45',  'Basel III Capital Regulations — Revised Framework',
 '2024-07-22', 'Department of Regulation',
 'CET1, Tier 1, Tier 2 capital requirements, capital conservation buffer, CRAR computation',
 'All Scheduled Commercial Banks', 'BASEL3_CAPITAL_2024'),

('RBI/2023-24/67',  'Supervisory Framework for UCBs — Revised CAMELS',
 '2023-10-19', 'Department of Supervision',
 'Revised CAMELS rating methodology for Urban Co-operative Banks, PCA framework for UCBs',
 'All Urban Co-operative Banks', 'RBI_UCB_CAMELS_2023'),

('RBI/2024-25/28',  'UPI — Interoperability and Transaction Limit Framework',
 '2024-05-30', 'Department of Payment and Settlement Systems',
 'UPI transaction limits, interoperability mandate, failed transaction resolution TAT',
 'All Banks and Payment System Operators', 'RBI_UPI_2024');


-- ============================================================
-- TABLE 3: npa_accounts (depends on bank_entities)
-- ============================================================
CREATE TABLE npa_accounts (
    account_id              VARCHAR(15)     PRIMARY KEY,
    bank_id                 VARCHAR(10)     NOT NULL REFERENCES bank_entities(bank_id),
    borrower_name           VARCHAR(100)    NOT NULL,
    borrower_type           VARCHAR(15)     NOT NULL CHECK (borrower_type IN ('INDIVIDUAL','MSME','CORPORATE','AGRI')),
    loan_type               VARCHAR(20)     NOT NULL CHECK (loan_type IN ('HOME','AGRI','CORPORATE','MSME','PERSONAL','VEHICLE')),
    sanctioned_amt_cr       DECIMAL(10,2)   NOT NULL,
    outstanding_amt_cr      DECIMAL(10,2)   NOT NULL,
    dpd                     INTEGER         NOT NULL CHECK (dpd > 90),
    npa_category            VARCHAR(15)     NOT NULL CHECK (npa_category IN ('SUB_STANDARD','DOUBTFUL_1','DOUBTFUL_2','LOSS')),
    classification_date     DATE            NOT NULL,
    provisioning_pct        DECIMAL(5,2)    NOT NULL,
    city                    VARCHAR(50)     NOT NULL,
    sector                  VARCHAR(40)     NOT NULL,
    collateral_type         VARCHAR(30),
    collateral_value_cr     DECIMAL(10,2),
    account_open_date       DATE,
    last_payment_date       DATE,
    created_at              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO npa_accounts VALUES
-- BNK-001 SBI NPA Accounts (INFRASTRUCTURE / REAL_ESTATE — large tickets)
('NPA-SBI-001','BNK-001','Jaypee Infratech Ltd',          'CORPORATE','CORPORATE',480.00,412.50, 547,'DOUBTFUL_2', '2022-03-31',40.00,'Noida',       'INFRASTRUCTURE','Land + Project',380.00,'2016-04-01','2022-01-15',DEFAULT),
('NPA-SBI-002','BNK-001','Lanco Infratech Ltd',           'CORPORATE','CORPORATE',320.00,298.40, 820,'LOSS',       '2021-06-30',100.00,'Hyderabad',  'INFRASTRUCTURE','Plant & Machinery',180.00,'2014-07-01','2020-08-20',DEFAULT),
('NPA-SBI-003','BNK-001','Amtek Auto Ltd',                'CORPORATE','CORPORATE',210.00,195.80, 430,'DOUBTFUL_1', '2022-09-30',25.00,'Gurgaon',     'MANUFACTURING', 'Factory Assets',140.00,'2015-03-15','2021-06-10',DEFAULT),
('NPA-SBI-004','BNK-001','Sunrise Realty Pvt Ltd',        'CORPORATE','CORPORATE',85.00, 79.20,  210,'SUB_STANDARD','2023-06-30',15.00,'Mumbai',      'REAL_ESTATE',   'Commercial Property',95.00,'2020-01-10','2023-01-05',DEFAULT),
('NPA-SBI-005','BNK-001','Sharma Textile Mills',          'MSME',     'MSME',     12.50, 11.80,  145,'SUB_STANDARD','2023-03-31',15.00,'Surat',       'TEXTILE',       'Plant',8.00,'2019-06-01','2022-11-20',DEFAULT),
('NPA-SBI-006','BNK-001','Kiran Agro Industries',         'MSME',     'MSME',     8.40,  7.90,   180,'SUB_STANDARD','2023-03-31',15.00,'Nashik',      'AGRI',          'Warehouse',5.00,'2018-09-01','2022-09-30',DEFAULT),
('NPA-SBI-007','BNK-001','Rajesh Kumar Sharma',           'INDIVIDUAL','HOME',    0.85,  0.78,   112,'SUB_STANDARD','2023-06-30',15.00,'Mumbai',      'RETAIL',        'Residential Property',1.20,'2019-11-15','2023-03-01',DEFAULT),
('NPA-SBI-008','BNK-001','Priya Constructions Pvt Ltd',   'CORPORATE','CORPORATE',150.00,138.90, 365,'DOUBTFUL_1', '2022-09-30',25.00,'Pune',        'REAL_ESTATE',   'Land',120.00,'2017-08-01','2021-09-20',DEFAULT),

-- BNK-002 PNB NPA Accounts (NPA stories — fraud linked)
('NPA-PNB-001','BNK-002','Era Infra Engineering Ltd',     'CORPORATE','CORPORATE',380.00,356.20, 910,'LOSS',       '2020-12-31',100.00,'New Delhi',  'INFRASTRUCTURE','Project Assets',200.00,'2013-05-01','2019-12-10',DEFAULT),
('NPA-PNB-002','BNK-002','Bhushan Steel Ltd',             'CORPORATE','CORPORATE',440.00,398.60,1200,'LOSS',       '2020-06-30',100.00,'New Delhi',  'STEEL',         'Plant & Machinery',320.00,'2012-01-01','2019-06-01',DEFAULT),
('NPA-PNB-003','BNK-002','Zoom Developers Pvt Ltd',       'CORPORATE','CORPORATE',95.00, 88.40,  275,'SUB_STANDARD','2023-03-31',15.00,'Chandigarh', 'REAL_ESTATE',   'Commercial Property',75.00,'2019-03-01','2022-07-15',DEFAULT),
('NPA-PNB-004','BNK-002','Singh Packaging Pvt Ltd',       'MSME',     'MSME',     14.80, 13.90,  165,'SUB_STANDARD','2023-06-30',15.00,'Ludhiana',   'MANUFACTURING', 'Plant',10.00,'2018-07-01','2022-12-01',DEFAULT),
('NPA-PNB-005','BNK-002','Videocon Industries Ltd',       'CORPORATE','CORPORATE',520.00,489.80,1460,'LOSS',       '2019-12-31',100.00,'Mumbai',     'ELECTRONICS',   'Factory',380.00,'2010-06-01','2018-06-01',DEFAULT),
('NPA-PNB-006','BNK-002','Harpreet Singh',                'INDIVIDUAL','HOME',    0.65,  0.61,   98, 'SUB_STANDARD','2023-09-30',15.00,'Amritsar',   'RETAIL',        'Residential Property',0.80,'2021-02-01','2023-07-01',DEFAULT),
('NPA-PNB-007','BNK-002','Patel Construction Co',         'MSME',     'MSME',     18.50, 17.20,  240,'SUB_STANDARD','2023-03-31',15.00,'Ahmedabad',  'CONSTRUCTION',  'Equipment',12.00,'2019-01-15','2022-07-10',DEFAULT),
('NPA-PNB-008','BNK-002','North Star Power Ltd',          'CORPORATE','CORPORATE',280.00,261.40, 730,'DOUBTFUL_2', '2021-09-30',40.00,'Delhi',      'INFRASTRUCTURE','Power Assets',200.00,'2015-02-01','2021-03-01',DEFAULT),
('NPA-PNB-009','BNK-002','Reddy Agro Industries',         'MSME',     'AGRI',     6.20,  5.80,   130,'SUB_STANDARD','2023-06-30',15.00,'Hyderabad',  'AGRI',          'Farm Equipment',4.00,'2020-04-01','2023-02-10',DEFAULT),
('NPA-PNB-010','BNK-002','Sunrise Hotels Pvt Ltd',        'CORPORATE','CORPORATE',45.00, 41.80,  310,'DOUBTFUL_1', '2022-06-30',25.00,'Shimla',     'HOSPITALITY',   'Hotel Property',55.00,'2017-10-01','2021-08-15',DEFAULT),

-- BNK-008 YES BANK (WATCH — mixed portfolio)
('NPA-YES-001','BNK-008','Reliance ADAG Power Ltd',       'CORPORATE','CORPORATE',210.00,198.40, 420,'DOUBTFUL_1', '2022-09-30',25.00,'Mumbai',     'INFRASTRUCTURE','Power Plant',150.00,'2015-04-01','2021-09-10',DEFAULT),
('NPA-YES-002','BNK-008','Cafe Coffee Day Enterprises',   'CORPORATE','CORPORATE',280.00,261.50, 548,'DOUBTFUL_2', '2022-03-31',40.00,'Bengaluru',  'FOOD_BEVERAGE', 'Brand + Assets',120.00,'2016-08-01','2021-03-20',DEFAULT),
('NPA-YES-003','BNK-008','Radius Developers Pvt Ltd',     'CORPORATE','CORPORATE',120.00,112.80, 185,'SUB_STANDARD','2023-03-31',15.00,'Mumbai',     'REAL_ESTATE',   'Land',130.00,'2019-07-01','2022-09-15',DEFAULT),
('NPA-YES-004','BNK-008','Sai Prakash Enterprises',       'MSME',     'MSME',     9.80,  9.10,   140,'SUB_STANDARD','2023-06-30',15.00,'Pune',       'MANUFACTURING', 'Plant',6.50,'2019-11-01','2023-02-01',DEFAULT),
('NPA-YES-005','BNK-008','Meera Devi',                    'INDIVIDUAL','HOME',    0.45,  0.42,   105,'SUB_STANDARD','2023-09-30',15.00,'Mumbai',     'RETAIL',        'Flat',0.65,'2021-05-10','2023-06-01',DEFAULT),

-- BNK-009 PUNJAB & MAHARASHTRA UCB (SUSPENDED)
('NPA-UCB-001','BNK-009','HDIL (Housing Dev Infrastructure)','CORPORATE','CORPORATE',3500.00,3420.00,1640,'LOSS',  '2019-09-30',100.00,'Mumbai',     'REAL_ESTATE',   'Land',1200.00,'2008-01-01','2018-09-01',DEFAULT),
('NPA-UCB-002','BNK-009','Privilege Industries Ltd',      'CORPORATE','CORPORATE',180.00,172.50,1460,'LOSS',       '2019-12-31',100.00,'Mumbai',     'MANUFACTURING', 'Factory',80.00,'2010-03-01','2018-12-01',DEFAULT),
('NPA-UCB-003','BNK-009','Gupta Traders',                 'MSME',     'MSME',     4.20,  3.98,   820,'LOSS',       '2020-06-30',100.00,'Mumbai',     'TRADING',       'Stock',1.50,'2014-06-01','2019-06-01',DEFAULT),
('NPA-UCB-004','BNK-009','Ramesh Patil',                  'INDIVIDUAL','HOME',    0.38,  0.35,   730,'DOUBTFUL_2', '2021-03-31',40.00,'Pune',        'RETAIL',        'Flat',0.45,'2017-08-01','2021-03-01',DEFAULT),
('NPA-UCB-005','BNK-009','Sunrise Housing Society',       'MSME',     'CORPORATE',28.00, 26.40,  640,'DOUBTFUL_2', '2021-09-30',40.00,'Mumbai',     'REAL_ESTATE',   'Property',22.00,'2016-04-01','2020-09-01',DEFAULT),

-- BNK-010 DECCAN UCB (WATCH)
('NPA-DCN-001','BNK-010','Pune Motors Pvt Ltd',           'MSME',     'MSME',     3.80,  3.52,   210,'SUB_STANDARD','2023-03-31',15.00,'Pune',       'AUTOMOBILE',    'Showroom',4.50,'2019-06-01','2022-09-01',DEFAULT),
('NPA-DCN-002','BNK-010','Shalini Builders',              'MSME',     'MSME',     2.40,  2.21,   145,'SUB_STANDARD','2023-06-30',15.00,'Nashik',     'CONSTRUCTION',  'Equipment',1.80,'2020-01-01','2023-02-01',DEFAULT),
('NPA-DCN-003','BNK-010','Vitthal Kadam',                 'INDIVIDUAL','AGRI',    0.12,  0.11,   118,'SUB_STANDARD','2023-09-30',15.00,'Solapur',    'AGRI',          'Farm Land',0.18,'2021-03-01','2023-06-01',DEFAULT),

-- BNK-013 CANARA BANK
('NPA-CNR-001','BNK-013','Deccan Chronicle Holdings Ltd', 'CORPORATE','CORPORATE',180.00,168.40, 548,'DOUBTFUL_2', '2022-03-31',40.00,'Hyderabad',  'MEDIA',         'Brand + Assets',60.00,'2015-07-01','2021-03-15',DEFAULT),
('NPA-CNR-002','BNK-013','Kolkata Hotel Projects Ltd',    'CORPORATE','CORPORATE',65.00, 60.80,  365,'DOUBTFUL_1', '2022-09-30',25.00,'Kolkata',    'HOSPITALITY',   'Hotel Property',72.00,'2017-02-01','2021-09-20',DEFAULT),
('NPA-CNR-003','BNK-013','Karnataka Textile Corp',        'MSME',     'MSME',     11.20, 10.50,  188,'SUB_STANDARD','2023-03-31',15.00,'Bengaluru',  'TEXTILE',       'Plant',8.00,'2019-08-01','2022-09-15',DEFAULT),
('NPA-CNR-004','BNK-013','Mohammed Rashid Khan',          'INDIVIDUAL','HOME',    0.72,  0.68,   102,'SUB_STANDARD','2023-09-30',15.00,'Mysuru',     'RETAIL',        'Residential',0.90,'2021-07-01','2023-07-01',DEFAULT),

-- BNK-015 INDUSIND (WATCH — cyber/fintech risk)
('NPA-IND-001','BNK-015','MK Fintech Solutions Pvt Ltd',  'CORPORATE','CORPORATE',38.00, 35.20,  155,'SUB_STANDARD','2023-06-30',15.00,'Pune',       'FINTECH',       'IP Assets',15.00,'2020-03-01','2023-01-15',DEFAULT),
('NPA-IND-002','BNK-015','Shree Krishna Jewellers',       'MSME',     'MSME',     5.80,  5.40,   128,'SUB_STANDARD','2023-06-30',15.00,'Pune',       'GEMS_JEWELLERY','Gold Inventory',6.20,'2020-09-01','2023-02-20',DEFAULT);


-- ============================================================
-- TABLE 4: bank_inspection_reports (depends on bank_entities)
-- ============================================================
CREATE TABLE bank_inspection_reports (
    inspection_id               VARCHAR(15)  PRIMARY KEY,
    bank_id                     VARCHAR(10)  NOT NULL REFERENCES bank_entities(bank_id),
    inspection_year             INTEGER      NOT NULL,
    inspection_type             VARCHAR(15)  NOT NULL CHECK (inspection_type IN ('AFI','SPECIAL','THEMATIC')),
    camels_rating               INTEGER      NOT NULL CHECK (camels_rating BETWEEN 1 AND 5),
    capital_score               INTEGER      NOT NULL CHECK (capital_score BETWEEN 1 AND 5),
    asset_score                 INTEGER      NOT NULL CHECK (asset_score BETWEEN 1 AND 5),
    mgmt_score                  INTEGER      NOT NULL CHECK (mgmt_score BETWEEN 1 AND 5),
    earnings_score              INTEGER      NOT NULL CHECK (earnings_score BETWEEN 1 AND 5),
    liquidity_score             INTEGER      NOT NULL CHECK (liquidity_score BETWEEN 1 AND 5),
    systems_score               INTEGER      NOT NULL CHECK (systems_score BETWEEN 1 AND 5),
    major_findings              TEXT,
    corrective_action_required  BOOLEAN      DEFAULT FALSE,
    pca_triggered               BOOLEAN      DEFAULT FALSE,
    next_inspection_due         DATE,
    inspection_team_lead        VARCHAR(80),
    created_at                  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO bank_inspection_reports VALUES
('INS-SBI-2023', 'BNK-001',2023,'AFI',   2, 1,2,2,2,1,2,
 'Minor divergence in NPA classification of ₹420 Cr in infrastructure segment. IT audit gaps noted — CBS patch pending for 4 months. KYC re-verification pending for 2.3% of accounts.',
 TRUE, FALSE,'2025-01-01','Suresh Menon, CGM Supervision',DEFAULT),

('INS-PNB-2023', 'BNK-002',2023,'AFI',   3, 2,4,3,3,2,3,
 'Significant NPA divergence detected — ₹1,240 Cr under-reported across 12 accounts. Evergreening suspected in 8 MSME accounts. Fraud reporting delay in 6 cases exceeded 21-day RBI norm. Concentration risk — top 10 borrowers = 38% of loan book.',
 TRUE, FALSE,'2025-01-01','Anita Sharma, CGM Supervision',DEFAULT),

('INS-BOB-2023', 'BNK-003',2023,'AFI',   2, 2,2,2,2,2,2,
 'Satisfactory overall. Minor KYC gaps in rural branches. MSME NPA trending upward — monitoring recommended.',
 FALSE,FALSE,'2025-01-01','Rakesh Sinha, DGM Supervision',DEFAULT),

('INS-HDFC-2023','BNK-004',2023,'AFI',   1, 1,1,1,1,1,2,
 'Best-in-class capital adequacy. NPA levels well within norms. IT systems robust. Minor finding on digital lending LSP disclosures.',
 FALSE,FALSE,'2025-01-01','Vijay Nair, CGM Supervision',DEFAULT),

('INS-ICICI-2023','BNK-005',2023,'AFI',  1, 1,2,1,1,1,1,
 'Strong capital position and improving asset quality. Satisfactory management oversight. No major findings.',
 FALSE,FALSE,'2025-01-01','Deepa Krishnan, CGM Supervision',DEFAULT),

('INS-AXIS-2023', 'BNK-006',2023,'AFI',  2, 2,2,2,2,2,2,
 'Adequate capital buffers. Moderate NPA movement in unsecured retail. Digital payment systems compliant.',
 FALSE,FALSE,'2025-01-01','Arun Verma, DGM Supervision',DEFAULT),

('INS-KOTAK-2023','BNK-007',2023,'AFI',  1, 1,1,1,1,1,1,
 'Excellent CRAR at 21.8%. Clean asset quality. Well-managed liquidity. No significant findings.',
 FALSE,FALSE,'2025-01-01','Smita Joshi, CGM Supervision',DEFAULT),

('INS-YES-2023',  'BNK-008',2023,'SPECIAL',4, 3,4,4,4,3,3,
 'Capital adequacy marginally above minimum — requires monitoring. Significant NPA stress in corporate and NBFC segments. Management governance concerns. IT infrastructure — 3 critical cyber incidents in FY2023-24. Loan evergreening detected in 4 accounts totalling ₹480 Cr. Fraud reporting delays in 3 instances.',
 TRUE, TRUE, '2024-06-01','Rajiv Menon, ED Supervision',DEFAULT),

('INS-UCB9-2023', 'BNK-009',2022,'SPECIAL',5, 5,5,5,4,5,4,
 'Critical: HDIL-linked exposure constitutes 73% of loan book — ₹3,500 Cr classified LOSS. Capital fully eroded. Liquidity crisis — withdrawal restrictions imposed. Director fraud suspected — ED investigation initiated. License suspension recommended to Board for Financial Supervision.',
 TRUE, TRUE, '2023-01-01','S K Ghosh, ED Supervision',DEFAULT),

('INS-DCN-2023',  'BNK-010',2023,'AFI',   4, 3,4,4,3,4,3,
 'Gross NPA at 18.3% — well above UCB peer average of 8%. Top 5 borrowers constitute 62% of loan book — severe concentration risk. Management quality deteriorating — 3 board members resigned in FY2023. Returns submission delay noted in 4 instances.',
 TRUE, TRUE, '2024-06-01','Pradeep Shah, GM Supervision',DEFAULT),

('INS-MUT-2023',  'BNK-011',2023,'AFI',   2, 2,2,2,1,2,2,
 'Strong gold loan business with adequate LTV maintained. Minor KYC gaps in small-ticket loans. Capital adequate.',
 FALSE,FALSE,'2025-01-01','Lekha Nair, DGM Supervision',DEFAULT),

('INS-BAJ-2023',  'BNK-012',2023,'AFI',   1, 1,1,1,1,1,1,
 'Best-in-class NBFC. Capital adequacy strong. NPA well-managed. Risk management frameworks robust.',
 FALSE,FALSE,'2025-01-01','Sanjay Iyer, CGM Supervision',DEFAULT),

('INS-CNR-2023',  'BNK-013',2023,'AFI',   3, 2,3,3,3,2,3,
 'NPA elevated in media and hospitality segments. KYC non-compliance in 3.1% of accounts. Evergreening suspected in 2 corporate accounts. IT systems — CBS upgrade pending.',
 TRUE, FALSE,'2025-01-01','Meena Rao, CGM Supervision',DEFAULT),

('INS-UNI-2023',  'BNK-014',2023,'AFI',   3, 2,3,3,2,2,3,
 'NPA ratio improving but corporate stress remains. Provisioning coverage ratio at 72% — below recommended 75%. KYC and MSME lending gaps noted.',
 TRUE, FALSE,'2025-01-01','Prakash Gupta, CGM Supervision',DEFAULT),

('INS-IND-2023',  'BNK-015',2023,'SPECIAL',4, 3,3,4,3,3,4,
 'Cyber incident — 3 UPI system breaches in FY2024 affecting 18,000 customers. Fraud reporting delay — 4 cases exceeded 21-day norm. IT systems score poor — SOC team understaffed. Management governance under scrutiny post CEO controversy.',
 TRUE, TRUE, '2024-06-01','Kavita Menon, ED Supervision',DEFAULT);


-- ============================================================
-- TABLE 5: penalty_orders (depends on bank_entities + rbi_circulars_registry)
-- ============================================================
CREATE TABLE penalty_orders (
    penalty_id              VARCHAR(15)     PRIMARY KEY,
    bank_id                 VARCHAR(10)     NOT NULL REFERENCES bank_entities(bank_id),
    penalty_date            DATE            NOT NULL,
    violation_type          VARCHAR(60)     NOT NULL,
    penalty_amt_lakh        DECIMAL(8,2)    NOT NULL,
    rbi_circular_ref        VARCHAR(30)     REFERENCES rbi_circulars_registry(circular_ref),
    compliance_deadline     DATE            NOT NULL,
    complied                BOOLEAN         DEFAULT FALSE,
    complied_date           DATE,
    remarks                 TEXT,
    created_at              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO penalty_orders VALUES
-- BNK-002 PNB Penalties (multiple violations — fraud + NPA)
('PEN-PNB-001','BNK-002','2024-02-15','FRAUD_REPORTING_DELAY',      500.00,'RBI/2023-24/85', '2024-05-15',TRUE, '2024-04-20','Penalty for delay exceeding 21 days in reporting 6 fraud cases under FMRS',DEFAULT),
('PEN-PNB-002','BNK-002','2024-03-20','NPA_DIVERGENCE',            2000.00,'RBI/2023-24/53', '2024-06-20',FALSE,NULL,        'Divergence of ₹1,240 Cr in NPA classification — compliance plan awaited',DEFAULT),
('PEN-PNB-003','BNK-002','2023-11-10','KYC_NON_COMPLIANCE',         150.00,'RBI/2023-24/101','2024-02-10',TRUE, '2024-01-28','KYC re-verification gaps in 14,000 accounts across Delhi region',DEFAULT),

-- BNK-008 YES BANK Penalties
('PEN-YES-001','BNK-008','2024-01-18','FRAUD_REPORTING_DELAY',      300.00,'RBI/2023-24/85', '2024-04-18',TRUE, '2024-03-30','3 fraud cases reported with delays of 28-45 days',DEFAULT),
('PEN-YES-002','BNK-008','2024-04-05','CYBERSECURITY_GAP',           75.00,'RBI/2024-25/12', '2024-07-05',FALSE,NULL,        'SOC team inadequate — 3 reportable cyber incidents not escalated within mandated TAT',DEFAULT),
('PEN-YES-003','BNK-008','2023-09-12','KYC_NON_COMPLIANCE',         100.00,'RBI/2023-24/101','2023-12-12',TRUE, '2023-11-25','New account KYC documents found incomplete in 8,200 accounts',DEFAULT),

-- BNK-009 UCB SUSPENDED Penalties
('PEN-UCB-001','BNK-009','2022-04-01','CAPITAL_ADEQUACY_BREACH',   1000.00,'RBI/2024-25/45', '2022-07-01',FALSE,NULL,        'Capital fully eroded — CRAR negative. Corrective plan not submitted despite 3 notices',DEFAULT),
('PEN-UCB-002','BNK-009','2022-04-01','FRAUD_REPORTING_DELAY',      500.00,'RBI/2023-24/85', '2022-07-01',FALSE,NULL,        'HDIL fraud not reported to RBI for 6 months — gross violation of FMRS norms',DEFAULT),

-- BNK-010 DECCAN UCB
('PEN-DCN-001','BNK-010','2024-03-10','KYC_NON_COMPLIANCE',          50.00,'RBI/2023-24/101','2024-06-10',FALSE,NULL,        'KYC gaps in 22% of new accounts opened in FY2023-24',DEFAULT),
('PEN-DCN-002','BNK-010','2024-05-15','NPA_DIVERGENCE',             200.00,'RBI/2023-24/53', '2024-08-15',FALSE,NULL,        'NPA under-reporting by ₹48 Cr detected during AFI 2023',DEFAULT),

-- BNK-013 CANARA BANK
('PEN-CNR-001','BNK-013','2023-12-20','KYC_NON_COMPLIANCE',         120.00,'RBI/2023-24/101','2024-03-20',TRUE, '2024-02-15','KYC non-compliance across 3 southern branches',DEFAULT),
('PEN-CNR-002','BNK-013','2024-06-01','NPA_DIVERGENCE',             400.00,'RBI/2023-24/53', '2024-09-01',FALSE,NULL,        'Evergreening of 2 corporate accounts worth ₹180 Cr — under investigation',DEFAULT),

-- BNK-015 INDUSIND
('PEN-IND-001','BNK-015','2024-05-10','CYBERSECURITY_GAP',          100.00,'RBI/2024-25/12', '2024-08-10',FALSE,NULL,        'Failure to report 3 cyber security incidents within mandated 6-hour window',DEFAULT),
('PEN-IND-002','BNK-015','2024-03-28','FRAUD_REPORTING_DELAY',      250.00,'RBI/2023-24/85', '2024-06-28',FALSE,NULL,        '4 fraud cases reported with delays of 24-38 days',DEFAULT),
('PEN-IND-003','BNK-015','2023-10-15','DIGITAL_LENDING_BREACH',      30.00,'RBI/2022-23/178','2024-01-15',TRUE, '2024-01-10','LSP disclosure non-compliant in 3 digital lending partnerships',DEFAULT),

-- BNK-001 SBI
('PEN-SBI-001','BNK-001','2024-01-10','KYC_NON_COMPLIANCE',         200.00,'RBI/2023-24/101','2024-04-10',TRUE, '2024-03-20','Re-KYC compliance gap in 28,000 accounts — rural branches',DEFAULT),

-- BNK-014 UNION BANK
('PEN-UNI-001','BNK-014','2024-02-28','KYC_NON_COMPLIANCE',         100.00,'RBI/2023-24/101','2024-05-28',TRUE, '2024-05-10','KYC documentation gaps in MSME segment',DEFAULT),
('PEN-UNI-002','BNK-014','2024-04-15','FRAUD_REPORTING_DELAY',       75.00,'RBI/2023-24/85', '2024-07-15',FALSE,NULL,        '2 fraud cases — reporting delay of 25 and 32 days respectively',DEFAULT);


-- ============================================================
-- TABLE 6: digital_payment_metrics (depends on bank_entities)
-- ============================================================
CREATE TABLE digital_payment_metrics (
    metric_id               SERIAL          PRIMARY KEY,
    bank_id                 VARCHAR(10)     NOT NULL REFERENCES bank_entities(bank_id),
    month                   DATE            NOT NULL,
    upi_txn_count           BIGINT          NOT NULL,
    upi_txn_val_cr          DECIMAL(14,2)   NOT NULL,
    neft_txn_count          BIGINT          NOT NULL,
    neft_txn_val_cr         DECIMAL(14,2)   NOT NULL,
    rtgs_txn_val_cr         DECIMAL(14,2)   NOT NULL,
    failed_txn_pct          DECIMAL(5,2)    NOT NULL,
    system_uptime_pct       DECIMAL(5,2)    NOT NULL,
    cyber_incidents         INTEGER         DEFAULT 0,
    upi_complaint_count     INTEGER         DEFAULT 0,
    created_at              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(bank_id, month)
);

INSERT INTO digital_payment_metrics (bank_id,month,upi_txn_count,upi_txn_val_cr,neft_txn_count,neft_txn_val_cr,rtgs_txn_val_cr,failed_txn_pct,system_uptime_pct,cyber_incidents,upi_complaint_count) VALUES
-- SBI — high volumes, stable
('BNK-001','2024-01-01',48200000,28420.00,18400000,142000.00,380000.00,0.38,99.92,0,142),
('BNK-001','2024-02-01',44800000,26180.00,17200000,138000.00,372000.00,0.41,99.90,0,128),
('BNK-001','2024-03-01',52100000,31200.00,19800000,155000.00,410000.00,0.35,99.94,0,138),
('BNK-001','2024-04-01',46500000,27400.00,17800000,143000.00,385000.00,0.39,99.91,0,130),
('BNK-001','2024-10-01',64800000,38200.00,22100000,172000.00,445000.00,0.42,99.89,0,185),
('BNK-001','2024-11-01',71200000,42000.00,24200000,188000.00,468000.00,0.44,99.88,0,198),

-- HDFC Bank — best performance
('BNK-004','2024-01-01',38400000,24800.00,16200000,128000.00,342000.00,0.18,99.98,0,48),
('BNK-004','2024-02-01',36200000,23400.00,15400000,122000.00,330000.00,0.19,99.97,0,42),
('BNK-004','2024-03-01',41800000,27000.00,17200000,136000.00,358000.00,0.17,99.98,0,52),
('BNK-004','2024-10-01',52400000,33800.00,20400000,162000.00,415000.00,0.20,99.97,0,64),
('BNK-004','2024-11-01',58200000,37600.00,22200000,175000.00,438000.00,0.21,99.97,0,70),

-- ICICI Bank
('BNK-005','2024-01-01',32800000,21200.00,14200000,112000.00,298000.00,0.22,99.95,0,58),
('BNK-005','2024-02-01',30400000,19600.00,13200000,105000.00,284000.00,0.24,99.94,0,52),
('BNK-005','2024-10-01',44800000,28800.00,18200000,144000.00,362000.00,0.25,99.93,0,78),

-- YES BANK (WATCH — higher failure rate)
('BNK-008','2024-01-01',8200000, 4800.00, 4200000, 32000.00, 84000.00, 1.82,99.40,1,380),
('BNK-008','2024-02-01',7800000, 4560.00, 3980000, 30400.00, 80000.00, 1.94,99.38,1,410),
('BNK-008','2024-03-01',8600000, 5020.00, 4380000, 33200.00, 87000.00, 2.08,99.35,2,445),
('BNK-008','2024-04-01',8100000, 4740.00, 4120000, 31400.00, 82000.00, 2.15,99.32,1,462),
('BNK-008','2024-05-01',7900000, 4620.00, 3940000, 30000.00, 79000.00, 2.24,99.28,1,488),
('BNK-008','2024-10-01',9800000, 5720.00, 4800000, 36600.00, 96000.00, 2.42,99.25,2,548),

-- INDUSIND BANK (WATCH — cyber issues)
('BNK-015','2024-01-01',9400000, 5600.00, 4800000, 38000.00, 96000.00, 1.68,99.55,1,320),
('BNK-015','2024-02-01',8800000, 5240.00, 4520000, 35800.00, 90800.00, 1.75,99.50,2,355),
('BNK-015','2024-03-01',9800000, 5840.00, 4980000, 39600.00, 100200.00,2.12,99.42,3,418),
('BNK-015','2024-04-01',9200000, 5480.00, 4680000, 37200.00, 94200.00, 2.28,99.38,2,445),
('BNK-015','2024-05-01',8960000, 5360.00, 4560000, 36200.00, 91600.00, 2.45,99.30,2,472),
('BNK-015','2024-06-01',9120000, 5440.00, 4640000, 36800.00, 93200.00, 2.38,99.34,1,458),

-- CANARA BANK
('BNK-013','2024-01-01',18400000,10800.00,8400000, 66400.00, 178000.00,0.58,99.78,0,148),
('BNK-013','2024-02-01',17200000,10080.00,7840000, 62000.00, 166000.00,0.62,99.75,0,140),
('BNK-013','2024-10-01',24600000,14400.00,10400000,82400.00, 220800.00,0.65,99.72,0,188),

-- DECCAN UCB (small volumes, WATCH)
('BNK-010','2024-01-01',182000,  108.00,  84000,   680.00,  1820.00,  3.82,98.40,0,48),
('BNK-010','2024-02-01',168000,   99.60,  77600,   628.00,  1680.00,  4.10,98.20,0,52),
('BNK-010','2024-03-01',192000,  114.00,  88400,   716.00,  1920.00,  4.45,97.98,0,58);


-- ============================================================
-- TABLE 7: fraud_reports (depends on bank_entities + npa_accounts — SEED LAST)
-- ============================================================
CREATE TABLE fraud_reports (
    fraud_id                VARCHAR(15)     PRIMARY KEY,
    bank_id                 VARCHAR(10)     NOT NULL REFERENCES bank_entities(bank_id),
    account_id              VARCHAR(15)     REFERENCES npa_accounts(account_id),
    fraud_type              VARCHAR(30)     NOT NULL CHECK (fraud_type IN ('DIVERSION','KYC_FRAUD','CYBER_FRAUD','INCOME_INFLATION','FORGED_DOCUMENTS','MISREPRESENTATION')),
    amount_cr               DECIMAL(10,2)   NOT NULL,
    detected_date           DATE            NOT NULL,
    reported_date           DATE            NOT NULL,
    reporting_delay_days    INTEGER         GENERATED ALWAYS AS (reported_date - detected_date) STORED,
    fir_filed               BOOLEAN         DEFAULT FALSE,
    recovery_amt_cr         DECIMAL(10,2)   DEFAULT 0.00,
    status                  VARCHAR(25)     NOT NULL CHECK (status IN ('UNDER_INVESTIGATION','CLOSED','ESCALATED','REFERRED_TO_ED')),
    sarfaesi_applied        BOOLEAN         DEFAULT FALSE,
    wilful_defaulter_tagged BOOLEAN         DEFAULT FALSE,
    investigating_agency    VARCHAR(50),
    remarks                 TEXT,
    created_at              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO fraud_reports VALUES
-- BNK-002 PNB Frauds (Story Arc 2 — Large PSB)
('FRD-PNB-001','BNK-002','NPA-PNB-002','DIVERSION',       440.00,'2023-04-10','2023-05-18',DEFAULT,TRUE, 38.50,'REFERRED_TO_ED',  TRUE, TRUE, 'CBI + ED',   'Funds diverted to overseas entities via LoUs — Bhushan Steel case',DEFAULT),
('FRD-PNB-002','BNK-002','NPA-PNB-001','DIVERSION',       380.00,'2023-06-15','2023-08-02',DEFAULT,TRUE, 22.00,'REFERRED_TO_ED',  TRUE, TRUE, 'CBI',        'Project funds diverted to promoter personal accounts — Era Infra',DEFAULT),
('FRD-PNB-003','BNK-002','NPA-PNB-005','FORGED_DOCUMENTS',520.00,'2023-02-20','2023-03-18',DEFAULT,TRUE, 0.00, 'UNDER_INVESTIGATION',TRUE,TRUE,'ED + CBI',  'Fake collateral documents — Videocon Industries',DEFAULT),
('FRD-PNB-004','BNK-002','NPA-PNB-007','INCOME_INFLATION', 18.50,'2024-01-08','2024-02-15',DEFAULT,FALSE,1.20, 'UNDER_INVESTIGATION',TRUE,FALSE,'Bank Internal','Inflated turnover figures to avail MSME working capital',DEFAULT),
('FRD-PNB-005','BNK-002','NPA-PNB-003','MISREPRESENTATION',95.00,'2023-09-14','2023-10-28',DEFAULT,TRUE, 8.40, 'ESCALATED',       TRUE, TRUE, 'ED',         'End-use of funds diverted to related party — Zoom Developers',DEFAULT),
('FRD-PNB-006','BNK-002',NULL,          'KYC_FRAUD',        2.80,'2024-03-01','2024-04-10',DEFAULT,TRUE, 0.80, 'UNDER_INVESTIGATION',FALSE,FALSE,'Bank Internal','Multiple accounts opened with forged Aadhaar — identity theft ring',DEFAULT),
('FRD-PNB-007','BNK-002',NULL,          'CYBER_FRAUD',      0.42,'2024-05-20','2024-06-01',DEFAULT,FALSE,0.38, 'CLOSED',          FALSE,FALSE,'Cyber Cell',  'UPI credential phishing — 14 customers affected',DEFAULT),
('FRD-PNB-008','BNK-002','NPA-PNB-008','DIVERSION',       280.00,'2023-11-10','2024-01-18',DEFAULT,TRUE, 14.00,'REFERRED_TO_ED',  TRUE, TRUE, 'ED',         'Power sector funds siphoned — North Star Power Ltd',DEFAULT),

-- BNK-008 YES BANK Frauds (Story Arc 1 variant)
('FRD-YES-001','BNK-008','NPA-YES-001','DIVERSION',        210.00,'2023-05-12','2023-06-18',DEFAULT,TRUE, 18.00,'REFERRED_TO_ED',  TRUE, TRUE, 'ED',         'ADAG Power — funds routed to promoter entities',DEFAULT),
('FRD-YES-002','BNK-008','NPA-YES-002','MISREPRESENTATION',280.00,'2023-03-08','2023-04-02',DEFAULT,TRUE, 0.00, 'UNDER_INVESTIGATION',TRUE,TRUE,'ED + SFIO', 'Cafe CCD — massive overstatement of assets',DEFAULT),
('FRD-YES-003','BNK-008','NPA-YES-003','INCOME_INFLATION',  120.00,'2024-01-15','2024-02-18',DEFAULT,FALSE,5.40, 'UNDER_INVESTIGATION',TRUE,FALSE,'Bank Internal','Radius Developers — inflated project valuations',DEFAULT),
('FRD-YES-004','BNK-008',NULL,          'CYBER_FRAUD',       0.85,'2024-04-22','2024-05-20',DEFAULT,TRUE, 0.72, 'CLOSED',          FALSE,FALSE,'Cyber Cell',  'Internet banking credential compromise — 38 accounts',DEFAULT),
('FRD-YES-005','BNK-008',NULL,          'KYC_FRAUD',         1.20,'2024-02-10','2024-03-28',DEFAULT,FALSE,0.40, 'UNDER_INVESTIGATION',FALSE,FALSE,'Bank Internal','Mule accounts opened using stolen KYC docs — 28 accounts',DEFAULT),

-- BNK-009 UCB SUSPENDED (Story Arc 1 — UCB Failure)
('FRD-UCB-001','BNK-009','NPA-UCB-001','DIVERSION',       3500.00,'2019-06-15','2019-12-28',DEFAULT,TRUE, 0.00, 'REFERRED_TO_ED',  TRUE, TRUE, 'ED + EOW',   'HDIL — core fraud. Funds diverted over 10 years. Promoters arrested.',DEFAULT),
('FRD-UCB-002','BNK-009','NPA-UCB-002','FORGED_DOCUMENTS', 180.00,'2020-01-10','2020-03-15',DEFAULT,TRUE, 0.00, 'REFERRED_TO_ED',  TRUE, TRUE, 'ED',         'Privilege Industries — forged stock statements submitted for 6 years',DEFAULT),
('FRD-UCB-003','BNK-009','NPA-UCB-003','INCOME_INFLATION',   4.20,'2020-04-05','2020-05-10',DEFAULT,FALSE,0.00, 'CLOSED',          FALSE,FALSE,'Bank Internal','Gupta Traders — inflated turnover for working capital',DEFAULT),
('FRD-UCB-004','BNK-009',NULL,          'KYC_FRAUD',          0.95,'2020-02-18','2020-04-01',DEFAULT,FALSE,0.00, 'CLOSED',          FALSE,FALSE,'Police',      'Fictitious accounts created using director relatives KYC',DEFAULT),

-- BNK-015 INDUSIND (Story Arc 3 — Fintech/Cyber)
('FRD-IND-001','BNK-015',NULL,          'CYBER_FRAUD',       1.82,'2024-01-28','2024-02-25',DEFAULT,TRUE, 1.44, 'UNDER_INVESTIGATION',FALSE,FALSE,'Cyber Cell',  'UPI system breach — 420 customer accounts compromised',DEFAULT),
('FRD-IND-002','BNK-015',NULL,          'CYBER_FRAUD',       2.48,'2024-03-14','2024-04-22',DEFAULT,TRUE, 1.96, 'UNDER_INVESTIGATION',FALSE,FALSE,'Cyber Cell',  'Core banking API vulnerability exploited — 680 customers',DEFAULT),
('FRD-IND-003','BNK-015',NULL,          'CYBER_FRAUD',       0.94,'2024-05-02','2024-06-12',DEFAULT,FALSE,0.78, 'UNDER_INVESTIGATION',FALSE,FALSE,'Cyber Cell',  'Phishing attack on mobile banking — 220 customers',DEFAULT),
('FRD-IND-004','BNK-015','NPA-IND-001','INCOME_INFLATION',  38.00,'2023-11-20','2023-12-28',DEFAULT,FALSE,2.80, 'UNDER_INVESTIGATION',TRUE,FALSE,'Bank Internal','MK Fintech — inflated revenue projections for working capital',DEFAULT),
('FRD-IND-005','BNK-015',NULL,          'KYC_FRAUD',          0.68,'2024-04-08','2024-05-20',DEFAULT,FALSE,0.52, 'CLOSED',          FALSE,FALSE,'Bank Internal','Digital account opening — 48 accounts with synthetic KYC',DEFAULT),

-- BNK-013 CANARA BANK
('FRD-CNR-001','BNK-013','NPA-CNR-001','DIVERSION',        180.00,'2023-08-18','2023-09-28',DEFAULT,TRUE, 12.00,'ESCALATED',       TRUE, TRUE, 'ED',         'Deccan Chronicle — funds diverted to promoter offshore accounts',DEFAULT),
('FRD-CNR-002','BNK-013','NPA-CNR-002','FORGED_DOCUMENTS',  65.00,'2024-02-05','2024-02-28',DEFAULT,FALSE,4.80, 'UNDER_INVESTIGATION',TRUE,FALSE,'Bank Internal','Hotel project — forged completion certificates for loan drawdown',DEFAULT),

-- BNK-001 SBI
('FRD-SBI-001','BNK-001','NPA-SBI-002','DIVERSION',        320.00,'2023-07-10','2023-08-04',DEFAULT,TRUE, 28.00,'REFERRED_TO_ED',  TRUE, TRUE, 'CBI',        'Lanco Infratech — infrastructure funds diverted to promoter entities',DEFAULT),
('FRD-SBI-002','BNK-001','NPA-SBI-001','FORGED_DOCUMENTS', 480.00,'2023-04-20','2023-05-15',DEFAULT,TRUE, 0.00, 'REFERRED_TO_ED',  TRUE, TRUE, 'ED + CBI',   'Jaypee Infratech — land collateral documents forged',DEFAULT),
('FRD-SBI-003','BNK-001',NULL,          'KYC_FRAUD',          0.38,'2024-06-01','2024-06-22',DEFAULT,FALSE,0.30, 'CLOSED',          FALSE,FALSE,'Bank Internal','Jan Dhan account misuse — mule network detected',DEFAULT);


-- ============================================================
-- USEFUL VIEWS FOR DEMO QUERIES
-- ============================================================

-- View 1: Banks with both fraud AND NPA stress (multi-hop ready)
CREATE VIEW v_bank_risk_summary AS
SELECT
    b.bank_id,
    b.bank_name,
    b.bank_type,
    b.license_status,
    b.gross_npa_pct,
    i.camels_rating,
    COUNT(DISTINCT n.account_id)    AS npa_count,
    COUNT(DISTINCT f.fraud_id)      AS fraud_count,
    COALESCE(SUM(f.amount_cr),0)    AS total_fraud_amt_cr,
    COUNT(DISTINCT p.penalty_id)    AS penalty_count,
    COUNT(DISTINCT p.penalty_id) FILTER (WHERE p.complied = FALSE) AS uncomplied_penalties
FROM bank_entities b
LEFT JOIN bank_inspection_reports i ON b.bank_id = i.bank_id
LEFT JOIN npa_accounts n    ON b.bank_id = n.bank_id
LEFT JOIN fraud_reports f   ON b.bank_id = f.bank_id
LEFT JOIN penalty_orders p  ON b.bank_id = p.bank_id
GROUP BY b.bank_id, b.bank_name, b.bank_type, b.license_status, b.gross_npa_pct, i.camels_rating;

-- View 2: Fraud cases with reporting delay violations
CREATE VIEW v_fraud_delay_violations AS
SELECT
    f.fraud_id,
    b.bank_name,
    f.fraud_type,
    f.amount_cr,
    f.detected_date,
    f.reported_date,
    f.reporting_delay_days,
    f.sarfaesi_applied,
    f.status
FROM fraud_reports f
JOIN bank_entities b ON f.bank_id = b.bank_id
WHERE f.reporting_delay_days > 21
ORDER BY f.reporting_delay_days DESC;

-- View 3: Uncomplied penalties older than 90 days
CREATE VIEW v_uncomplied_penalties AS
SELECT
    p.penalty_id,
    b.bank_name,
    p.penalty_date,
    p.violation_type,
    p.penalty_amt_lakh,
    p.rbi_circular_ref,
    p.compliance_deadline,
    (CURRENT_DATE - p.compliance_deadline) AS days_overdue
FROM penalty_orders p
JOIN bank_entities b ON p.bank_id = b.bank_id
WHERE p.complied = FALSE
  AND p.compliance_deadline < CURRENT_DATE
ORDER BY days_overdue DESC;

-- ============================================================
-- END OF SQL SETUP
-- ============================================================
