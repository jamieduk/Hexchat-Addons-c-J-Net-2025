#!/bin/bash
# (c) J~Net 2025
#


#For nicktrace
#put file hostmasks.db into config folder

cp hostmasks.db /home/$USER/.config/hexchat

#all addons go into your addons / perl folder

cp perl/*.* /home/$USER/.config/hexchat/addons/perl

sudo apt install -y libcanberra-gtk-module hexchat libdatetime-format-strptime-perl

echo "type sudo if asked for reminder bot to work!!"
mkdir -p ~/perl5/lib/perl5
export PERL5LIB=~/perl5/lib/perl5:$PERL5LIB
cpan -i Time::ParseDate

echo "put in your bashrc file export PERL5LIB=~/perl5/lib/perl5:$PERL5LIB"



