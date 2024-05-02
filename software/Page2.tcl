set exe 0
if {[namespace exists ::freewrap]} {
  puts "::freewrap::runMode $::freewrap::runMode"
  if {$::freewrap::runMode eq {wrappedExec}} {
    set exe 1
    ##set ::wdir [::zvfs::list [file dirname [info script]]]
    set ::wdir  [file dirname [info script]]
    set filePath [::zvfs::list  [info script]]
    
    foreach fpath [zvfs::list */*/pkgIndex.tcl] {
      lappend ::auto_path [file dirname $fpath]
    }
    foreach fpath [zvfs::list */*/tclIndex] {
      lappend ::auto_path [file dirname $fpath]
    }
  } else {
    ##set filePath [file dirname [info script]]
    ##set ::wdir  $filePath
  }
} else {
  set filePath [file dirname [info script]]
  set ::wdir  $filePath
}
set ::fol [pwd]

package require BWidget
package require registry
package require img::gif

package require RLEH
package require RLSerial
#package require RLTime
source $::wdir/Gui_ClaroPage2.tcl
source $::wdir/Lib_DialogBox.tcl
source $::wdir/Gen_ClaroPage2.tcl
source $::wdir/Main_ClaroPage2.tcl
source $::wdir/Ds280e01_ClaroPage2.tcl
source $::wdir/Lib_Put_Etx2i10G.tcl

#source $::wdir/init.tcl
if {![file exists $::fol/init.tcl] && $exe} {
  file copy  $::wdir/init.tcl $::fol
}
source $::fol/init.tcl

set gaSet(editSN) 0

GUI