Param(
  [string]$select
)

# Nombre de usuarios Activos
if ( $select -eq 'ACTIVO' )
{
Import-Module PSTerminalServices
Get-TSSession -State Active -ComputerName localhost | foreach {$_.UserName}
}

# Total de Usuarios Activos
if ( $select -eq 'ACTIVONUM' )
{
Import-Module PSTerminalServices
Get-TSSession -State Active -ComputerName localhost | foreach {$_.UserName} | Measure-Object -Line | select-object Lines | select-object -ExpandProperty Lines
}

# Nombre de Usuarios Inactivos
if ( $select -eq 'INACTIVO' )
{
Import-Module PSTerminalServices
Get-TSSession -State Disconnected -ComputerName localhost | where { $_.SessionID -ne 0 } | foreach {$_.UserName}
}

# Total de Usuarios Inactivos
if ( $select -eq 'INACTIVONUM' )
{
Import-Module PSTerminalServices
Get-TSSession -State Disconnected -ComputerName localhost | where { $_.SessionID -ne 0 } | foreach {$_.UserName} | Measure-Object -Line | select-object Lines | select-object -ExpandProperty Lines
}

# Nombre do Dispositivo Remoto
if ( $select -eq 'DEVICE' )
{
Import-Module PSTerminalServices
Get-TSSession -State Active -ComputerName localhost | foreach {$_.ClientName}
}

# IP de Dispositivo Remoto
if ( $select -eq 'IP' )
{
Import-Module PSTerminalServices
Get-TSSession -State Active -ComputerName localhost | foreach {(($_.IPAddress).IPAddressToString)}
}
