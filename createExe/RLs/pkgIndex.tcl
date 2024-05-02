# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded RLSerial 1.2 [list source [file join $dir RLSerial.tcl]]
package ifneeded RLEH 1.04 [list source [file join $dir RLEH.tcl]]
package ifneeded RLSound 1.11 [list source [file join $dir RLSound.tcl]]
package ifneeded RLFile 1.12 [list source [file join $dir RLFile.tcl]]
# package ifneeded RLDTime 2.0 [list load [file join $dir RLDTime.dll]]
# package ifneeded RLTime 3.0 [list source [file join $dir RLTime.tcl]]
