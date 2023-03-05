REM Удалить файлы старше 15 дней
ForFiles /p "C:\Backup\dbbackups" /s /d -15 /c "cmd /c del @file"
REM Создание бэкапа БД MSSQL
sqlcmd.exe -S (local)\SQLEXPRESS -i C:\Backup\backup.sql