docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" `
 -p 1433:1433 --name sql2022 `
 -v C:\docker-sql-data:/var/opt/mssql/data `
 -v C:\mssql-backups:/var/opt/mssql/backup `
 -d mcr.microsoft.com/mssql/server:2022-latest
