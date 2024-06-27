$JAVAC="$env:JAVA_HOME/bin/javac"
$JAR="$env:JAVA_HOME/bin/jar"

$ErrorActionPreference = "Stop"

# HELPER METHODS
function GetFullPath([string] $path) {
    return [System.IO.Path]::GetFullPath("$pwd" + "/" + $path)
}

function GetFilesFromFolder([string] $path, [string] $pattern) {
    return [System.IO.Directory]::GetFiles($path, $pattern, [System.IO.SearchOption]::AllDirectories)
}

function GetJavaSourceString() {
    $result = ""
	
	if ($IsWindows) {
		$files = GetFilesFromFolder "$pwd\src\" "*.java"
    
		foreach ($file in $files) {
			$file = $file.replace("$pwd\src\", "")
			$result += "$file "
		}
	}
	
	if ($IsLinux) {
		$files = GetFilesFromFolder "$pwd/src/" "*.java"
    
		foreach ($file in $files) {
			$file = $file.replace("$pwd/src/", "")
			$result += "$file "
		}
	}
    
    return $result
}

function RemoveFolderIfExists([string] $path) {
    if (Test-Path -Path $path) {
        Remove-Item -Path $path -Recurse -Force > $null
    }
}

function CreateFolder([string] $name) {
    New-Item -Path . -Name $name -ItemType "directory" > $null
}

# BUILD METHODS
function InitBuild() {
    RemoveFolderIfExists "out"
    CreateFolder "out"
}

function BuildApplication() {
    $cwd = GetFullPath "."
    $src = GetJavaSourceString
	               
    try {
		Write-Host "Building java application"
        Set-Location "$cwd/src"
        Invoke-Expression "$JAVAC -cp $cwd/lib/jarqanore.jar -d $cwd/out -g $src > '$null'"
        Set-Location $cwd
    } catch {
        Write-Host $_
        Exit 1
    }
}

function CopyResources() {
    $cwd = GetFullPath "."

    Write-Host "Copying lib files"
    Copy-Item -Path "lib/" -Destination $cwd/out/ -Recurse > $null

    Write-Host "Copying asset files"
    Copy-Item -Path "assets/" -Destination $cwd/out/ -Recurse > $null
}

function BuildJar() {
    $cwd = GetFullPath "."
        
    try {
        Write-Host "Generating manifest files"
        Set-Location $cwd/out

        "Class-Path: lib/jarqanore.jar" | Out-File -FilePath WINDOW.mf -Encoding ascii
        "Main-Class: com.reapenshaw.examples.window.App" | Out-File -FilePath WINDOW.mf -Encoding ascii -Append

        "Class-Path: lib/jarqanore.jar" | Out-File -FilePath FONTS.mf -Encoding ascii
        "Main-Class: com.reapenshaw.examples.fonts.App" | Out-File -FilePath FONTS.mf -Encoding ascii -Append

        "Class-Path: lib/jarqanore.jar" | Out-File -FilePath SPRITES.mf -Encoding ascii
        "Main-Class: com.reapenshaw.examples.sprites.App" | Out-File -FilePath SPRITES.mf -Encoding ascii -Append

        "Class-Path: lib/jarqanore.jar" | Out-File -FilePath SHADERS.mf -Encoding ascii
        "Main-Class: com.reapenshaw.examples.shaders.App" | Out-File -FilePath SHADERS.mf -Encoding ascii -Append
    } catch {
        Write-Host $_
        Exit 1
    }
    
    try {
		Write-Host "Building jars"
        Set-Location $cwd/out
        Invoke-Expression "$JAR -cfm example-window.jar WINDOW.mf ./com/reapenshaw/examples/window/"
        Invoke-Expression "$JAR -cfe example-fonts.jar com.reapenshaw.examples.fonts.App ./com/reapenshaw/examples/fonts/"
        Invoke-Expression "$JAR -cfe example-shaders.jar com.reapenshaw.examples.shaders.App ./com/reapenshaw/examples/shaders/"
        Invoke-Expression "$JAR -cfe example-sprites.jar com.reapenshaw.examples.sprites.App ./com/reapenshaw/examples/sprites/"
        Set-Location $cwd
    } catch {
        Write-Host $_
        Exit 1
    }
}

function Cleanup() {
    $cwd = GetFullPath "."
    
    Write-Host "Cleanup"
    RemoveFolderIfExists "$cwd/out/com"
}

# EXECUTION
InitBuild
BuildApplication
BuildJar
CopyResources
Cleanup
