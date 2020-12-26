#############################################
#   Autor: https://github.com/vcont
#   Descripcion: Query DHCP Server
#   
#############################################
#
#  Zabix Agent configuration
#   
#         UnsafeUserParameters=1
#         UserParameter=dhcp[*],powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\Zabbix Agent\conf\zabbix_dhcp_scope.ps1" "$1" "$2"


$ITEM = [string]$args[0]
$ID = [string]$args[1]

switch ($ITEM) {
  "Discovery" {
    # Open JSON object
    $output =  "{`"data`":["
      $query = Get-DhcpServerv4ScopeStatistics | Where {$_.Free -gt 0} | Select-Object ScopeId
      $count = $query | Measure-Object
      $count = $count.count
      foreach ($object in $query) {
        $Id = [string]$object.ScopeId
        if ($count -eq 1) {
          $output = $output + "{`"{#SCOPEID}`":`"$Id`"}"
        } else {
          $output = $output + "{`"{#SCOPEID}`":`"$Id`"},"
        }
        $count--
    }
    # Close JSON object
    $output = $output + "]}"
    Write-Host $output
  }
   
   "ScopeFree" {
  $query = Get-DhcpServerv4ScopeStatistics | Where-Object {$_.ScopeId -like "*$ID*"} | Select-Object Free
  foreach ($object in $query) {
  $Free = [string]$object.Free}
  $Free
    }

   "ScopeInUse" {
  $query = Get-DhcpServerv4ScopeStatistics | Where-Object {$_.ScopeId -like "*$ID*"} | Select-Object InUse
  foreach ($object in $query) {
  $InUse = [string]$object.InUse}
  $InUse
    }
    
   "ScopePercentageInUse" {
  $query = Get-DhcpServerv4ScopeStatistics | Where-Object {$_.ScopeId -like "*$ID*"} | Select-Object PercentageInUse
  foreach ($object in $query) {
  $PercentageInUse = [string]$object.PercentageInUse}
  $PercentageInUse
    } 

   "ScopeReserved" {
  $query = Get-DhcpServerv4ScopeStatistics | Where-Object {$_.ScopeId -like "*$ID*"} | Select-Object Reserved
  foreach ($object in $query) {
  $Reserved = [string]$object.Reserved}
  $Reserved
    } 
 
  default {
      Write-Host "-- ERROR -- : BOOL Syntax !"
  }
}
