# SQL Assignment – Student Table

## Objective

Create a table named **Student** in the **CollegeDB** database.

### Table Structure

| Column | Data Type | Constraints |
|---------|-----------|-------------|
| StudentID | Number(5) | PRIMARY KEY |
| StudentName | VARCHAR(20) | NOT NULL, UNIQUE |
| DOB | DATE | NOT NULL |
| Gender | VARCHAR(10) | NOT NULL |
| DepartmentID | Number(5) | NOT NULL |

---

## Instructions

1. Open `starter.sql`.
2. Complete the SQL statements.
3. Do not rename the file.
4. Commit and push your changes.

```bash
git add .
git commit -m "Completed SQL Assignment"
git push
```

GitHub Actions will automatically evaluate your submission.

---

## Marks Distribution

| Test | Marks |
|------|------:|
| Student table | 2 |
| Primary Key | 2 |
| StudentName datatype | 1 |
| DOB datatype | 1 |
| Gender datatype | 1 |
| DepartmentID datatype | 1 |
| NOT NULL constraints | 1 |
| UNIQUE constraint | 1 |

**Total: 10 Marks**
