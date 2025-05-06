# File Copy Script for Specific Extensions

This PowerShell script copies files with specific extensions from a source directory to a destination directory on a Windows Server. It is designed to handle a list of uncommon file extensions, log operations, and manage errors.

## Purpose
The script copies files from `C:\inetpub\wwwroot\fitripm\HL7\Files\outbound` to `D:\Lockboxfolder` for files with extensions like `.drv`, `.uxz`, `.0mc`, etc. It ensures the destination folder exists, logs copied files, and reports errors.

## Prerequisites
- **Windows Server** with PowerShell (tested on Windows Server 2016+).
- **Permissions**:
  - Read access to `C:\inetpub\wwwroot\fitripm\HL7\Files\outbound`.
  - Write access to `D:\Lockboxfolder` and `C:\` (for logs).
- PowerShell execution policy set to allow scripts (e.g., `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`).

## Usage
1. Clone or download this repository.
2. Open PowerShell as Administrator.
3. Navigate to the script directory:
   ```powershell
   cd path\to\repository