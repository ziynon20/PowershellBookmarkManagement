# Powershell
A collection of Useful Powershell scripts

**UserPrompts** is a interactive way of setting bookmarks for users in Chrome. 

1: To do this, Simply download or copy the script, 

2: sign into the account you want to set bookmarks for. This ensures the directory that is selected is C:\Users\%Username%\AppData\Local\Google\Chrome\User Data automatically.
  
  2A: You can also manually set the directory, To do this, 
    2A.1: Find "$chromeUserDataPath = "$env:LOCALAPPDATA\Google\Chrome\User Data" in the script
    2A.2: Replace the path with where you want. 

    For example, instead of "$env:LOCALAPPDATA\Google\Chrome\User Data" 
    You can set it manually to "C:\Users\JohnSmith\AppData\Local\Google\Chrome\User Data" 

3: Launch Powershell

4: Move into the directory where the script is

5: Type .\NameofScript
