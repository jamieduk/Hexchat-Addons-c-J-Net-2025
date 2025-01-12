# Made By Jay @ J~Net 2025

# HexChat slap addon for Perl
# Version: 2.0
# Description: Adds a command `/slap <username>` to randomly slap a user.

use strict;
use warnings;
use Xchat qw(:all);

register('Slap', '2.0', 'Slaps specified users', \&unload);

# List of slap messages
my @slaps=(
    'slaps %s around a bit with a large trout',
    'gives %s a clout round the head with a fresh copy of WeeChat',
    'slaps %s with a large smelly trout',
    'breaks out the slapping rod and looks sternly at %s',
    'slaps %s\'s bottom and grins cheekily',
    'slaps %s a few times',
    'slaps %s and starts getting carried away',
    'would slap %s, but is not being violent today',
    'gives %s a hearty slap',
    'finds the closest large object and gives %s a slap with it',
    'likes slapping people and randomly picks %s to slap',
    'dusts off a kitchen towel and slaps it at %s'
);

# Hook the /slap command
hook_command('slap', \&slap_cb, {
    help_text => 'SLAP <nick> - Randomly slaps the specified user.'
});

sub slap_cb {
    my ($word, $word_eol, $userdata)=@_;

    if (scalar(@$word) > 1) {
        my $nick=$word->[1];
        my $slap_message=$slaps[int(rand(@slaps))];
        command("me " . sprintf($slap_message, $nick));
    } else {
        command('help slap');
    }

    return EAT_ALL;
}

sub unload {
    print('Slap version 2.0 unloaded.');
}

