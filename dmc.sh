#! /usr/bin/env bash

# Control MPRIS supported music players from command line using qdbus.
# License : GPLv3
# Prime Jyothi 20140728 primejyothi [at] gmail [dot] com


# Log / debug functions.
. ./logs.sh

function help ()
{
	echo "Usage : `basename $0` [-d] -p playerName command"
	echo -e "\t -d : Enable debug messages"
	echo -e "\t -h : Display this help message"
	echo -e "\t -p : Player name"
	echo -e "\t\tSupported commands are play, pause, stop, next & previous"
	exit 1
}

if [[ ! -x "/usr/bin/qdbus" ]]
then
	err $LINENO "/usr/bin/qdbus not available"
	exit 1
fi

while getopts p:dh args
do
	case $args in
		"h")
			help
			;;
			
		"p")
			targetPlayer="$OPTARG"
			;;

		"d")
			dbgFlag=Y
			;;
		*)
			echo "Got $OPTARG"
			;;
	esac
done

shift $((OPTIND-1))
if [[ "$#" -ne 1 ]]
then
	err $LINENO "Invalid argument(s), try `basename $0` -h"
	exit 1
fi

cmd=$1

# Find music players.

mp=`qdbus org.mpris.MediaPlayer2*`
dbg $LINENO "mp [$mp]"

if [[ -z "$mp" ]]
then
	log $LINENO "No music player running."
	exit 2
fi

if [[ ! -z "$targetPlayer" ]]
then
	player=$targetPlayer
else
	for i in ${mp}
	do
		# Field separator is period and player name is the last filed.
		pl=`echo $i | awk -F"." '{print $NF}'`
		# dbg $LINENO "pl [$pl]"

		# Check the playback status.
		pbStatus=`qdbus org.mpris.MediaPlayer2.${pl} /org/mpris/MediaPlayer2 \
			org.mpris.MediaPlayer2.Player.PlaybackStatus`
		dbg $LINENO "$pl : [$pbStatus]"

		# No player specified from command line. Get the list of active
		# players and check the player status. If there are multiple 
		# players, the one in "Playing" status will get selected. If
		# there are no such players, a player in "Paused" state is selected.
		# If there are no players in "Playing" or "Paused" status, one with
		# "Stopped" status is selected.
		
		case $pbStatus in
			"Playing" )
				# Found a player that is playing. Select this player.
				player=$pl
				dbg $LINENO "Found $pl playing."
				break
				;;

			"Paused" )
				# Found a player that has been paused. Select this player.
				dbg $LINENO "Setting player to paused $pl"
				player=$pl
				;;

			"Stopped" )
				# Found a player that has been stopped.
				# Set the player only if it is empty, should not over write
				# a paused player with stopped player.
				if [[ -z "$player" ]]
				then
					dbg $LINENO "Setting player to stopped $pl"
					player=$pl
				fi
		esac
	done
	dbg $LINENO "Selected player is $player"
fi

cmdString="qdbus org.mpris.MediaPlayer2.${player} /org/mpris/MediaPlayer2"

case $cmd in
	"play" )
		action="org.mpris.MediaPlayer2.Player.Play"
		;;

	"playPause" )
		action="org.mpris.MediaPlayer2.Player.PlayPause"
		;;

	"pause" )
		action="org.mpris.MediaPlayer2.Player.Pause"
		;;

	"stop" )
		action="org.mpris.MediaPlayer2.Player.Stop"
		;;

	"next" )
		action="org.mpris.MediaPlayer2.Player.Next"
		;;

	"previous" | "prev" )
		action="org.mpris.MediaPlayer2.Player.Previous"
		;;

	* )
		err $LINENO "Command [$cmd] not supported"
		exit 1
		;;
esac

dbg $LINENO "cmdString [$cmdString] $action"
$cmdString $action

exit $?
