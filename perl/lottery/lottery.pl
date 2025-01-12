# Made By Jay @ J~Net 2025
#
# HexChat lottery responder addon for Perl
# Version: 1.1
# Description: Auto-responds to specific phrases with lottery numbers and includes test commands

use strict;
use warnings;
use Xchat qw(:all);

register('LotteryResponder', '1.1', 'Responds to phrases with lottery numbers', \&unload);

# Hook messages in the current channel
hook_print('Channel Message', \&message_cb);
hook_print('Private Message to Dialog', \&message_cb);

# Hook the /lottery command
hook_command('lottery', \&lottery_command);
hook_command('help', \&help_command);

# Function to generate lottery numbers
sub generate_lottery_numbers {
    my @numbers=(1 .. 49);
    my @rare_numbers=(13, 17, 21, 37, 44); # Define uncommon numbers

    # Boost the chance of rare numbers
    push @numbers, @rare_numbers for (1 .. 2);

    my %picked;
    while (keys(%picked) < 6) {
        my $num=$numbers[int(rand(@numbers))];
        $picked{$num}=1;
    }

    return sort { $a <=> $b } keys %picked;
}

# Callback for handling messages
sub message_cb {
    my ($word, $word_eol, $event_data)=@_;

    if ($word->[1] =~ /\blottery\b/i) {
        my @lottery_numbers=generate_lottery_numbers();
        my $response=sprintf('Your Winning Lottery Numbers Are... %s', join(", ", @lottery_numbers));
        command("say $response");
    }

    return EAT_NONE;
}

# /lottery command callback for testing
sub lottery_command {
    my ($args, $server, $channel)=@_;
    my @lottery_numbers=generate_lottery_numbers();
    my $response=sprintf('Your Winning Lottery Numbers Are... %s', join(", ", @lottery_numbers));
    command("say $response");

    return EAT_ALL;
}

# /help lottery command callback
sub help_command {
    my ($args, $server, $channel)=@_;
    if ($args =~ /\blottery\b/i) {
        command("say To get lottery numbers, simply mention 'lottery' in the chat or use the /lottery command to test.");
    }

    return EAT_ALL;
}

sub unload {
    print('LotteryResponder version 1.1 unloaded.');
}

