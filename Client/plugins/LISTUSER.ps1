# By Joe Shields
# Script to list number of active UniData licenses in use (windows UniData)
Write-Host -NoNewLine "<<<LISTUSER>>>"
# Modify for UniData bin directory
$u = &"C:\U2\ud81\bin\listuser.exe"
$u = ($u.Split("[\t]"))[7]
$l = [int]$u.Substring(19,4).Trim()
$u = [int]$u.Split([char]9)[6]
if($u -lt 160) {
	"OK"
	$u
	$l
} ElseIf ($u -lt 180) {
	"Warn/"
	$u
	$l
} Else {
	"Crit/"
	$u
	$l
}