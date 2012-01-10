#!/usr/bin/perl
package Example::Bot::Backbone::Jabber;
use strict;
use warnings;
use v5.10;
use Bot::Backbone;
use DateTime;
#modified from Bot::Backbone synopsis

my $domain       = 'chat.example.com';
my $group_domain = 'conference.' . $domain;
my $username     = 'guest';
my $password     = 'guest';
my $group        = 'test_room';

service jabber_chat => (
    service      => 'JabberChat',
    domain       => $domain,
    group_domain => $group_domain,
    username     => $username,
    password     => $password,
);
service "group_\$group" => (
    service    => 'GroupChat',
    group      => $group,
    chat       => 'jabber_chat',
    dispatcher => 'group_chat',
);
dispatcher group_chat => as {
    # Report the bot's time
    command '!time' =>
        respond { DateTime->now->format_cldr('ddd, MMM d, yyyy @ hh:mm:ss') };
};

my $bot = Example::Bot::Backbone::Jabber->new;
$bot->run;
