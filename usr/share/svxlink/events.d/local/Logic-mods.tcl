namespace eval Logic {

variable is_rf 0;

#
# Executed when the SvxLink software is started
#
proc startup {} {
 global mycall;
 variable CFG_TYPE;
# send_short_ident
 puts "DEBUG: SYSTEM $CFG_TYPE";
 if {$CFG_TYPE == "Simplex"} {
 playMsg "Own" "hotspot"; }
 spellWord $mycall;
 playMsg "Core" "online";
}

proc squelch_open {rx_id is_open} {
variable sql_rx_id;
variable is_rf;
set sql_rx_id $rx_id;
if {!$is_open} {
   CW::play "k" 120 1000 -18;
   playSilence 500;
   set is_rf 1;
  }
}

proc send_rgr_sound {} {
variable is_rf;
puts "DEBUG: IS_RF $is_rf";
if {!$is_rf} {
   CW::play "i" 120 880 -18;
   playSilence 500;
 }
 set is_rf 0;
}

#
# Executed when a short identification should be sent
#   hour    - The hour on which this identification occur
#   minute  - The minute on which this identification occur
#
proc send_short_ident {{hour -1} {minute -1}} {
  global mycall;
  variable CFG_TYPE;
  variable short_announce_file
  variable short_announce_enable
  variable short_voice_id_enable
  variable short_cw_id_enable

  # Play voice id if enabled
  if {$short_voice_id_enable} {
    puts "Playing short voice ID"
    spellWord $mycall;
    if {$CFG_TYPE == "Repeater"} {
      playMsg "Core" "repeater";
    }
    playSilence 500;
  }
  # Play announcement file if enabled
  if {$short_announce_enable} {
    puts "Playing short announce"
    if [file exist "$short_announce_file"] {
      playFile "$short_announce_file"
      playSilence 500
    }
  }

  # Play CW id if enabled
  if {$short_cw_id_enable} {
    puts "Playing short CW ID"
    if {$CFG_TYPE == "Repeater"} {
      set call "$mycall"
      playSilence 200;
      CW::play $call 120 800 -18
    } else {
      playSilence 200;
      CW::play $mycall 120 800 -18
    }
    playSilence 500;
  }
}


# Die folgenden 4 Prozeduren erzeugen eine Ansage wenn der Reflektor getrennt/verbunden/aktiv/nicht aktiv ist
# Es wird nach einer Datei <LINKIDENTIFIER>.wav gesucht, hier ist das z.B. LL.wav --> siehe svxlink.conf
# ansonsten wird der Linkidentifier einfach buchstabiert ausgegeben (so im Original)
#
# Bsp in der /etc/svxlink/svxlink.conf :
# [ReflectorLink]
# CONNECT_LOGICS=RepeaterLogic:94:LL,ReflectorLogic
# 94:LL bedeutet, LL ist der Link-Identifier und den geben wir als LL.wav aus, sonst wird der einfach nur buchstabiert

#
# Executed when a link to another logic core is activated.
#   name  - The name of the link
#
proc activating_link {name} {
  if {[string length $name] > 0} {
    playMsg "Core" "activating_link_to";
    if {$name == "FMN"} {
      playMsg "Own" $name
    } else {
      spellWord $name;
    }
  }
}


#
# Executed when a link to another logic core is deactivated.
#   name  - The name of the link
#
proc deactivating_link {name} {
  if {[string length $name] > 0} {
    playMsg "Core" "deactivating_link_to";
    if {$name == "FMN"} {
      playMsg "Own" $name
    } else {
      spellWord $name;
    }
  }
}

#
# Executed when trying to deactivate a link to another logic core but the
# link is not currently active.
#   name  - The name of the link
#
proc link_not_active {name} {
  if {[string length $name] > 0} {
    playMsg "Core" "link_not_active_to";
    if {$name == "FMN"} {
      playMsg "Own" $name
    } else {
      spellWord $name;
    }
  }
}


#
# Executed when trying to activate a link to another logic core but the
# link is already active.
#   name  - The name of the link
#
proc link_already_active {name} {
  if {[string length $name] > 0} {
    playMsg "Core" "link_already_active_to";
    if {$name == "FMN"} {
      playMsg "Own" $name
    } else {
      spellWord $name;
    }
  }
}

# end of namespace
}
