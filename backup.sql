DECLARE @pathName NVARCHAR(512) 
SET @pathName = 'C:\Backup\dbbackups\db_backup_' + Convert(varchar(8), GETDATE(), 112) + '.bak' 
BACKUP DATABASE [Showbusiness] TO  DISK = @pathName WITH NOFORMAT, NOINIT,  NAME = N'db_backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10