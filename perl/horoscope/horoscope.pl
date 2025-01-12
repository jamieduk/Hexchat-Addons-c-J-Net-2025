use strict;
use warnings;
use Xchat qw(:all);
use Encode qw(encode decode);

register('HoroscopeBot', '1.1', 'A bot to generate daily horoscopes', \&unload);

# Supported zodiac signs
my @signs = qw(aries taurus gemini cancer leo virgo libra scorpio sagittarius capricorn aquarius pisces);

# Horoscope templates and phrases with escaped emojis
my @templates = (
    "🔮 {sign}: Today, {trait} will guide you. {advice}. 🔮",
    "🔮 {sign}: {trait} shines brightly for you today. {advice}. 🔮",
    "🔮 {sign}: Expect {trait} to play a big role in your day. {advice}. 🔮",
);

my @traits = (
    "🌠 your adaptability", "your charm", "your creativity", "your courage 🌠 ",
    "🌠 your patience", "your determination", "your intuition", "your intelligence 🌠 ",
    "🌠 your energy", "your sense of humor 🌠 "
);

my @advice = (
    "💫 Embrace new opportunities", "Take time to reflect 💫 ",
    "💫 Be cautious with your decisions", "Look out for unexpected surprises 💫 ",
    "💫 Focus on self-care", "Trust your instincts 💫 ",
    "💫 Connect with old friends", "Stay open to change 💫 "
);

# Hook for the /horoscope command
hook_command('horoscope', \&horoscope_command);

# Hook for phrases like "what's my horoscope for Gemini?"
hook_print('Channel Message', \&check_message);
hook_print('Private Message', \&check_message);

# Respond to /horoscope <sign>
sub horoscope_command {
    my $args = $_[1][1] // '';  # Get the argument (sign) from the command
    $args =~ s/^\s+|\s+$//g;    # Trim leading and trailing whitespace
    my $sign = lc($args);

    if ($sign && grep { $_ eq $sign } @signs) {
        my $horoscope = generate_horoscope($sign);
        command("say $horoscope");
    } else {
        command("say 🔮 Usage: /horoscope <sign>. Supported signs: " . join(', ', @signs) . " 🔮");
    }
    return EAT_ALL;
}

# Respond to messages like "what’s my horoscope for Gemini?"
sub check_message {
    my ($data, $server, $channel) = @_;
    my $message = lc($data->{message});

    if ($message =~ /what(?:'s| is) my horoscope for (\w+)/i) {
        my $sign = lc($1);
        if (grep { $_ eq $sign } @signs) {
            my $horoscope = generate_horoscope($sign);
            command("say $horoscope");
        } else {
            command("say 🔮 Sorry, '$1' is not a valid zodiac sign. Supported signs: " . join(', ', @signs) . " 🔮");
        }
    }

    return EAT_NONE;
}

# Generate a random horoscope for a given sign
sub generate_horoscope {
    my ($sign) = @_;
    my $template = $templates[int(rand(@templates))];
    my $trait = $traits[int(rand(@traits))];
    my $advice = $advice[int(rand(@advice))];

    # Replace placeholders with values
    $template =~ s/{sign}/\u$sign/;
    $template =~ s/{trait}/$trait/;
    $template =~ s/{advice}/$advice/;

    # Decode the template to convert the Unicode escape sequences to actual emoji characters
    $template = decode("UTF-8", $template);

    # Return the horoscope string
    return $template;
}

# Unload handler for the plugin
sub unload {
    print "HoroscopeBot unloaded.\n";
}

