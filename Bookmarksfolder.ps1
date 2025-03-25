# Define the bookmark URL and name
$bookmarkUrl = "https://www.google.com"
$bookmarkName = "Google"
$folderName = "test"

# Locate Chrome's User Data folder
$chromeUserDataPath = "$env:LOCALAPPDATA\Google\Chrome\User Data"
if (-Not (Test-Path -Path $chromeUserDataPath)) {
    Write-Output "Chrome User Data folder not found."
    exit
}

# Iterate through all profiles
Get-ChildItem -Path $chromeUserDataPath -Directory | ForEach-Object {
    $profilePath = $_.FullName
    $bookmarksFile = Join-Path -Path $profilePath -ChildPath "Bookmarks"

    if (Test-Path -Path $bookmarksFile) {
        # Read and parse the JSON from the Bookmarks file
        $bookmarksJson = Get-Content -Path $bookmarksFile -Raw | ConvertFrom-Json

        # Check if the folder 'test' exists, and create it if necessary
        if (-Not ($bookmarksJson.roots.bookmark_bar.children | Where-Object { $_.name -eq $folderName -and $_.type -eq "folder" })) {
            $newFolder = @{
                name = $folderName
                type = "folder"
                children = @()
            }
            $bookmarksJson.roots.bookmark_bar.children += $newFolder
        }

        # Add the new bookmark to the 'test' folder
        $testFolder = $bookmarksJson.roots.bookmark_bar.children | Where-Object { $_.name -eq $folderName -and $_.type -eq "folder" }
        $newBookmark = @{
            url = $bookmarkUrl
            name = $bookmarkName
            type = "url"
        }
        $testFolder.children += $newBookmark

        # Write the modified JSON back to the Bookmarks file
        $bookmarksJson | ConvertTo-Json -Depth 10 | Set-Content -Path $bookmarksFile

        Write-Output "Added bookmark to the '$folderName' folder for profile: $($_.Name)"
    }
}
