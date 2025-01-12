# HexChat Perl script for converting text to Base64 and Base64 to text
# Name: b64_converter
# Version: 1.0
# Description: Converts text to Base64 and Base64 to text in HexChat, and sends the result to the channel.

use strict;
use warnings;
use MIME::Base64;

# Register the script with HexChat
HexChat::register("B64-Converter", "1.0", "Converts to and from Base 64.");

# Command for converting text to Base64
HexChat::print("B64-Converter script loaded (Version 1.0)\n");

HexChat::hook_command("txt2b64", sub {
    my ($data, $word, $nick, $args)=@_;

    # Debugging output to inspect $data
    #HexChat::print("Raw Data: '$data'");

    # Check if there is any input after the command
    if (defined($data->[1])) {
        # Extract the first argument (text to encode), skipping the command
        my $text=join(" ", @{$data}[1..$#$data]);  # Join the remaining arguments
        
        # Debugging output to inspect extracted text
        HexChat::print("Extracted Text: '$text'");

        # Trim any leading or trailing whitespace
        $text =~ s/^\s+|\s+$//g;

        # Check if text is provided
        if ($text) {
            my $encoded=encode_base64($text);
            
            # Send the Base64 output to the channel Base64 Output: 
            HexChat::command("SAY $encoded");
        } else {
            HexChat::command("SAY No text provided for encoding.");
        }
    } else {
        HexChat::command("SAY No text provided for encoding.");
    }

    return HexChat::EAT_ALL;
}, { 'help' => 'Converts text to Base64' });

# Command for converting Base64 to text
HexChat::hook_command("b642txt", sub {
    my ($data, $word, $nick, $args)=@_;

    # Debugging output to inspect $data
    #HexChat::print("Raw Data: '$data'");

    # Check if there is any input after the command
    if (defined($data->[1])) {
        # Extract the first argument (Base64 code to decode), skipping the command
        my $code=join(" ", @{$data}[1..$#$data]);  # Join the remaining arguments

        # Debugging output to inspect extracted Base64 code
        HexChat::print("Extracted Base64 Code: '$code'");

        # Trim any leading or trailing whitespace
        $code =~ s/^\s+|\s+$//g;

        # Check if Base64 code is provided
        if ($code) {
            my $decoded=decode_base64($code);
            
            # Send the decoded text to the channel
            #HexChat::command("SAY Decoded Text: $decoded");
            HexChat::print("Decoded Text: $decoded");
        } else {
            HexChat::command("SAY No Base64 code provided for decoding.");
        }
    } else {
        HexChat::command("SAY No Base64 code provided for decoding.");
    }

    return HexChat::EAT_ALL;
}, { 'help' => 'Converts Base64 to text' });

# Unload function to clean up when the script is unloaded
sub unload {
    HexChat::print("B64-Converter script unloaded.\n");
}

