proc GUI {} {
  global gaSet gaGui
  wm title . "Edit Page 2"
  wm protocol . WM_DELETE_WINDOW {Quit}
  wm geometry . $gaGui(xy)
  wm resizable . 0 0
  set descmenu {
    "&File" all file 0 {	 
      {cascad "&Console" {} console 0 {
        {checkbutton "console show" {} "Console Show" {} -command "console show" -variable gConsole}  
        {command "Capture Console" cc "Capture Console" {} -command CaptureConsole}  
      }
      }
      {separator}
      {command "E&xit" exit "Exit" {Alt x} -command {Quit}}
    }
    
    "&About" all about 0 {
      {command "&About" about "" {} -command {About} 
      }
    }
  }
  
  set mainframe [MainFrame .mainframe -menu $descmenu]
  
    set gaSet(sstatus) [$mainframe addindicator]  
    $gaSet(sstatus) configure -width 40 
    
    set gaSet(statBarShortTest) [$mainframe addindicator]
        
    set gaSet(startTime) [$mainframe addindicator]
    
    set gaSet(runTime) [$mainframe addindicator]
    $gaSet(runTime) configure -width 5
    
    set frBut [frame [$mainframe getframe].frBut -relief groove -bd 0]
      #set gaGui(butCrPage0) [Button $frBut.butCrPage0 -text "Create Page0 File" -command {ButRun CreatePage0}]
      set gaGui(tbrun) [Button $frBut.butRun -text "Update Product's Page2" -command {ButRun UpdatePage2}]	
      pack $gaGui(tbrun) -anchor w -padx 2 -pady 2
    set fr0 [frame [$mainframe getframe].fr0 -relief groove -bd 2]
    
    set fr2 [frame $fr0.fr2 -relief groove]
      set fr10 [frame $fr2.fr10 -relief groove -bd 0]
      set fr $fr10
      set l1 [Label $fr.l1 -text "COM" -width 6]
        set gaGui(comName) [ComboBox $fr.comName -textvariable gaSet(comName)\
          -justify center -values [lsort [GetSerialPorts]] ]
        pack $l1 $gaGui(comName) -side left
      pack $fr -fill x        
    pack $fr2 -fill both
    
    set ::frTestPerf [frame $fr0.frTestPerf -bd 2 -relief groove]     
      set f $::frTestPerf
      set frFail [frame $f.frFail]
      set gaGui(frFailStatus) $frFail
        set labFail [Label $frFail.labFail -text "Fail Reason  " -width 12]
        set labFailStatus [Entry $frFail.labFailStatus \
            -bd 1 -editable 1 -relief groove \
            -textvariable gaSet(fail) -justify center -width 40]
      pack $labFail $labFailStatus -fill x -padx 7 -pady 3 -side left; # -expand 1	
      pack $gaGui(frFailStatus) -anchor w
    #pack $::frTestPerf -fill x
    
    pack $fr0 $frBut  -side left -padx 10 -anchor n
    
    
  pack $mainframe -fill both -expand yes
    
  bind . <F1> {console show}  
}
#***************************************************************************
#** Quit
#***************************************************************************
proc Quit {} {
  global gaSet
  SaveInit
  #RLSound::Play information
  set ret [DialogBox -title "Confirm exit"\
      -type "yes no" -icon question -aspect 2000\
      -text "Are you sure you want to close the application?"]
  if {$ret=="yes"} {exit}
}
#***************************************************************************
#** CaptureConsole
#***************************************************************************
proc CaptureConsole {} {
  console eval { 
    set ti [clock format [clock seconds] -format  "%Y.%m.%d_%H.%M.%S"]
    if ![file exists c:/temp] {
      file mkdir c:/temp
      after 1000
    }
    set fi c:\\temp\\ConsoleCapt_[set ti].txt
    if [file exists $fi] {
      set res [tk_messageBox -title "Save Console Content" \
        -icon info -type yesno \
        -message "File $fi already exist.\n\
               Do you want overwrite it?"]      
      if {$res=="no"} {
         set types { {{Text Files} {.txt}} }
         set new [tk_getSaveFile -defaultextension txt \
                 -initialdir c:\\ -initialfile [file rootname $fi]  \
                 -filetypes $types]
         if {$new==""} {return {}}
      }
    }
    set aa [.console get 1.0 end]
    set id [open $fi w]
    puts $id $aa
    close $id
  }
}


# ***************************************************************************
# About
# ***************************************************************************
proc About {} {
  set ret [DialogBox -title "SW version" -type "ok" -icon info -aspect 2000\
      -text "The software version: 1.0"]
  #tk_messageBox -parent . -icon info -type ok -message "The software version: $date" -title "SW version" 
}
