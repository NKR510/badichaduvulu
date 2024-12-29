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

# Print Java version
function Print-JavaVersion {
    try {
        Write-Host "Checking installed Java version..." -ForegroundColor Cyan
        $JavaVersionOutput = java -version 2>&1
        Write-Host "Java version installed:" -ForegroundColor Green
        Write-Host $JavaVersionOutput
    } catch {
        Write-Host "Unable to determine Java version. Please check your installation." -ForegroundColor Red
    }
}

# Main script execution
try {
    Install-Java-MSI
    Set-JavaEnvironmentVariables
    Print-JavaVersion
    Write-Host "Java installation completed successfully!" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}

#OUTPUT
#PS C:\Users\konda.r.nagireddy\Documents\java> .\InstallJava.ps1
# Installing Java 23.0.1 from C:\Users\konda.r.nagireddy\Documents\java\jdk-23_windows-x64_bin.msi...
# Java 23.0.1 installed successfully to C:\Program Files\Java\jdk-23.
# JAVA_HOME and PATH environment variables set.
# Checking installed Java version...
# Java version installed:
# java version "23.0.1" 2024-10-15 Java(TM) SE Runtime Environment (build 23.0.1+11-39) Java HotSpot(TM) 64-Bit Server VM (build 23.0.1+11-39, mixed mode, sharing)
# Java installation completed successfully!

