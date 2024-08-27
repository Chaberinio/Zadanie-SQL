-- generowanie Tenants
DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    INSERT INTO Tenants (TenantName)
    VALUES (CONCAT('Tenant_', @i));
    SET @i = @i + 1;
END;
-- generowanie Users
DECLARE @i INT = 1;
DECLARE @TenantID INT;
WHILE @i <= 100
BEGIN
    SET @TenantID = (ABS(CHECKSUM(NEWID())) % 10) + 1; 
    INSERT INTO Users (TenantID, UserName, UserRole)
    VALUES ( 
        @TenantID,
        CONCAT('User_', @i),
        CASE WHEN @i % 2 = 0 THEN 'Employee' ELSE 'Manager' END
    );
    SET @i = @i + 1;
END;
-- geneorwanie przypisań UserAssigments
DECLARE @i INT = 1;
DECLARE @ManagerID INT;
DECLARE @EmployeeID INT;
WHILE @i <= 100
BEGIN
    SET @ManagerID = (ABS(CHECKSUM(NEWID())) % 50) + 1;
    SET @EmployeeID = (ABS(CHECKSUM(NEWID())) % 100) + 1; 
    IF @ManagerID != @EmployeeID
    BEGIN
        INSERT INTO UserAssignments (ManagerID, EmployeeID)
        VALUES (@ManagerID, @EmployeeID);
    END
    SET @i = @i + 1;
END;
-- generowanie zadan Tasks
DECLARE @UserID INT;
DECLARE @i INT = 1;
DECLARE @TaskCount INT = 1000;

DECLARE user_cursor CURSOR FOR
SELECT UserID FROM Users;

OPEN user_cursor;

FETCH NEXT FROM user_cursor INTO @UserID;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @j INT = 1;
    WHILE @j <= @TaskCount
    BEGIN
        INSERT INTO Tasks (TenantID, UserID, TaskTitle, TaskPriority, TaskDescription, TaskStatus)
        VALUES (
            (ABS(CHECKSUM(NEWID())) % 10) + 1,
            @UserID,
            CONCAT('Task_', @j, '_User_', @UserID),
            CASE WHEN @j % 3 = 0 THEN 'Low' WHEN @j % 3 = 1 THEN 'Medium' ELSE 'High' END,
            CONCAT('Description for Task_', @j, ' for User_', @UserID),
            CASE WHEN @j % 3 = 0 THEN 'Open' WHEN @j % 3 = 1 THEN 'In Progress' ELSE 'Completed' END
        );
        SET @j = @j + 1;
    END;

    FETCH NEXT FROM user_cursor INTO @UserID;
END;

CLOSE user_cursor;

--generowanie histori zmian
DECLARE @TaskID INT;
DECLARE @ChangedBy INT;
DECLARE @i INT = 1;
DECLARE @TaskCount INT = 100000;
DECLARE @UserCount INT = 100; 


WHILE @i <= @TaskCount
BEGIN
    SET @TaskID = @i;

    DECLARE @j INT = 1;
    WHILE @j <= 5
    BEGIN
        SET @ChangedBy = (ABS(CHECKSUM(NEWID())) % @UserCount) + 1;

        INSERT INTO TaskHistory (TaskID, ChangedAt, ChangedBy, TaskTitle, TaskPriority, TaskDescription, TaskStatus)
        VALUES (
            @TaskID,
            DATEADD(DAY, -@j, GETDATE()),
            @ChangedBy,
            CONCAT('Task_', @TaskID),
            CASE WHEN @j % 3 = 0 THEN 'Low' WHEN @j % 3 = 1 THEN 'Medium' ELSE 'High' END,
            CONCAT('Description for Task_', @TaskID),
            CASE WHEN @j % 3 = 0 THEN 'Open' WHEN @j % 3 = 1 THEN 'In Progress' ELSE 'Completed' END
        );

        SET @j = @j + 1;
    END

    SET @i = @i + 1;
END;
DEALLOCATE user_cursor;

-- generowanie udostępnien zadań
DECLARE @TaskID INT;
DECLARE @SharedWithUserID INT;
DECLARE @i INT = 1;
DECLARE @TaskCount INT = 100000;
DECLARE @UserCount INT = 100; 


WHILE @i <= @TaskCount
BEGIN
    SET @TaskID = @i;


    DECLARE @j INT = 1;
    WHILE @j <= 10 
    BEGIN
        SET @SharedWithUserID = (ABS(CHECKSUM(NEWID())) % @UserCount) + 1;

        INSERT INTO TaskShare (TaskID, SharedWithUserID)
        VALUES (@TaskID, @SharedWithUserID);

        SET @j = @j + 1;
    END

    SET @i = @i + 1;
END;
