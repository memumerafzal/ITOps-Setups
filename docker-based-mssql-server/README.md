# 🐳 Run SQL Server in Docker with Persistent Storage (Beginner Guide)

This guide helps you set up **Microsoft SQL Server** using **Docker on Windows**, with local folders to save your database and backup files — even if Docker crashes or the container is deleted.

---

## 📦 What You'll Need

- Windows 10/11 with Docker Desktop installed
- Basic knowledge of PowerShell or Command Prompt
- SQL Server Management Studio (SSMS) installed

---

## 📁 Step 1: Create Folders on Your Computer

Before running the SQL Server container, create these folders:

```plaintext
C:\docker-sql-data     ← stores your .mdf and .ldf database files
C:\mssql-backups       ← stores your .bak backup files
```
---
## 🐳 Step 2: Run the SQL Server Docker Container
- Open PowerShell as Administrator and run: .ps1 file placed in home directory.
---

---
## 🧠 Step 3: Connect Using SSMS
- Open SQL Server Management Studio (SSMS)
- Connect to: localhost,1433
- Use SQL Server Authentication:

```plaintext
Login: sa  ← username
Password: YourStrong!Passw0rd ← Pass
```
---
## 🗂️ Step 4: Restore a .bak File
- Copy your .bak file into C:\mssql-backups
- In SSMS:Right-click Databases → Restore Database
- Select Device → Add → find file at:
```plaintext /var/opt/mssql/backup/yourfile.bak ```
- Click OK
- Make sure file paths look like:

- Data File (MDF): ```plaintext /var/opt/mssql/data/YourDB.mdf ```
- Log File (LDF): ```plaintext /var/opt/mssql/data/YourDB_log.ldf ```
---
## 🔄 Step 5: Backup Your Database
- To backup your DB, run this SQL query in SSMS:
```plaintext
BACKUP DATABASE YourDB
TO DISK = '/var/opt/mssql/backup/YourDB.bak'
```
---

## 🧪 Optional: Check Files Inside Container
- You can check your files inside the Docker container:
```plaintext
docker exec -it sql2022 bash
ls /var/opt/mssql/data
ls /var/opt/mssql/backup
```
----

### Thank you ! Umer