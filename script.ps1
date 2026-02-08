# Run as Administrator

$mysqlUrl  = "https://cdn.mysql.com//Downloads/MySQL-8.4/mysql-8.4.7-winx64.zip"  # <- paste your (desired) URL here for another version
$zipPath   = "C:\Temp\mysql.zip"
$installDir = "C:\mysql"
$dataDir    = "C:\mysql-data"

New-Item -ItemType Directory -Path (Split-Path $zipPath) -Force | Out-Null
New-Item -ItemType Directory -Path $installDir -Force | Out-Null
New-Item -ItemType Directory -Path $dataDir -Force | Out-Null

Invoke-WebRequest -Uri $mysqlUrl -OutFile $zipPath

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $installDir)

$sub = Get-ChildItem $installDir | Where-Object { $_.PSIsContainer } | Select-Object -First 1
if ($sub -and (Test-Path "$($sub.FullName)\bin")) {
    Get-ChildItem $sub.FullName | Move-Item -Destination $installDir -Force
    Remove-Item $sub.FullName -Recurse -Force
}

@"
[mysqld]
basedir="C:/mysql/"
datadir="C:/mysql-data/"
port=3306
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
"@ | Set-Content -Path "$installDir\my.ini" -Encoding ASCII

& "$installDir\bin\mysqld.exe" --initialize-insecure --basedir="$installDir" --datadir="$dataDir"
& "$installDir\bin\mysqld.exe" --install MySQL --defaults-file="$installDir\my.ini"
Start-Service MySQL
