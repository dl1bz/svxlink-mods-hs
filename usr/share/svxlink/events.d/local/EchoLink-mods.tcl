namespace eval EchoLink {

#
# Check if this module is loaded in the current logic core
#
if {![info exists CFG_ID]} {
  return;
}

proc remote_greeting {call} {
  global langdir
  variable module_name

# eigene Ansage bei Echolink-Connect
# es muss unter /usr/share/svxlink/sounds/de_DE/EchoLink eine Datei mit owncall.wav vorhanden sein

  if [file exists "$langdir/$module_name/owncall.wav"] {
    playSilence 1000;
    playMsg "greeting";
    playSilence 250;
    playMsg "owncall";
  } else {
    puts "$langdir/$module_name/owncall.wav nicht vorhanden."
  }
}

#
# Executed when a transmission from an EchoLink station is starting
# or stopping
#   rx   - 1 if receiving or 0 if not
#   call - The callsign of the remote station
#
#
proc is_receiving {rx call} {
  if {$rx == 0} {
    puts "### EchoLink talker stop $call";
    playTone 1000 100 100;
  }
  if {$rx == 1} {
    puts "### EchoLink talker start $call";
  }
 }

# end of namespace
}
