CREATE TABLE Tenants (
    TenantID INT PRIMARY KEY IDENTITY(1,1),
    TenantName NVARCHAR(255) NOT NULL
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    TenantID INT,
    UserName NVARCHAR(255) NOT NULL,
    UserRole NVARCHAR(50) NOT NULL CHECK (UserRole IN ('Employee', 'Manager')),
    FOREIGN KEY (TenantID) REFERENCES Tenants(TenantID)
);

CREATE TABLE UserAssignments (
    ManagerID INT,
    EmployeeID INT,
    PRIMARY KEY (ManagerID, EmployeeID),
    FOREIGN KEY (ManagerID) REFERENCES Users(UserID),
    FOREIGN KEY (EmployeeID) REFERENCES Users(UserID)
);

CREATE TABLE Tasks (
    TaskID INT PRIMARY KEY IDENTITY(1,1),
    TenantID INT,
    UserID INT,
    TaskTitle NVARCHAR(255) NOT NULL,
    TaskPriority NVARCHAR(50) NOT NULL CHECK (TaskPriority IN ('Low', 'Medium', 'High')),
    TaskDescription NVARCHAR(MAX),
    TaskStatus NVARCHAR(50) NOT NULL CHECK (TaskStatus IN ('Open', 'In Progress', 'Completed')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TenantID) REFERENCES Tenants(TenantID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE TaskHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
    TaskID INT,
    ChangedAt DATETIME DEFAULT GETDATE(),
    ChangedBy INT,
    TaskTitle NVARCHAR(255),
    TaskPriority NVARCHAR(50),
    TaskDescription NVARCHAR(MAX),
    TaskStatus NVARCHAR(50),
    FOREIGN KEY (TaskID) REFERENCES Tasks(TaskID),
    FOREIGN KEY (ChangedBy) REFERENCES Users(UserID)
);

CREATE TABLE TaskShare (
    TaskID INT,
    SharedWithUserID INT,
    PRIMARY KEY (TaskID, SharedWithUserID),
    FOREIGN KEY (TaskID) REFERENCES Tasks(TaskID),
    FOREIGN KEY (SharedWithUserID) REFERENCES Users(UserID)
);
