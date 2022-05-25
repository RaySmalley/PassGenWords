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

Download -Name WordList -URL https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt -Extension txt

$FirstWord = (Get-Culture).TextInfo.ToTitleCase($(Get-Random (Get-Content $WordListOutput | where {$_.Length -gt 4})))
$SecondWord = (Get-Culture).TextInfo.ToTitleCase($(Get-Random (Get-Content $WordListOutput | where {$_.Length -gt 4})))
$ThirdWord = (Get-Culture).TextInfo.ToTitleCase($(Get-Random (Get-Content $WordListOutput | where {$_.Length -gt 4})))

Write-Host $FirstWord -ForegroundColor Cyan -NoNewline
Write-Host $SecondWord -ForegroundColor Green -NoNewline
Write-Host $ThirdWord -ForegroundColor Yellow