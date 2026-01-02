# Vet-clinic---database

This project represents a relational database designed to manage the core operations of a veterinary clinic.
It was created as an academic project with the goal of practicing database design, normalization,
constraints, triggers, and SQL queries using **Oracle SQL**.

---

##  Project Overview

The database supports the following functionality:
- Managing pet owners and their animals
- Storing information about veterinarians and their specializations
- Tracking visits, diagnoses, and treatments
- Managing medications and their availability
- Recording which medications are used in each treatment

The schema is designed to reflect a real-world veterinary clinic scenario.

---

##  Database Structure

The database consists of the following main tables:

- **Owners** – information about pet owners
- **Pets** – animals registered in the clinic
- **Vets** – veterinarians and their specializations
- **Visits** – medical visits for pets
- **Treatments** – treatments performed during visits
- **Medications** – available medications
- **TreatmentMedications** – junction table for treatments and medications (many-to-many relationship)

Relationships are enforced using **primary keys**, **foreign keys**, and **ON DELETE CASCADE** constraints.

---

##  Technologies Used

- **Oracle SQL**
- Relational database design
- SQL DDL & DML
- Triggers and constraints
- Indexes for performance optimization

---

##  Constraints & Business Logic

The database includes several constraints and triggers to ensure data integrity:

- Primary and foreign key constraints
- Unique constraints for phone numbers and emails
- Check constraints for valid values
- Triggers that:
  - Prevent visits from being scheduled in the future
  - Prevent inserting expired medications
  - Check medication stock availability before usage

---

##  Sample Queries

The project contains example SQL queries demonstrating:
- JOINs between multiple tables
- LEFT JOIN usage
- Aggregation functions (SUM)
- Realistic reports, such as:
  - Pets and their owners
  - Visits with assigned veterinarians
  - Treatments and used medications
  - Total cost of treatments per pet

---

##  Project Files

All scripts are placed in a single SQL file for simplicity.

---

##  Purpose of the Project

This project was created for learning and practicing:
- Relational database modeling
- Oracle SQL syntax and features
- Writing clean and structured SQL scripts
- Implementing basic business rules at database level

---

##  Notes

This is an academic project intended for educational purposes.
IDs used in INSERT statements are predefined for demonstration clarity.
