use strict;
use warnings;
use Xchat qw(:all);

register('JokeBot', '1.0', 'A bot to tell jokes', \&unload);

# Array of jokes
my @jokes=(
    "🤣️ Why don’t scientists trust atoms? Because they make up everything! 🤣️",
    "🤣️ Why did the scarecrow win an award? Because he was outstanding in his field! 🤣️",
    "🤣️ Why don’t skeletons fight each other? They don’t have the guts. 🤣️",
    "🤣️ What do you call fake spaghetti? An impasta! 🤣️",
    "🤣️ Why couldn’t the bicycle stand up by itself? It was two tired. 🤣️",
    "🤣️ What did one wall say to the other? I'll meet you at the corner! 🤣️",
    "🤣️ Why don’t eggs tell jokes? They’d crack each other up. 🤣️",
    "🤣️ What do you call cheese that isn’t yours? Nacho cheese! 🤣️",
    "🤣️ Why did the math book look sad? Because it had too many problems. 🤣️",
    "🤣️ Why can’t your nose be 12 inches long? Because then it would be a foot! 🤣️"
);

# Hook for the /joke command
hook_command('joke', \&joke_command);

# Hook to check for phrases in messages
hook_print('Channel Message', \&check_message);
hook_print('Private Message', \&check_message);

# Respond with a random joke for the /joke command
sub joke_command {
    my ($args, $server, $channel)=@_;
    my $joke=$jokes[int(rand(scalar @jokes))];
    command("say $joke");
    return EAT_ALL;
}

# Check for phrases like "tell me a joke" or "tell joke"
sub check_message {
    my ($data, $server, $channel)=@_;
    if ($data->{message} =~ /\btell (?:me )?a? joke\b/i) {
        my $joke=$jokes[int(rand(scalar @jokes))];
        command("say $joke");
    }
    return EAT_NONE;
}

# Unload handler for the plugin
sub unload {
    print "JokeBot unloaded.\n";
}

