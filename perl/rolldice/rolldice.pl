use strict;
use warnings;
use Xchat qw(:all);

register('DiceBot', '1.1', 'A bot to roll virtual dice', \&unload);

# Hook for the /rolldice and /roll commands
hook_command('rolldice', \&roll_command);
hook_command('roll', \&roll_command);

# Hook for phrases like "roll 1-100"
hook_print('Channel Message', \&check_message);
hook_print('Private Message', \&check_message);

# Respond to /rolldice <number>d<sides> or /roll <min>-<max>
sub roll_command {
    my $args=$_[1][1] // '';  # Get the argument (roll command)
    $args =~ s/^\s+|\s+$//g;    # Trim leading and trailing whitespace

    # Default to 1d6 if no input is provided
    if ($args eq '') {
        $args='1d6';
    }

    # Check for standard dice roll format (XdY)
    if ($args =~ /^(\d+)d(\d+)$/) {
        my $num_rolls=$1;
        my $num_sides=$2;

        my @rolls;
        my $total=0;
        for (1..$num_rolls) {
            my $roll=int(rand($num_sides)) + 1;
            push @rolls, $roll;
            $total += $roll;
        }

        my $roll_result=join(" and ", @rolls);
        command("say 🎲 You rolled $args: $roll_result (total: $total) 🎲");
    }
    # Check for custom range roll like /roll 1-100
    elsif ($args =~ /^(\d+)-(\d+)$/) {
        my $min=$1;
        my $max=$2;
        my $roll=int(rand($max - $min + 1)) + $min;
        command("say 🎲 You rolled $min-$max: $roll 🎲");
    }
    else {
        command("say 🎲 Invalid format. Usage: /rolldice <number>d<sides> or /roll <min>-<max> 🎲");
    }

    return EAT_ALL;
}

# Check for phrases like "roll 1-100" in messages
sub check_message {
    my ($data, $server, $channel)=@_;
    my $message=lc($data->{message});

    if ($message =~ /roll (\d+)-(\d+)/i) {
        my $min=$1;
        my $max=$2;
        my $roll=int(rand($max - $min + 1)) + $min;
        command("say 🎲 You rolled $min-$max: $roll 🎲");
    }

    return EAT_NONE;
}

# Unload handler for the plugin
sub unload {
    print "DiceBot unloaded.\n";
}

