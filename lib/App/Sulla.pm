package App::Sulla;
use strict;
use warnings;
use v5.10;
use Bot::Backbone;
use DateTime;

has username     => ( is => 'ro', isa => 'Str', required   => 1 );
has password     => ( is => 'ro', isa => 'Str', required   => 1 );
has domain       => ( is => 'ro', isa => 'Str', required   => 1 );
has group_domain => ( is => 'ro', isa => 'Str', lazy_build => 1 );
has group        => ( is => 'ro', isa => 'Str', required   => 1 );
has debug        => ( is => 'rw', isa => 'Str', default    => 0 );

sub _build_group_domain {
    'conference.' . $_[0]->domain;
}
#ABSTRACT: Bot::Backbone based jabber chat and web robot

use Data::Dumper;
before 'construct_services' => sub {
    my $self = shift;
    service jabber_chat => (
        service      => 'JabberChat',
        domain       => $self->domain,
        group_domain => $self->group_domain,
        username     => $self->username,
        password     => $self->password,
    );
    service group_herb => (
        service    => 'GroupChat',
        group      => $self->group,
        chat       => 'jabber_chat',
        dispatcher => 'group_chat', # defined below
    );
};

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
