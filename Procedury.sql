
CREATE PROCEDURE AddUser
    @TenantID INT,
    @UserName NVARCHAR(255),
    @UserRole NVARCHAR(50)
AS
BEGIN
    INSERT INTO Users (TenantID, UserName, UserRole)
    VALUES (@TenantID, @UserName, @UserRole);
END;
GO

CREATE PROCEDURE AddTask
    @TenantID INT,
    @UserID INT,
    @TaskTitle NVARCHAR(255),
    @TaskPriority NVARCHAR(50),
    @TaskDescription NVARCHAR(MAX),
    @TaskStatus NVARCHAR(50)
AS
BEGIN
    INSERT INTO Tasks (TenantID, UserID, TaskTitle, TaskPriority, TaskDescription, TaskStatus)
    VALUES (@TenantID, @UserID, @TaskTitle, @TaskPriority, @TaskDescription, @TaskStatus);
END;
GO

CREATE PROCEDURE AddUserAssignment
    @ManagerID INT,
    @EmployeeID INT
AS
BEGIN
    INSERT INTO UserAssignments (ManagerID, EmployeeID)
    VALUES (@ManagerID, @EmployeeID);
END;
GO

CREATE PROCEDURE GetTasksForUser
    @UserID INT
AS
BEGIN
    SELECT * FROM Tasks
    WHERE UserID = @UserID;
END;
GO

CREATE PROCEDURE GetTasksForManager
    @ManagerID INT
AS
BEGIN
    SELECT t.*
    FROM Tasks t
    JOIN UserAssignments ua ON t.UserID = ua.EmployeeID
    WHERE ua.ManagerID = @ManagerID
    UNION
    SELECT * FROM Tasks
    WHERE UserID = @ManagerID;
END;
GO
