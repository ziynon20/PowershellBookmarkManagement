# Powershell Bookmark Management

A collection of useful Powershell scripts.

## UserPrompts

**UserPrompts** is an interactive way of setting bookmarks for users in Chrome.

### Instructions

1. **Download or Copy the Script:**
   - Simply download or copy the script.

2. **Sign into the Account:**
   - Sign into the account you want to set bookmarks for. This ensures the directory that is selected is `C:\Users\%Username%\AppData\Local\Google\Chrome\User Data` automatically.

   2A. **Manually Set the Directory:**
   - To do this:
     1. Find `$chromeUserDataPath = "$env:LOCALAPPDATA\Google\Chrome\User Data"` in the script.
     2. Replace the path with where you want. 
        - For example, instead of `$env:LOCALAPPDATA\Google\Chrome\User Data`, you can set it manually to `C:\Users\JohnSmith\AppData\Local\Google\Chrome\User Data`.

3. **Launch Powershell:**
   - Launch Powershell.

4. **Move into the Directory:**
   - Move into the directory where the script is located.

5. **Run the Script:**
   - Type `.\NameofScript`.


# Disabling Sign In and Profile Creation in Chrome

If you want to disable profile creation or stop users from signing into Chrome so only the default profile is available to them, follow these steps:

1. Navigate to `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome` in Registry Editor.

2. Create the following DWORDs:

   - **For Blocking Signing into the Browser:**
     - Create a DWORD and call it `SigninAllowed` and set its value to `0`. This stops users from being able to sign into Chrome.
     - You can also use CMD or Powershell to create the RegEdit with this command:
       ```shell
       reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v SigninAllowed /t REG_DWORD /d 0 /f
       ```

   - **For Disabling Profiles:**
     - Create a DWORD and call it `BrowserAddPersonEnabled` and set its value to `0`. This stops users from being able to make profiles in Chrome, resulting in only the default profile being used.
     - You can also use CMD or Powershell to create the RegEdit with this command:
       ```shell
       reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v BrowserAddPersonEnabled /t REG_DWORD /d 0 /f
       ```




    





