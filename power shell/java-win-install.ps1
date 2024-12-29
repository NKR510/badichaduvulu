# Ensure you run this script as Administrator

# Set variables
$JavaBuild = "23.0.1"  # Replace with the exact build if needed
$InstallerPath = "C:\Users\konda.r.nagireddy\Documents\java\jdk-23_windows-x64_bin.msi"  # Path to the MSI file
$InstallPath = "C:\Program Files\Java\jdk-23"  # Target installation directory

# Install Java using MSI
function Install-Java-MSI {
    Write-Host "Installing Java $JavaBuild from $InstallerPath..." -ForegroundColor Cyan
    if (Test-Path $InstallerPath) {
        Start-Process -FilePath $InstallerPath -ArgumentList "/quiet", "/norestart", "INSTALLDIR=$InstallPath" -Wait
        Write-Host "Java $JavaBuild installed successfully to $InstallPath." -ForegroundColor Green
    } else {
        Write-Host "Installer path $InstallerPath does not exist. Please check the path." -ForegroundColor Red
        exit 1
    }
}

# Set environment variables
function Set-JavaEnvironmentVariables {
    if (Test-Path $InstallPath) {
        [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $InstallPath, [System.EnvironmentVariableTarget]::Machine)
        $Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
        [System.Environment]::SetEnvironmentVariable("Path", "$InstallPath\bin;$Path", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "JAVA_HOME and PATH environment variables set." -ForegroundColor Green
    } else {
        Write-Host "Java installation directory not found. Skipping environment variable setup." -ForegroundColor Red
    }
}

# Main script execution
try {
    Install-Java-MSI
    Set-JavaEnvironmentVariables
    Write-Host "Java installation completed successfully!" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
