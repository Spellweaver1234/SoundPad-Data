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
        $soundsArray = @( $files | ForEach-Object {
            # Кодируем имя файла правильно для URL (включая пробелы и спецсимволы)
            $encodedFileName = [Uri]::EscapeDataString($_.Name)
            $fullUrl = "$baseUrl/$categoryName/$encodedFileName"
            
            @{
                Name = $_.Name
                Url  = $fullUrl
            }
        })

        @{
            Name   = $categoryName
            Sounds = $soundsArray
        }
    }
}

$catalog | ConvertTo-Json -Depth 5 | Out-File -FilePath $outputFile -Encoding utf8
Write-Host "--- Готово! catalog.json обновлен ---" -ForegroundColor Green
