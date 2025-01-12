use strict;
use warnings;
use Xchat qw(:all);

register('DankMemerPlugin', '1.0', 'A Dank Memer-like plugin', \&unload);

# Hook for every command
hook_command('8ball', \&eightball_command);
hook_command('beg', \&beg_command);
hook_command('coinflip', \&coinflip_command);
hook_command('meme', \&meme_command);
hook_command('automeme', \&automeme_command);
hook_command('postmemes', \&postmemes_command);
hook_command('clap', \&clap_command);
hook_command('blackjack', \&blackjack_command);
hook_command('balance', \&balance_command);
hook_command('leaderboard', \&leaderboard_command);
hook_command('daily', \&daily_command);
hook_command('withdraw', \&withdraw_command);
hook_command('deposit', \&deposit_command);
hook_command('bankrob', \&bankrob_command);
hook_command('rob', \&rob_command);
hook_command('inventory', \&inventory_command);
hook_command('helpmeme', \&helpmeme_command);

# Hook for commands without slash
hook_print('Channel Message', \&check_message);
hook_print('Private Message', \&check_message);

# Simulate /8ball command
sub eightball_command {
    my ($args, $server, $channel)=@_;
    if ($args) {
        my @responses=(
            "Yes", "No", "Maybe", "Ask again later", "Definitely not", "Certainly",
            "I don't know", "Probably", "Absolutely", "Unlikely"
        );
        my $response=$responses[int(rand(scalar @responses))];
        command("say 🫥️ The magic 8ball says: $response 🫥️");
    } else {
        command("say 🫥️ Please ask a question with /8ball <question>🫥️");
    }
    return EAT_ALL;
}

# Simulate /beg command
sub beg_command {
    my ($args, $server, $channel)=@_;
    command("say 🤑️ You begged and received a generous donation of coins! 🤑️");
    return EAT_ALL;
}

# Simulate /coinflip command (no argument needed)
sub coinflip_command {
    my ($args, $server, $channel)=@_;
    my $flip=(rand(2) < 1) ? "heads" : "tails";
    command("say 🪙️ The coin flip result is: $flip! 🪙️");
    return EAT_ALL;
}

# Simulate /meme command
sub meme_command {
    my ($args, $server, $channel)=@_;
    if ($args) {
        command("say 🤣️ Here's your meme: [meme of type $args] 🤣️");
    } else {
        command("say Use /meme <type> to get a meme.");
    }
    return EAT_ALL;
}

# Simulate /automeme command
sub automeme_command {
    my ($args, $server, $channel)=@_;
    if ($args) {
        command("say Automeme set for channel $args. Memes will be posted every x minutes.");
    } else {
        command("say Use /automeme <channel> to set up automeme.");
    }
    return EAT_ALL;
}

# Simulate /postmemes command
sub postmemes_command {
    my ($args, $server, $channel)=@_;
    command("say Posting memes with a chance for rewards! Here's a meme: [meme]");
    return EAT_ALL;
}

# Simulate /clap command
sub clap_command {
    my ($args, $server, $channel)=@_;
    if ($args) {
        command("say 👏️ *claps* $args 👏️");
    } else {
        command("say Use /clap <text> to make the bot say something with sass.");
    }
    return EAT_ALL;
}

# Simulate /blackjack command
sub blackjack_command {
    my ($args, $server, $channel)=@_;
    if ($args =~ /^\d+$/) {
        command("say 🤑️ You bet $args on blackjack. Let's see if you win! 🤑️");
    } else {
        command("say Use /blackjack <bet> to play blackjack.");
    }
    return EAT_ALL;
}

# Simulate /balance command
sub balance_command {
    my ($args, $server, $channel)=@_;
    command("say 🪙️🤑️ Your Current Balance is: 1000 Coins. 🤑️🪙️");
    return EAT_ALL;
}

# Simulate /leaderboard command
sub leaderboard_command {
    my ($args, $server, $channel)=@_;
    command("say Showing leaderboard: Top players in the server.");
    return EAT_ALL;
}

# Simulate /daily command
sub daily_command {
    my ($args, $server, $channel)=@_;
    command("say 🤑️🪙️ You've received your daily reward! 2000 coins! 🤑️🪙️");
    return EAT_ALL;
}

# Simulate /withdraw command
sub withdraw_command {
    my ($args, $server, $channel)=@_;
    if ($args =~ /^\d+$/) {
        command("say 🪙️🤑️ You've withdrawn $args coins 🤑️🪙️");
    } else {
        command("say Use /withdraw <amount> to withdraw coins.");
    }
    return EAT_ALL;
}

# Simulate /deposit command
sub deposit_command {
    my ($args, $server, $channel)=@_;
    if ($args =~ /^\d+$/) {
        command("say 🤑️🪙️ You've deposited $args coins into your bank🪙️🤑️");
    } else {
        command("say Use /deposit <amount> to deposit coins.");
    }
    return EAT_ALL;
}

# Simulate /bankrob command
sub bankrob_command {
    my ($args, $server, $channel)=@_;
    command("say 🤑️🪙️🪙️ You've gathered a group to rob someone's bank! It's risky but rewarding 🪙️🪙️🤑️");
    return EAT_ALL;
}

# Simulate /rob command
sub rob_command {
    my ($args, $server, $channel)=@_;
    command("say 🪙️🪙️ You tried to rob someone's pocket! Did you succeed? 🪙️🪙️");
    return EAT_ALL;
}

# Simulate /inventory command
sub inventory_command {
    my ($args, $server, $channel)=@_;
    command("say Here's your inventory: [list of items]");
    return EAT_ALL;
}

# Simulate /help command
sub helpmeme_command {
    my ($args, $server, $channel)=@_;
    command("say Available commands: /8ball, /beg, /coinflip, /meme, /automeme, /postmemes, /clap, /blackjack, /balance, /leaderboard, /daily, /withdraw, /deposit, /bankrob, /rob, /inventory");
    return EAT_ALL;
}

# Check message for certain phrases (no slash needed)
sub check_message {
    my ($data, $server, $channel)=@_;
    if ($data->{message} =~ /\b(8ball|beg|coinflip|meme)\b/i) {
        my $cmd=$1;
        if ($cmd eq '8ball') {
            eightball_command($data->{message}, $server, $channel);
        } elsif ($cmd eq 'beg') {
            beg_command($data->{message}, $server, $channel);
        } elsif ($cmd eq 'coinflip') {
            coinflip_command('', $server, $channel);
        } elsif ($cmd eq 'meme') {
            meme_command($data->{message}, $server, $channel);
        }
    }
    return EAT_NONE;
}

# Unload handler for the plugin
sub unload {
    print "Dank Memer-like plugin unloaded.\n";
}

