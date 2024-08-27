CREATE PROCEDURE AddTenant
    @TenantName NVARCHAR(255)
AS
BEGIN
    INSERT INTO Tenants (TenantName)
    VALUES (@TenantName);
END;
GO

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

CREATE PROCEDURE UpdateTask
    @TaskID INT,
    @TaskTitle NVARCHAR(255) = NULL,
    @TaskPriority NVARCHAR(50) = NULL,
    @TaskDescription NVARCHAR(MAX) = NULL,
    @TaskStatus NVARCHAR(50) = NULL,
    @ChangedBy INT 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldTaskTitle NVARCHAR(255);
    DECLARE @OldTaskPriority NVARCHAR(50);
    DECLARE @OldTaskDescription NVARCHAR(MAX);
    DECLARE @OldTaskStatus NVARCHAR(50);
    DECLARE @OldUpdatedAt DATETIME;

    SELECT
        @OldTaskTitle = TaskTitle,
        @OldTaskPriority = TaskPriority,
        @OldTaskDescription = TaskDescription,
        @OldTaskStatus = TaskStatus,
        @OldUpdatedAt = UpdatedAt
    FROM Tasks
    WHERE TaskID = @TaskID;

    UPDATE Tasks
    SET
        TaskTitle = ISNULL(@TaskTitle, TaskTitle),
        TaskPriority = ISNULL(@TaskPriority, TaskPriority),
        TaskDescription = ISNULL(@TaskDescription, TaskDescription),
        TaskStatus = ISNULL(@TaskStatus, TaskStatus),
        UpdatedAt = GETDATE() 
    WHERE TaskID = @TaskID;

    INSERT INTO TaskHistory (TaskID, ChangedAt, ChangedBy, TaskTitle, TaskPriority, TaskDescription, TaskStatus)
    VALUES (
        @TaskID,
        GETDATE(),
        @ChangedBy,
        ISNULL(@TaskTitle, @OldTaskTitle),
        ISNULL(@TaskPriority, @OldTaskPriority),
        ISNULL(@TaskDescription, @OldTaskDescription),
        ISNULL(@TaskStatus, @OldTaskStatus)
    );
END;
GO
    
    
CREATE PROCEDURE DeleteTask
    @TaskID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM TaskHistory
    WHERE TaskID = @TaskID;

    DELETE FROM Tasks
    WHERE TaskID = @TaskID;
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

CREATE PROCEDURE GetTaskStatistics
    @StartDate DATE, 
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        U.UserID,
        U.UserName,
        FORMAT(T.CreatedAt, 'yyyy-MM') AS Month,
        T.TaskStatus,
        COUNT(*) AS TaskCount
    FROM Tasks T
    INNER JOIN Users U ON T.UserID = U.UserID
    WHERE T.CreatedAt BETWEEN @StartDate AND @EndDate
    GROUP BY 
        U.UserID,
        U.UserName,
        FORMAT(T.CreatedAt, 'yyyy-MM'),
        T.TaskStatus
    ORDER BY 
        U.UserID,
        Month,
        T.TaskStatus;
END;
GO

