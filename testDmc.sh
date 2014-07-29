#! /usr/bin/env bash

# Script to test dmc.sh.

# Prime Jyothi 20140729 primejyothi [at] gmail [dot] com

# Log functions.
. ./logs.sh

players="amarok clementine mpd vlc"

# Keep "stop" at the end to prevent multiple players palaying together.
actions="play pause next previous stop"

# Execute actions for all players.

for p in ${players}
do
	for a in ${actions}
	do
		echo -n "Player [$p] Action [$a]. Execute (Enter) Quit (q) : "

		read choice

		case $choice in
			q | Q )
				cmdString="./dmc.sh -p ${p} stop"
				log $LINENO "Exeuting [$cmdString]"
				$cmdString
				exit 0
				;;
		esac
		cmdString="./dmc.sh -p ${p} ${a}"
		log $LINENO "Exeuting [$cmdString]"
		$cmdString
	done
done
