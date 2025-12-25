$RepoRoot = Get-Location

function Add-MavenArtifact {
    param(
        [Parameter(Mandatory)]
        [string]$GroupId,
        [Parameter(Mandatory)]
        [string]$ArtifactId,
        [Parameter(Mandatory)]
        [string]$Version,
        [Parameter(Mandatory)]
        [string]$JarFile
    )

    if (!(Test-Path $JarFile)) {
        throw "Jar not found: $JarFile"
    }

    $GroupPath = $GroupId -replace '\.', '/'
    $ArtifactPath = Join-Path $RepoRoot "$GroupPath/$ArtifactId/$Version"

    New-Item -ItemType Directory -Force -Path $ArtifactPath | Out-Null

    $TargetJar = Join-Path $ArtifactPath "$ArtifactId-$Version.jar"
    Copy-Item $JarFile $TargetJar -Force

$PomContent = @"
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>$GroupId</groupId>
    <artifactId>$ArtifactId</artifactId>
    <version>$Version</version>
    <packaging>jar</packaging>
</project>
"@

    $PomFile = Join-Path $ArtifactPath "$ArtifactId-$Version.pom"
    Set-Content -Path $PomFile -Value $PomContent -Encoding UTF8

    Write-Host "Added ${GroupId}:${ArtifactId}:${Version} to repository."
}

Add-MavenArtifact `
    -GroupId "xyz.krypton.spigot" `
    -ArtifactId "pulse-spigot-api" `
    -Version "1.8.8-R0.1" `
    -JarFile ".\provided\pulse-spigot-api-1.8.8-R0.1.jar"

Add-MavenArtifact `
    -GroupId "com.boydti.fawe" `
    -ArtifactId "FastAsyncWorldEdit" `
    -Version "6.1.9-caf0ad9" `
    -JarFile ".\provided\FastAsyncWorldEdit-1.8.8.jar"

Add-MavenArtifact `
    -GroupId "org.bukkit" `
    -ArtifactId "craftbukkit" `
    -Version "1.8.8" `
    -JarFile ".\provided\CraftBukkit-1.8.8.jar"

Add-MavenArtifact `
    -GroupId "com.sk89q.worldedit" `
    -ArtifactId "worldedit-bukkit" `
    -Version "6.1.7;dd00bb1" `
    -JarFile ".\provided\WorldEdit-1.8.8.jar"

Write-Host "Repository was updated successfully."
