# Windows

Write-Host PowerToys
Write-Host ----------------------------------------
winget install Microsoft.PowerToys --exact --no-upgrade --silent
Write-Host "DONE: Powertoys." -ForegroundColor Green

Write-Host Registry Update
Write-Host ----------------------------------------
## Show hidden files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden 1

## Show file extensions for known file types
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt 0
Write-Host "DONE: Registry updated." -ForegroundColor Green

# Git
Write-Host Git
Write-Host ----------------------------------------
winget install Git.Git --exact --no-upgrade --silent

git config --global user.name "SebastienDegodez"
git config --global user.email sebastien.degodez@gmail.com

Write-Host "DONE: git has been installed and user has been configured." -ForegroundColor Green

# Development Enviroment
Write-Host "Windows Terminal"
Write-Host ----------------------------------------
$winTerminal="Microsoft.WindowsTerminal"
winget install $winTerminal --exact --no-upgrade --silent
Write-Host "DONE: Windows Terminal" -ForegroundColor Green


Write-Host "Powershell"
Write-Host ----------------------------------------
winget install Microsoft.PowerShell --exact --no-upgrade --silent
Write-Host "DONE: Powershell" -ForegroundColor Green

Write-Host "OhMyPosh"
Write-Host ----------------------------------------
winget install JanDeDobbeleer.OhMyPosh --exact --no-upgrade --silent
Write-Host "DONE: Install OhMyPosh" -ForegroundColor Green

Write-Host "- Download CascadiaCode Nerd Fonts."
$request = Invoke-WebRequest -Uri "https://www.nerdfonts.com/font-downloads" -UseBasicParsing

foreach ($letter in $request.Links)
{
    $link = $letter.href
    if ($link -like  "*CascadiaCode.zip") { 
        $urlCascadia = $link
    }
}
$currentDir = Get-Location
$fileNameWithExtension = $urlCascadia.Split("/")[-1]
$fileName = $fileNameWithExtension -replace "[.zip]", ""
$pathName = "$currentDir\NerdFonts"
$fileNamePath = "$pathName\$fileNameWithExtension"

If (-not(Test-Path "$pathName")) {
    New-Item -Path $currentDir -Name "NerdFonts" -ItemType Directory
}

If (-not(Test-Path "$pathName\$fileName")) {
    New-Item -Path $pathName -Name "$fileName" -ItemType Directory

    Invoke-WebRequest -Uri $urlCascadia -OutFile $fileNamePath

    Expand-Archive -LiteralPath $fileNamePath -DestinationPath "$pathName\$fileName\"
}

$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)

Get-ChildItem -Path "$pathName\$fileName\" -Include '*.ttf','*.ttc','*.otf' -Recurse | ForEach {
    $targetPath = Join-Path "C:\Windows\Fonts" $_.Name
    #Write-Host $targetPath
    if($_.Name -like "*Regular*")
    {
        $Destination.CopyHere($_.FullName, 0x10 -bor 0x4 -bor 0x40)
    }

	if(Test-Path -Path $targetPath){
		$_.Name + " already installed"
	}
}

Write-Host "DONE: Install CascadiaCode Nerd Fonts." -ForegroundColor Green

Write-Host "- Activate OhMyPosh"

# Check if $PROFILE exists
$profileDir = Split-Path -Path $PROFILE

if (-Not (Test-Path -Path $profileDir)) {
    # Create the directory and file if it doesn't exist
    New-Item -ItemType Directory -Path $profileDir -Force
    New-Item -ItemType File -Path $PROFILE -Force


    # Activate OhMyPosh theme and add it to the config file
    Add-Content -Path $PROFILE -Value "`$OMP_THEME = `"`$env:LOCALAPPDATA/Programs/oh-my-posh/themes/paradox.omp.json`""
    Add-Content -Path $PROFILE -Value "& ([ScriptBlock]::Create((oh-my-posh init pwsh --config `"`$OMP_THEME`" --print) -join `"``n`"))"

    # Source the created config file in the current shell session
    & $PROFILE
}
Write-Host "DONE: Activate OhMyPosh" -ForegroundColor Green

Write-Host "- Configuration Windows.Terminal Font."
$fontname = "CaskaydiaCove Nerd Font"
$winTerminalPath = Get-Command wt | Select-Object -ExpandProperty Definition

$winTerminalAppData = "$ENV:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

# export settings.json
# clean up comment lines to prevent issues with older JSON parsers (looking at you Windows PowerShell)
$winTerminalJSON =  Get-Content "$winTerminalAppData\settings.json" | Where-Object { $_ -notmatch "^.*//.*$" -and $_ -ne "" -and $_ -ne $null} | ConvertFrom-Json

# Change all profil "powershell"
$winTerminalJSON.profiles.list | ForEach-Object {
    if ( $null -ne $_.Font.Face -and $_.Name -eq "PowerShell")
    {
        $_.Font.Face = $fontName
    }
    else
    {
        $pwshProfile = $_ | Where-Object { $_.Name -eq "PowerShell" }
        $pwshProfile | Add-Member -NotePropertyName font -NotePropertyValue ([PSCustomObject]@{face="$fontName"})
    }
}
   
# save settings
$winTerminalJSON | ConvertTo-Json -Depth 20 | Out-File "$winTerminalAppData\settings.json" -Force -Encoding utf8

############
Write-Host "DONE: OhMyPosh has been installed and configured for PowerShell." -ForegroundColor Green


# .NET SDK
Write-Host "Microsoft.DotNet SDK 8."
Write-Host -----------------------
winget install Microsoft.DotNet.SDK.8 --exact --no-upgrade --silent
Write-Host "DONE: " -ForegroundColor Green

# Docker
Write-Host "Podman."
Write-Host -----------------------
winget install RedHat.Podman --exact --no-upgrade --silent
Write-Host "DONE: " -ForegroundColor Green

# IDE
Write-Host "VSCode."
Write-Host -----------------------
winget install Microsoft.VisualStudioCode --exact --no-upgrade --silent

git config --global core.editor "code --wait"
Write-Host "DONE: VSCode has been installed and configured as a git editor." -ForegroundColor Green


Write-Host "WSL2."
Write-Host -----------------------
winget install Microsoft.WSL --exact --no-upgrade --silent
Write-Host "DONE: " -ForegroundColor Green
