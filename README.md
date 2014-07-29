Dbus-MPRIS-MusicPlayer-Controller
=================================

A shell script to control Music Players using MPRIS &amp; dbus

#### Running dmc.sh
dmc.sh [-d] [-h] [-p player name] command

	-h : Display the help message
	-d : Display debug messages.
	-p : Name of the media player that need to be controlled.
	Commands : play, pause, stop, next & previous

#### Finding the player name
Use the following command to identify the name of the player.
````
qdbus org.mpris.MediaPlayer2.*
````
This will give output like
````
org.mpris.MediaPlayer2.amarok
org.mpris.MediaPlayer2.clementine
org.mpris.MediaPlayer2.mpd
org.mpris.MediaPlayer2.vlc
````
In the above result, the available player names are amarok, clementine, mpd &amp; vlc.

#### VLC Player
VLC player need to be started with MPRIS support. Launch vlc as follows:
````
vlc --control dbus
````

#### Music Player Daemon (MPD)
MPRIS support for MPD need to be enabled using the mpDris2 package. Please refer https://github.com/eonpatapon/mpDris2 for installation and configuration information.


#### Clementine & Amarok
No special setup required.
