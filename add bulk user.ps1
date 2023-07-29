clear
function Get-csvFile{
 
    Write-Host "> Enter the Address of your excel.csv Folder : "
    $folder = Read-Host
    cd $folder
    $folder = Get-ChildItem *.csv
    Write-Host "-----------------------------------------------------------------"
    for ($i=0 ; $i -lt $folder.Length ; $i++){
        Write-Host "`t"$($i+1)"`t"$folder[$i]
    }
    Write-Host "-----------------------------------------------------------------"
    Write-Host "> Select a file based on it's Number : "
    $userinput = Read-Host
    $folder[$userinput -1 ]

 }
function Users{
    $file = Get-csvFile
    $users = Import-Csv -Path $file

    $password = "P@ssw0rd"
 
    foreach ($user in $users) {

        New-ADUser -Name $user.FirstName -Surname $user.LastName -DisplayName $user.FirstName -path $user.OU  -GivenName $user.FirstName `
           -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -SamAccountName $user.SamAccountName -UserPrincipalName $user.UPN `
           -Enabled $true -ChangePasswordAtLogon $true
        
    }
}

function getaduser{

    foreach ($user in $users) {
       if(Get-ADUser -Filter " SamAccountName -eq'$($user.SamAccountName)'" -ErrorAction SilentlyContinue) {
       Write-Host "user $($user.Firstname) alredy exist.skipping recreation"
       }
       else { users }
    }
  
 }

function prop{
    do{ 
        Write-Host "> if you want to see all users ditails press 'y' else 'n' :"
        $in = Read-Host
        if($in -eq "y") {
            Get-ADUser -Filter *
            $invalidchoice = $false 
            Write-Host "================================================================================="
            Write-Host "> press 'Enter' to exit : "
      
            Write-Host "================================================================================="
            pause
            exit
        }
       elseif($in -eq "n") {
           Write-Host "================================================================================="
           Write-Host "> press 'Enter' to exit : "
    
           Write-Host "================================================================================="
           $invalidchoice = $false 
           pause
           exit
       }
       else {Write-Error ">> Invalid choice. please enter 'y' or 'n' ."
           $invalidchoice = $true
           }
   }until (!$invalidchoice)
 }
 
  Write-Host "================================================================================="
  Write-Host "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  Write-Host ">PLEASE READ THE THIS BEFORE USING THIS SCRIPT :"`n "the following columns should be created in Excel with exactly the same syntax;"`n "Then their rows should be filled;"`n `
   "And saved as '.csv' file and copy the 'FOLDER ADDRESS' to use in this script : "`n`n "FirstName "`n "LastName "`n "SamAccountName"`n "UPN"`n "OU"  
   Write-Host "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   Write-Host "================================================================================="
   users
   Write-Host "================================================================================="
   Write-Host "> press 'Enter' to test users are added or not : "
   Write-Host "================================================================================="
   pause
   getaduser
   prop
