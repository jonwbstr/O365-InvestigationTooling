#This script will enable non-owner mailbox access auditing on every mailbox in your tenancy
#First, let's get us a cred!
$userCredential = Get-Credential

#This gets us connected to an Exchange remote powershell service
$ExoSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $userCredential -Authentication Basic -AllowRedirection
Import-PSSession $ExoSession

#Enable global audit logging
Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox" -or RecipientTypeDetails -eq "SharedMailbox" -or RecipientTypeDetails -eq "RoomMailbox" -or RecipientTypeDetails -eq "DiscoveryMailbox"} | Select-Object -exp userprincipalname | Set-Mailbox -AuditEnabled $true -AuditLogAgeLimit 180 -AuditOwner Create,HardDelete,MailboxLogin,Move,MoveToDeletedItems,SoftDelete,Update,UpdateFolderPermissions -AuditDelegate Create,HardDelete,Move,MoveToDeletedItems,SendAs,SendOnBehalf,SoftDelete,Update,UpdateFolderPermissions -AuditAdmin Copy,Create ,HardDelete ,Move,MoveToDeletedItems,SendAs,SendOnBehalf,SoftDelete,Update,UpdateFolderPermissions

#Double-Check It!
Get-Mailbox -ResultSize Unlimited | Select Name, AuditEnabled, AuditLogAgeLimit | Out-Gridview
