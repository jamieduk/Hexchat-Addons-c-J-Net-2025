use strict;
use warnings;
use Xchat qw(:all);

register('InsultBot', '1.0', 'A bot to dish out insults', \&unload);

# Array of humorous insults
my @insults=(
    "😏️ I'd agree with you, but then we’d both be wrong. 😏️",
    "😏️ You bring everyone so much joy… when you leave the room. 😏️",
    "😏️ You have something on your chin… no, the third one down. 😏️",
    "😏️ You’re like a cloud. When you disappear, it’s a beautiful day. 😏️",
    "😏️ I’d explain it to you, but I left my crayons at home. 😏️",
    "😏️ You have something on your face… oh wait, that’s just your personality. 😏️",
    "😏️ You bring everyone happiness. Some when you enter the room, and others when you leave it. 😏️",
    "😏️ You’re proof that even evolution takes breaks. 😏️",
    "😏️ Your secrets are safe with me. I never even listen when you tell me them. 😏️",
    "😏️ You have something I don’t have. A lower IQ. 😏️"
);

# Hook for the /insult command
hook_command('insult', \&insult_command);

# Hook to check for phrases in messages
hook_print('Channel Message', \&check_message);
hook_print('Private Message', \&check_message);

# Respond with a random insult for the /insult command
sub insult_command {
    my ($args, $server, $channel)=@_;
    my $insult=$insults[int(rand(scalar @insults))];
    command("say $insult");
    return EAT_ALL;
}

# Check for phrases like "insult me" or "give me an insult"
sub check_message {
    my ($data, $server, $channel)=@_;
    if ($data->{message} =~ /\b(insult me|give me an insult)\b/i) {
        my $insult=$insults[int(rand(scalar @insults))];
        command("say $insult");
    }
    return EAT_NONE;
}

# Unload handler for the plugin
sub unload {
    print "InsultBot unloaded.\n";
}

