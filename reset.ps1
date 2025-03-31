# PowerShell-Skript zum Zurücksetzen des Benutzerprofils "student"

$UserProfile = "C:\Users\student"
$BackupProfile = "C:\Users\studentclean"

# Prüfen, ob das aktuelle Profil existiert und löschen
if (Test-Path $UserProfile) {
    Write-Output "Lösche altes Profil: $UserProfile"
    Remove-Item -Path $UserProfile -Recurse -Force
}

# Neues Profil aus "studentclean" kopieren
if (Test-Path $BackupProfile) {
    Write-Output "Kopiere neues Profil aus $BackupProfile"
    Copy-Item -Path "$BackupProfile\*" -Destination $UserProfile -Recurse -Force
    
    # Setzt die korrekten Berechtigungen für den Benutzer "student"
    $acl = Get-Acl $UserProfile
    $user = "student"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl -Path $UserProfile -AclObject $acl
} else {
    Write-Output "Fehler: Standardprofil 'studentclean' nicht gefunden!"
}
