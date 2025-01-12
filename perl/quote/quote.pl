# QuoteBot for HexChat
# Shares inspirational or funny quotes based on user triggers or categories.

use strict;
use warnings;
use Xchat qw(:all);

register("QuoteBot", "1.0", "Shares inspirational or funny quotes.", \&unload);

my %quotes=(
    "inspirational" => [
        "\xF0\x9F\x92\xA1 'The only way to do great work is to love what you do.' - Steve Jobs",
        "\xF0\x9F\x92\xA1 'Success is not the key to happiness. Happiness is the key to success.' - Albert Schweitzer",
        "\xF0\x9F\x92\xA1 'Act as if what you do makes a difference. It does.' - William James"
    ],
    "funny" => [
        "\xF0\x9F\x98\x82 'I used to think I was indecisive, but now I'm not so sure.'",
        "\xF0\x9F\x98\x82 'I'm on a whiskey diet. I've lost three days already.'",
        "\xF0\x9F\x98\x82 'Why don’t scientists trust atoms? Because they make up everything!'"
    ],
    "life" => [
        "\xF0\x9F\x92\xA1 'Life is what happens when you’re busy making other plans.' - John Lennon",
        "\xF0\x9F\x92\xA1 'Get busy living or get busy dying.' - Stephen King",
        "\xF0\x9F\x92\xA1 'You only live once, but if you do it right, once is enough.' - Mae West"
    ]
);

hook_command("quote", \&quote_command, {help => "Use /quote [category] to get a random quote. Categories: inspirational, funny, life."});
hook_print("Channel Message", \&quote_trigger);
hook_print("Channel Msg Hilight", \&quote_trigger);

sub unload {
    print "QuoteBot unloaded.\n";
}

sub quote_command {
    my ($word, $word_eol, $event)=@_;
    my $category=lc($word->[1] // "inspirational");

    if (exists $quotes{$category}) {
        my $quote=$quotes{$category}[int(rand(@{$quotes{$category}}))];
        command("say $quote");
    } else {
        command("say \xF0\x9F\x98\xB1 Unknown category. Available categories: inspirational, funny, life.");
    }

    return EAT_ALL;
}

sub quote_trigger {
    my ($word, $word_eol, $event)=@_;
    my $trigger_phrases=qr/give me a quote|quote bot/i;

    if ($word->[1] =~ $trigger_phrases) {
        quote_command(["quote", "inspirational"], $word_eol, $event);
    }

    return EAT_NONE;
}

