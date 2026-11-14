CREATE SCHEMA IF NOT EXISTS kthsocial;
SET search_path TO hospital;

DROP TABLE IF EXISTS Nurses;
DROP TABLE IF EXISTS Mentors;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Worksat;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

CREATE TABLE Departments(
    departmentName varchar(255) PRIMARY KEY, 
    buildingNR int NOT NULL
); 

CREATE TABLE Employees(
    employeeID int PRIMARY KEY, 
    phoneNR varchar(255) NOT NULL, 
    name varchar(255) NOT NULL,
    startDate date NOT NULL,
    departmentName varchar NOT NULL, 
    FOREIGN KEY (departmentName) REFERENCES Departments(departmentName)
);

CREATE TABLE Patients(
    patientID int PRIMARY KEY, 
    age int NOT NULL, 
    name varchar(255) NOT NULL, 
    diagnosis varchar(255)
); 

CREATE TABLE Doctors(
    employeeID int PRIMARY KEY, 
    specialization varchar(255), 
    roomNR int,
    FOREIGN KEY (employeeID) REFERENCES Employee(ID)
);

CREATE TABLE Treatments(
    patientID int NOT NULL, 
    doctorID int NOT NULL, 
    FOREIGN KEY (patientID) REFERENCES Patients(patientID), 
    FOREIGN KEY (doctorID) REFERENCES Doctors(employeeID),
    PRIMARY KEY (patientID, doctorID) 
);

CREATE TABLE Mentors(
    mentorID int UNIQUE,
    menteeID int UNIQUE, 
    FOREIGN KEY (mentorID) REFERENCES Employees(employeeID), 
    FOREIGN KEY (menteeID) REFERENCES Employees(employeeID),
    PRIMARY KEY (mentorID, menteeID)
);

CREATE TABLE Nurses (
    employeeID int PRIMARY KEY, 
    degree varchar(255), 
    FOREIGN KEY (employeeID) REFERENCES Employees(employeeID)
);

-- tests of insertstatements

-- insert into departments
INSERT INTO Departments VALUES('AVA', 14);
INSERT INTO Departments VALUES('IMA', 4);


