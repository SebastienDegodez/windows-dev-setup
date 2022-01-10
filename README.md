# windows-dev-setup
Dev environment on windows

## Install Windows Terminal

- [Github](https://github.com/microsoft/terminal/releases)
 
## Install posh-git and oh-my-posh

![ps-oh-my-posh](https://user-images.githubusercontent.com/2349146/148851615-b4bb7421-4649-4ef2-b826-26cf463ebd13.png)

Open powershell and install module

```
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
```

### Install Caskaydia Cove Nerd Font
https://www.nerdfonts.com/font-downloads

### Configuration Profile

Open powershell 

```
notepad $PROFILE
```
Add 
```
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme paradox
```

In Windows Terminal Settings, set the default font:
```
"font": 
{
    "face": "CaskaydiaCove NF"
},
```
