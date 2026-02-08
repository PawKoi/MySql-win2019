$basedir = "C:\Program Files\MySQL\MySQL Server 8.0"
$datadir = "$basedir\Data"

# Create data dir if missing
New-Item -ItemType Directory -Path $datadir -Force | Out-Null

# Optional: simple config file
@"
[mysqld]
basedir="$basedir"
datadir="$datadir"
port=3306
"@ | Set-Content -Path "C:\my.ini" -Encoding ASCII
