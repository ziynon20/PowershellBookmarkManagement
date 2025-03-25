# Define the bookmark URL and name
$bookmarkUrl = "https://www.google.com"
$bookmarkName = "Google"

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

        # Add the new bookmark to the Bookmarks Bar
        $newBookmark = @{
            url = $bookmarkUrl
            name = $bookmarkName
            type = "url"
        }

        $bookmarksJson.roots.bookmark_bar.children += $newBookmark

        # Write the modified JSON back to the Bookmarks file
        $bookmarksJson | ConvertTo-Json -Depth 10 | Set-Content -Path $bookmarksFile

        Write-Output "Added bookmark to the Bookmarks Bar for profile: $($_.Name)"
    }
}
