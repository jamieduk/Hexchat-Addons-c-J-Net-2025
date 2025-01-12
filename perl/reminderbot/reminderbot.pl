use strict;
use warnings;
use Xchat qw(:all);

# Register the plugin
register('ReminderBot', '1.0', 'A bot to set reminders', \&unload);

# Hook for the /remind command
hook_command('remind', \&remind_command);
# Hook for checking time format from channel message
hook_print('Channel Message', \&handle_channel_message);

# Store reminders
my %reminders;

# Hook for checking time format from command
sub remind_command {
    my ($word, $word_eol, $userdata)=@_;
    
    # Extract the first argument (time) and the rest as the message
    my $time_input=$word->[1];  # First argument after the command
    my $message=$word_eol->[2]; # Everything after the time argument
    
    # Get the nick of the user who issued the command
    my $nick=$userdata->{nick};
   # my $channel=$userdata->{"Reminder-Bot"};
    my $channel="Reminder-Bot";
    process_reminder($nick, $channel, $time_input, $message, $userdata);
}

# Hook for checking time format from channel message
sub handle_channel_message {
    my ($words, $properties)=@_;
    
    my ($nick, undef, $message, undef, $channel)=@$words;
    
    # Check if the message starts with "remind me"
    if ($message =~ /^remind me (\d+)([smhd])\s+(.*)/) {
        my $amount=$1;
        my $unit=$2;
        my $reminder_message=$3;
        
        my $time_input="$amount$unit";
        
        process_reminder($nick, $channel, $time_input, $reminder_message, { server => '', channel => $channel });
    }
    
    return EAT_NONE;
}

# Process the reminder logic
sub process_reminder {
    my ($nick, $channel, $time_input, $message, $userdata)=@_;
    
    # Ensure $nick and $channel are defined
    $nick //= 'you';
    $channel //= 'channel';
    
    # Debug: Check the extracted time and message
    print "DEBUG: Time input: '$time_input'\n";
    print "DEBUG: Message: '$message'\n";
    print "DEBUG: Nick: '$nick'\n";
    print "DEBUG: Channel: '$channel'\n";
    
    # Check if the time format is valid (e.g., 10m, 1h, etc.)
    if ($time_input =~ /^(\d+)([smhd])$/) {
        my $amount=$1;
        my $unit=$2;
        my $time_in_seconds;
        
        # Convert time to seconds based on unit
        if ($unit eq 's') {
            $time_in_seconds=$amount;
        } elsif ($unit eq 'm') {
            $time_in_seconds=$amount * 60;
        } elsif ($unit eq 'h') {
            $time_in_seconds=$amount * 3600;
        } elsif ($unit eq 'd') {
            $time_in_seconds=$amount * 86400;
        }
        
        # Store reminder
        my $reminder_time=time() + $time_in_seconds;
        my $reminder_id=int(rand(10000));  # Unique ID for each reminder
        
        # Store the reminder data
        $reminders{$reminder_id}={
            time => $reminder_time,
            message => $message,
            server => $userdata->{server},
            channel => $channel,
            nick => $nick,
        };
        
        # Directly use the emoticons in the message
        my $reminder_message="Ok will remind $nick to '$message' in $time_input!";
        
        # Send the reminder confirmation with emoticons
        command("say $reminder_message");
        
        # Set a timer for when the reminder will go off
        hook_timer($time_in_seconds * 1000, sub { send_reminder($reminder_id); });  # Convert seconds to milliseconds
    } else {
        # Invalid time format
        my $error_message="⏰ Invalid time format. You entered '$time_input'. Please use something like '10m' for 10 minutes. ⏰";
        
        # Send the error message with emoticons
        command("say $error_message");
        
        # Output to debug
        print "DEBUG: Invalid time format. You entered '$time_input'.\n";
    }
}

# Send reminder message
sub send_reminder {
    my ($reminder_id)=@_;
    my $reminder=$reminders{$reminder_id};
    if ($reminder) {
        my $server=$reminder->{server};
        my $channel=$reminder->{channel} // 'you';  # Default to 'you' if undefined
        my $message=$reminder->{message};
        my $nick=$reminder->{nick} // 'you';  # Default to 'you' if undefined
        
        # Send reminder to channel or private message with emoticons
        my $reminder_message="Reminder for $nick to $message" . join(" ⏰ ");
        
        # Send the reminder message
        if ($channel) {
            command("msg $channel $reminder_message");
        } else {
            print "DEBUG: No channel specified for reminder.\n";
        }
        
        # Clean up the reminder from memory
        delete $reminders{$reminder_id};
    }
    return EAT_NONE;
}

# Unload handler for the plugin
sub unload {
    print "ReminderBot unloaded.\n";
}
