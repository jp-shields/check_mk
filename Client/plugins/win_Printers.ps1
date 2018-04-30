# By Joe Shields
# Cleaner version of http://git.mathias-kettner.de/git/?p=check_mk.git;a=blob_plain;f=agents/windows/plugins/win_printers.ps1;hb=fc9471fe2ed1bc8915aae50da85cf4ace8cc3ed4
# By default this concats printer name and port as service name to monitor both
# Command line args for:
#	nul = list of printers on 'nul' port
#	port = List of ports
#	LP = List of printers on 'Local Port'
#	count = count of printers and ports
# https://elderec.org/2012/11/powershell-list-printer-names-ports-and-drivers-on-print-server/

If($args[0] -eq 'nul'){
	Get-WMIObject -Class Win32_Printer| ?{$_.PortName -eq 'nul'} | Select Name,DriverName,PortName,Shared,ShareName | ft -auto
}ElseIf($args[0] -eq 'port'){
	Get-PrinterPort | Select-Object Name,DeviceID,Description,LprQueueName
}ElseIf($args[0] -eq 'LP'){
	Get-PrinterPort | ?{$_.Description -eq 'Local Port'} | Select-Object Name,DeviceID,Description,LprQueueName
}ElseIf($args[0] -eq 'count'){
	Write-Host -NoNewLine "Printers: "
	@(Get-WMIObject -Class Win32_Printer).Count
	Write-Host -NoNewLine "Ports:    "
	@(Get-PrinterPort).Count
}Else{
	Write-Host -NoNewLine "<<<win_printers>>>"
	# Monitor printer name + port as a service
	# "Name" "CurrentJobs" "printerstatus" "detectederrorstate"
	Get-WMIObject -Class Win32_Printer | 
		Select @{Name="Name"; Expression = {($_.Name+':'+$_.PortName) }},
		@{Name="CurrentJobs"; Expression = {0}},
		printerstatus,detectederrorstate | ft -HideTableHeaders
		
	<# # Swap above for this to monitor only printer names
	Get-WMIObject -Class Win32_Printer | 
		Select @{Name="Name"; Expression = {($_.Name)}},
		@{Name="CurrentJobs"; Expression = {0}},
		printerstatus,detectederrorstate | ft -HideTableHeaders #>
}