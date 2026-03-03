/*
===============================================================================
 Script:           Update DOCUMENTREQUEST State by POLICYNUMBER
 Description:      Updates all records in NYB_DOCUMENTREQUEST to COMPLETED
                   associated with the specified POLICYNUMBER list.
 Usage:            Edit the POLICYNUMBER list below as needed for each execution.
===============================================================================
*/

-- Declare needed variables at the top level
DECLARE @RecordsToUpdate INT;
DECLARE @Remaining INT;

-- Drop temp table if exists
IF OBJECT_ID('tempdb..#POLICIES_IDS') IS NOT NULL
    DROP TABLE #POLICIES_IDS;

/*
*****************************************************************************
***   EDIT ONLY THE POLICYNUMBER LIST BELOW AS NEEDED FOR EACH EXECUTION   ***
*****************************************************************************
*/
SELECT p.POLICIESID, p.POLICYNUMBER
INTO #POLICIES_IDS
FROM sysdba.POLICIES p
WHERE p.POLICYNUMBER IN (
    'U320692', 'U0399501', '5020120', '4230131264', 'JJ7050871', '156201825', 'V2417873',
    '46193843', 'US00001889', '4230124906', '17B363176', '004496358U', '020176083',
    'VMRE000246', 'JJ7146103', 'JJ7137438', 'JP5286413', 'VPA840325', '8640325',
    '93907848', 'UME104029L', '003000845', '7224263', '95567010', '20035101'
    -- Add or replace values as required
);

-- Pre-update audit: Get count of records to update
SELECT @RecordsToUpdate = COUNT(*)
FROM NYB_DOCUMENTREQUEST dr
INNER JOIN #POLICIES_IDS pi
    ON dr.POLICY_ID = pi.POLICIESID
WHERE dr.STATE != 'COMPLETED';

IF @RecordsToUpdate = 0
BEGIN
    PRINT 'No records to update. All are already COMPLETED.';
END
ELSE
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Update records to COMPLETED
        UPDATE dr
        SET dr.STATE = 'COMPLETED'
        FROM NYB_DOCUMENTREQUEST dr
        INNER JOIN #POLICIES_IDS pi
            ON dr.POLICY_ID = pi.POLICIESID
        WHERE dr.STATE != 'COMPLETED';

        PRINT CONCAT(CAST(@RecordsToUpdate AS varchar(10)), ' records were updated to COMPLETED.');

        -- Post-update validation
        SELECT @Remaining = COUNT(*)
        FROM NYB_DOCUMENTREQUEST dr
        INNER JOIN #POLICIES_IDS pi
            ON dr.POLICY_ID = pi.POLICIESID
        WHERE dr.STATE != 'COMPLETED';

        IF @Remaining = 0
            PRINT 'Validation OK: No records remain with incomplete state.';
        ELSE
            PRINT CONCAT('Warning: ', CAST(@Remaining AS varchar(10)), ' records still have incomplete state.');

        COMMIT TRANSACTION;
        PRINT 'Transaction successfully committed.';

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'ERROR: Transaction was rolled back.';
        PRINT ERROR_MESSAGE();
    END CATCH
END