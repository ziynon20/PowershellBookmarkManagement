# Define the Chrome User Data folder path
$chromeUserDataPath = "$env:LOCALAPPDATA\Google\Chrome\User Data"

# Check if the User Data folder exists
if (-Not (Test-Path -Path $chromeUserDataPath)) {
    Write-Output "Chrome User Data folder not found."
    exit
}

do {
    # Prompt the user for bookmark details
    $bookmarkUrl = Read-Host "Enter the URL for the bookmark"
    $bookmarkName = Read-Host "Enter the name for the bookmark"
    $locationChoice = Read-Host "Add to Bookmarks Bar or a Folder? (Type 'bar' or 'folder')"

    if ($locationChoice -eq "folder") {
        $folderName = Read-Host "Enter the name of the folder"
    }

    # Process the Default profile and profiles with "profile" in their name
    Get-ChildItem -Path $chromeUserDataPath -Directory | Where-Object {
        $_.Name -eq "Default" -or $_.Name -match "profile"
    } | ForEach-Object {
        $profilePath = $_.FullName
        $bookmarksFile = Join-Path -Path $profilePath -ChildPath "Bookmarks"

        if (Test-Path -Path $bookmarksFile) {
            try {
                # Read and parse the JSON from the Bookmarks file
                $bookmarksJson = Get-Content -Path $bookmarksFile -Raw | ConvertFrom-Json

                if ($locationChoice -eq "folder") {
                    # Check if the folder exists, and create it if necessary
                    if (-Not ($bookmarksJson.roots.bookmark_bar.children | Where-Object { $_.name -eq $folderName -and $_.type -eq "folder" })) {
                        $newFolder = @{
                            name = $folderName
                            type = "folder"
                            children = @()
                        }
                        $bookmarksJson.roots.bookmark_bar.children += $newFolder
                    }

                    # Add the new bookmark to the folder
                    $targetFolder = $bookmarksJson.roots.bookmark_bar.children | Where-Object { $_.name -eq $folderName -and $_.type -eq "folder" }
                    $newBookmark = @{
                        url = $bookmarkUrl
                        name = $bookmarkName
                        type = "url"
                    }
                    $targetFolder.children += $newBookmark
                } else {
                    # Add the new bookmark to the Bookmarks Bar
                    $newBookmark = @{
                        url = $bookmarkUrl
                        name = $bookmarkName
                        type = "url"
                    }
                    $bookmarksJson.roots.bookmark_bar.children += $newBookmark
                }

                # Write the modified JSON back to the Bookmarks file
                $bookmarksJson | ConvertTo-Json -Depth 10 | Set-Content -Path $bookmarksFile

                Write-Output "Successfully added bookmark '$bookmarkName' to $locationChoice for profile: $($_.Name)"
            } catch {
                Write-Output "Failed to add bookmark to profile: $($_.Name). Error: $($_.Exception.Message)"
            }
        } else {
            Write-Output "Bookmarks file not found for profile: $($_.Name)"
        }
    }

    # Ask if the user wants to add another bookmark
    $addAnother = Read-Host "Do you want to add another bookmark? (yes or no)"
} while ($addAnother -eq "yes")
