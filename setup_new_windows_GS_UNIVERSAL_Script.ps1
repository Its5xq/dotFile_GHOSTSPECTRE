function install_scoop {
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

  if ( Get-Command "scoop" -ErrorAction SilentlyContinue -eq $null) {
      scoop update
  } else {
      iwr -useb get.scoop.sh | iex 
  }
}

function install_scoop_apps {
  scoop install winget sudo wget curl winfetch ffmpeg
}

# make a function that takes in the app name and installs it
function install_winget_app($name) {
  winget install --silent --accept-package-agreements --accept-source-agreements --force -e $name
}

function uninstall_winget_app($name) {
  winget uninstall --silent $name
}

function add_winfetch_to_profile {
  $str = Get-Content $profile -Tail 1 
  if ($str -notmatch "winfetch") {
    [System.IO.File]::AppendAllText($profile, "winfetch")
  }
}


# make an array of apps
[string[]] $apps = @(
  "Microsoft.WindowsTerminal"
  "Microsoft.PowerShell"
  "Google.Chrome"
  "RARLab.WinRAR"
  "Oracle.JavaRuntimeEnvironment"
  #"OpenJS.NodeJS"
  #"Python.Python.2"
  #"Python.Python.3"
  "VideoLAN.VLC"
  #"IObit.AdvancedSystemCare"
  #"IObit.Uninstaller"
  "Notepad++.Notepad++"
  #"Valve.Steam"
)

[string[]] $bloat_apps = @(

)

install_scoop
install_scoop_apps

foreach ($app in $apps) {
  write-host "* Installing $app" -ForegroundColor Green 
  install_winget_app($app)
}

foreach ($app in $bloat_apps) {
  write-host "* Uninstalling $app" -ForegroundColor Red 
  uninstall_winget_app($app)
}

add_winfetch_to_profile

Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer"