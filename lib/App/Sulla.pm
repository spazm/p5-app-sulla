package App::Sulla;
use strict;
use warnings;
use v5.10;
use Bot::Backbone;
use DateTime;

#ABSTRACT: Bot::Backbone based jabber chat and web robot
my $username = 'andrew.grangaard';
my $password = $ENV{JABBER_PASSWORD};
my $domain   = 'chat.demandmedia.net';
my $group    = 'herbbot';

#use App::Sulla::Plugin::Foo;
service jabber_chat => (
    service      => 'JabberChat',
    domain       => $domain,
    group_domain => "conference.$domain",
    username     => $username,
    password     => $password,
);

service group_herb => (
    service    => 'GroupChat',
    group      => $group,
    chat       => 'jabber_chat',
    dispatcher => 'group_chat', # defined below
);

dispatcher group_chat => as {
    # Report the bot's time
    command '!time' =>
        respond { DateTime->now->format_cldr('ddd, MMM d, yyyy @ hh:mm:ss') };

    # Finally:
    #  - also: match even if something else already responded
    #  - not_command: but not if a command matched
    #  - not_to_me: but not if addressed to me
    #  - run: run this code, but do not respond
    also not_command not_to_me run_this {
            my ( $self, $message ) = @_;
            respond { "hello world" };
    };
};

1;
