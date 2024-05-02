#***************************************************************************
#** MyTime
#***************************************************************************
proc MyTime {} {
  return [clock format [clock seconds] -format "%Y.%m.%d-%H.%M.%S"]
}

#***************************************************************************
#** Send
#** #set ret [RLCom::SendSlow $com $toCom 150 buffer $fromCom $timeOut]
#** #set ret [Send$com $toCom buffer $fromCom $timeOut]
#** 
#***************************************************************************
proc Send {com sent expected {timeOut 8}} {
  global buffer gaSet
  # if {$gaSet(act)==0} {return -2}

  #puts "sent:<$sent>"
  regsub -all {[ ]+} $sent " " sent
  #puts "sent:<[string trimleft $sent]>"
  ##set cmd [list RLSerial::SendSlow $com $sent 50 buffer $expected $timeOut]
  set cmd [list RLSerial::Send $com $sent buffer $expected $timeOut]
  # if {$gaSet(act)==0} {return -2}
  set tt "[expr {[lindex [time {set ret [eval $cmd]}] 0]/1000000.0}]sec"
  #puts buffer:<$buffer> ; update
  if {[info exists gaSet(filterBuffer)] && $gaSet(filterBuffer)=="1"} {
    regsub -all -- {\x1B\x5B..\;..H} $buffer " " b1
    regsub -all -- {\x1B\x5B.\;..H}  $b1 " " b1
    regsub -all -- {\x1B\x5B..\;.H}  $b1 " " b1
    regsub -all -- {\x1B\x5B.\;.H}   $b1 " " b1
    regsub -all -- {\x1B\x5B..\;..r} $b1 " " b1
    regsub -all -- {\x1B\x5B.J}      $b1 " " b1
    regsub -all -- {\x1B\x5BK}       $b1 " " b1
    regsub -all -- {\x1B\x5B\x38\x30\x44}     $b1 " " b1
    regsub -all -- {\x1B\x5B\x31\x42}      $b1 " " b1
    regsub -all -- {\x1B\x5B.\x6D}      $b1 " " b1
    regsub -all -- \\\[m $b1 " " b1
    set re \[\x1B\x0D\]
    regsub -all -- $re $b1 " " b2
    #regsub -all -- ..\;..H $b1 " " b2
    regsub -all {\s+} $b2 " " b3
    regsub -all {\-+} $b3 "-" b3
    regsub -all -- {\[0\;30\;47m} $b3 " " b3
    regsub -all -- {\[1\;30\;47m} $b3 " " b3
    regsub -all -- {\[0\;34\;47m} $b3 " " b3
    set buffer $b3
  }
  #puts "sent:<$sent>"
  if 1 {
    #puts "\nsend: ---------- [clock format [clock seconds] -format %T] ---------------------------"
    puts "\nsend: ---------- [MyTime] ---------------------------"
    puts "send: com:$com, ret:$ret tt:$tt, sent=$sent,  expected=$expected, buffer=$buffer"
    puts "send: ----------------------------------------\n"
    update
  }
  
  after 50 ; #RLTime::Delayms 50
  return $ret
}

#***************************************************************************
#** Status
#***************************************************************************
proc Status {txt {color white}} {
  global gaSet gaGui
  #set gaSet(status) $txt
  #$gaGui(labStatus) configure -bg $color
  $gaSet(sstatus) configure -bg $color  -text $txt
  if {$txt!=""} {
    puts "\n ..... $txt ..... /* [MyTime] */ \n"
  }
  $gaSet(runTime) configure -text ""
  update
}


##***************************************************************************
##** Wait
##***************************************************************************
proc Wait {txt count {color white}} {
  global gaSet
  puts "\nStart Wait $txt $count.....[MyTime]"; update
  Status $txt $color 
  for {set i $count} {$i > 0} {incr i -1} {
    if {$gaSet(act)==0} {return -2}
	  $gaSet(runTime) configure -text $i
	  after 1000; #RLTime::Delay 1
  }
  $gaSet(runTime) configure -text ""
  Status "" 
  puts "Finish Wait $txt $count.....[MyTime]\n"; update
  return 0
}

# ***************************************************************************
# SaveInit
# ***************************************************************************
proc SaveInit {} {
  global gaSet  
  set id [open init.tcl w]
  puts $id "set gaGui(xy) +[winfo x .]+[winfo y .]"
  puts $id "set gaSet(comName) \"$gaSet(comName)\""
  close $id   
}
 
 
# ***************************************************************************
# GetSerialPorts
# ***************************************************************************
proc GetSerialPorts { } {
  set serial_base "HKEY_LOCAL_MACHINE\\HARDWARE\\DEVICEMAP\\SERIALCOMM"
  set values [ registry values $serial_base ]

  set result {}

  foreach valueName $values {
     lappend result [ registry get $serial_base $valueName ]
  }

  return $result
}
# ***************************************************************************
# OpenRL
# ***************************************************************************
proc OpenRL {} {
  global gaSet
  CloseRL
  catch {RLEH::Close}
  
  RLEH::Open
  
  set ret1 [OpenComUut]
  puts "[MyTime] ret1:$ret1" ; update
  if {$ret1!=0} {
    return -1
  }
  return 0
}

# ***************************************************************************
# OpenComUut
# ***************************************************************************
proc OpenComUut {} {
  global gaSet
  set ret [RLSerial::Open $gaSet(comDut) 9600 n 8 1]
  ##set ret [RLCom::Open $gaSet(comDut) 9600 8 NONE 1]
  if {$ret!=0} {
    set gaSet(fail) "Open COM $gaSet(comDut) fail"
  }
  return $ret
}
proc ocu {} {OpenComUut}
proc ouc {} {OpenComUut}
proc ccu {} {CloseComUut}
proc cuc {} {CloseComUut}
# ***************************************************************************
# CloseComUut
# ***************************************************************************
proc CloseComUut {} {
  global gaSet
  catch {RLSerial::Close $gaSet(comDut)}
  ##catch {RLCom::Close $gaSet(comDut)}
  return {}
}

#***************************************************************************
#** CloseRL
#***************************************************************************
proc CloseRL {} {
  global gaSet
  set gaSet(serial) ""
  CloseComUut
  puts "CloseRL CloseComUut" ; update 

  catch {RLEH::Close}
}


# ***************************************************************************
# LogFile
# ***************************************************************************
proc LogFile {res open} {
  global gaSet
  if ![file exists c:/Page2_logs] {
    file mkdir c:/Page2_logs
  }
  set fi c:/Page2_logs/${gaSet(barcode)}_${gaSet(DG)}.txt
  if [file exists $fi] {
    set openMode a
  } else {
    set openMode w
  }
  if [catch {open $fi $openMode} id ] {
    set gaSet(fail) "$id"
    return -1
  } else {
    # if {$openMode eq "a"} {
      # puts $id "\n\n[MyTime]"  
    # }
    puts $id "\n\n[MyTime]"
    puts $id "ID Barcode: $gaSet(barcode)"
    puts $id "Page2: $res"
    close $id
    
    if $open {
      eval exec [auto_execok start] \"\" [list $fi]
    }
  }
  return 0
}