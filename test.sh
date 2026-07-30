#!/bin/bash

HOST=127.0.0.1
USER=root
PASS=root

echo "======================================"
echo "Student Table Autograder"
echo "======================================"

# Create database
mysql -h$HOST -u$USER -p$PASS <<EOF
DROP DATABASE IF EXISTS CollegeDB;
CREATE DATABASE CollegeDB;
USE CollegeDB;

CREATE TABLE Department(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(20),
    HOD VARCHAR(20)
);
EOF

# Execute student's SQL
mysql -h$HOST -u$USER -p$PASS < starter.sql

TOTAL=0

echo ""
echo "Running Tests..."

# Test 1
TABLE=$(mysql -h$HOST -u$USER -p$PASS -Nse \
"USE CollegeDB; SHOW TABLES LIKE 'Student';")

if [ "$TABLE" = "Student" ]; then
    echo "✅ Student table exists"
    TOTAL=$((TOTAL+2))
else
    echo "❌ Student table missing"
    exit 1
fi

# Test 2
PK=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND CONSTRAINT_NAME='PRIMARY';
")

if [ "$PK" = "StudentID" ]; then
    echo "✅ Primary Key correct"
    TOTAL=$((TOTAL+2))
else
    echo "❌ Primary Key incorrect"
fi

# Test 3
NAME=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='StudentName';
")

if [ "$NAME" = "varchar(20)" ]; then
    echo "✅ StudentName datatype"
    TOTAL=$((TOTAL+1))
else
    echo "❌ StudentName datatype"
fi

# Test 4
DOB=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='DOB';
")

if [ "$DOB" = "date" ]; then
    echo "✅ DOB datatype"
    TOTAL=$((TOTAL+1))
else
    echo "❌ DOB datatype"
fi

# Test 5
GENDER=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='Gender';
")

if [ "$GENDER" = "varchar(10)" ]; then
    echo "✅ Gender datatype"
    TOTAL=$((TOTAL+1))
else
    echo "❌ Gender datatype"
fi

# Test 6
DEPT=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='DepartmentID';
")

if [ "$DEPT" = "int" ]; then
    echo "✅ DepartmentID datatype"
    TOTAL=$((TOTAL+1))
else
    echo "❌ DepartmentID datatype"
fi

# Test 7
NOTNULL=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND IS_NULLABLE='NO';
")

if [ "$NOTNULL" -ge 5 ]; then
    echo "✅ NOT NULL constraints"
    TOTAL=$((TOTAL+1))
else
    echo "❌ NOT NULL constraints"
fi

# Test 8
UNIQUE=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND CONSTRAINT_TYPE='UNIQUE';
")

if [ "$UNIQUE" -ge 1 ]; then
    echo "✅ UNIQUE constraint"
    TOTAL=$((TOTAL+1))
else
    echo "❌ UNIQUE constraint missing"
fi

echo ""
echo "Final Score : $TOTAL / 10"

if [ "$TOTAL" -eq 10 ]; then
    exit 0
else
    exit 1
fi
