#!/bin/bash

HOST=127.0.0.1
USER=root
PASS=root

SCORE=0

echo "======================================"
echo " Student Table SQL Autograder"
echo "======================================"

echo ""
echo "Preparing Database..."

mysql -h$HOST -u$USER -p$PASS <<EOF
DROP DATABASE IF EXISTS CollegeDB;
CREATE DATABASE CollegeDB;

USE CollegeDB;

CREATE TABLE Department(
    DepartmentID INT(5) PRIMARY KEY,
    DepartmentName VARCHAR(20),
    HOD VARCHAR(20)
);
EOF

echo ""
echo "Executing student SQL file..."

mysql -h$HOST -u$USER -p$PASS < starter.sql

if [ $? -ne 0 ]; then
    echo "❌ SQL execution failed. Check your starter.sql"
    exit 1
fi


echo ""
echo "Checking Student Table..."
echo "--------------------------------"


# Test 1: Student table exists
TABLE=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SHOW TABLES FROM CollegeDB LIKE 'Student';
")

if [ "$TABLE" = "Student" ]; then
    echo "✅ Student table exists (2 Marks)"
    SCORE=$((SCORE+2))
else
    echo "❌ Student table missing (0 Marks)"
fi


# Test 2: StudentID column
COLUMN=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='StudentID';
")

if [ "$COLUMN" = "StudentID" ]; then
    echo "✅ StudentID column exists (1 Mark)"
    SCORE=$((SCORE+1))
else
    echo "❌ StudentID column missing"
fi


# Test 3: Primary Key
PK=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND CONSTRAINT_NAME='PRIMARY';
")

if [ "$PK" = "StudentID" ]; then
    echo "✅ StudentID is Primary Key (2 Marks)"
    SCORE=$((SCORE+2))
else
    echo "❌ Primary Key missing"
fi


# Test 4: StudentName datatype
NAME=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='StudentName';
")

if [ "$NAME" = "varchar(20)" ]; then
    echo "✅ StudentName VARCHAR(20) (1 Mark)"
    SCORE=$((SCORE+1))
else
    echo "❌ StudentName datatype incorrect"
fi


# Test 5: DOB datatype
DOB=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='DOB';
")

if [ "$DOB" = "date" ]; then
    echo "✅ DOB DATE datatype (1 Mark)"
    SCORE=$((SCORE+1))
else
    echo "❌ DOB datatype incorrect"
fi


# Test 6: Gender datatype
GENDER=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='Gender';
")

if [ "$GENDER" = "varchar(10)" ]; then
    echo "✅ Gender VARCHAR(10) (1 Mark)"
    SCORE=$((SCORE+1))
else
    echo "❌ Gender datatype incorrect"
fi


# Test 7: DepartmentID datatype
DEPT=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='DepartmentID';
")

if [ "$DEPT" = "int" ]; then
    echo "✅ DepartmentID datatype (1 Mark)"
    SCORE=$((SCORE+1))
else
    echo "❌ DepartmentID datatype incorrect"
fi


# Test 8: NOT NULL constraints
NULLCOUNT=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND IS_NULLABLE='NO';
")

if [ "$NULLCOUNT" -ge 5 ]; then
    echo "✅ NOT NULL constraints (1 Mark)"
    SCORE=$((SCORE+1))
else
    echo "❌ NOT NULL constraints missing"
fi


# Test 9: UNIQUE constraint
UNIQUE=$(mysql -h$HOST -u$USER -p$PASS -Nse "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND CONSTRAINT_TYPE='UNIQUE';
")

if [ "$UNIQUE" -ge 1 ]; then
    echo "✅ UNIQUE constraint (1 Mark)"
    SCORE=$((SCORE+1))
else
    echo "❌ UNIQUE constraint missing"
fi


echo ""
echo "======================================"
echo "Final Score : $SCORE / 10"
echo "======================================"


if [ "$SCORE" -eq 10 ]; then
    echo "🎉 Assignment Passed"
    exit 0
else
    echo "⚠️ Assignment Failed"
    exit 1
fi
