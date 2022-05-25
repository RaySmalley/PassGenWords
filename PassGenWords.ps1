# Disable progress bar for faster downloads
$global:ProgressPreference = 'SilentlyContinue'

function Download {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$URL,
	    [Parameter(Mandatory)][string]$Name,
	    [Parameter(Mandatory)][string]$Extension
	)
    $Error.Clear()
    if ($URL -match "\....$") {
		$Filename = Split-Path $URL -Leaf
	} else {
		$Filename = $Name + ".$Extension"
	}
    $Output = $env:TEMP + "\$Filename" -replace '...$',$Extension
    #$Name = $Name -csplit '(?=[A-Z])' -ne '' -join ' '
    #Write-Host "Downloading $Name..."`n
    if (!(Test-Path $Output)) {(New-Object System.Net.WebClient).DownloadFile($URL, $Output)}
    if ($Error.count -gt 0) {Write-Host "Retrying..."`n; $Error.Clear(); (New-Object System.Net.WebClient).DownloadFile($URL, $Output)}
    if ($Error.count -gt 0) {Write-Warning "$Name download failed";Write-Host}
    New-Variable -Name $Name"Output" -Value $Output -Scope Global -Force
}

function pgw {
    Download -Name WordList -URL https://github.com/RaySmalley/PassGenWords/raw/main/WordList.txt -Extension txt
    $FirstWord = (Get-Culture).TextInfo.ToTitleCase($(Get-Random (Get-Content $WordListOutput | where {$_.Length -gt 4})))
    $SecondWord = (Get-Culture).TextInfo.ToTitleCase($(Get-Random (Get-Content $WordListOutput | where {$_.Length -gt 4})))
    $ThirdWord = (Get-Culture).TextInfo.ToTitleCase($(Get-Random (Get-Content $WordListOutput | where {$_.Length -gt 4})))
    Write-Host "Password added to clipboard: " -ForegroundColor Cyan -NoNewline
    Write-Host $FirstWord -ForegroundColor Red -NoNewline
    Write-Host - -NoNewline
    Write-Host $SecondWord -ForegroundColor Yellow -NoNewline
    Write-Host - -NoNewline
    Write-Host $ThirdWord -ForegroundColor Green
    Set-Clipboard $FirstWord-$SecondWord-$ThirdWord
}