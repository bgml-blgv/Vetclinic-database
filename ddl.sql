DROP TABLE TreatmentMedications CASCADE CONSTRAINTS;
DROP TABLE Treatments CASCADE CONSTRAINTS;
DROP TABLE Visits CASCADE CONSTRAINTS;
DROP TABLE Pets CASCADE CONSTRAINTS;
DROP TABLE Medications CASCADE CONSTRAINTS;
DROP TABLE Vets CASCADE CONSTRAINTS;
DROP TABLE Owners CASCADE CONSTRAINTS;

//Таблици 

CREATE TABLE Owners (
    OwnerID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    FirstName VARCHAR2(50) NOT NULL,
    LastName VARCHAR2(50) NOT NULL,
    Phone VARCHAR2(20) UNIQUE NOT NULL,
    Email VARCHAR2(100) UNIQUE,
    Address VARCHAR2(200)
);

CREATE TABLE Pets (
    PetID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    OwnerID NUMBER NOT NULL,
    Name VARCHAR2(50) NOT NULL,
    Species VARCHAR2(30) NOT NULL,
    Breed VARCHAR2(50),
    BirthDate DATE NOT NULL,
    Gender VARCHAR2(10),
    MicrochipNumber VARCHAR2(50) UNIQUE,
    CONSTRAINT fk_pets_owner FOREIGN KEY (OwnerID)
        REFERENCES Owners(OwnerID) ON DELETE CASCADE
);

CREATE TABLE Vets (
    VetID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    FirstName VARCHAR2(50) NOT NULL,
    LastName VARCHAR2(50) NOT NULL,
    Phone VARCHAR2(20) UNIQUE,
    Specialization VARCHAR2(100),
    Available CHAR(1) DEFAULT 'Y' CHECK (Available IN ('Y','N'))
);

CREATE TABLE Visits (
    VisitID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    PetID NUMBER NOT NULL,
    VetID NUMBER NOT NULL,
    VisitDate DATE NOT NULL,
    Diagnosis VARCHAR2(200),
    Notes VARCHAR2(300),
    CONSTRAINT fk_visits_pet FOREIGN KEY (PetID)
        REFERENCES Pets(PetID) ON DELETE CASCADE,
    CONSTRAINT fk_visits_vet FOREIGN KEY (VetID)
        REFERENCES Vets(VetID)
);

CREATE TABLE Medications (
    MedicationID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Description VARCHAR2(200),
    Quantity NUMBER CHECK (Quantity >= 0),
    ExpirationDate DATE
);

CREATE TABLE Treatments (
    TreatmentID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    VisitID NUMBER NOT NULL,
    Description VARCHAR2(150) NOT NULL,
    Cost NUMBER(10,2),
    CONSTRAINT fk_treatment_visit FOREIGN KEY (VisitID)
        REFERENCES Visits(VisitID) ON DELETE CASCADE
);

CREATE TABLE TreatmentMedications (
    TreatmentID NUMBER NOT NULL,
    MedicationID NUMBER NOT NULL,
    QuantityUsed NUMBER CHECK (QuantityUsed >= 0),
    PRIMARY KEY (TreatmentID, MedicationID),
    CONSTRAINT fk_tm_treatment FOREIGN KEY (TreatmentID)
        REFERENCES Treatments(TreatmentID) ON DELETE CASCADE,
    CONSTRAINT fk_tm_medication FOREIGN KEY (MedicationID)
        REFERENCES Medications(MedicationID)
);
//Индекси 

CREATE INDEX idx_pet_owner ON Pets(OwnerID);
CREATE INDEX idx_visit_pet ON Visits(PetID);
CREATE INDEX idx_visit_vet ON Visits(VetID);
CREATE INDEX idx_tm_treat ON TreatmentMedications(TreatmentID);
CREATE INDEX idx_tm_med ON TreatmentMedications(MedicationID);

//Тригъри 

CREATE OR REPLACE TRIGGER trg_check_visit_date
BEFORE INSERT OR UPDATE ON Visits
FOR EACH ROW
BEGIN
    IF :NEW.VisitDate > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Дата на преглед не може да бъде в бъдещето!');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_check_expiration
BEFORE INSERT OR UPDATE ON Medications
FOR EACH ROW
BEGIN
    IF :NEW.ExpirationDate <= SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002, 'Срокът на годност трябва да е в бъдещето!');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_med_stock
BEFORE INSERT OR UPDATE ON TreatmentMedications
FOR EACH ROW
DECLARE
    available_qty NUMBER;
BEGIN
    SELECT Quantity INTO available_qty
    FROM Medications
    WHERE MedicationID = :NEW.MedicationID;

    IF :NEW.QuantityUsed > available_qty THEN
        RAISE_APPLICATION_ERROR(-20003, 'Няма достатъчно наличен медикамент в склада!');
    END IF;
END;
/
// Попълване на таблиците с информация
// Собственици

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Богомил', 'Благоев', '0876916663', 'boghata123@gmail.com', 'София, бул. Арсеналски 105');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Иван', 'Петров', '0899123456', 'ivan.petrov@example.com', 'София, ул. Витоша 10');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Мария', 'Георгиева', '0888123123', 'm.georgieva@example.com', 'София, ул. Бузлуджа 24');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Даниел', 'Христов', '0888555666', 'dan.h@example.com', 'Пловдив, бул. Източен 88');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Елена', 'Илиева', '0899001122', 'elena.ilieva@example.com', 'Варна, ул. Морска 1');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Петър', 'Ангелов', '0877555444', 'p.angelov@example.com', 'Бургас, ул. Поморие 5');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Силвия', 'Стоянова', '0899110040', 'sil.stoyanova@example.com', 'Плевен, ул. Мизия 77');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Християн', 'Ганев', '0889245681', 'hr.ganev@example.com', 'София, жк. Младост 2');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Александра', 'Жекова', '0896554411', 'alexz@example.com', 'София, жк. Лозенец');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Пламен', 'Стефанов', '0896002332', 'pl.stefanov@example.com', 'Пловдив, ул. Родопи 9');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Гергана', 'Маринова', '0888991111', 'gerganam@example.com', 'Русе, ул. Дунав 33');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Калоян', 'Колев', '0877889900', 'kal.kolev@example.com', 'Благоевград, ул. Пирин');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Антония', 'Цветанова', '0897332121', 'antcvetanova@example.com', 'София, ул. Черни Връх');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Росица', 'Димитрова', '0887412589', 'rdimitrova@example.com', 'Велико Търново, ул. Опълченска');

INSERT INTO Owners (FirstName, LastName, Phone, Email, Address)
VALUES ('Мартин', 'Полов', '0879005005', 'martinpolov@example.com', 'Стара Загора, бул. Цар Симеон');

//Животни 

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender, MicrochipNumber)
VALUES (1, 'Съни', 'Куче', 'Cavalier King Charles Spaniel', DATE '2024-06-06', 'M', 'MC1000');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (2, 'Рекс', 'Куче', 'Немска овчарка', DATE '2022-04-15', 'M');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (3, 'Мици', 'Котка', 'Европейска късокосместа', DATE '2021-09-09', 'F');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender, MicrochipNumber)
VALUES (4, 'Бъни', 'Заек', 'Мини лоп', DATE '2023-03-02', 'F', 'MC2001');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (5, 'Макс', 'Куче', 'Лабрадор', DATE '2020-12-10', 'M');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (6, 'Снежи', 'Котка', 'Персийска', DATE '2023-01-22', 'F');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender, MicrochipNumber)
VALUES (7, 'Пухчо', 'Хамстер', 'Golden Hamster', DATE '2024-02-14', 'M', 'MC3451');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (8, 'Кико', 'Куче', 'Ши Тцу', DATE '2021-08-29', 'M');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender, MicrochipNumber)
VALUES (9, 'Луна', 'Коте', 'Британска късокосместа', DATE '2022-11-01', 'F', 'MC4004');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (10, 'Рио', 'Папагал', 'Ара', DATE '2019-05-18', 'M');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (11, 'Белла', 'Куче', 'Померан', DATE '2023-06-25', 'F');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (12, 'Гари', 'Котка', 'Сфинкс', DATE '2020-10-07', 'M');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (5, 'Тоби', 'Куче', 'Джак Ръсел Териер', DATE '2019-04-12', 'M');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (7, 'Мина', 'Котка', 'Персийска', DATE '2021-09-09', 'F');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (13, 'Скип', 'Куче', 'Бийгъл', DATE '2022-02-18', 'M');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (8, 'Руби', 'Котка', 'Британска късокосместа', DATE '2023-11-01', 'F');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (10, 'Боби', 'Гризач', 'Морско свинче', DATE '2024-01-22', 'M');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (6, 'Дора', 'Куче', 'Пудел', DATE '2023-03-02', 'F');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (11, 'Чери', 'Птица', 'Папагал Корела', DATE '2023-07-05', 'F');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (4, 'Рони', 'Куче', 'Сибирско хъски', DATE '2022-10-10', 'M');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (9, 'Лизи', 'Котка', 'Сиамска', DATE '2021-12-15', 'F');

INSERT INTO Pets (OwnerID, Name, Species, Breed, BirthDate, Gender)
VALUES (3, 'Грета', 'Заек', 'Мини лоп', DATE '2023-08-22', 'F');

//Ветеринари

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Иван', 'Петров', '0887001001', 'Обща ветеринарна медицина', 'Y');

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Мария', 'Николова', '0887001002', 'Кардиология', 'Y');

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Петър', 'Димитров', '0887001003', 'Хирургия', 'Y');

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Елица', 'Стоянова', '0887001004', 'Дерматология', 'N');

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Георги', 'Тодоров', '0887001005', 'Ортопедия', 'Y');

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Даниела', 'Христова', '0887001006', 'Рентгенология', 'Y');

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Калоян', 'Михайлов', '0887001007', 'Стоматология', 'Y');

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Росица', 'Пенева', '0887001008', 'Ендокринология', 'N');

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Христо', 'Ангелов', '0887001009', 'Онкология', 'Y');

INSERT INTO Vets (FirstName, LastName, Phone, Specialization, Available)
VALUES ('Албена', 'Жекова', '0887001010', 'Неврология', 'Y');

//Медикаменти

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Амоксицилин', 'Антибиотик за бактериални инфекции', 50, DATE '2026-05-20');

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Ибупрофен', 'Обезболяващо и противовъзпалително', 80, DATE '2027-01-10');

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Ваксина DHPPi', 'Комбинирана ваксина за кучета', 40, DATE '2026-11-01');

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Дронтал', 'Обезпаразитяващ медикамент', 30, DATE '2027-03-14');

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Преднизолон', 'Кортикостероид за алергии', 25, DATE '2026-09-18');

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Седалгин', 'Болкоуспокояващо', 60, DATE '2027-08-30');

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Римадил', 'Противовъзпалително за кучета', 35, DATE '2026-04-22');

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Сироп Бронховит', 'Сироп за кашлица', 20, DATE '2026-12-10');

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Очни капки Тобрекс', 'Антибиотични капки за очи', 45, DATE '2027-07-08');

INSERT INTO Medications (Name, Description, Quantity, ExpirationDate)
VALUES ('Мелоксикам', 'Обезболяващо за възпаления в ставите', 50, DATE '2026-10-15');

//Прегледи

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (81, 21, DATE '2024-10-01', 'Рутинен преглед', 'Животното е в отлично състояние.');

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (82, 22, DATE '2024-09-12', 'Болка в лапата', 'Назначен Римадил.');

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (83, 23, DATE '2024-08-03', 'Кожна алергия', 'Предписан Преднизолон.');

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (84, 24, DATE '2024-07-14', 'Обезпаразитяване', 'Даден Дронтал.');

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (85, 25, DATE '2024-06-11', 'Зъбен камък', 'Препоръчано почистване.');

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (86, 26, DATE '2024-05-19', 'Сърбеж и бълхи', 'Изписан препарат против паразити.');

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (87, 27, DATE '2024-04-08', 'Конюнктивит', 'Изписан Тобрекс.');

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (88, 28, DATE '2024-03-27', 'Кашлица', 'Предписан Бронховит.');

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (89, 29, DATE '2024-02-20', 'Намалена активност', 'Препоръчано наблюдение.');

INSERT INTO Visits (PetID, VetID, VisitDate, Diagnosis, Notes)
VALUES (90, 30, DATE '2024-01-13', 'Хормонален дисбаланс', 'Назначени тестове.');

//treatments 

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (93, 'Обстоен профилактичен преглед', 20.00);

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (94, 'Лечение на болка в лапата', 35.00);

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (95, 'Терапия при кожна алергия', 40.00);

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (96, 'Обезпаразитяваща процедура', 25.00);

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (97, 'Стоматологична процедура при кариес', 50.00);

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (98, 'Лечение на сърбеж и бълхи', 30.00);

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (99, 'Почистване на зъбен камък', 45.00);

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (100, 'Лечение на кашлица', 32.00);

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (101, 'Хормонално изследване', 55.00);

INSERT INTO Treatments (VisitID, Description, Cost)
VALUES (102, 'Неврологично наблюдение', 60.00);

//treatmentmedication

INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (11, 21, 1);
INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (12, 22, 1);
INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (13, 23, 1);
INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (14, 24, 1);
INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (15, 25, 1);
INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (16, 26, 1);
INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (17, 27, 1);
INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (18, 28, 1);
INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (19, 29, 1);
INSERT INTO TreatmentMedications (TreatmentID, MedicationID, QuantityUsed) VALUES (20, 30, 1);

COMMIT;

//select - заявки

//Всичките домашни любимци и техните собственици
SELECT p.PetID, p.Name AS PetName, o.FirstName || ' ' || o.LastName AS OwnerName
FROM Pets p
JOIN Owners o ON p.OwnerID = o.OwnerID;

//Всичките прегледи с животно + ветеринар
SELECT v.VisitID, p.Name AS PetName, vet.FirstName || ' ' || vet.LastName AS VetName, 
       v.VisitDate, v.Diagnosis
FROM Visits v
JOIN Pets p ON v.PetID = p.PetID
JOIN Vets vet ON v.VetID = vet.VetID;

//Леченията за всеки преглед
SELECT t.TreatmentID, t.Description, t.Cost, v.VisitDate, p.Name AS PetName
FROM Treatments t
JOIN Visits v ON t.VisitID = v.VisitID
JOIN Pets p ON v.PetID = p.PetID;

//Всички медикаменти използвани в лечение
SELECT tm.TreatmentID, m.Name AS Medication, tm.QuantityUsed
FROM TreatmentMedications tm
JOIN Medications m ON tm.MedicationID = m.MedicationID;

//Пълна справка: животно → преглед → лечение → медикаменти / брой медикаменти

SELECT p.Name AS PetName,
       v.VisitDate,
       t.Description AS Treatment,
       m.Name AS Medication,
       tm.QuantityUsed
FROM Pets p
JOIN Visits v ON p.PetID = v.PetID
JOIN Treatments t ON v.VisitID = t.VisitID
LEFT JOIN TreatmentMedications tm ON t.TreatmentID = tm.TreatmentID
LEFT JOIN Medications m ON tm.MedicationID = m.MedicationID
ORDER BY p.PetID, v.VisitDate;

//Обща цена на всички лечения на едно животно

SELECT p.Name AS PetName, SUM(t.Cost) AS TotalCost
FROM Pets p
JOIN Visits v ON p.PetID = v.PetID
JOIN Treatments t ON v.VisitID = t.VisitID
GROUP BY p.Name;

