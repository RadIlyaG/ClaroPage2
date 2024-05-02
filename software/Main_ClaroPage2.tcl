# ***************************************************************************
# ButRun
# ***************************************************************************
proc ButRun {mode} {
  global gaSet gaGui
  pack forget $::frTestPerf
  
  Status ""
  set ret [CheckSanity]
  
  if {$ret==0} {
    if {$mode=="UpdatePage2"} {
      set gaSet(comDut) [string range $gaSet(comName) 3 end]
      set ret [OpenRL]
      
      if {$ret==0} {
        set gaSet(act) 1
        set gaSet(bootErrorsL) ""
        set ret [EditPage2]
      }
      
      CloseRL
    }
  }
  
  if {$ret!=0} {
    Status "Fail" red
    if {$ret=="-2"} {
      set gaSet(fail) "User stop"
    }
    pack $::frTestPerf -anchor w
    #pack $gaGui(frFailStatus) -anchor w
    
  } else {
    if {$mode=="UpdatePage2"} {
      set clr #00d700
      set txt "Product updated,"
      Status "$txt $gaSet(DG)" $clr
    }    
  }
  
  return {}
}
# ***************************************************************************
# CheckSanity
# ***************************************************************************
proc CheckSanity {} {
  global gaSet  gaGui
   
  return 0
}
# ***************************************************************************
# EditPage2
# ***************************************************************************
proc EditPage2 {} {
  global gaSet
  set ret [Boot_Menu]
  if {$ret!=0} {
    set gaSet(fail) "Login to Boot fail"
    return $ret
  }
  set ret [WritePage2]
  
  return $ret
}
# ***************************************************************************
# Boot_Menu
# ***************************************************************************
proc Boot_Menu {} {
  global gaGui gaSet
  catch {unset ::Wait4bootStartTime}  
  set ::Wait4bootResult "-"  
  Wait4boot

  if {$::Wait4bootResult!="0"} {
    DialogBox -icon info -type "Continue" -title "Power reset"\
      -text "Turn OFF and ON the UUT's power and immediately press Continue" \
      -aspect 2000
  }  

	set ::Wait4bootStartTime [clock seconds]
	if {$::Wait4bootResult!="0"} {
	  vwait ::Wait4bootResult ;# wait for change in variable !
	}
  return $::Wait4bootResult
}

# ***************************************************************************
# Wait4boot
# ***************************************************************************
proc Wait4boot {} {
  global gaSet buffer buff  
  if [info exists ::Wait4bootStartTime] {
    set timeNow [clock seconds]
    set durationWait4bootSec [expr {$timeNow - $::Wait4bootStartTime}] 
    if {$durationWait4bootSec>20} {
      set ::Wait4bootResult "-1"
      return {}
    }
  }
  #Enter:
  Status "Enter to Boot.."
  set res [Send $gaSet(comDut) "\r" "\[boot\]:" 2]
  if {$res==0} {
    set ::Wait4bootResult "0"
    destroy .tmpldlg
    return {}
  }
  if {$res!=0} {
    after 50 Wait4boot
  }
  return {}
}

