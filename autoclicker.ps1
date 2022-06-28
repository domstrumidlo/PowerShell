#https://github.com/mavaddat/wasp
#autoclicker
Import-Module -name WASP
Add-Type -AssemblyName System.Windows.Forms
Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);' -Name U32 -Namespace W;

$ZName = 2
$Zkey = 2



#FIRST RUN
sleep 1
#select item
  #$Pos = [System.Windows.Forms.Cursor]::Position
  $x = -1550
  $y = 478
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
[W.U32]::mouse_event(6,0,0,0,0);
  sleep 1
Do {


 sleep 1
 #click clone
  $x = -1400
  $y = 775
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

  [W.U32]::mouse_event(6,0,0,0,0);
  
sleep 1

#
#CLICK NAME
#
  $x = -1460
  $y = 255
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  [W.U32]::mouse_event(6,0,0,0,0);

  Send-UIKeys '{END}'
  Send-UIKeys '{BACKSPACE}'
  Send-UIkeys $ZName

#
#CLICK KEY
#
  $x = -1260
  $y = 312
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  [W.U32]::mouse_event(6,0,0,0,0);

  Send-UIKeys '{END}'
  Send-UIKeys '{BACKSPACE}'
  Send-UIKeys $Zkey
  
#
#CLICK SNMP OID
#
  $x = -1400
  $y = 365
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  [W.U32]::mouse_event(6,0,0,0,0);

  <#
  Send-UIKeys '^a'
  sleep 1
  Send-UIKeys '{BACKSPACE}'
  #(last(//ifInOctets.49)+last(//ifOutOctets.49))/last(//ifSpeed.49)
  Send-UIKeys '{(}last{(}//ifInOctets.'
  Send-UIKeys $Zkey
  Send-UIKeys '{)}{+}last{(}//ifOutOctets.'
  Send-UIKeys $Zkey
  Send-UIKeys '{)}{)}/last{(}//ifSpeed.'
  Send-UIKeys $Zkey
  Send-UIKeys '{)}'
  #>
    Send-UIKeys '{END}'
  Send-UIKeys '{BACKSPACE}'
  Send-UIKeys $Zkey

  $x = -1465
  $y = 780
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  [W.U32]::mouse_event(6,0,0,0,0);
  sleep 1
  $Zkey = $Zkey + 1
  $ZName = $ZName + 1
  sleep 1
#select item
  #$Pos = [System.Windows.Forms.Cursor]::Position
  $x = -1550
  $y = 520
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
[W.U32]::mouse_event(6,0,0,0,0);
  } Until ($ZName -eq 15)
