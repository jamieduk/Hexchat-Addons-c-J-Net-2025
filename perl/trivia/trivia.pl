# TriviaBot for HexChat
# Responds to the /trivia command or phrases like "tell me something cool".
# Includes a trivia challenge feature.

use strict;
use warnings;
use Xchat qw(:all);

register("TriviaBot", "1.0", "Shares random trivia facts and challenges users.", \&unload);

my @trivia_facts=(
    "Octopuses have three hearts, and two of them stop beating when they swim!",
    "Bananas are berries, but strawberries aren't!",
    "Honey never spoils; archaeologists have found 3000-year-old honey that is still edible!",
    "Wombat poop is cube-shaped!",
    "Sharks existed before trees!"
);

my %challenges=(
    "What is the largest planet in our solar system?" => "Jupiter",
    "What is the chemical symbol for gold?" => "Au",
    "What is the capital of Australia?" => "Canberra",
    "Who wrote 'Romeo and Juliet'?" => "William Shakespeare",
    "How many continents are there?" => "7"
);

hook_command("trivia", \&trivia_command, {help => "Use /trivia to get a random trivia fact."});
hook_print("Channel Message", \&trivia_trigger);
hook_print("Channel Msg Hilight", \&trivia_trigger);

sub unload {
    print "TriviaBot unloaded.\n";
}

sub trivia_command {
    my $fact=$trivia_facts[int(rand(@trivia_facts))];
    command("say \xF0\x9F\xA7\xA0 Did you know? $fact \xF0\x9F\xA7\xA0");
    return EAT_ALL;
}

sub trivia_trigger {
    my ($word, $word_eol, $event)=@_;
    my $trigger_phrases=qr/tell me something cool|trivia bot/i;

    if ($word->[1] =~ $trigger_phrases) {
        trivia_command();
    } elsif ($word->[1] =~ /trivia challenge/i) {
        my ($question, $answer)=get_random_challenge();
        command("say Trivia Challenge! $question");
        hook_print("Channel Message", sub {
            my ($word)=@_;
            if (lc($word->[1]) eq lc($answer)) {
                command("say Correct! The answer is $answer.");
                return REMOVE;
            }
            return EAT_NONE;
        });
    }

    return EAT_NONE;
}

sub get_random_challenge {
    my @keys=keys %challenges;
    my $question=$keys[int(rand(@keys))];
    return ($question, $challenges{$question});
}

