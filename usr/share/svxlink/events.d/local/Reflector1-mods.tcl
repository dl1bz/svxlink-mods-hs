namespace eval ReflectorLogic1 {

# initialisiere Variablen
variable myNodeCall none

#
# Executed on talker stop
#
#   tg        -- The talk group
#   callsign  -- The callsign of the talker node
#
proc talker_stop {tg callsign} {

global langdir
variable myNodeCall
variable selected_tg

# wir kontrollieren mal den Pfad ob korrekt
# puts "DEBUG: $langdir"
# puts "DEBUG: SELECT_TG $selected_tg"
# puts "DEBUG: TG $tg"
# puts "DEBUG: myNodeCall $myNodeCall"
# puts "DEBUG: CALLSIGN $callsign"

if {($tg == $selected_tg) && ($myNodeCall != $callsign)} {
     CW::play "i" 120 880 -18;
     playSilence 500;
}
#   puts "DEBUG: myNodeCall $myNodeCall"
}

#
# Executed when a TG selection has timed out
#
#   new_tg -- Always 0
#   old_tg -- The talk group that was active
#
proc tg_selection_timeout {new_tg old_tg} {
  #puts "### tg_selection_timeout"
  # bei Wechsel zu TG0 NICHT den TX hochtasten wie es eigentlich im Original gemacht wird

  if {$new_tg == 0} {
    puts "DEBUG: REFL CONN IDLE > switch to TG #0"
  } elseif {$old_tg != 0} {
    playSilence 100
    playTone 880 200 50
    playTone 659 200 50
    playTone 440 200 50
    playSilence 100
  }
}

if [info exists ::Logic::CFG_CALLSIGN] {
  set myNodeCall $::Logic::CFG_CALLSIGN
}

# end of namespace
}
