# Настройки
$baseUrl = "https://raw.githubusercontent.com"
$soundsDir = "Sounds"
$outputFile = "catalog.json"

if (-not (Test-Path $soundsDir)) { 
    Write-Error "Папка $soundsDir не найдена!"; pause; exit 
}

$catalog = Get-ChildItem -Path $soundsDir -Directory | ForEach-Object {
    $categoryName = $_.Name
    $files = Get-ChildItem -Path $_.FullName -File | Where-Object { $_.Extension -match "mp3|wav" }
    
    if ($files.Count -gt 0) {
        @{
            Name = $categoryName
            Sounds = $files | ForEach-Object {
                @{
                    Name = $_.Name
                    # Кодируем спецсимволы в URL (пробелы и т.д.)
                    Url = "$baseUrl/$categoryName/$($_.Name)" -replace ' ', '%20'
                }
            }
        }
    }
}

$catalog | ConvertTo-Json -Depth 5 | Out-File -FilePath $outputFile -Encoding utf8
Write-Host "--- Готово! catalog.json обновлен ---" -ForegroundColor Green
