# Database Creation & Development + MySQL

Welcome to the **Database Creation & Development + MySQL** workshop! This repository contains all the training materials, models, and scripts used during the course to design, build, and secure a relational database from scratch.

## 👥 Lecturers

| Lecturer Name | Email | LinkedIn |
| :--- | :---: | :---: |
| **Eduardo Freitas Fernandes** | [![Email Badge](https://img.shields.io/badge/-Email-red?style=flat&logo=gmail&logoColor=white)](mailto:eduardo.fernandes@epicje.pt) | [![Linkedin Badge](https://img.shields.io/badge/-LinkedIn-blue?style=flat&logo=Linkedin&logoColor=white)](https://www.linkedin.com/in/eduardoffernandes/) |

## 📄 Presentation

The workshop slide deck is available in [presentation.pdf](presentation.pdf). It covers database fundamentals, relational modeling, SQL syntax, transactions, and ORM concepts.

## 🚀 Getting Started

Follow these steps to initialize the database and configure users on your local machine:

### 1. Prerequisites
Ensure you have the following software installed:
* [MySQL Server](https://dev.mysql.com/downloads/mysql/) (v8.0+)
* [MySQL Workbench](https://dev.mysql.com/downloads/workbench/)

### 2. Setup Database & User Permissions
Run the SQL scripts in the following order using MySQL Workbench or your preferred database client:

1. **`scripts/users.sql`**: Run this script to create the database schema `star_projetos` and initialize database users with different permission levels:
   - `admin_star`: Full administrative rights.
   - `gestor_projetos`: Read, write, and update access.
   - `consultor_star`: Read-only access.
   - `app_backend`: Standard CRUD permissions for application integration.
2. **`scripts/schema.sql`**: Run this script to create the database tables, fields, constraints, and foreign key relations.
3. **`scripts/data.sql`**: Run this script to populate the tables with initial mock records for testing.
4. **`scripts/queries.sql`**: Play with the queries, transactions and others to see the database working.
