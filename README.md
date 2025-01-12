Hexchat Addons (c) J~Net 2025

jnet2025.ddns.net

For nicktrace
put file hostmasks.db into config folder

cp hostmasks.db /home/$USER/.config/hexchat

all addons go into your addons / perl folder

cp *.* /home/$USER/.config/hexchat/addons/perl


sudo apt-get install -y libcanberra-gtk-module hexchat libdatetime-format-strptime-perl

mkdir -p ~/perl5/lib/perl5
export PERL5LIB=~/perl5/lib/perl5:$PERL5LIB
cpan -i Time::ParseDate

Type sudo if asked!


Put this line into your bashrc file

export PERL5LIB=~/perl5/lib/perl5:$PERL5LIB

for reminder bot to work!




